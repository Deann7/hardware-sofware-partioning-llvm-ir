; ModuleID = '/mnt/d/Ayah/Percobaan2/kernels/conv5/gen/annotated.ll'
source_filename = "/mnt/d/Ayah/Percobaan2/kernels/conv5/ref.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: mustprogress nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @_Z12conv5_filterPA64_hS0_(ptr nocapture noundef readonly %input, ptr nocapture noundef writeonly %output) local_unnamed_addr #0 {
entry:
  %hw_result = alloca i8, align 1
  br label %for.cond1.preheader, !hwsw.partition !5

for.cond1.preheader:                              ; preds = %for.cond.cleanup3, %entry
  %indvars.iv102 = phi i64 [ 0, %entry ], [ %3, %for.cond.cleanup3 ], !hwsw.partition !5
  %0 = trunc i64 %indvars.iv102 to i32, !hwsw.partition !5
  %1 = add i32 %0, -62, !hwsw.partition !5
  %or.cond = icmp ult i32 %1, -60, !hwsw.partition !5
  %2 = add nuw nsw i64 %indvars.iv102, 2, !hwsw.partition !5
  %3 = add nuw nsw i64 %indvars.iv102, 1, !hwsw.partition !5
  %4 = add nsw i64 %indvars.iv102, -1, !hwsw.partition !5
  %5 = add nsw i64 %indvars.iv102, -2, !hwsw.partition !5
  br label %for.body4, !hwsw.partition !5

for.cond.cleanup:                                 ; preds = %for.cond.cleanup3
  ret void, !hwsw.partition !5

for.cond.cleanup3:                                ; preds = %for.inc41
  %exitcond105.not = icmp eq i64 %3, 64, !hwsw.partition !5
  br i1 %exitcond105.not, label %for.cond.cleanup, label %for.cond1.preheader, !llvm.loop !6, !hwsw.partition !5

for.body4:                                        ; preds = %for.inc41, %for.cond1.preheader
  %indvars.iv = phi i64 [ 0, %for.cond1.preheader ], [ %indvars.iv.next, %for.inc41 ], !hwsw.partition !5
  %6 = trunc i64 %indvars.iv to i32, !hwsw.partition !5
  %7 = add i32 %6, -62, !hwsw.partition !5
  %8 = icmp ult i32 %7, -60, !hwsw.partition !5
  %or.cond48 = or i1 %or.cond, %8, !hwsw.partition !5
  br i1 %or.cond48, label %for.inc41, label %for.cond17.preheader.preheader, !hwsw.partition !5

