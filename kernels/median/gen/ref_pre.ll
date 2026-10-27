; ModuleID = '/mnt/d/Ayah/Percobaan2/kernels/median/gen/ref_O1.ll'
source_filename = "/mnt/d/Ayah/Percobaan2/kernels/median/ref.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: mustprogress nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @_Z13median_filterPA64_hS0_(ptr nocapture noundef readonly %input, ptr nocapture noundef writeonly %output) local_unnamed_addr #0 {
entry:
  br label %for.cond1.preheader

for.cond1.preheader:                              ; preds = %for.cond.cleanup3, %entry
  %indvar = phi i64 [ 0, %entry ], [ %indvar.next, %for.cond.cleanup3 ]
  %0 = shl nuw nsw i64 %indvar, 6
  %cmp5 = icmp eq i64 %indvar, 0
  %cmp6 = icmp eq i64 %indvar, 63
  %or.cond = or i1 %cmp5, %cmp6
  %arrayidx12.peel = getelementptr inbounds [64 x i8], ptr %output, i64 %indvar, i64 0
  store i8 0, ptr %arrayidx12.peel, align 1, !tbaa !5
  br label %for.body4

for.cond.cleanup:                                 ; preds = %for.cond.cleanup3
  ret void

for.cond.cleanup3:                                ; preds = %for.inc70
  %indvar.next = add nuw nsw i64 %indvar, 1
  %exitcond135.not = icmp eq i64 %indvar.next, 64
  br i1 %exitcond135.not, label %for.cond.cleanup, label %for.cond1.preheader, !llvm.loop !8

for.body4:                                        ; preds = %for.inc70, %for.cond1.preheader
  %indvar113 = phi i64 [ 1, %for.cond1.preheader ], [ %indvar.next114, %for.inc70 ]
  %cmp10 = icmp eq i64 %indvar113, 63
  %or.cond77 = or i1 %cmp10, %or.cond
  br i1 %or.cond77, label %if.then, label %if.else

if.then:                                          ; preds = %for.body4
  %arrayidx12 = getelementptr inbounds [64 x i8], ptr %output, i64 %indvar, i64 %indvar113
  store i8 0, ptr %arrayidx12, align 1, !tbaa !5
  br label %for.inc70

