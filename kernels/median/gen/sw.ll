; ModuleID = '/mnt/d/Ayah/Percobaan2/kernels/median/gen/annotated.ll'
source_filename = "/mnt/d/Ayah/Percobaan2/kernels/median/ref.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: mustprogress nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @_Z13median_filterPA64_hS0_(ptr nocapture noundef readonly %input, ptr nocapture noundef writeonly %output) local_unnamed_addr #0 {
entry:
  %hw_result = alloca i8, align 1
  br label %for.cond1.preheader, !hwsw.partition !5

for.cond1.preheader:                              ; preds = %for.cond.cleanup3, %entry
  %indvar = phi i64 [ 0, %entry ], [ %indvar.next, %for.cond.cleanup3 ], !hwsw.partition !5
  %0 = shl nuw nsw i64 %indvar, 6, !hwsw.partition !5
  %cmp5 = icmp eq i64 %indvar, 0, !hwsw.partition !5
  %cmp6 = icmp eq i64 %indvar, 63, !hwsw.partition !5
  %or.cond = or i1 %cmp5, %cmp6, !hwsw.partition !5
  %arrayidx12.peel = getelementptr inbounds [64 x i8], ptr %output, i64 %indvar, i64 0, !hwsw.partition !5
  store i8 0, ptr %arrayidx12.peel, align 1, !tbaa !6, !hwsw.partition !5
  br label %for.body4, !hwsw.partition !5

for.cond.cleanup:                                 ; preds = %for.cond.cleanup3
  ret void, !hwsw.partition !5

for.cond.cleanup3:                                ; preds = %for.inc70
  %indvar.next = add nuw nsw i64 %indvar, 1, !hwsw.partition !5
  %exitcond135.not = icmp eq i64 %indvar.next, 64, !hwsw.partition !5
  br i1 %exitcond135.not, label %for.cond.cleanup, label %for.cond1.preheader, !llvm.loop !9, !hwsw.partition !5

for.body4:                                        ; preds = %for.inc70, %for.cond1.preheader
  %indvar113 = phi i64 [ 1, %for.cond1.preheader ], [ %indvar.next114, %for.inc70 ], !hwsw.partition !5
  %cmp10 = icmp eq i64 %indvar113, 63, !hwsw.partition !5
  %or.cond77 = or i1 %cmp10, %or.cond, !hwsw.partition !5
  br i1 %or.cond77, label %if.then, label %if.else, !hwsw.partition !5

if.then:                                          ; preds = %for.body4
  %arrayidx12 = getelementptr inbounds [64 x i8], ptr %output, i64 %indvar, i64 %indvar113, !hwsw.partition !5
  store i8 0, ptr %arrayidx12, align 1, !tbaa !6, !hwsw.partition !5
  br label %for.inc70, !hwsw.partition !5

if.else:                                          ; preds = %for.body4
  %1 = getelementptr i8, ptr %input, i64 %0, !hwsw.partition !5
  %2 = getelementptr i8, ptr %1, i64 -65, !hwsw.partition !5
  %scevgep117 = getelementptr i8, ptr %2, i64 %indvar113, !hwsw.partition !5
  %v.sroa.0.0.copyload = load i8, ptr %scevgep117, align 1, !tbaa !6, !hwsw.partition !11
  %v.sroa.5.0.scevgep117.sroa_idx = getelementptr inbounds i8, ptr %scevgep117, i64 1, !hwsw.partition !5
  %v.sroa.5.0.copyload = load i8, ptr %v.sroa.5.0.scevgep117.sroa_idx, align 1, !tbaa !6, !hwsw.partition !11
  %v.sroa.9.0.scevgep117.sroa_idx = getelementptr inbounds i8, ptr %scevgep117, i64 2, !hwsw.partition !5
  %v.sroa.9.0.copyload = load i8, ptr %v.sroa.9.0.scevgep117.sroa_idx, align 1, !tbaa !6, !hwsw.partition !11
  %scevgep117.1 = getelementptr i8, ptr %scevgep117, i64 64, !hwsw.partition !5
  %v.sroa.13.3.copyload = load i8, ptr %scevgep117.1, align 1, !tbaa !6, !hwsw.partition !11
  %v.sroa.18.3.scevgep117.1.sroa_idx = getelementptr i8, ptr %scevgep117, i64 65, !hwsw.partition !5
  %v.sroa.18.3.copyload = load i8, ptr %v.sroa.18.3.scevgep117.1.sroa_idx, align 1, !tbaa !6, !hwsw.partition !11
  %v.sroa.23.3.scevgep117.1.sroa_idx = getelementptr i8, ptr %scevgep117, i64 66, !hwsw.partition !5
  %v.sroa.23.3.copyload = load i8, ptr %v.sroa.23.3.scevgep117.1.sroa_idx, align 1, !tbaa !6, !hwsw.partition !11
  %scevgep117.2 = getelementptr i8, ptr %scevgep117, i64 128, !hwsw.partition !5
  %v.sroa.27.6.copyload = load i8, ptr %scevgep117.2, align 1, !tbaa !6, !hwsw.partition !11
  %v.sroa.32.6.scevgep117.2.sroa_idx = getelementptr i8, ptr %scevgep117, i64 129, !hwsw.partition !5
  %v.sroa.32.6.copyload = load i8, ptr %v.sroa.32.6.scevgep117.2.sroa_idx, align 1, !tbaa !6, !hwsw.partition !11
  %v.sroa.36.6.scevgep117.2.sroa_idx = getelementptr i8, ptr %scevgep117, i64 130, !hwsw.partition !5
  %v.sroa.36.6.copyload = load i8, ptr %v.sroa.36.6.scevgep117.2.sroa_idx, align 1, !tbaa !6, !hwsw.partition !11
  call void @median_hw_gen_c(i8 %v.sroa.0.0.copyload, i8 %v.sroa.5.0.copyload, i8 %v.sroa.9.0.copyload, i8 %v.sroa.13.3.copyload, i8 %v.sroa.18.3.copyload, i8 %v.sroa.23.3.copyload, i8 %v.sroa.27.6.copyload, i8 %v.sroa.32.6.copyload, i8 %v.sroa.36.6.copyload, ptr %hw_result), !hwsw.partition !12
  %hw_value = load i8, ptr %hw_result, align 1
  %arrayidx68 = getelementptr inbounds [64 x i8], ptr %output, i64 %indvar, i64 %indvar113, !hwsw.partition !5
  store i8 %hw_value, ptr %arrayidx68, align 1, !tbaa !6, !hwsw.partition !5
  br label %for.inc70, !hwsw.partition !5

for.inc70:                                        ; preds = %if.else, %if.then
  %indvar.next114 = add nuw nsw i64 %indvar113, 1, !hwsw.partition !5
  %exitcond133.not = icmp eq i64 %indvar.next114, 64, !hwsw.partition !5
  br i1 %exitcond133.not, label %for.cond.cleanup3, label %for.body4, !llvm.loop !13, !hwsw.partition !5
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i8 @llvm.umax.i8(i8, i8) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i8 @llvm.umin.i8(i8, i8) #1

declare void @median_hw_gen_c(i8, i8, i8, i8, i8, i8, i8, i8, i8, ptr)

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
!12 = !{!"hw_invocation"}
!13 = distinct !{!13, !10, !14}
!14 = !{!"llvm.loop.peeled.count", i32 1}
