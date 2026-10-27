; ModuleID = '/mnt/d/Ayah/Percobaan2/kernels/sobel/gen/ref_pre.ll'
source_filename = "/mnt/d/Ayah/Percobaan2/kernels/sobel/ref.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: mustprogress nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @_Z21sobel_codesign_filterPA64_hS0_(ptr nocapture noundef readonly %input, ptr nocapture noundef writeonly %output) local_unnamed_addr #0 {
entry:
  %hw_result = alloca i8, align 1
  br label %for.cond1.preheader, !hwsw.partition !5

for.cond1.preheader:                              ; preds = %for.cond.cleanup3, %entry
  %indvars.iv135 = phi i64 [ 0, %entry ], [ %0, %for.cond.cleanup3 ], !hwsw.partition !5
  %cmp5 = icmp eq i64 %indvars.iv135, 0, !hwsw.partition !5
  %cmp6 = icmp eq i64 %indvars.iv135, 63, !hwsw.partition !5
  %or.cond = or i1 %cmp5, %cmp6, !hwsw.partition !5
  %arrayidx58.peel = getelementptr inbounds [64 x i8], ptr %output, i64 %indvars.iv135, i64 0, !hwsw.partition !5
  store i8 0, ptr %arrayidx58.peel, align 1, !tbaa !6, !hwsw.partition !5
  %0 = add nuw nsw i64 %indvars.iv135, 1, !hwsw.partition !5
  %1 = add nsw i64 %indvars.iv135, -1, !hwsw.partition !5
  br label %for.body4, !hwsw.partition !5

for.cond.cleanup:                                 ; preds = %for.cond.cleanup3
  ret void, !hwsw.partition !5

for.cond.cleanup3:                                ; preds = %for.inc66
  %exitcond138.not = icmp eq i64 %0, 64, !hwsw.partition !5
  br i1 %exitcond138.not, label %for.cond.cleanup, label %for.cond1.preheader, !llvm.loop !9, !hwsw.partition !5

for.body4:                                        ; preds = %for.inc66, %for.cond1.preheader
  %indvars.iv = phi i64 [ 1, %for.cond1.preheader ], [ %indvars.iv.next, %for.inc66 ], !hwsw.partition !5
  %cmp10 = icmp eq i64 %indvars.iv, 63, !hwsw.partition !5
  %or.cond73 = or i1 %cmp10, %or.cond, !hwsw.partition !5
  br i1 %or.cond73, label %for.inc66, label %for.cond17.preheader.preheader, !hwsw.partition !5

