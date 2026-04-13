; ModuleID = 'benchmarks/ulidgen/source.ll'
source_filename = "benchmarks/ulidgen/source.c"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-redhat-linux-gnu"

%struct.timespec = type { i64, i64 }

@ulidgen_r.b32alphabet = internal global ptr @.str, align 8
@.str = private unnamed_addr constant [33 x i8] c"0123456789ABCDEFGHJKMNPQRSTVWXYZ\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"n:t\00", align 1
@optarg = external dso_local global ptr, align 8
@stdout = external dso_local global ptr, align 8
@stdin = external dso_local global ptr, align 8
@.str.2 = private unnamed_addr constant [6 x i8] c"%s %s\00", align 1

; Function Attrs: nounwind uwtable
define dso_local void @ulidgen_r(ptr noundef %ulid) #0 {
entry:
  %tv = alloca %struct.timespec, align 8
  %.compoundliteral = alloca %struct.timespec, align 8
  %rnd = alloca [16 x i8], align 1
  %add.ptr = getelementptr inbounds i8, ptr %ulid, i64 10
  %arrayidx = getelementptr inbounds i8, ptr %ulid, i64 26
  store i8 0, ptr %arrayidx, align 1, !tbaa !4
  call void @llvm.lifetime.start.p0(i64 16, ptr %tv) #9
  %call = call i32 @clock_gettime(i32 noundef 0, ptr noundef %tv) #9
  %tv_sec = getelementptr inbounds %struct.timespec, ptr %tv, i32 0, i32 0
  %0 = load i64, ptr %tv_sec, align 8, !tbaa !7
  %mul = mul nsw i64 %0, 1000
  %tv_nsec = getelementptr inbounds %struct.timespec, ptr %tv, i32 0, i32 1
  %1 = load i64, ptr %tv_nsec, align 8, !tbaa !10
  %div = sdiv i64 %1, 1000000
  %add = add nsw i64 %mul, %div
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 9, %entry ], [ %dec, %for.inc ]
  %t.0 = phi i64 [ %add, %entry ], [ %div10, %for.inc ]
  %same.0 = phi i32 [ 1, %entry ], [ %same.1, %for.inc ]
  %cmp = icmp sge i32 %i.0, 0
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %idxprom = sext i32 %i.0 to i64
  %arrayidx1 = getelementptr inbounds i8, ptr %ulid, i64 %idxprom
  %2 = load i8, ptr %arrayidx1, align 1, !tbaa !4
  %conv = zext i8 %2 to i32
  %3 = load ptr, ptr @ulidgen_r.b32alphabet, align 8, !tbaa !11
  %rem = urem i64 %t.0, 32
  %arrayidx2 = getelementptr inbounds i8, ptr %3, i64 %rem
  %4 = load i8, ptr %arrayidx2, align 1, !tbaa !4
  %conv3 = zext i8 %4 to i32
  %cmp4 = icmp ne i32 %conv, %conv3
  br i1 %cmp4, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  %5 = load ptr, ptr @ulidgen_r.b32alphabet, align 8, !tbaa !11
  %rem6 = urem i64 %t.0, 32
  %arrayidx7 = getelementptr inbounds i8, ptr %5, i64 %rem6
  %6 = load i8, ptr %arrayidx7, align 1, !tbaa !4
  %idxprom8 = sext i32 %i.0 to i64
  %arrayidx9 = getelementptr inbounds i8, ptr %ulid, i64 %idxprom8
  store i8 %6, ptr %arrayidx9, align 1, !tbaa !4
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  %same.1 = phi i32 [ 0, %if.then ], [ %same.0, %for.body ]
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %dec = add nsw i32 %i.0, -1
  %div10 = udiv i64 %t.0, 32
  br label %for.cond, !llvm.loop !13

for.end:                                          ; preds = %for.cond.cleanup
  %tobool = icmp ne i32 %same.0, 0
  br i1 %tobool, label %if.then11, label %if.end41

if.then11:                                        ; preds = %for.end
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.then11
  %i12.0 = phi i32 [ 15, %if.then11 ], [ %dec20, %while.body ]
  %cmp13 = icmp sge i32 %i12.0, 0
  br i1 %cmp13, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %while.cond
  %idxprom15 = sext i32 %i12.0 to i64
  %arrayidx16 = getelementptr inbounds i8, ptr %add.ptr, i64 %idxprom15
  %7 = load i8, ptr %arrayidx16, align 1, !tbaa !4
  %conv17 = zext i8 %7 to i32
  %cmp18 = icmp eq i32 %conv17, 90
  br label %land.end