for.cond17.preheader.preheader:                   ; preds = %for.body4
  %9 = add nsw i64 %indvars.iv, -2, !hwsw.partition !5
  %10 = add nuw nsw i64 %indvars.iv, 2, !hwsw.partition !5
  %arrayidx25.4.3 = getelementptr inbounds [64 x i8], ptr %input, i64 %3, i64 %10, !hwsw.partition !5
  %11 = load i8, ptr %arrayidx25.4.3, align 1, !tbaa !8, !hwsw.partition !11
  %12 = add nuw nsw i64 %indvars.iv, 1, !hwsw.partition !5
  %arrayidx25.3.3 = getelementptr inbounds [64 x i8], ptr %input, i64 %3, i64 %12, !hwsw.partition !5
  %13 = load i8, ptr %arrayidx25.3.3, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.2.3 = getelementptr inbounds [64 x i8], ptr %input, i64 %3, i64 %indvars.iv, !hwsw.partition !5
  %14 = load i8, ptr %arrayidx25.2.3, align 1, !tbaa !8, !hwsw.partition !11
  %15 = add nsw i64 %indvars.iv, -1, !hwsw.partition !5
  %arrayidx25.1.3 = getelementptr inbounds [64 x i8], ptr %input, i64 %3, i64 %15, !hwsw.partition !5
  %16 = load i8, ptr %arrayidx25.1.3, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.391 = getelementptr inbounds [64 x i8], ptr %input, i64 %3, i64 %9, !hwsw.partition !5
  %17 = load i8, ptr %arrayidx25.391, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.4.2 = getelementptr inbounds [64 x i8], ptr %input, i64 %indvars.iv102, i64 %10, !hwsw.partition !5
  %18 = load i8, ptr %arrayidx25.4.2, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.3.2 = getelementptr inbounds [64 x i8], ptr %input, i64 %indvars.iv102, i64 %12, !hwsw.partition !5
  %19 = load i8, ptr %arrayidx25.3.2, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.2.2 = getelementptr inbounds [64 x i8], ptr %input, i64 %indvars.iv102, i64 %indvars.iv, !hwsw.partition !5
  %20 = load i8, ptr %arrayidx25.2.2, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.1.2 = getelementptr inbounds [64 x i8], ptr %input, i64 %indvars.iv102, i64 %15, !hwsw.partition !5
  %21 = load i8, ptr %arrayidx25.1.2, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.286 = getelementptr inbounds [64 x i8], ptr %input, i64 %indvars.iv102, i64 %9, !hwsw.partition !5
  %22 = load i8, ptr %arrayidx25.286, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.4.1 = getelementptr inbounds [64 x i8], ptr %input, i64 %4, i64 %10, !hwsw.partition !5
  %23 = load i8, ptr %arrayidx25.4.1, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.3.1 = getelementptr inbounds [64 x i8], ptr %input, i64 %4, i64 %12, !hwsw.partition !5
  %24 = load i8, ptr %arrayidx25.3.1, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.2.1 = getelementptr inbounds [64 x i8], ptr %input, i64 %4, i64 %indvars.iv, !hwsw.partition !5
  %25 = load i8, ptr %arrayidx25.2.1, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.1.1 = getelementptr inbounds [64 x i8], ptr %input, i64 %4, i64 %15, !hwsw.partition !5
  %26 = load i8, ptr %arrayidx25.1.1, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.181 = getelementptr inbounds [64 x i8], ptr %input, i64 %4, i64 %9, !hwsw.partition !5
  %27 = load i8, ptr %arrayidx25.181, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.3 = getelementptr inbounds [64 x i8], ptr %input, i64 %5, i64 %12, !hwsw.partition !5
  %28 = load i8, ptr %arrayidx25.3, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.2 = getelementptr inbounds [64 x i8], ptr %input, i64 %5, i64 %indvars.iv, !hwsw.partition !5
  %29 = load i8, ptr %arrayidx25.2, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.1 = getelementptr inbounds [64 x i8], ptr %input, i64 %5, i64 %15, !hwsw.partition !5
  %30 = load i8, ptr %arrayidx25.1, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25 = getelementptr inbounds [64 x i8], ptr %input, i64 %5, i64 %9, !hwsw.partition !5
  %31 = load i8, ptr %arrayidx25, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.4 = getelementptr inbounds [64 x i8], ptr %input, i64 %5, i64 %10, !hwsw.partition !5
  %32 = load i8, ptr %arrayidx25.4, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.496 = getelementptr inbounds [64 x i8], ptr %input, i64 %2, i64 %9, !hwsw.partition !5
  %33 = load i8, ptr %arrayidx25.496, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.1.4 = getelementptr inbounds [64 x i8], ptr %input, i64 %2, i64 %15, !hwsw.partition !5
  %34 = load i8, ptr %arrayidx25.1.4, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.2.4 = getelementptr inbounds [64 x i8], ptr %input, i64 %2, i64 %indvars.iv, !hwsw.partition !5
  %35 = load i8, ptr %arrayidx25.2.4, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.3.4 = getelementptr inbounds [64 x i8], ptr %input, i64 %2, i64 %12, !hwsw.partition !5
  %36 = load i8, ptr %arrayidx25.3.4, align 1, !tbaa !8, !hwsw.partition !11
  %arrayidx25.4.4 = getelementptr inbounds [64 x i8], ptr %input, i64 %2, i64 %10, !hwsw.partition !5
  %37 = load i8, ptr %arrayidx25.4.4, align 1, !tbaa !8, !hwsw.partition !11
  call void @conv5_hw_gen_c(i8 %31, i8 %30, i8 %29, i8 %28, i8 %32, i8 %27, i8 %26, i8 %25, i8 %24, i8 %23, i8 %22, i8 %21, i8 %20, i8 %19, i8 %18, i8 %17, i8 %16, i8 %14, i8 %13, i8 %11, i8 %33, i8 %34, i8 %35, i8 %36, i8 %37, ptr %hw_result), !hwsw.partition !12
  %hw_value = load i8, ptr %hw_result, align 1
  br label %for.inc41, !hwsw.partition !5

for.inc41:                                        ; preds = %for.cond17.preheader.preheader, %for.body4
  %.sink = phi i8 [ %hw_value, %for.cond17.preheader.preheader ], [ 0, %for.body4 ], !hwsw.partition !5
  %arrayidx12 = getelementptr inbounds [64 x i8], ptr %output, i64 %indvars.iv102, i64 %indvars.iv, !hwsw.partition !5
  store i8 %.sink, ptr %arrayidx12, align 1, !tbaa !8, !hwsw.partition !5
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !hwsw.partition !5
  %exitcond.not = icmp eq i64 %indvars.iv.next, 64, !hwsw.partition !5
  br i1 %exitcond.not, label %for.cond.cleanup3, label %for.body4, !llvm.loop !13, !hwsw.partition !5
}

declare void @conv5_hw_gen_c(i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, ptr)

attributes #0 = { mustprogress nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!5 = !{!"software"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = !{!9, !9, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C++ TBAA"}
!11 = !{!"boundary"}
!12 = !{!"hw_invocation"}
!13 = distinct !{!13, !7}