for.cond17.preheader.preheader:                   ; preds = %for.body4
  %2 = add nsw i64 %indvars.iv, -1, !hwsw.partition !5
  %arrayidx25.1 = getelementptr inbounds [64 x i8], ptr %input, i64 %1, i64 %indvars.iv, !hwsw.partition !5
  %3 = load i8, ptr %arrayidx25.1, align 1, !tbaa !6, !hwsw.partition !11
  %conv.1 = zext i8 %3 to i32, !hwsw.partition !12
  %mul40.1 = mul nsw i32 %conv.1, -2, !hwsw.partition !12
  %arrayidx25 = getelementptr inbounds [64 x i8], ptr %input, i64 %1, i64 %2, !hwsw.partition !5
  %4 = load i8, ptr %arrayidx25, align 1, !tbaa !6, !hwsw.partition !11
  %conv = zext i8 %4 to i32, !hwsw.partition !12
  %5 = add nuw nsw i64 %indvars.iv, 1, !hwsw.partition !5
  %arrayidx25.2 = getelementptr inbounds [64 x i8], ptr %input, i64 %1, i64 %5, !hwsw.partition !5
  %6 = load i8, ptr %arrayidx25.2, align 1, !tbaa !6, !hwsw.partition !11
  %conv.2 = zext i8 %6 to i32, !hwsw.partition !12
  %7 = add nuw nsw i32 %conv, %conv.2, !hwsw.partition !12
  %add41.2 = sub nsw i32 %mul40.1, %7, !hwsw.partition !12
  %arrayidx25.2.1 = getelementptr inbounds [64 x i8], ptr %input, i64 %indvars.iv135, i64 %5, !hwsw.partition !5
  %8 = load i8, ptr %arrayidx25.2.1, align 1, !tbaa !6, !hwsw.partition !11
  %conv.2.1 = zext i8 %8 to i32, !hwsw.partition !12
  %mul.2.1 = shl nuw nsw i32 %conv.2.1, 1, !hwsw.partition !12
  %arrayidx25.1118 = getelementptr inbounds [64 x i8], ptr %input, i64 %indvars.iv135, i64 %2, !hwsw.partition !5
  %9 = load i8, ptr %arrayidx25.1118, align 1, !tbaa !6, !hwsw.partition !11
  %conv.1121 = zext i8 %9 to i32, !hwsw.partition !12
  %10 = shl nuw nsw i32 %conv.1121, 1, !hwsw.partition !12
  %11 = add nuw nsw i32 %10, %conv, !hwsw.partition !12
  %arrayidx25.2126 = getelementptr inbounds [64 x i8], ptr %input, i64 %0, i64 %2, !hwsw.partition !5
  %12 = load i8, ptr %arrayidx25.2126, align 1, !tbaa !6, !hwsw.partition !11
  %conv.2129 = zext i8 %12 to i32, !hwsw.partition !12
  %13 = add nuw nsw i32 %mul.2.1, %conv.2, !hwsw.partition !12
  %14 = add nuw nsw i32 %11, %conv.2129, !hwsw.partition !12
  %add38.2131 = sub nsw i32 %13, %14, !hwsw.partition !12
  %add41.2133 = add nsw i32 %add41.2, %conv.2129, !hwsw.partition !12
  %arrayidx25.1.2 = getelementptr inbounds [64 x i8], ptr %input, i64 %0, i64 %indvars.iv, !hwsw.partition !5
  %15 = load i8, ptr %arrayidx25.1.2, align 1, !tbaa !6, !hwsw.partition !11
  %conv.1.2 = zext i8 %15 to i32, !hwsw.partition !12
  %mul40.1.2 = shl nuw nsw i32 %conv.1.2, 1, !hwsw.partition !12
  %add41.1.2 = add nsw i32 %mul40.1.2, %add41.2133, !hwsw.partition !12
  %arrayidx25.2.2 = getelementptr inbounds [64 x i8], ptr %input, i64 %0, i64 %5, !hwsw.partition !5
  %16 = load i8, ptr %arrayidx25.2.2, align 1, !tbaa !6, !hwsw.partition !11
  %conv.2.2 = zext i8 %16 to i32, !hwsw.partition !12
  %add38.2.2 = add nsw i32 %add38.2131, %conv.2.2, !hwsw.partition !12
  %add41.2.2 = add nsw i32 %add41.1.2, %conv.2.2, !hwsw.partition !12
  %cond = tail call i32 @llvm.abs.i32(i32 %add38.2.2, i1 true), !hwsw.partition !12
  %cond51 = tail call i32 @llvm.abs.i32(i32 %add41.2.2, i1 true), !hwsw.partition !12
  %add52 = add nuw nsw i32 %cond, %cond51, !hwsw.partition !12
  %spec.select139 = tail call i32 @llvm.umin.i32(i32 %add52, i32 255), !hwsw.partition !12
  call void @sobel_hw_gen_c(i8 %4, i8 %3, i8 %6, i8 %9, i8 %8, i8 %12, i8 %15, i8 %16, ptr %hw_result), !hwsw.partition !13
  %hw_value = load i8, ptr %hw_result, align 1
  %spec.select = trunc i32 %spec.select139 to i8, !hwsw.partition !12
  br label %for.inc66, !hwsw.partition !5

for.inc66:                                        ; preds = %for.cond17.preheader.preheader, %for.body4
  %.sink = phi i8 [ 0, %for.body4 ], [ %hw_value, %for.cond17.preheader.preheader ], !hwsw.partition !5
  %arrayidx58 = getelementptr inbounds [64 x i8], ptr %output, i64 %indvars.iv135, i64 %indvars.iv, !hwsw.partition !5
  store i8 %.sink, ptr %arrayidx58, align 1, !tbaa !6, !hwsw.partition !5
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !hwsw.partition !5
  %exitcond.not = icmp eq i64 %indvars.iv.next, 64, !hwsw.partition !5
  br i1 %exitcond.not, label %for.cond.cleanup3, label %for.body4, !llvm.loop !14, !hwsw.partition !5
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.abs.i32(i32, i1 immarg) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #1

declare void @sobel_hw_gen_c(i8, i8, i8, i8, i8, i8, i8, i8, ptr)

attributes #0 = { mustprogress nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!5 = !{!"software"}
!6 = !{!7, !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C++ TBAA"}
!9 = distinct !{!9, !10}
!10 = !{!"llvm.loop.mustprogress"}
!11 = !{!"boundary"}
!12 = !{!"hardware"}
!13 = !{!"hw_invocation"}
!14 = distinct !{!14, !10, !15}
!15 = !{!"llvm.loop.peeled.count", i32 1}