land.end:                                         ; preds = %land.rhs, %while.cond
  %8 = phi i1 [ false, %while.cond ], [ %cmp18, %land.rhs ]
  br i1 %8, label %while.body, label %while.end

while.body:                                       ; preds = %land.end
  %dec20 = add nsw i32 %i12.0, -1
  %idxprom21 = sext i32 %i12.0 to i64
  %arrayidx22 = getelementptr inbounds i8, ptr %add.ptr, i64 %idxprom21
  store i8 48, ptr %arrayidx22, align 1, !tbaa !4
  br label %while.cond, !llvm.loop !16

while.end:                                        ; preds = %land.end
  %cmp23 = icmp slt i32 %i12.0, 0
  br i1 %cmp23, label %if.then25, label %if.end29

if.then25:                                        ; preds = %while.end
  %tv_sec26 = getelementptr inbounds %struct.timespec, ptr %.compoundliteral, i32 0, i32 0
  store i64 0, ptr %tv_sec26, align 8, !tbaa !7
  %tv_nsec27 = getelementptr inbounds %struct.timespec, ptr %.compoundliteral, i32 0, i32 1
  store i64 1234567, ptr %tv_nsec27, align 8, !tbaa !10
  %call28 = call i32 @nanosleep(ptr noundef %.compoundliteral, ptr noundef null)
  call void @ulidgen_r(ptr noundef %ulid)
  br label %cleanup40

if.end29:                                         ; preds = %while.end
  %9 = load ptr, ptr @ulidgen_r.b32alphabet, align 8, !tbaa !11
  %idxprom30 = sext i32 %i12.0 to i64
  %arrayidx31 = getelementptr inbounds i8, ptr %add.ptr, i64 %idxprom30
  %10 = load i8, ptr %arrayidx31, align 1, !tbaa !4
  %conv32 = zext i8 %10 to i32
  %call33 = call ptr @strchr(ptr noundef %9, i32 noundef %conv32) #10
  %tobool34 = icmp ne ptr %call33, null
  br i1 %tobool34, label %if.then35, label %if.end39

if.then35:                                        ; preds = %if.end29
  %add.ptr36 = getelementptr inbounds i8, ptr %call33, i64 1
  %11 = load i8, ptr %add.ptr36, align 1, !tbaa !4
  %idxprom37 = sext i32 %i12.0 to i64
  %arrayidx38 = getelementptr inbounds i8, ptr %add.ptr, i64 %idxprom37
  store i8 %11, ptr %arrayidx38, align 1, !tbaa !4
  br label %cleanup

if.end39:                                         ; preds = %if.end29
  br label %cleanup

cleanup:                                          ; preds = %if.end39, %if.then35
  %cleanup.dest.slot.0 = phi i32 [ 1, %if.then35 ], [ 0, %if.end39 ]
  br label %cleanup40

cleanup40:                                        ; preds = %cleanup, %if.then25
  %cleanup.dest.slot.1 = phi i32 [ 1, %if.then25 ], [ %cleanup.dest.slot.0, %cleanup ]
  switch i32 %cleanup.dest.slot.1, label %cleanup64 [
    i32 0, label %cleanup.cont
  ]

cleanup.cont:                                     ; preds = %cleanup40
  br label %if.end41

if.end41:                                         ; preds = %cleanup.cont, %for.end
  call void @llvm.lifetime.start.p0(i64 16, ptr %rnd) #9
  %arraydecay = getelementptr inbounds [16 x i8], ptr %rnd, i64 0, i64 0
  %call42 = call i32 @getentropy(ptr noundef %arraydecay, i64 noundef 16)
  %cmp43 = icmp slt i32 %call42, 0
  br i1 %cmp43, label %if.then45, label %if.end46

if.then45:                                        ; preds = %if.end41
  call void @abort() #11
  unreachable

if.end46:                                         ; preds = %if.end41
  br label %for.cond48

for.cond48:                                       ; preds = %for.inc61, %if.end46
  %i47.0 = phi i32 [ 0, %if.end46 ], [ %inc, %for.inc61 ]
  %cmp49 = icmp slt i32 %i47.0, 16
  br i1 %cmp49, label %for.body52, label %for.cond.cleanup51

for.cond.cleanup51:                               ; preds = %for.cond48
  br label %for.end63

