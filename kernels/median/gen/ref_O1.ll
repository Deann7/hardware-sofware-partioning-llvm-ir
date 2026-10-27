; ModuleID = '/mnt/d/Ayah/Percobaan2/kernels/median/ref.cpp'
source_filename = "/mnt/d/Ayah/Percobaan2/kernels/median/ref.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: mustprogress nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @_Z13median_filterPA64_hS0_(ptr nocapture noundef readonly %input, ptr nocapture noundef writeonly %output) local_unnamed_addr #0 {
entry:
  br label %for.cond1.preheader

for.cond1.preheader:                              ; preds = %entry, %for.cond.cleanup3
  %indvar = phi i64 [ 0, %entry ], [ %indvar.next, %for.cond.cleanup3 ]
  %0 = shl nuw nsw i64 %indvar, 6
  %1 = add nsw i64 %0, -65
  %cmp5 = icmp eq i64 %indvar, 0
  %cmp6 = icmp eq i64 %indvar, 63
  %or.cond = or i1 %cmp5, %cmp6
  br label %for.body4

for.cond.cleanup:                                 ; preds = %for.cond.cleanup3
  ret void

for.cond.cleanup3:                                ; preds = %for.inc70
  %indvar.next = add nuw nsw i64 %indvar, 1
  %exitcond135.not = icmp eq i64 %indvar.next, 64
  br i1 %exitcond135.not, label %for.cond.cleanup, label %for.cond1.preheader, !llvm.loop !5

for.body4:                                        ; preds = %for.cond1.preheader, %for.inc70
  %indvar113 = phi i64 [ 0, %for.cond1.preheader ], [ %indvar.next114, %for.inc70 ]
  %cmp8 = icmp eq i64 %indvar113, 0
  %or.cond76 = or i1 %or.cond, %cmp8
  %cmp10 = icmp eq i64 %indvar113, 63
  %or.cond77 = or i1 %cmp10, %or.cond76
  br i1 %or.cond77, label %if.then, label %if.else

if.then:                                          ; preds = %for.body4
  %arrayidx12 = getelementptr inbounds [64 x i8], ptr %output, i64 %indvar, i64 %indvar113
  store i8 0, ptr %arrayidx12, align 1, !tbaa !7
  br label %for.inc70

if.else:                                          ; preds = %for.body4
  %2 = add nsw i64 %1, %indvar113
  %scevgep117 = getelementptr i8, ptr %input, i64 %2
  %v.sroa.0.0.copyload = load i8, ptr %scevgep117, align 1, !tbaa !7
  %v.sroa.5.0.scevgep117.sroa_idx = getelementptr inbounds i8, ptr %scevgep117, i64 1
  %v.sroa.5.0.copyload = load i8, ptr %v.sroa.5.0.scevgep117.sroa_idx, align 1, !tbaa !7
  %v.sroa.9.0.scevgep117.sroa_idx = getelementptr inbounds i8, ptr %scevgep117, i64 2
  %v.sroa.9.0.copyload = load i8, ptr %v.sroa.9.0.scevgep117.sroa_idx, align 1, !tbaa !7
  %3 = getelementptr i8, ptr %input, i64 %2
  %scevgep117.1 = getelementptr i8, ptr %3, i64 64
  %v.sroa.13.3.copyload = load i8, ptr %scevgep117.1, align 1, !tbaa !7
  %v.sroa.18.3.scevgep117.1.sroa_idx = getelementptr i8, ptr %3, i64 65
  %v.sroa.18.3.copyload = load i8, ptr %v.sroa.18.3.scevgep117.1.sroa_idx, align 1, !tbaa !7
  %v.sroa.23.3.scevgep117.1.sroa_idx = getelementptr i8, ptr %3, i64 66
  %v.sroa.23.3.copyload = load i8, ptr %v.sroa.23.3.scevgep117.1.sroa_idx, align 1, !tbaa !7
  %4 = getelementptr i8, ptr %input, i64 %2
  %scevgep117.2 = getelementptr i8, ptr %4, i64 128
  %v.sroa.27.6.copyload = load i8, ptr %scevgep117.2, align 1, !tbaa !7
  %v.sroa.32.6.scevgep117.2.sroa_idx = getelementptr i8, ptr %4, i64 129
  %v.sroa.32.6.copyload = load i8, ptr %v.sroa.32.6.scevgep117.2.sroa_idx, align 1, !tbaa !7
  %v.sroa.36.6.scevgep117.2.sroa_idx = getelementptr i8, ptr %4, i64 130
  %v.sroa.36.6.copyload = load i8, ptr %v.sroa.36.6.scevgep117.2.sroa_idx, align 1, !tbaa !7
  br label %for.cond36.preheader

