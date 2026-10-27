//===- HwSwPartition.cpp - IR-level HW/SW partitioning for stencil kernels -===//
//
// New-pass-manager plugin. For an image kernel written as nested traversal loops
// around a window computation, the pass
//   1. finds the store that writes the computed output pixel,
//   2. takes the backward data-flow slice of the stored value and splits it at
//      the boundary between traversal control (loop induction variables,
//      address arithmetic, border conditions) and window arithmetic,
//   3. annotates every instruction with !hwsw.partition = software | hardware |
//      boundary,
//   4. emits the hardware slice as an HLS-ready C++ function (straight-line
//      code over ap_uint values, one argument per boundary load),
//   5. rewrites the software function so that it calls the extracted kernel,
//   6. writes a JSON manifest with partition statistics.
//
// Usage:
//   opt -load-pass-plugin=./HwSwPartition.so -passes=hwsw-partition \
//       -hwsw-kernel=sobel -hwsw-out-dir=gen in.ll -S -o sw.ll
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/Analysis/ConstantFolding.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Metadata.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/FormatVariadic.h"
#include "llvm/Support/JSON.h"
#include "llvm/Support/raw_ostream.h"

#include <algorithm>
#include <map>
#include <string>
#include <vector>

using namespace llvm;

static cl::opt<std::string> OutDir("hwsw-out-dir", cl::init("."),
                                   cl::desc("Directory for generated files"));
static cl::opt<std::string> KernelName("hwsw-kernel", cl::init("kernel"),
                                       cl::desc("Prefix of generated names"));
static cl::opt<unsigned> RowWidth("hwsw-row-width", cl::init(64),
                                  cl::desc("Image row width in elements"));

namespace {

struct BoundaryInput {
  LoadInst *Load;
  int64_t Offset; // element offset relative to the output pixel
  int Dy, Dx;
  std::string Name;
};

class Partitioner {
  Function &F;
  LoopInfo &LI;
  DominatorTree &DT;
  ScalarEvolution &SE;

  StoreInst *Store = nullptr;
  Loop *Body = nullptr;
  Value *Root = nullptr;
  Constant *Default = nullptr; // value written on the software-only path

  SetVector<Instruction *> HW;
  std::vector<BoundaryInput> Inputs;
  DenseMap<Value *, unsigned> InputIdx;
  SetVector<Value *> LiveIns;
  DenseMap<Value *, Constant *> Folded;
  DenseMap<PHINode *, std::pair<Value *, bool>> PhiCond; // cond, true-edge is incoming 0
  DenseMap<Value *, bool> InductionDep;

public:
  std::string Err;

  Partitioner(Function &F, LoopInfo &LI, DominatorTree &DT, ScalarEvolution &SE)
      : F(F), LI(LI), DT(DT), SE(SE) {}

