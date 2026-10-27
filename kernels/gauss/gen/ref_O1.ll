; ModuleID = '/mnt/d/Ayah/Percobaan2/kernels/gauss/ref.cpp'
source_filename = "/mnt/d/Ayah/Percobaan2/kernels/gauss/ref.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: mustprogress nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @_Z12gauss_filterPA64_hS0_(ptr nocapture noundef readonly %input, ptr nocapture noundef writeonly %output) local_unnamed_addr #0 {
entry:
  br label %for.cond1.preheader

for.cond1.preheader:                              ; preds = %entry, %for.cond.cleanup3
  %indvars.iv91 = phi i64 [ 0, %entry ], [ %indvars.iv.next92, %for.cond.cleanup3 ]
  %cmp5 = icmp eq i64 %indvars.iv91, 0
  %cmp6 = icmp eq i64 %indvars.iv91, 63
  %or.cond = or i1 %cmp5, %cmp6
  %arrayidx12.peel = getelementptr inbounds [64 x i8], ptr %output, i64 %indvars.iv91, i64 0
  store i8 0, ptr %arrayidx12.peel, align 1, !tbaa !5
  %0 = add nuw nsw i64 %indvars.iv91, 1
  %1 = add nsw i64 %indvars.iv91, -1
  br label %for.body4

for.cond.cleanup:                                 ; preds = %for.cond.cleanup3
  ret void

for.cond.cleanup3:                                ; preds = %for.inc41
  %indvars.iv.next92 = add nuw nsw i64 %indvars.iv91, 1
  %exitcond94.not = icmp eq i64 %indvars.iv.next92, 64
  br i1 %exitcond94.not, label %for.cond.cleanup, label %for.cond1.preheader, !llvm.loop !8

for.body4:                                        ; preds = %for.cond1.preheader, %for.inc41
  %indvars.iv = phi i64 [ 1, %for.cond1.preheader ], [ %indvars.iv.next, %for.inc41 ]
  %cmp10 = icmp eq i64 %indvars.iv, 63
  %or.cond48 = or i1 %cmp10, %or.cond
  br i1 %or.cond48, label %for.inc41, label %for.cond17.preheader.preheader

for.cond17.preheader.preheader:                   ; preds = %for.body4
  %2 = add nsw i64 %indvars.iv, -1
  %3 = add nuw nsw i64 %indvars.iv, 1
  %arrayidx25.2.1 = getelementptr inbounds [64 x i8], ptr %input, i64 %indvars.iv91, i64 %3
  %4 = load i8, ptr %arrayidx25.2.1, align 1, !tbaa !5
  %conv.2.1 = zext i8 %4 to i32
  %mul.2.1 = shl nuw nsw i32 %conv.2.1, 1
  %arrayidx25.1.1 = getelementptr inbounds [64 x i8], ptr %input, i64 %indvars.iv91, i64 %indvars.iv
  %5 = load i8, ptr %arrayidx25.1.1, align 1, !tbaa !5
  %conv.1.1 = zext i8 %5 to i32
  %mul.1.1 = shl nuw nsw i32 %conv.1.1, 2
  %arrayidx25.179 = getelementptr inbounds [64 x i8], ptr %input, i64 %indvars.iv91, i64 %2
  %6 = load i8, ptr %arrayidx25.179, align 1, !tbaa !5
  %conv.180 = zext i8 %6 to i32
  %mul.182 = shl nuw nsw i32 %conv.180, 1
  %arrayidx25.1 = getelementptr inbounds [64 x i8], ptr %input, i64 %1, i64 %indvars.iv
  %7 = load i8, ptr %arrayidx25.1, align 1, !tbaa !5
  %conv.1 = zext i8 %7 to i32
  %mul.1 = shl nuw nsw i32 %conv.1, 1
  %arrayidx25 = getelementptr inbounds [64 x i8], ptr %input, i64 %1, i64 %2
  %8 = load i8, ptr %arrayidx25, align 1, !tbaa !5
  %conv = zext i8 %8 to i32
  %add32.1 = add nuw nsw i32 %mul.1, %conv
  %9 = add nuw nsw i64 %indvars.iv, 1
  %arrayidx25.2 = getelementptr inbounds [64 x i8], ptr %input, i64 %1, i64 %9
  %10 = load i8, ptr %arrayidx25.2, align 1, !tbaa !5
  %conv.2 = zext i8 %10 to i32
  %add32.2 = add nuw nsw i32 %add32.1, %conv.2
  %add32.183 = add nuw nsw i32 %mul.182, %add32.2
  %add32.1.1 = add nuw nsw i32 %mul.1.1, %add32.183
  %add32.2.1 = add nuw nsw i32 %mul.2.1, %add32.1.1
  %arrayidx25.284 = getelementptr inbounds [64 x i8], ptr %input, i64 %0, i64 %2
  %11 = load i8, ptr %arrayidx25.284, align 1, !tbaa !5
  %conv.285 = zext i8 %11 to i32
  %add32.288 = add nuw nsw i32 %add32.2.1, %conv.285
  %arrayidx25.1.2 = getelementptr inbounds [64 x i8], ptr %input, i64 %0, i64 %indvars.iv
  %12 = load i8, ptr %arrayidx25.1.2, align 1, !tbaa !5
  %conv.1.2 = zext i8 %12 to i32
  %mul.1.2 = shl nuw nsw i32 %conv.1.2, 1
  %add32.1.2 = add nuw nsw i32 %mul.1.2, %add32.288
  %13 = add nuw nsw i64 %indvars.iv, 1
  %arrayidx25.2.2 = getelementptr inbounds [64 x i8], ptr %input, i64 %0, i64 %13
  %14 = load i8, ptr %arrayidx25.2.2, align 1, !tbaa !5
  %conv.2.2 = zext i8 %14 to i32
  %add32.2.2 = add nuw nsw i32 %add32.1.2, %conv.2.2
  %shr = lshr i32 %add32.2.2, 4
  %conv36 = trunc i32 %shr to i8
  br label %for.inc41

for.inc41:                                        ; preds = %for.body4, %for.cond17.preheader.preheader
  %.sink = phi i8 [ %conv36, %for.cond17.preheader.preheader ], [ 0, %for.body4 ]
  %arrayidx12 = getelementptr inbounds [64 x i8], ptr %output, i64 %indvars.iv91, i64 %indvars.iv
  store i8 %.sink, ptr %arrayidx12, align 1, !tbaa !5
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, 64
  br i1 %exitcond.not, label %for.cond.cleanup3, label %for.body4, !llvm.loop !10
}

attributes #0 = { mustprogress nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

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