for.cond36.preheader:                             ; preds = %if.else, %for.cond.cleanup38
  %v.sroa.36.0 = phi i8 [ %v.sroa.36.6.copyload, %if.else ], [ %v.sroa.36.2, %for.cond.cleanup38 ]
  %v.sroa.32.0 = phi i8 [ %v.sroa.32.6.copyload, %if.else ], [ %v.sroa.32.2, %for.cond.cleanup38 ]
  %v.sroa.27.0 = phi i8 [ %v.sroa.27.6.copyload, %if.else ], [ %v.sroa.27.2, %for.cond.cleanup38 ]
  %v.sroa.23.0 = phi i8 [ %v.sroa.23.3.copyload, %if.else ], [ %v.sroa.23.2, %for.cond.cleanup38 ]
  %v.sroa.18.0 = phi i8 [ %v.sroa.18.3.copyload, %if.else ], [ %v.sroa.18.2, %for.cond.cleanup38 ]
  %v.sroa.13.0 = phi i8 [ %v.sroa.13.3.copyload, %if.else ], [ %v.sroa.13.2, %for.cond.cleanup38 ]
  %v.sroa.9.0 = phi i8 [ %v.sroa.9.0.copyload, %if.else ], [ %v.sroa.9.2, %for.cond.cleanup38 ]
  %v.sroa.5.0 = phi i8 [ %v.sroa.5.0.copyload, %if.else ], [ %v.sroa.5.2, %for.cond.cleanup38 ]
  %v.sroa.0.0 = phi i8 [ %v.sroa.0.0.copyload, %if.else ], [ %v.sroa.0.1, %for.cond.cleanup38 ]
  %indvars.iv128 = phi i64 [ 0, %if.else ], [ %indvars.iv.next129, %for.cond.cleanup38 ]
  %cmp37108 = icmp ult i64 %indvars.iv128, 8
  br i1 %cmp37108, label %for.body39, label %for.cond.cleanup38

for.cond.cleanup34:                               ; preds = %for.cond.cleanup38
  %arrayidx68 = getelementptr inbounds [64 x i8], ptr %output, i64 %indvar, i64 %indvar113
  store i8 %v.sroa.18.2, ptr %arrayidx68, align 1, !tbaa !7
  br label %for.inc70

