; ModuleID = 'benchmarks/leftpad/source.ll'
source_filename = "benchmarks/leftpad/source.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.1 = private unnamed_addr constant [40 x i8] c"usage: leftpad string length [padding]\0A\00", align 1
@stderr = external global ptr, align 8
@.str.2 = private unnamed_addr constant [24 x i8] c"leftpad: invalid length\00", align 1
@.str.3 = private unnamed_addr constant [23 x i8] c"leftpad: out of memory\00", align 1

; Function Attrs: nounwind uwtable
define dso_local i64 @leftpad(ptr noundef %str, ptr noundef %padding, i64 noundef %min_len, ptr noundef %dest, i64 noundef %dest_sz) #0 {
entry:
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %str_len.0 = phi i64 [ 0, %entry ], [ %inc, %while.body ]
  %tobool = icmp ne ptr %str, null
  br i1 %tobool, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %while.cond
  %arrayidx = getelementptr inbounds i8, ptr %str, i64 %str_len.0
  %0 = load i8, ptr %arrayidx, align 1, !tbaa !5
  %conv = sext i8 %0 to i32
  %tobool1 = icmp ne i32 %conv, 0
  br label %land.end

land.end:                                         ; preds = %land.rhs, %while.cond
  %1 = phi i1 [ false, %while.cond ], [ %tobool1, %land.rhs ]
  br i1 %1, label %while.body, label %while.end

while.body:                                       ; preds = %land.end
  %inc = add i64 %str_len.0, 1
  br label %while.cond, !llvm.loop !8

while.end:                                        ; preds = %land.end
  %tobool2 = icmp ne ptr %padding, null
  br i1 %tobool2, label %lor.lhs.false, label %if.then

lor.lhs.false:                                    ; preds = %while.end
  %arrayidx3 = getelementptr inbounds i8, ptr %padding, i64 0
  %2 = load i8, ptr %arrayidx3, align 1, !tbaa !5
  %tobool4 = icmp ne i8 %2, 0
  br i1 %tobool4, label %if.end, label %if.then

if.then:                                          ; preds = %lor.lhs.false, %while.end
  br label %if.end

if.end:                                           ; preds = %if.then, %lor.lhs.false
  %padding.addr.0 = phi ptr [ %padding, %lor.lhs.false ], [ @.str, %if.then ]
  %cmp = icmp ult i64 %str_len.0, %min_len
  br i1 %cmp, label %if.then6, label %if.end7

if.then6:                                         ; preds = %if.end
  %sub = sub i64 %min_len, %str_len.0
  br label %if.end7

if.end7:                                          ; preds = %if.then6, %if.end
  %npad.0 = phi i64 [ %sub, %if.then6 ], [ 0, %if.end ]
  %tobool8 = icmp ne ptr %dest, null
  br i1 %tobool8, label %lor.lhs.false9, label %if.then11

lor.lhs.false9:                                   ; preds = %if.end7
  %tobool10 = icmp ne i64 %dest_sz, 0
  br i1 %tobool10, label %if.end12, label %if.then11

if.then11:                                        ; preds = %lor.lhs.false9, %if.end7
  %add = add i64 %str_len.0, %npad.0
  br label %cleanup

if.end12:                                         ; preds = %lor.lhs.false9
  br label %while.cond13

while.cond13:                                     ; preds = %if.end31, %if.end12
  %i.0 = phi i64 [ 0, %if.end12 ], [ %i.1, %if.end31 ]
  %dest_len.0 = phi i64 [ 0, %if.end12 ], [ %inc24, %if.end31 ]
  %cmp14 = icmp ult i64 %dest_len.0, %npad.0
  br i1 %cmp14, label %land.rhs16, label %land.end20

land.rhs16:                                       ; preds = %while.cond13
  %sub17 = sub i64 %dest_sz, 1
  %cmp18 = icmp ult i64 %dest_len.0, %sub17
  br label %land.end20

land.end20:                                       ; preds = %land.rhs16, %while.cond13
  %3 = phi i1 [ false, %while.cond13 ], [ %cmp18, %land.rhs16 ]
  br i1 %3, label %while.body21, label %while.end32

