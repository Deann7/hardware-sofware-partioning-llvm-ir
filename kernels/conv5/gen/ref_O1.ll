; ModuleID = '/mnt/d/Ayah/Percobaan2/kernels/conv5/ref.cpp'
source_filename = "/mnt/d/Ayah/Percobaan2/kernels/conv5/ref.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: mustprogress nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @_Z12conv5_filterPA64_hS0_(ptr nocapture noundef readonly %input, ptr nocapture noundef writeonly %output) local_unnamed_addr #0 {
entry:
  br label %for.cond1.preheader

for.cond1.preheader:                              ; preds = %entry, %for.cond.cleanup3
  %indvars.iv102 = phi i64 [ 0, %entry ], [ %indvars.iv.next103, %for.cond.cleanup3 ]
  %0 = trunc i64 %indvars.iv102 to i32
  %1 = add i32 %0, -62
  %or.cond = icmp ult i32 %1, -60
  %2 = add nuw nsw i64 %indvars.iv102, 2
  %3 = add nuw nsw i64 %indvars.iv102, 1
  %4 = add nsw i64 %indvars.iv102, -1
  %5 = add nsw i64 %indvars.iv102, -2
  br label %for.body4

for.cond.cleanup:                                 ; preds = %for.cond.cleanup3
  ret void

for.cond.cleanup3:                                ; preds = %for.inc41
  %indvars.iv.next103 = add nuw nsw i64 %indvars.iv102, 1
  %exitcond105.not = icmp eq i64 %indvars.iv.next103, 64
  br i1 %exitcond105.not, label %for.cond.cleanup, label %for.cond1.preheader, !llvm.loop !5

for.body4:                                        ; preds = %for.cond1.preheader, %for.inc41
  %indvars.iv = phi i64 [ 0, %for.cond1.preheader ], [ %indvars.iv.next, %for.inc41 ]
  %6 = trunc i64 %indvars.iv to i32
  %7 = add i32 %6, -62
  %8 = icmp ult i32 %7, -60
  %or.cond48 = or i1 %or.cond, %8
  br i1 %or.cond48, label %for.inc41, label %for.cond17.preheader.preheader