for.cond.cleanup38:                               ; preds = %for.body39, %for.body39.1, %for.body39.2, %for.body39.3, %for.body39.4, %for.body39.5, %for.body39.6, %for.body39.7, %for.cond36.preheader
  %v.sroa.36.2 = phi i8 [ %v.sroa.36.0, %for.cond36.preheader ], [ %spec.select157, %for.body39.7 ], [ %v.sroa.36.0, %for.body39.6 ], [ %v.sroa.36.0, %for.body39.5 ], [ %v.sroa.36.0, %for.body39.4 ], [ %v.sroa.36.0, %for.body39.3 ], [ %v.sroa.36.0, %for.body39.2 ], [ %v.sroa.36.0, %for.body39.1 ], [ %v.sroa.36.0, %for.body39 ]
  %v.sroa.32.2 = phi i8 [ %v.sroa.32.0, %for.cond36.preheader ], [ %spec.select158, %for.body39.7 ], [ %spec.select155, %for.body39.6 ], [ %v.sroa.32.0, %for.body39.5 ], [ %v.sroa.32.0, %for.body39.4 ], [ %v.sroa.32.0, %for.body39.3 ], [ %v.sroa.32.0, %for.body39.2 ], [ %v.sroa.32.0, %for.body39.1 ], [ %v.sroa.32.0, %for.body39 ]
  %v.sroa.27.2 = phi i8 [ %v.sroa.27.0, %for.cond36.preheader ], [ %spec.select156, %for.body39.7 ], [ %spec.select156, %for.body39.6 ], [ %spec.select153, %for.body39.5 ], [ %v.sroa.27.0, %for.body39.4 ], [ %v.sroa.27.0, %for.body39.3 ], [ %v.sroa.27.0, %for.body39.2 ], [ %v.sroa.27.0, %for.body39.1 ], [ %v.sroa.27.0, %for.body39 ]
  %v.sroa.23.2 = phi i8 [ %v.sroa.23.0, %for.cond36.preheader ], [ %spec.select154, %for.body39.7 ], [ %spec.select154, %for.body39.6 ], [ %spec.select154, %for.body39.5 ], [ %spec.select151, %for.body39.4 ], [ %v.sroa.23.0, %for.body39.3 ], [ %v.sroa.23.0, %for.body39.2 ], [ %v.sroa.23.0, %for.body39.1 ], [ %v.sroa.23.0, %for.body39 ]
  %v.sroa.18.2 = phi i8 [ %v.sroa.18.0, %for.cond36.preheader ], [ %spec.select152, %for.body39.7 ], [ %spec.select152, %for.body39.6 ], [ %spec.select152, %for.body39.5 ], [ %spec.select152, %for.body39.4 ], [ %spec.select149, %for.body39.3 ], [ %v.sroa.18.0, %for.body39.2 ], [ %v.sroa.18.0, %for.body39.1 ], [ %v.sroa.18.0, %for.body39 ]
  %v.sroa.13.2 = phi i8 [ %v.sroa.13.0, %for.cond36.preheader ], [ %spec.select150, %for.body39.7 ], [ %spec.select150, %for.body39.6 ], [ %spec.select150, %for.body39.5 ], [ %spec.select150, %for.body39.4 ], [ %spec.select150, %for.body39.3 ], [ %spec.select147, %for.body39.2 ], [ %v.sroa.13.0, %for.body39.1 ], [ %v.sroa.13.0, %for.body39 ]
  %v.sroa.9.2 = phi i8 [ %v.sroa.9.0, %for.cond36.preheader ], [ %spec.select148, %for.body39.7 ], [ %spec.select148, %for.body39.6 ], [ %spec.select148, %for.body39.5 ], [ %spec.select148, %for.body39.4 ], [ %spec.select148, %for.body39.3 ], [ %spec.select148, %for.body39.2 ], [ %spec.select145, %for.body39.1 ], [ %v.sroa.9.0, %for.body39 ]
  %v.sroa.5.2 = phi i8 [ %v.sroa.5.0, %for.cond36.preheader ], [ %spec.select146, %for.body39.7 ], [ %spec.select146, %for.body39.6 ], [ %spec.select146, %for.body39.5 ], [ %spec.select146, %for.body39.4 ], [ %spec.select146, %for.body39.3 ], [ %spec.select146, %for.body39.2 ], [ %spec.select146, %for.body39.1 ], [ %spec.select, %for.body39 ]
  %v.sroa.0.1 = phi i8 [ %v.sroa.0.0, %for.cond36.preheader ], [ %spec.select144, %for.body39.7 ], [ %spec.select144, %for.body39.6 ], [ %spec.select144, %for.body39.5 ], [ %spec.select144, %for.body39.4 ], [ %spec.select144, %for.body39.3 ], [ %spec.select144, %for.body39.2 ], [ %spec.select144, %for.body39.1 ], [ %spec.select144, %for.body39 ]
  %indvars.iv.next129 = add nuw nsw i64 %indvars.iv128, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next129, 9
  br i1 %exitcond.not, label %for.cond.cleanup34, label %for.cond36.preheader, !llvm.loop !10

for.body39:                                       ; preds = %for.cond36.preheader
  %cmp46 = icmp ugt i8 %v.sroa.0.0, %v.sroa.5.0
  %spec.select = select i1 %cmp46, i8 %v.sroa.0.0, i8 %v.sroa.5.0
  %spec.select144 = select i1 %cmp46, i8 %v.sroa.5.0, i8 %v.sroa.0.0
  %cmp37.not = icmp eq i64 %indvars.iv128, 7
  br i1 %cmp37.not, label %for.cond.cleanup38, label %for.body39.1, !llvm.loop !11