while.body21:                                     ; preds = %land.end20
  %inc22 = add i64 %i.0, 1
  %arrayidx23 = getelementptr inbounds i8, ptr %padding.addr.0, i64 %i.0
  %4 = load i8, ptr %arrayidx23, align 1, !tbaa !5
  %inc24 = add i64 %dest_len.0, 1
  %arrayidx25 = getelementptr inbounds i8, ptr %dest, i64 %dest_len.0
  store i8 %4, ptr %arrayidx25, align 1, !tbaa !5
  %tobool26 = icmp ne i8 %4, 0
  br i1 %tobool26, label %if.end31, label %if.then27

if.then27:                                        ; preds = %while.body21
  %arrayidx28 = getelementptr inbounds i8, ptr %padding.addr.0, i64 0
  %5 = load i8, ptr %arrayidx28, align 1, !tbaa !5
  %sub29 = sub i64 %inc24, 1
  %arrayidx30 = getelementptr inbounds i8, ptr %dest, i64 %sub29
  store i8 %5, ptr %arrayidx30, align 1, !tbaa !5
  br label %if.end31

if.end31:                                         ; preds = %if.then27, %while.body21
  %i.1 = phi i64 [ %inc22, %while.body21 ], [ 1, %if.then27 ]
  br label %while.cond13, !llvm.loop !11

while.end32:                                      ; preds = %land.end20
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %while.end32
  %i.2 = phi i64 [ 0, %while.end32 ], [ %inc43, %for.inc ]
  %dest_len.1 = phi i64 [ %dest_len.0, %while.end32 ], [ %inc41, %for.inc ]
  %cmp33 = icmp ult i64 %i.2, %str_len.0
  br i1 %cmp33, label %land.rhs35, label %land.end39

land.rhs35:                                       ; preds = %for.cond
  %sub36 = sub i64 %dest_sz, 1
  %cmp37 = icmp ult i64 %dest_len.1, %sub36
  br label %land.end39

land.end39:                                       ; preds = %land.rhs35, %for.cond
  %6 = phi i1 [ false, %for.cond ], [ %cmp37, %land.rhs35 ]
  br i1 %6, label %for.body, label %for.end

for.body:                                         ; preds = %land.end39
  %arrayidx40 = getelementptr inbounds i8, ptr %str, i64 %i.2
  %7 = load i8, ptr %arrayidx40, align 1, !tbaa !5
  %inc41 = add i64 %dest_len.1, 1
  %arrayidx42 = getelementptr inbounds i8, ptr %dest, i64 %dest_len.1
  store i8 %7, ptr %arrayidx42, align 1, !tbaa !5
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc43 = add i64 %i.2, 1
  br label %for.cond, !llvm.loop !12

for.end:                                          ; preds = %land.end39
  %arrayidx44 = getelementptr inbounds i8, ptr %dest, i64 %dest_len.1
  store i8 0, ptr %arrayidx44, align 1, !tbaa !5
  br label %cleanup

cleanup:                                          ; preds = %for.end, %if.then11
  %retval.0 = phi i64 [ %dest_len.1, %for.end ], [ %add, %if.then11 ]
  ret i64 %retval.0
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main(i32 noundef %argc, ptr noundef %argv) #0 {
entry:
  %end = alloca ptr, align 8
  call void @llvm.lifetime.start.p0(i64 8, ptr %end) #5
  %cmp = icmp eq i32 %argc, 4
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %arrayidx = getelementptr inbounds ptr, ptr %argv, i64 3
  %0 = load ptr, ptr %arrayidx, align 8, !tbaa !13
  br label %if.end3

if.else:                                          ; preds = %entry
  %cmp1 = icmp ne i32 %argc, 3
  br i1 %cmp1, label %if.then2, label %if.end

if.then2:                                         ; preds = %if.else
  %1 = load ptr, ptr @stderr, align 8, !tbaa !13
  %call = call i32 @fputs(ptr noundef @.str.1, ptr noundef %1)
  br label %cleanup

if.end:                                           ; preds = %if.else
  br label %if.end3