for.cond17.preheader.preheader:                   ; preds = %for.body4
  %9 = add nsw i64 %indvars.iv, -2
  %10 = add nuw nsw i64 %indvars.iv, 2
  %arrayidx25.4.3 = getelementptr inbounds [64 x i8], ptr %input, i64 %3, i64 %10
  %11 = load i8, ptr %arrayidx25.4.3, align 1, !tbaa !7
  %conv.4.3 = zext i8 %11 to i32
  %mul.4.3 = shl nuw nsw i32 %conv.4.3, 2
  %12 = add nuw nsw i64 %indvars.iv, 1
  %arrayidx25.3.3 = getelementptr inbounds [64 x i8], ptr %input, i64 %3, i64 %12
  %13 = load i8, ptr %arrayidx25.3.3, align 1, !tbaa !7
  %conv.3.3 = zext i8 %13 to i32
  %mul.3.3 = shl nuw nsw i32 %conv.3.3, 4
  %arrayidx25.2.3 = getelementptr inbounds [64 x i8], ptr %input, i64 %3, i64 %indvars.iv
  %14 = load i8, ptr %arrayidx25.2.3, align 1, !tbaa !7
  %conv.2.3 = zext i8 %14 to i32
  %mul.2.3 = mul nuw nsw i32 %conv.2.3, 26
  %15 = add nsw i64 %indvars.iv, -1
  %arrayidx25.1.3 = getelementptr inbounds [64 x i8], ptr %input, i64 %3, i64 %15
  %16 = load i8, ptr %arrayidx25.1.3, align 1, !tbaa !7
  %conv.1.3 = zext i8 %16 to i32
  %mul.1.3 = shl nuw nsw i32 %conv.1.3, 4
  %arrayidx25.391 = getelementptr inbounds [64 x i8], ptr %input, i64 %3, i64 %9
  %17 = load i8, ptr %arrayidx25.391, align 1, !tbaa !7
  %conv.392 = zext i8 %17 to i32
  %mul.394 = shl nuw nsw i32 %conv.392, 2
  %18 = add nuw nsw i64 %indvars.iv, 2
  %arrayidx25.4.2 = getelementptr inbounds [64 x i8], ptr %input, i64 %indvars.iv102, i64 %18
  %19 = load i8, ptr %arrayidx25.4.2, align 1, !tbaa !7
  %conv.4.2 = zext i8 %19 to i32
  %mul.4.2 = mul nuw nsw i32 %conv.4.2, 7
  %20 = add nuw nsw i64 %indvars.iv, 1
  %arrayidx25.3.2 = getelementptr inbounds [64 x i8], ptr %input, i64 %indvars.iv102, i64 %20
  %21 = load i8, ptr %arrayidx25.3.2, align 1, !tbaa !7
  %conv.3.2 = zext i8 %21 to i32
  %mul.3.2 = mul nuw nsw i32 %conv.3.2, 26
  %arrayidx25.2.2 = getelementptr inbounds [64 x i8], ptr %input, i64 %indvars.iv102, i64 %indvars.iv
  %22 = load i8, ptr %arrayidx25.2.2, align 1, !tbaa !7
  %conv.2.2 = zext i8 %22 to i32
  %mul.2.2 = mul nuw nsw i32 %conv.2.2, 41
  %23 = add nsw i64 %indvars.iv, -1
  %arrayidx25.1.2 = getelementptr inbounds [64 x i8], ptr %input, i64 %indvars.iv102, i64 %23
  %24 = load i8, ptr %arrayidx25.1.2, align 1, !tbaa !7
  %conv.1.2 = zext i8 %24 to i32
  %mul.1.2 = mul nuw nsw i32 %conv.1.2, 26
  %arrayidx25.286 = getelementptr inbounds [64 x i8], ptr %input, i64 %indvars.iv102, i64 %9
  %25 = load i8, ptr %arrayidx25.286, align 1, !tbaa !7
  %conv.287 = zext i8 %25 to i32
  %mul.289 = mul nuw nsw i32 %conv.287, 7
  %26 = add nuw nsw i64 %indvars.iv, 2
  %arrayidx25.4.1 = getelementptr inbounds [64 x i8], ptr %input, i64 %4, i64 %26
  %27 = load i8, ptr %arrayidx25.4.1, align 1, !tbaa !7
  %conv.4.1 = zext i8 %27 to i32
  %mul.4.1 = shl nuw nsw i32 %conv.4.1, 2
  %28 = add nuw nsw i64 %indvars.iv, 1
  %arrayidx25.3.1 = getelementptr inbounds [64 x i8], ptr %input, i64 %4, i64 %28
  %29 = load i8, ptr %arrayidx25.3.1, align 1, !tbaa !7
  %conv.3.1 = zext i8 %29 to i32
  %mul.3.1 = shl nuw nsw i32 %conv.3.1, 4
  %arrayidx25.2.1 = getelementptr inbounds [64 x i8], ptr %input, i64 %4, i64 %indvars.iv
  %30 = load i8, ptr %arrayidx25.2.1, align 1, !tbaa !7
  %conv.2.1 = zext i8 %30 to i32
  %mul.2.1 = mul nuw nsw i32 %conv.2.1, 26
  %31 = add nsw i64 %indvars.iv, -1
  %arrayidx25.1.1 = getelementptr inbounds [64 x i8], ptr %input, i64 %4, i64 %31
  %32 = load i8, ptr %arrayidx25.1.1, align 1, !tbaa !7
  %conv.1.1 = zext i8 %32 to i32
  %mul.1.1 = shl nuw nsw i32 %conv.1.1, 4
  %arrayidx25.181 = getelementptr inbounds [64 x i8], ptr %input, i64 %4, i64 %9
  %33 = load i8, ptr %arrayidx25.181, align 1, !tbaa !7
  %conv.182 = zext i8 %33 to i32
  %mul.184 = shl nuw nsw i32 %conv.182, 2
  %34 = add nuw nsw i64 %indvars.iv, 1
  %arrayidx25.3 = getelementptr inbounds [64 x i8], ptr %input, i64 %5, i64 %34
  %35 = load i8, ptr %arrayidx25.3, align 1, !tbaa !7
  %conv.3 = zext i8 %35 to i32
  %mul.3 = shl nuw nsw i32 %conv.3, 2
  %arrayidx25.2 = getelementptr inbounds [64 x i8], ptr %input, i64 %5, i64 %indvars.iv
  %36 = load i8, ptr %arrayidx25.2, align 1, !tbaa !7
  %conv.2 = zext i8 %36 to i32
  %mul.2 = mul nuw nsw i32 %conv.2, 7
  %37 = add nsw i64 %indvars.iv, -1
  %arrayidx25.1 = getelementptr inbounds [64 x i8], ptr %input, i64 %5, i64 %37
  %38 = load i8, ptr %arrayidx25.1, align 1, !tbaa !7
  %conv.1 = zext i8 %38 to i32
  %mul.1 = shl nuw nsw i32 %conv.1, 2
  %arrayidx25 = getelementptr inbounds [64 x i8], ptr %input, i64 %5, i64 %9
  %39 = load i8, ptr %arrayidx25, align 1, !tbaa !7
  %conv = zext i8 %39 to i32
  %add32.1 = add nuw nsw i32 %mul.1, %conv
  %add32.2 = add nuw nsw i32 %mul.2, %add32.1
  %add32.3 = add nuw nsw i32 %mul.3, %add32.2
  %40 = add nuw nsw i64 %indvars.iv, 2
  %arrayidx25.4 = getelementptr inbounds [64 x i8], ptr %input, i64 %5, i64 %40
  %41 = load i8, ptr %arrayidx25.4, align 1, !tbaa !7
  %conv.4 = zext i8 %41 to i32
  %add32.4 = add nuw nsw i32 %add32.3, %conv.4
  %add32.185 = add nuw nsw i32 %mul.184, %add32.4
  %add32.1.1 = add nuw nsw i32 %mul.1.1, %add32.185
  %add32.2.1 = add nuw nsw i32 %mul.2.1, %add32.1.1
  %add32.3.1 = add nuw nsw i32 %mul.3.1, %add32.2.1
  %add32.4.1 = add nuw nsw i32 %mul.4.1, %add32.3.1
  %add32.290 = add nuw nsw i32 %mul.289, %add32.4.1
  %add32.1.2 = add nuw nsw i32 %mul.1.2, %add32.290
  %add32.2.2 = add nuw nsw i32 %mul.2.2, %add32.1.2
  %add32.3.2 = add nuw nsw i32 %mul.3.2, %add32.2.2
  %add32.4.2 = add nuw nsw i32 %mul.4.2, %add32.3.2
  %add32.395 = add nuw nsw i32 %mul.394, %add32.4.2
  %add32.1.3 = add nuw nsw i32 %mul.1.3, %add32.395
  %add32.2.3 = add nuw nsw i32 %mul.2.3, %add32.1.3
  %add32.3.3 = add nuw nsw i32 %mul.3.3, %add32.2.3
  %add32.4.3 = add nuw nsw i32 %mul.4.3, %add32.3.3
  %arrayidx25.496 = getelementptr inbounds [64 x i8], ptr %input, i64 %2, i64 %9
  %42 = load i8, ptr %arrayidx25.496, align 1, !tbaa !7
  %conv.497 = zext i8 %42 to i32
  %add32.4100 = add nuw nsw i32 %add32.4.3, %conv.497
  %43 = add nsw i64 %indvars.iv, -1
  %arrayidx25.1.4 = getelementptr inbounds [64 x i8], ptr %input, i64 %2, i64 %43
  %44 = load i8, ptr %arrayidx25.1.4, align 1, !tbaa !7
  %conv.1.4 = zext i8 %44 to i32
  %mul.1.4 = shl nuw nsw i32 %conv.1.4, 2
  %add32.1.4 = add nuw nsw i32 %mul.1.4, %add32.4100
  %arrayidx25.2.4 = getelementptr inbounds [64 x i8], ptr %input, i64 %2, i64 %indvars.iv
  %45 = load i8, ptr %arrayidx25.2.4, align 1, !tbaa !7
  %conv.2.4 = zext i8 %45 to i32
  %mul.2.4 = mul nuw nsw i32 %conv.2.4, 7
  %add32.2.4 = add nuw nsw i32 %mul.2.4, %add32.1.4
  %46 = add nuw nsw i64 %indvars.iv, 1
  %arrayidx25.3.4 = getelementptr inbounds [64 x i8], ptr %input, i64 %2, i64 %46
  %47 = load i8, ptr %arrayidx25.3.4, align 1, !tbaa !7
  %conv.3.4 = zext i8 %47 to i32
  %mul.3.4 = shl nuw nsw i32 %conv.3.4, 2
  %add32.3.4 = add nuw nsw i32 %mul.3.4, %add32.2.4
  %48 = add nuw nsw i64 %indvars.iv, 2
  %arrayidx25.4.4 = getelementptr inbounds [64 x i8], ptr %input, i64 %2, i64 %48
  %49 = load i8, ptr %arrayidx25.4.4, align 1, !tbaa !7
  %conv.4.4 = zext i8 %49 to i32
  %add32.4.4 = add nuw nsw i32 %add32.3.4, %conv.4.4
  %div = udiv i32 %add32.4.4, 273
  %conv36 = trunc i32 %div to i8
  br label %for.inc41

for.inc41:                                        ; preds = %for.body4, %for.cond17.preheader.preheader
  %.sink = phi i8 [ %conv36, %for.cond17.preheader.preheader ], [ 0, %for.body4 ]
  %arrayidx12 = getelementptr inbounds [64 x i8], ptr %output, i64 %indvars.iv102, i64 %indvars.iv
  store i8 %.sink, ptr %arrayidx12, align 1, !tbaa !7
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
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
!7 = !{!8, !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C++ TBAA"}
!10 = distinct !{!10, !6}