  bool run();
  void annotate();
  bool emitKernel(const std::string &Path);
  bool emitStream(const std::string &Path);
  bool emitDriver(const std::string &Path);
  bool emitManifest(const std::string &Path);
  void rewriteSoftware();

private:
  bool fail(const Twine &Msg) {
    Err = Msg.str();
    return false;
  }
  bool isInductionDependent(Value *V);
  bool controlConditions(PHINode *P, SmallVectorImpl<Value *> &Conds);
  bool collectRoots(Value *V, SmallVectorImpl<Value *> &Roots);
  bool visit(Value *V);
  bool addBoundaryLoad(LoadInst *L);
  std::vector<Instruction *> orderedHW();
  std::string name(Value *V, DenseMap<Value *, std::string> &Names);
  std::string expr(Instruction *I, DenseMap<Value *, std::string> &Names);
};

std::string apType(Type *T) {
  return "ap_uint<" + std::to_string(T->getIntegerBitWidth()) + ">";
}
std::string sgn(const std::string &V, Type *T) {
  return "((ap_int<" + std::to_string(T->getIntegerBitWidth()) + ">)" + V + ")";
}
std::string offName(int D) {
  return D < 0 ? "m" + std::to_string(-D) : "p" + std::to_string(D);
}

// A value is induction dependent when it is computed (through anything but a
// load result) from a loop-header phi or a function argument. Such values
// belong to the traversal control and stay in software.
bool Partitioner::isInductionDependent(Value *V) {
  if (isa<Constant>(V))
    return false;
  if (isa<Argument>(V))
    return true;
  auto *I = dyn_cast<Instruction>(V);
  if (!I)
    return true;
  auto It = InductionDep.find(V);
  if (It != InductionDep.end())
    return It->second;
  if (isa<LoadInst>(I))
    return InductionDep[V] = false;
  if (auto *P = dyn_cast<PHINode>(I))
    if (LI.isLoopHeader(P->getParent()))
      return InductionDep[V] = true;
  InductionDep[V] = false; // breaks cycles through non-header phis
  bool Dep = false;
  for (Value *Op : I->operands())
    if (isInductionDependent(Op)) {
      Dep = true;
      break;
    }
  if (auto *P = dyn_cast<PHINode>(I)) {
    SmallVector<Value *, 4> Conds;
    if (controlConditions(P, Conds))
      for (Value *C : Conds)
        Dep |= isInductionDependent(C);
  }
  return InductionDep[V] = Dep;
}

// Conditions of the conditional branches between the immediate dominator of a
// phi's block and the phi itself.
bool Partitioner::controlConditions(PHINode *P, SmallVectorImpl<Value *> &Conds) {
  BasicBlock *PB = P->getParent();
  auto *IDom = DT.getNode(PB)->getIDom();
  if (!IDom)
    return false;
  BasicBlock *Top = IDom->getBlock();
  SmallVector<BasicBlock *, 8> Work(pred_begin(PB), pred_end(PB));
  SmallPtrSet<BasicBlock *, 16> Seen;
  while (!Work.empty()) {
    BasicBlock *B = Work.pop_back_val();
    if (!Seen.insert(B).second || !DT.dominates(Top, B))
      continue;
    if (auto *Br = dyn_cast<BranchInst>(B->getTerminator()))
      if (Br->isConditional())
        Conds.push_back(Br->getCondition());
    if (B != Top)
      for (BasicBlock *Pr : predecessors(B))
        Work.push_back(Pr);
  }
  return true;
}

// Strip phis/selects whose condition is traversal control (e.g. the image
// border test); the remaining non-constant values are the hardware roots.
bool Partitioner::collectRoots(Value *V, SmallVectorImpl<Value *> &Roots) {
  if (auto *C = dyn_cast<Constant>(V)) {
    if (Default && Default != C)
      return fail("more than one software default value");
    Default = C;
    return true;
  }
  if (auto *P = dyn_cast<PHINode>(V)) {
    SmallVector<Value *, 4> Conds;
    if (!LI.isLoopHeader(P->getParent()) && controlConditions(P, Conds) &&
        !Conds.empty() &&
        std::all_of(Conds.begin(), Conds.end(),
                    [&](Value *C) { return isInductionDependent(C); })) {
      for (Value *In : P->incoming_values())
        if (!collectRoots(In, Roots))
          return false;
      return true;
    }
  }
  if (auto *S = dyn_cast<SelectInst>(V))
    if (isInductionDependent(S->getCondition()))
      return collectRoots(S->getTrueValue(), Roots) &&
             collectRoots(S->getFalseValue(), Roots);
  if (!is_contained(Roots, V))
    Roots.push_back(V);
  return true;
}

bool Partitioner::addBoundaryLoad(LoadInst *L) {
  if (InputIdx.count(L))
    return true;
  Value *LP = L->getPointerOperand();
  Value *SP = Store->getPointerOperand();
  Value *LB = getUnderlyingObject(LP), *SB = getUnderlyingObject(SP);
  const SCEV *LOff = SE.getMinusSCEV(SE.getSCEV(LP), SE.getSCEV(LB));
  const SCEV *SOff = SE.getMinusSCEV(SE.getSCEV(SP), SE.getSCEV(SB));
  auto *D = dyn_cast<SCEVConstant>(SE.getMinusSCEV(LOff, SOff));
  if (!D)
    return fail("boundary load offset is not a compile-time constant");
  unsigned ElemBytes = L->getType()->getIntegerBitWidth() / 8;
  int64_t Off = D->getAPInt().getSExtValue() / (int64_t)std::max(1u, ElemBytes);
  int W = RowWidth;
  int Dy = (int)((Off + (Off >= 0 ? W / 2 : -W / 2)) / W);
  int Dx = (int)(Off - (int64_t)Dy * W);
  BoundaryInput BI{L, Off, Dy, Dx, "px_" + offName(Dy) + "_" + offName(Dx)};
  InputIdx[L] = Inputs.size();
  Inputs.push_back(BI);
  return true;
}

bool Partitioner::visit(Value *V) {
  if (isa<Constant>(V))
    return true;
  auto *I = dyn_cast<Instruction>(V);
  if (!I || LI.getLoopFor(I->getParent()) != Body) {
    LiveIns.insert(V);
    return true;
  }
  if (HW.count(I) || InputIdx.count(I) || LiveIns.count(I) || Folded.count(I))
    return true;

  if (auto *L = dyn_cast<LoadInst>(I)) {
    if (isInductionDependent(L->getPointerOperand()))
      return addBoundaryLoad(L);
    if (Constant *C = ConstantFoldLoadFromConstPtr(
            dyn_cast<Constant>(L->getPointerOperand()), L->getType(),
            F.getParent()->getDataLayout())) {
      Folded[L] = C;
      return true;
    }
    return fail("load with loop-invariant, non-constant address in slice");
  }
  if (auto *P = dyn_cast<PHINode>(I)) {
    if (LI.isLoopHeader(P->getParent())) {
      LiveIns.insert(P);
      return true;
    }
    // Data-dependent merge inside the window computation: convert to select.
    if (P->getNumIncomingValues() != 2)
      return fail("data phi with more than two incoming values");
    BasicBlock *Dom = DT.getNode(P->getParent())->getIDom()->getBlock();
    auto *Br = dyn_cast<BranchInst>(Dom->getTerminator());
    if (!Br || !Br->isConditional())
      return fail("data phi without a conditional dominator");
    BasicBlock *T = Br->getSuccessor(0);
    BasicBlock *In0 = P->getIncomingBlock(0);
    bool ZeroIsTrue = (In0 == Dom) ? (T == P->getParent()) : DT.dominates(T, In0);
    PhiCond[P] = {Br->getCondition(), ZeroIsTrue};
    HW.insert(P);
    return visit(Br->getCondition()) && visit(P->getIncomingValue(0)) &&
           visit(P->getIncomingValue(1));
  }
  if (isInductionDependent(I)) {
    LiveIns.insert(I);
    return true;
  }
  if (I->mayHaveSideEffects() || isa<AllocaInst>(I) || isa<GetElementPtrInst>(I))
    return fail("unsupported instruction in hardware slice: " +
                std::string(I->getOpcodeName()));
  if (auto *CI = dyn_cast<CallInst>(I)) {
    auto *II = dyn_cast<IntrinsicInst>(CI);
    if (!II)
      return fail("call in hardware slice");
    switch (II->getIntrinsicID()) {
    case Intrinsic::abs:
    case Intrinsic::smax:
    case Intrinsic::smin:
    case Intrinsic::umax:
    case Intrinsic::umin:
      break;
    default:
      return fail("unsupported intrinsic in hardware slice");
    }
    HW.insert(I);
    return visit(II->getArgOperand(0)) &&
           (II->getIntrinsicID() == Intrinsic::abs || visit(II->getArgOperand(1)));
  }
  HW.insert(I);
  for (Value *Op : I->operands())
    if (!visit(Op))
      return false;
  return true;
}

bool Partitioner::run() {
  for (Instruction &I : instructions(F))
    if (auto *S = dyn_cast<StoreInst>(&I)) {
      if (!isa<Argument>(getUnderlyingObject(S->getPointerOperand())) ||
          isa<Constant>(S->getValueOperand()))
        continue;
      if (Store)
        return fail("more than one non-constant output store");
      Store = S;
    }
  if (!Store)
    return fail("no output store found");
  Body = LI.getLoopFor(Store->getParent());
  if (!Body)
    return fail("output store is not inside a traversal loop");
  if (!Body->getSubLoops().empty())
    return fail("window loops are not fully unrolled");

  SmallVector<Value *, 2> Roots;
  if (!collectRoots(Store->getValueOperand(), Roots))
    return false;
  if (Roots.size() != 1)
    return fail("expected exactly one hardware root, found " +
                Twine(Roots.size()));
  Root = Roots[0];
  if (!Default)
    Default = Constant::getNullValue(Root->getType());
  if (!visit(Root))
    return false;
  if (HW.empty())
    return fail("hardware slice is empty");
  if (!LiveIns.empty())
    return fail("slice consumes software scalars; not supported by the driver");
  std::sort(Inputs.begin(), Inputs.end(),
            [](const BoundaryInput &A, const BoundaryInput &B) { return A.Offset < B.Offset; });
  for (unsigned K = 0; K < Inputs.size(); ++K)
    InputIdx[Inputs[K].Load] = K;
  return true;
}

void Partitioner::annotate() {
  LLVMContext &Ctx = F.getContext();
  auto Tag = [&](const char *S) { return MDNode::get(Ctx, MDString::get(Ctx, S)); };
  for (Instruction &I : instructions(F)) {
    const char *K = "software";
    if (HW.count(&I))
      K = "hardware";
    else if (InputIdx.count(&I))
      K = "boundary";
    I.setMetadata("hwsw.partition", Tag(K));
  }
}

std::vector<Instruction *> Partitioner::orderedHW() {
  std::vector<Instruction *> Out;
  ReversePostOrderTraversal<Function *> RPOT(&F);
  for (BasicBlock *B : RPOT)
    for (Instruction &I : *B)
      if (HW.count(&I))
        Out.push_back(&I);
  return Out;
}

std::string Partitioner::name(Value *V, DenseMap<Value *, std::string> &Names) {
  if (Folded.count(V))
    V = Folded[V];
  if (auto *C = dyn_cast<ConstantInt>(V))
    return apType(C->getType()) + "(" + std::to_string(C->getZExtValue()) + "ULL)";
  auto It = Names.find(V);
  return It == Names.end() ? std::string("/*?*/0") : It->second;
}

std::string Partitioner::expr(Instruction *I, DenseMap<Value *, std::string> &Names) {
  auto N = [&](unsigned K) { return name(I->getOperand(K), Names); };
  Type *T0 = I->getOperand(0)->getType();
  if (auto *B = dyn_cast<BinaryOperator>(I)) {
    std::string A = N(0), C = N(1);
    switch (B->getOpcode()) {
    case Instruction::Add: return A + " + " + C;
    case Instruction::Sub: return A + " - " + C;
    case Instruction::Mul: return A + " * " + C;
    case Instruction::And: return A + " & " + C;
    case Instruction::Or:  return A + " | " + C;
    case Instruction::Xor: return A + " ^ " + C;
    case Instruction::Shl: return A + " << (unsigned)(" + C + ")";
    case Instruction::LShr: return A + " >> (unsigned)(" + C + ")";
    case Instruction::AShr: return sgn(A, T0) + " >> (unsigned)(" + C + ")";
    case Instruction::UDiv: return A + " / " + C;
    case Instruction::URem: return A + " % " + C;
    case Instruction::SDiv: return sgn(A, T0) + " / " + sgn(C, T0);
    case Instruction::SRem: return sgn(A, T0) + " % " + sgn(C, T0);
    default: return "/*unsupported binop*/0";
    }
  }
  if (auto *C = dyn_cast<ICmpInst>(I)) {
    std::string A = N(0), B = N(1);
    switch (C->getPredicate()) {
    case CmpInst::ICMP_EQ:  return A + " == " + B;
    case CmpInst::ICMP_NE:  return A + " != " + B;
    case CmpInst::ICMP_UGT: return A + " > " + B;
    case CmpInst::ICMP_UGE: return A + " >= " + B;
    case CmpInst::ICMP_ULT: return A + " < " + B;
    case CmpInst::ICMP_ULE: return A + " <= " + B;
    case CmpInst::ICMP_SGT: return sgn(A, T0) + " > " + sgn(B, T0);
    case CmpInst::ICMP_SGE: return sgn(A, T0) + " >= " + sgn(B, T0);
    case CmpInst::ICMP_SLT: return sgn(A, T0) + " < " + sgn(B, T0);
    case CmpInst::ICMP_SLE: return sgn(A, T0) + " <= " + sgn(B, T0);
    default: return "/*unsupported icmp*/0";
    }
  }
  if (isa<SelectInst>(I))
    return N(0) + " ? " + N(1) + " : " + N(2);
  if (auto *P = dyn_cast<PHINode>(I)) {
    auto PC = PhiCond[P];
    std::string A = name(P->getIncomingValue(0), Names), B = name(P->getIncomingValue(1), Names);
    return name(PC.first, Names) + " ? " + (PC.second ? A + " : " + B : B + " : " + A);
  }
  if (isa<ZExtInst>(I) || isa<TruncInst>(I) || isa<FreezeInst>(I))
    return N(0);
  if (isa<SExtInst>(I))
    return sgn(N(0), T0);
  if (auto *II = dyn_cast<IntrinsicInst>(I)) {
    std::string A = N(0), B = II->arg_size() > 1 ? N(1) : "";
    std::string T = apType(I->getType());
    switch (II->getIntrinsicID()) {
    case Intrinsic::abs:
      return "(" + sgn(A, T0) + " < 0) ? (" + T + ")(-" + sgn(A, T0) + ") : " + A;
    case Intrinsic::smax: return "(" + sgn(A, T0) + " > " + sgn(B, T0) + ") ? " + A + " : " + B;
    case Intrinsic::smin: return "(" + sgn(A, T0) + " < " + sgn(B, T0) + ") ? " + A + " : " + B;
    case Intrinsic::umax: return "(" + A + " > " + B + ") ? " + A + " : " + B;
    case Intrinsic::umin: return "(" + A + " < " + B + ") ? " + A + " : " + B;
    default: break;
    }
  }
  return "/*unsupported*/0";
}

bool Partitioner::emitKernel(const std::string &Path) {
  std::error_code EC;
  raw_fd_ostream OS(Path, EC);
  if (EC)
    return fail("cannot write " + Path);
  std::string Fn = KernelName + "_hw_gen";
  DenseMap<Value *, std::string> Names;
  OS << "// Generated by the HwSwPartition LLVM pass from function '" << F.getName()
     << "'.\n// Hardware slice: " << HW.size() << " IR instructions, " << Inputs.size()
     << " boundary inputs. Do not edit.\n#include \"ap_int.h\"\n\n";
  std::string Params;
  for (auto &BI : Inputs)
    Params += "unsigned char " + BI.Name + ", ";
  OS << "void " << Fn << "(" << Params << "unsigned char *result) {\n";
  OS << "#pragma HLS INTERFACE s_axilite port=return bundle=control\n";
  for (auto &BI : Inputs)
    OS << "#pragma HLS INTERFACE s_axilite port=" << BI.Name << " bundle=control\n";
  OS << "#pragma HLS INTERFACE s_axilite port=result bundle=control\n";
  OS << "#pragma HLS PIPELINE II=1\n";
  for (auto &BI : Inputs) {
    std::string V = "w_" + BI.Name.substr(3);
    OS << "    " << apType(BI.Load->getType()) << " " << V << " = " << BI.Name << ";\n";
    Names[BI.Load] = V;
  }
  unsigned K = 0;
  for (Instruction *I : orderedHW()) {
    std::string V = "t" + std::to_string(K++);
    OS << "    " << apType(I->getType()) << " " << V << " = " << expr(I, Names) << ";\n";
    Names[I] = V;
  }
  OS << "    *result = (unsigned char)" << name(Root, Names) << ";\n}\n\n";
  OS << "#ifdef HWSW_VERIFY\n// C-linkage entry used by the rewritten software IR.\nextern \"C\" void "
     << Fn << "_c(" << Params << "unsigned char *result) {\n    " << Fn << "(";
  for (auto &BI : Inputs)
    OS << BI.Name << ", ";
  OS << "result);\n}\n#endif\n";
  return true;
}

// Streaming variant: the same extracted datapath as a window operator `kop`, placed in the
// shared line-buffer template. The window extent K_S comes from the SCEV-derived offsets.
bool Partitioner::emitStream(const std::string &Path) {
  std::error_code EC;
  raw_fd_ostream OS(Path, EC);
  if (EC)
    return fail("cannot write " + Path);
  int R = 0;
  for (auto &BI : Inputs)
    R = std::max({R, std::abs(BI.Dy), std::abs(BI.Dx)});
  if (!cast<ConstantInt>(Default)->isZero())
    return fail("streaming template assumes border value 0");
  DenseMap<Value *, std::string> Names;
  OS << "// Generated by the HwSwPartition LLVM pass from function '" << F.getName()
     << "'.\n// Streaming wrapper: extracted datapath (" << HW.size() << " IR instructions) as the\n"
     << "// window operator of the line-buffer stencil template. Do not edit.\n"
     << "#include \"ap_int.h\"\n#define K_S " << 2 * R + 1 << "\n#define IMG_N " << RowWidth
     << "\n\nstatic unsigned char kop(unsigned char w[K_S][K_S]) {\n#pragma HLS INLINE\n";
  for (auto &BI : Inputs) {
    std::string V = "w_" + BI.Name.substr(3);
    OS << "    " << apType(BI.Load->getType()) << " " << V << " = w[" << BI.Dy + R << "]["
       << BI.Dx + R << "];\n";
    Names[BI.Load] = V;
  }
  unsigned K = 0;
  for (Instruction *I : orderedHW()) {
    std::string V = "t" + std::to_string(K++);
    OS << "    " << apType(I->getType()) << " " << V << " = " << expr(I, Names) << ";\n";
    Names[I] = V;
  }
  OS << "    return (unsigned char)" << name(Root, Names) << ";\n}\n\n#define STREAM_TOP "
     << KernelName << "_stream\n#include \"stencil_stream.inc\"\n";
  return true;
}

bool Partitioner::emitDriver(const std::string &Path) {
  std::error_code EC;
  raw_fd_ostream OS(Path, EC);
  if (EC)
    return fail("cannot write " + Path);
  int R = 0;
  for (auto &BI : Inputs)
    R = std::max({R, std::abs(BI.Dy), std::abs(BI.Dx)});
  std::string Fn = KernelName + "_hw_gen";
  OS << "// Generated by the HwSwPartition LLVM pass: software side of the partition\n"
        "// (window gather + kernel call) for Vitis HLS C-simulation / co-simulation.\n";
  OS << "void " << Fn << "(";
  for (auto &BI : Inputs)
    OS << "unsigned char, ";
  OS << "unsigned char *);\n\n";
  OS << "static void run_dut(img_t in, img_t out) {\n"
     << "    const int R = " << R << ";\n"
     << "    for (int y = 0; y < N; y++)\n        for (int x = 0; x < N; x++) {\n"
     << "            if (y < R || y >= N - R || x < R || x >= N - R) { out[y][x] = "
     << cast<ConstantInt>(Default)->getZExtValue() << "; continue; }\n"
     << "            unsigned char r = 0;\n            " << Fn << "(";
  for (auto &BI : Inputs)
    OS << "in[y + (" << BI.Dy << ")][x + (" << BI.Dx << ")], ";
  OS << "&r);\n            out[y][x] = r;\n        }\n}\n";
  return true;
}

bool Partitioner::emitManifest(const std::string &Path) {
  unsigned Total = 0, Sw = 0, Hw = 0, Bd = 0;
  std::map<std::string, unsigned> Hist;
  for (Instruction &I : instructions(F)) {
    ++Total;
    if (HW.count(&I)) {
      ++Hw;
      Hist[I.getOpcodeName()]++;
    } else if (InputIdx.count(&I))
      ++Bd;
    else
      ++Sw;
  }
  json::Array In;
  for (auto &BI : Inputs)
    In.push_back(json::Object{{"name", BI.Name}, {"dy", BI.Dy}, {"dx", BI.Dx}, {"offset", BI.Offset}});
  json::Object H;
  for (auto &P : Hist)
    H[P.first] = P.second;
  json::Object M{{"kernel", KernelName},
                 {"function", F.getName()},
                 {"row_width", (int64_t)RowWidth},
                 {"ir_instructions_total", Total},
                 {"software", Sw},
                 {"hardware", Hw},
                 {"boundary", Bd},
                 {"hardware_opcodes", std::move(H)},
                 {"inputs", std::move(In)},
                 {"default_value", (int64_t)cast<ConstantInt>(Default)->getZExtValue()}};
  std::error_code EC;
  raw_fd_ostream OS(Path, EC);
  if (EC)
    return fail("cannot write " + Path);
  OS << formatv("{0:2}", json::Value(std::move(M))) << "\n";
  return true;
}

// Replace the hardware root with a call to the extracted kernel. The now-dead
// hardware instructions are removed by a later DCE pass.
void Partitioner::rewriteSoftware() {
  Module &M = *F.getParent();
  LLVMContext &Ctx = F.getContext();
  Type *I8 = Type::getInt8Ty(Ctx);
  SmallVector<Type *, 16> Params(Inputs.size(), I8);
  Params.push_back(PointerType::getUnqual(Ctx));
  FunctionCallee Callee = M.getOrInsertFunction(
      KernelName + "_hw_gen_c", FunctionType::get(Type::getVoidTy(Ctx), Params, false));
  IRBuilder<> EB(&*F.getEntryBlock().getFirstInsertionPt());
  AllocaInst *Res = EB.CreateAlloca(I8, nullptr, "hw_result");
  auto *RootI = cast<Instruction>(Root);
  IRBuilder<> B(RootI);
  SmallVector<Value *, 16> Args;
  for (auto &BI : Inputs)
    Args.push_back(B.CreateZExtOrTrunc(BI.Load, I8));
  Args.push_back(Res);
  CallInst *Call = B.CreateCall(Callee, Args);
  Call->setMetadata("hwsw.partition",
                    MDNode::get(Ctx, MDString::get(Ctx, "hw_invocation")));
  Value *R = B.CreateLoad(I8, Res, "hw_value");
  R = B.CreateZExtOrTrunc(R, Root->getType());
  // Uses inside the slice keep the original value; only consumers outside it switch.
  RootI->replaceUsesWithIf(R, [&](Use &U) {
    auto *UI = dyn_cast<Instruction>(U.getUser());
    return UI && !HW.count(UI);
  });
}

struct HwSwPartitionPass : PassInfoMixin<HwSwPartitionPass> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM) {
    if (F.isDeclaration())
      return PreservedAnalyses::all();
    Partitioner P(F, AM.getResult<LoopAnalysis>(F), AM.getResult<DominatorTreeAnalysis>(F),
                  AM.getResult<ScalarEvolutionAnalysis>(F));
    if (!P.run()) {
      errs() << "hwsw-partition: " << F.getName() << ": " << P.Err << "\n";
      return PreservedAnalyses::all();
    }
    sys::fs::create_directories(OutDir);
    P.annotate();
    std::string Base = OutDir + "/";
    if (!P.emitKernel(Base + "hw.cpp") || !P.emitStream(Base + "stream.cpp") ||
        !P.emitDriver(Base + "driver.inc") ||
        !P.emitManifest(Base + "manifest.json"))
      errs() << "hwsw-partition: " << P.Err << "\n";
    P.rewriteSoftware();
    errs() << "hwsw-partition: " << F.getName() << ": extracted kernel "
           << KernelName << "_hw_gen\n";
    return PreservedAnalyses::none();
  }
};

} // namespace

extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "HwSwPartition", "1.0", [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name != "hwsw-partition")
                    return false;
                  FPM.addPass(HwSwPartitionPass());
                  return true;
                });
          }};
}