for.body52:                                       ; preds = %for.cond48
  %12 = load ptr, ptr @ulidgen_r.b32alphabet, align 8, !tbaa !11
  %idxprom53 = sext i32 %i47.0 to i64
  %arrayidx54 = getelementptr inbounds [16 x i8], ptr %rnd, i64 0, i64 %idxprom53
  %13 = load i8, ptr %arrayidx54, align 1, !tbaa !4
  %conv55 = zext i8 %13 to i32
  %rem56 = srem i32 %conv55, 32
  %idxprom57 = sext i32 %rem56 to i64
  %arrayidx58 = getelementptr inbounds i8, ptr %12, i64 %idxprom57
  %14 = load i8, ptr %arrayidx58, align 1, !tbaa !4
  %idxprom59 = sext i32 %i47.0 to i64
  %arrayidx60 = getelementptr inbounds i8, ptr %add.ptr, i64 %idxprom59
  store i8 %14, ptr %arrayidx60, align 1, !tbaa !4
  br label %for.inc61

for.inc61:                                        ; preds = %for.body52
  %inc = add nsw i32 %i47.0, 1
  br label %for.cond48, !llvm.loop !17

for.end63:                                        ; preds = %for.cond.cleanup51
  call void @llvm.lifetime.end.p0(i64 16, ptr %rnd) #9
  br label %cleanup64

cleanup64:                                        ; preds = %for.end63, %cleanup40
  %cleanup.dest.slot.2 = phi i32 [ %cleanup.dest.slot.1, %cleanup40 ], [ 0, %for.end63 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr %tv) #9
  switch i32 %cleanup.dest.slot.2, label %unreachable [
    i32 0, label %cleanup.cont69
    i32 1, label %cleanup.cont69
  ]

cleanup.cont69:                                   ; preds = %cleanup64, %cleanup64
  ret void

unreachable:                                      ; preds = %cleanup64
  unreachable
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nounwind
declare dso_local i32 @clock_gettime(i32 noundef, ptr noundef) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

declare dso_local i32 @nanosleep(ptr noundef, ptr noundef) #3

; Function Attrs: nounwind willreturn memory(read)
declare dso_local ptr @strchr(ptr noundef, i32 noundef) #4

declare dso_local i32 @getentropy(ptr noundef, i64 noundef) #3

; Function Attrs: cold noreturn nounwind
declare dso_local void @abort() #5

; Function Attrs: nounwind uwtable
define dso_local i32 @main(i32 noundef %argc, ptr noundef %argv) #0 {
entry:
  %ulid = alloca [27 x i8], align 1
  %line = alloca ptr, align 8
  %linelen = alloca i64, align 8
  call void @llvm.lifetime.start.p0(i64 27, ptr %ulid) #9
  call void @llvm.memset.p0.i64(ptr align 1 %ulid, i8 0, i64 27, i1 false)
  br label %while.cond

while.cond:                                       ; preds = %sw.epilog, %entry
  %n.0 = phi i64 [ 1, %entry ], [ %n.1, %sw.epilog ]
  %tflag.0 = phi i32 [ 0, %entry ], [ %tflag.1, %sw.epilog ]
  %call = call i32 @getopt(i32 noundef %argc, ptr noundef %argv, ptr noundef @.str.1) #9
  %cmp = icmp ne i32 %call, -1
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  switch i32 %call, label %sw.epilog [
    i32 110, label %sw.bb
    i32 116, label %sw.bb2
  ]

sw.bb:                                            ; preds = %while.body
  %0 = load ptr, ptr @optarg, align 8, !tbaa !11
  %call1 = call i64 @atol(ptr noundef %0) #10
  br label %sw.epilog

sw.bb2:                                           ; preds = %while.body
  br label %sw.epilog

sw.epilog:                                        ; preds = %sw.bb2, %sw.bb, %while.body
  %n.1 = phi i64 [ %n.0, %while.body ], [ %n.0, %sw.bb2 ], [ %call1, %sw.bb ]
  %tflag.1 = phi i32 [ %tflag.0, %while.body ], [ 1, %sw.bb2 ], [ %tflag.0, %sw.bb ]
  br label %while.cond, !llvm.loop !18

while.end:                                        ; preds = %while.cond
  %tobool = icmp ne i32 %tflag.0, 0
  br i1 %tobool, label %if.then, label %if.else

if.then:                                          ; preds = %while.end
  call void @llvm.lifetime.start.p0(i64 8, ptr %line) #9
  store ptr null, ptr %line, align 8, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 8, ptr %linelen) #9
  store i64 0, ptr %linelen, align 8, !tbaa !19
  %1 = load ptr, ptr @stdout, align 8, !tbaa !11
  %call3 = call i32 @setvbuf(ptr noundef %1, ptr noundef null, i32 noundef 1, i64 noundef 0) #9
  br label %while.cond4

while.cond4:                                      ; preds = %while.body7, %if.then
  %2 = load ptr, ptr @stdin, align 8, !tbaa !11
  %call5 = call i64 @getdelim(ptr noundef %line, ptr noundef %linelen, i32 noundef 10, ptr noundef %2)
  %cmp6 = icmp ne i64 %call5, -1
  br i1 %cmp6, label %while.body7, label %while.end10