if.end3:                                          ; preds = %if.end, %if.then
  %padding.0 = phi ptr [ %0, %if.then ], [ @.str, %if.end ]
  %arrayidx4 = getelementptr inbounds ptr, ptr %argv, i64 2
  %2 = load ptr, ptr %arrayidx4, align 8, !tbaa !13
  %call5 = call i64 @strtol(ptr noundef %2, ptr noundef %end, i32 noundef 10) #5
  %arrayidx6 = getelementptr inbounds ptr, ptr %argv, i64 2
  %3 = load ptr, ptr %arrayidx6, align 8, !tbaa !13
  %arrayidx7 = getelementptr inbounds i8, ptr %3, i64 0
  %4 = load i8, ptr %arrayidx7, align 1, !tbaa !5
  %tobool = icmp ne i8 %4, 0
  br i1 %tobool, label %lor.lhs.false, label %if.then13

lor.lhs.false:                                    ; preds = %if.end3
  %5 = load ptr, ptr %end, align 8, !tbaa !13
  %arrayidx8 = getelementptr inbounds i8, ptr %5, i64 0
  %6 = load i8, ptr %arrayidx8, align 1, !tbaa !5
  %conv = sext i8 %6 to i32
  %tobool9 = icmp ne i32 %conv, 0
  br i1 %tobool9, label %if.then13, label %lor.lhs.false10

lor.lhs.false10:                                  ; preds = %lor.lhs.false
  %cmp11 = icmp slt i64 %call5, 0
  br i1 %cmp11, label %if.then13, label %if.end15

if.then13:                                        ; preds = %lor.lhs.false10, %lor.lhs.false, %if.end3
  %7 = load ptr, ptr @stderr, align 8, !tbaa !13
  %call14 = call i32 @fputs(ptr noundef @.str.2, ptr noundef %7)
  br label %cleanup

if.end15:                                         ; preds = %lor.lhs.false10
  %arrayidx16 = getelementptr inbounds ptr, ptr %argv, i64 1
  %8 = load ptr, ptr %arrayidx16, align 8, !tbaa !13
  %call17 = call i64 @leftpad(ptr noundef %8, ptr noundef %padding.0, i64 noundef %call5, ptr noundef null, i64 noundef 0)
  %call18 = call noalias ptr @malloc(i64 noundef %call17) #6
  %tobool19 = icmp ne ptr %call18, null
  br i1 %tobool19, label %if.end22, label %if.then20

if.then20:                                        ; preds = %if.end15
  %9 = load ptr, ptr @stderr, align 8, !tbaa !13
  %call21 = call i32 @fputs(ptr noundef @.str.3, ptr noundef %9)
  br label %cleanup

if.end22:                                         ; preds = %if.end15
  %arrayidx23 = getelementptr inbounds ptr, ptr %argv, i64 1
  %10 = load ptr, ptr %arrayidx23, align 8, !tbaa !13
  %add = add i64 %call17, 1
  %call24 = call i64 @leftpad(ptr noundef %10, ptr noundef %padding.0, i64 noundef %call5, ptr noundef %call18, i64 noundef %add)
  %call25 = call i32 @puts(ptr noundef %call18)
  br label %cleanup

cleanup:                                          ; preds = %if.end22, %if.then20, %if.then13, %if.then2
  %retval.0 = phi i32 [ 1, %if.then13 ], [ 0, %if.end22 ], [ 1, %if.then20 ], [ 1, %if.then2 ]
  call void @llvm.lifetime.end.p0(i64 8, ptr %end) #5
  ret i32 %retval.0
}

declare i32 @fputs(ptr noundef, ptr noundef) #2

; Function Attrs: nounwind
declare i64 @strtol(ptr noundef, ptr noundef, i32 noundef) #3

; Function Attrs: nounwind allocsize(0)
declare noalias ptr @malloc(i64 noundef) #4

declare i32 @puts(ptr noundef) #2

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind allocsize(0) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { nounwind allocsize(0) }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 17.0.6 (22build1)"}
!5 = !{!6, !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = distinct !{!8, !9, !10}
!9 = !{!"llvm.loop.mustprogress"}
!10 = !{!"llvm.loop.unroll.disable"}
!11 = distinct !{!11, !9, !10}
!12 = distinct !{!12, !9, !10}
!13 = !{!14, !14, i64 0}
!14 = !{!"any pointer", !6, i64 0}