if.else:                                          ; preds = %for.body4
  %1 = getelementptr i8, ptr %input, i64 %0
  %2 = getelementptr i8, ptr %1, i64 -65
  %scevgep117 = getelementptr i8, ptr %2, i64 %indvar113
  %v.sroa.0.0.copyload = load i8, ptr %scevgep117, align 1, !tbaa !5
  %v.sroa.5.0.scevgep117.sroa_idx = getelementptr inbounds i8, ptr %scevgep117, i64 1
  %v.sroa.5.0.copyload = load i8, ptr %v.sroa.5.0.scevgep117.sroa_idx, align 1, !tbaa !5
  %v.sroa.9.0.scevgep117.sroa_idx = getelementptr inbounds i8, ptr %scevgep117, i64 2
  %v.sroa.9.0.copyload = load i8, ptr %v.sroa.9.0.scevgep117.sroa_idx, align 1, !tbaa !5
  %scevgep117.1 = getelementptr i8, ptr %scevgep117, i64 64
  %v.sroa.13.3.copyload = load i8, ptr %scevgep117.1, align 1, !tbaa !5
  %v.sroa.18.3.scevgep117.1.sroa_idx = getelementptr i8, ptr %scevgep117, i64 65
  %v.sroa.18.3.copyload = load i8, ptr %v.sroa.18.3.scevgep117.1.sroa_idx, align 1, !tbaa !5
  %v.sroa.23.3.scevgep117.1.sroa_idx = getelementptr i8, ptr %scevgep117, i64 66
  %v.sroa.23.3.copyload = load i8, ptr %v.sroa.23.3.scevgep117.1.sroa_idx, align 1, !tbaa !5
  %scevgep117.2 = getelementptr i8, ptr %scevgep117, i64 128
  %v.sroa.27.6.copyload = load i8, ptr %scevgep117.2, align 1, !tbaa !5
  %v.sroa.32.6.scevgep117.2.sroa_idx = getelementptr i8, ptr %scevgep117, i64 129
  %v.sroa.32.6.copyload = load i8, ptr %v.sroa.32.6.scevgep117.2.sroa_idx, align 1, !tbaa !5
  %v.sroa.36.6.scevgep117.2.sroa_idx = getelementptr i8, ptr %scevgep117, i64 130
  %v.sroa.36.6.copyload = load i8, ptr %v.sroa.36.6.scevgep117.2.sroa_idx, align 1, !tbaa !5
  %spec.select144 = call i8 @llvm.umin.i8(i8 %v.sroa.0.0.copyload, i8 %v.sroa.5.0.copyload)
  %spec.select = call i8 @llvm.umax.i8(i8 %v.sroa.0.0.copyload, i8 %v.sroa.5.0.copyload)
  %spec.select146 = call i8 @llvm.umin.i8(i8 %spec.select, i8 %v.sroa.9.0.copyload)
  %spec.select145 = call i8 @llvm.umax.i8(i8 %spec.select, i8 %v.sroa.9.0.copyload)
  %spec.select148 = call i8 @llvm.umin.i8(i8 %spec.select145, i8 %v.sroa.13.3.copyload)
  %spec.select147 = call i8 @llvm.umax.i8(i8 %spec.select145, i8 %v.sroa.13.3.copyload)
  %spec.select150 = call i8 @llvm.umin.i8(i8 %spec.select147, i8 %v.sroa.18.3.copyload)
  %spec.select149 = call i8 @llvm.umax.i8(i8 %spec.select147, i8 %v.sroa.18.3.copyload)
  %spec.select152 = call i8 @llvm.umin.i8(i8 %spec.select149, i8 %v.sroa.23.3.copyload)
  %spec.select151 = call i8 @llvm.umax.i8(i8 %spec.select149, i8 %v.sroa.23.3.copyload)
  %spec.select154 = call i8 @llvm.umin.i8(i8 %spec.select151, i8 %v.sroa.27.6.copyload)
  %spec.select153 = call i8 @llvm.umax.i8(i8 %spec.select151, i8 %v.sroa.27.6.copyload)
  %spec.select156 = call i8 @llvm.umin.i8(i8 %spec.select153, i8 %v.sroa.32.6.copyload)
  %spec.select155 = call i8 @llvm.umax.i8(i8 %spec.select153, i8 %v.sroa.32.6.copyload)
  %spec.select158 = call i8 @llvm.umin.i8(i8 %spec.select155, i8 %v.sroa.36.6.copyload)
  %spec.select144.1 = call i8 @llvm.umin.i8(i8 %spec.select144, i8 %spec.select146)
  %spec.select.1 = call i8 @llvm.umax.i8(i8 %spec.select144, i8 %spec.select146)
  %spec.select146.1 = call i8 @llvm.umin.i8(i8 %spec.select.1, i8 %spec.select148)
  %spec.select145.1 = call i8 @llvm.umax.i8(i8 %spec.select.1, i8 %spec.select148)
  %spec.select148.1 = call i8 @llvm.umin.i8(i8 %spec.select145.1, i8 %spec.select150)
  %spec.select147.1 = call i8 @llvm.umax.i8(i8 %spec.select145.1, i8 %spec.select150)
  %spec.select150.1 = call i8 @llvm.umin.i8(i8 %spec.select147.1, i8 %spec.select152)
  %spec.select149.1 = call i8 @llvm.umax.i8(i8 %spec.select147.1, i8 %spec.select152)
  %spec.select152.1 = call i8 @llvm.umin.i8(i8 %spec.select149.1, i8 %spec.select154)
  %spec.select151.1 = call i8 @llvm.umax.i8(i8 %spec.select149.1, i8 %spec.select154)
  %spec.select154.1 = call i8 @llvm.umin.i8(i8 %spec.select151.1, i8 %spec.select156)
  %spec.select153.1 = call i8 @llvm.umax.i8(i8 %spec.select151.1, i8 %spec.select156)
  %spec.select156.1 = call i8 @llvm.umin.i8(i8 %spec.select153.1, i8 %spec.select158)
  %spec.select144.2 = call i8 @llvm.umin.i8(i8 %spec.select144.1, i8 %spec.select146.1)
  %spec.select.2 = call i8 @llvm.umax.i8(i8 %spec.select144.1, i8 %spec.select146.1)
  %spec.select146.2 = call i8 @llvm.umin.i8(i8 %spec.select.2, i8 %spec.select148.1)
  %spec.select145.2 = call i8 @llvm.umax.i8(i8 %spec.select.2, i8 %spec.select148.1)
  %spec.select148.2 = call i8 @llvm.umin.i8(i8 %spec.select145.2, i8 %spec.select150.1)
  %spec.select147.2 = call i8 @llvm.umax.i8(i8 %spec.select145.2, i8 %spec.select150.1)
  %spec.select150.2 = call i8 @llvm.umin.i8(i8 %spec.select147.2, i8 %spec.select152.1)
  %spec.select149.2 = call i8 @llvm.umax.i8(i8 %spec.select147.2, i8 %spec.select152.1)
  %spec.select152.2 = call i8 @llvm.umin.i8(i8 %spec.select149.2, i8 %spec.select154.1)
  %spec.select151.2 = call i8 @llvm.umax.i8(i8 %spec.select149.2, i8 %spec.select154.1)
  %spec.select154.2 = call i8 @llvm.umin.i8(i8 %spec.select151.2, i8 %spec.select156.1)
  %spec.select144.3 = call i8 @llvm.umin.i8(i8 %spec.select144.2, i8 %spec.select146.2)
  %spec.select.3 = call i8 @llvm.umax.i8(i8 %spec.select144.2, i8 %spec.select146.2)
  %spec.select146.3 = call i8 @llvm.umin.i8(i8 %spec.select.3, i8 %spec.select148.2)
  %spec.select145.3 = call i8 @llvm.umax.i8(i8 %spec.select.3, i8 %spec.select148.2)
  %spec.select148.3 = call i8 @llvm.umin.i8(i8 %spec.select145.3, i8 %spec.select150.2)
  %spec.select147.3 = call i8 @llvm.umax.i8(i8 %spec.select145.3, i8 %spec.select150.2)
  %spec.select150.3 = call i8 @llvm.umin.i8(i8 %spec.select147.3, i8 %spec.select152.2)
  %spec.select149.3 = call i8 @llvm.umax.i8(i8 %spec.select147.3, i8 %spec.select152.2)
  %spec.select152.3 = call i8 @llvm.umin.i8(i8 %spec.select149.3, i8 %spec.select154.2)
  %spec.select.4 = call i8 @llvm.umax.i8(i8 %spec.select144.3, i8 %spec.select146.3)
  %spec.select145.4 = call i8 @llvm.umax.i8(i8 %spec.select.4, i8 %spec.select148.3)
  %spec.select147.4 = call i8 @llvm.umax.i8(i8 %spec.select145.4, i8 %spec.select150.3)
  %spec.select149.4 = call i8 @llvm.umax.i8(i8 %spec.select147.4, i8 %spec.select152.3)
  %arrayidx68 = getelementptr inbounds [64 x i8], ptr %output, i64 %indvar, i64 %indvar113
  store i8 %spec.select149.4, ptr %arrayidx68, align 1, !tbaa !5
  br label %for.inc70

for.inc70:                                        ; preds = %if.else, %if.then
  %indvar.next114 = add nuw nsw i64 %indvar113, 1
  %exitcond133.not = icmp eq i64 %indvar.next114, 64
  br i1 %exitcond133.not, label %for.cond.cleanup3, label %for.body4, !llvm.loop !10
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i8 @llvm.umax.i8(i8, i8) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i8 @llvm.umin.i8(i8, i8) #1

attributes #0 = { mustprogress nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!5 = !{!6, !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C++ TBAA"}
!8 = distinct !{!8, !9}
!9 = !{!"llvm.loop.mustprogress"}
!10 = distinct !{!10, !9, !11}
!11 = !{!"llvm.loop.peeled.count", i32 1}