while.body7:                                      ; preds = %while.cond4
  %arraydecay = getelementptr inbounds [27 x i8], ptr %ulid, i64 0, i64 0
  call void @ulidgen_r(ptr noundef %arraydecay)
  %arraydecay8 = getelementptr inbounds [27 x i8], ptr %ulid, i64 0, i64 0
  %3 = load ptr, ptr %line, align 8, !tbaa !11
  %call9 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, ptr noundef %arraydecay8, ptr noundef %3)
  br label %while.cond4, !llvm.loop !20

while.end10:                                      ; preds = %while.cond4
  call void @llvm.lifetime.end.p0(i64 8, ptr %linelen) #9
  call void @llvm.lifetime.end.p0(i64 8, ptr %line) #9
  br label %if.end

if.else:                                          ; preds = %while.end
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.else
  %i.0 = phi i64 [ 0, %if.else ], [ %inc, %for.inc ]
  %cmp11 = icmp slt i64 %i.0, %n.0
  br i1 %cmp11, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %arraydecay12 = getelementptr inbounds [27 x i8], ptr %ulid, i64 0, i64 0
  call void @ulidgen_r(ptr noundef %arraydecay12)
  %arraydecay13 = getelementptr inbounds [27 x i8], ptr %ulid, i64 0, i64 0
  %call14 = call i32 @puts(ptr noundef %arraydecay13)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i64 %i.0, 1
  br label %for.cond, !llvm.loop !21

for.end:                                          ; preds = %for.cond.cleanup
  br label %if.end

if.end:                                           ; preds = %for.end, %while.end10
  %call15 = call i32 @fflush(ptr noundef null)
  %4 = load ptr, ptr @stdout, align 8, !tbaa !11
  %call16 = call i32 @ferror(ptr noundef %4) #9
  %tobool17 = icmp ne i32 %call16, 0
  %lnot = xor i1 %tobool17, true
  %lnot18 = xor i1 %lnot, true
  %lnot.ext = zext i1 %lnot18 to i32
  call void @exit(i32 noundef %lnot.ext) #12
  unreachable
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #6

; Function Attrs: nounwind
declare dso_local i32 @getopt(i32 noundef, ptr noundef, ptr noundef) #2

; Function Attrs: inlinehint nounwind willreturn memory(read) uwtable
define available_externally dso_local i64 @atol(ptr noundef nonnull %__nptr) #7 {
entry:
  %call = call i64 @strtol(ptr noundef %__nptr, ptr noundef null, i32 noundef 10) #9
  ret i64 %call
}

; Function Attrs: nounwind
declare dso_local i32 @setvbuf(ptr noundef, ptr noundef, i32 noundef, i64 noundef) #2

declare dso_local i64 @getdelim(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

declare dso_local i32 @printf(ptr noundef, ...) #3

declare dso_local i32 @puts(ptr noundef) #3

declare dso_local i32 @fflush(ptr noundef) #3

; Function Attrs: noreturn nounwind
declare dso_local void @exit(i32 noundef) #8

; Function Attrs: nounwind
declare dso_local i32 @ferror(ptr noundef) #2

; Function Attrs: nounwind
declare dso_local i64 @strtol(ptr noundef, ptr noundef, i32 noundef) #2

attributes #0 = { nounwind uwtable "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #3 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #4 = { nounwind willreturn memory(read) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #5 = { cold noreturn nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #6 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #7 = { inlinehint nounwind willreturn memory(read) uwtable "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #8 = { noreturn nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #9 = { nounwind }
attributes #10 = { nounwind willreturn memory(read) }
attributes #11 = { cold noreturn nounwind }
attributes #12 = { noreturn nounwind }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 2}
!2 = !{i32 7, !"frame-pointer", i32 1}
!3 = !{!"clang version 17.0.6 (Fedora 17.0.6-9.fc42)"}
!4 = !{!5, !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!8, !9, i64 0}
!8 = !{!"timespec", !9, i64 0, !9, i64 8}
!9 = !{!"long", !5, i64 0}
!10 = !{!8, !9, i64 8}
!11 = !{!12, !12, i64 0}
!12 = !{!"any pointer", !5, i64 0}
!13 = distinct !{!13, !14, !15}
!14 = !{!"llvm.loop.mustprogress"}
!15 = !{!"llvm.loop.unroll.disable"}
!16 = distinct !{!16, !14, !15}
!17 = distinct !{!17, !14, !15}
!18 = distinct !{!18, !14, !15}
!19 = !{!9, !9, i64 0}
!20 = distinct !{!20, !14, !15}
!21 = distinct !{!21, !14, !15}