for.body39.1:                                     ; preds = %for.body39
  %cmp46.1 = icmp ugt i8 %spec.select, %v.sroa.9.0
  %spec.select145 = select i1 %cmp46.1, i8 %spec.select, i8 %v.sroa.9.0
  %spec.select146 = select i1 %cmp46.1, i8 %v.sroa.9.0, i8 %spec.select
  %cmp37.1 = icmp ult i64 %indvars.iv128, 6
  br i1 %cmp37.1, label %for.body39.2, label %for.cond.cleanup38, !llvm.loop !11

for.body39.2:                                     ; preds = %for.body39.1
  %cmp46.2 = icmp ugt i8 %spec.select145, %v.sroa.13.0
  %spec.select147 = select i1 %cmp46.2, i8 %spec.select145, i8 %v.sroa.13.0
  %spec.select148 = select i1 %cmp46.2, i8 %v.sroa.13.0, i8 %spec.select145
  %cmp37.2.not = icmp eq i64 %indvars.iv128, 5
  br i1 %cmp37.2.not, label %for.cond.cleanup38, label %for.body39.3, !llvm.loop !11

for.body39.3:                                     ; preds = %for.body39.2
  %cmp46.3 = icmp ugt i8 %spec.select147, %v.sroa.18.0
  %spec.select149 = select i1 %cmp46.3, i8 %spec.select147, i8 %v.sroa.18.0
  %spec.select150 = select i1 %cmp46.3, i8 %v.sroa.18.0, i8 %spec.select147
  %cmp37.3 = icmp ult i64 %indvars.iv128, 4
  br i1 %cmp37.3, label %for.body39.4, label %for.cond.cleanup38, !llvm.loop !11

for.body39.4:                                     ; preds = %for.body39.3
  %cmp46.4 = icmp ugt i8 %spec.select149, %v.sroa.23.0
  %spec.select151 = select i1 %cmp46.4, i8 %spec.select149, i8 %v.sroa.23.0
  %spec.select152 = select i1 %cmp46.4, i8 %v.sroa.23.0, i8 %spec.select149
  %cmp37.4.not = icmp eq i64 %indvars.iv128, 3
  br i1 %cmp37.4.not, label %for.cond.cleanup38, label %for.body39.5, !llvm.loop !11

for.body39.5:                                     ; preds = %for.body39.4
  %cmp46.5 = icmp ugt i8 %spec.select151, %v.sroa.27.0
  %spec.select153 = select i1 %cmp46.5, i8 %spec.select151, i8 %v.sroa.27.0
  %spec.select154 = select i1 %cmp46.5, i8 %v.sroa.27.0, i8 %spec.select151
  %cmp37.5 = icmp ult i64 %indvars.iv128, 2
  br i1 %cmp37.5, label %for.body39.6, label %for.cond.cleanup38, !llvm.loop !11

for.body39.6:                                     ; preds = %for.body39.5
  %cmp46.6 = icmp ugt i8 %spec.select153, %v.sroa.32.0
  %spec.select155 = select i1 %cmp46.6, i8 %spec.select153, i8 %v.sroa.32.0
  %spec.select156 = select i1 %cmp46.6, i8 %v.sroa.32.0, i8 %spec.select153
  %cmp37.6 = icmp eq i64 %indvars.iv128, 0
  br i1 %cmp37.6, label %for.body39.7, label %for.cond.cleanup38, !llvm.loop !11

for.body39.7:                                     ; preds = %for.body39.6
  %cmp46.7 = icmp ugt i8 %spec.select155, %v.sroa.36.0
  %spec.select157 = select i1 %cmp46.7, i8 %spec.select155, i8 %v.sroa.36.0
  %spec.select158 = select i1 %cmp46.7, i8 %v.sroa.36.0, i8 %spec.select155
  br label %for.cond.cleanup38

for.inc70:                                        ; preds = %if.then, %for.cond.cleanup34
  %indvar.next114 = add nuw nsw i64 %indvar113, 1
  %exitcond133.not = icmp eq i64 %indvar.next114, 64
  br i1 %exitcond133.not, label %for.cond.cleanup3, label %for.body4, !llvm.loop !12
}

attributes #0 = { mustprogress nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
!7 = !{!8, !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C++ TBAA"}
!10 = distinct !{!10, !6}
!11 = distinct !{!11, !6}
!12 = distinct !{!12, !6}
