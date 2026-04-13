; ModuleID = 'benchmarks/amp/source.ll'
source_filename = "benchmarks/amp/source.c"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-redhat-linux-gnu"

%struct.amp_t = type { i16, i16, ptr }

@.str = private unnamed_addr constant [5 x i8] c"some\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"stuff\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"here\00", align 1
@__const.main.args = private unnamed_addr constant [3 x ptr] [ptr @.str, ptr @.str.1, ptr @.str.2], align 8
@.str.3 = private unnamed_addr constant [17 x i8] c"1 == msg.version\00", align 1
@.str.4 = private unnamed_addr constant [24 x i8] c"benchmarks/amp/source.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@.str.5 = private unnamed_addr constant [14 x i8] c"3 == msg.argc\00", align 1
@.str.6 = private unnamed_addr constant [25 x i8] c"0 == strcmp(\22some\22, arg)\00", align 1
@.str.7 = private unnamed_addr constant [26 x i8] c"0 == strcmp(\22stuff\22, arg)\00", align 1
@.str.8 = private unnamed_addr constant [25 x i8] c"0 == strcmp(\22here\22, arg)\00", align 1
@.str.9 = private unnamed_addr constant [4 x i8] c"ok\0A\00", align 1

; Function Attrs: nounwind uwtable
define dso_local void @amp_decode(ptr noundef %msg, ptr noundef %buf) #0 {
entry:
  %arrayidx = getelementptr inbounds i8, ptr %buf, i64 0
  %0 = load i8, ptr %arrayidx, align 1, !tbaa !4
  %conv = zext i8 %0 to i32
  %shr = ashr i32 %conv, 4
  %conv1 = trunc i32 %shr to i16
  %version = getelementptr inbounds %struct.amp_t, ptr %msg, i32 0, i32 0
  store i16 %conv1, ptr %version, align 8, !tbaa !7
  %arrayidx2 = getelementptr inbounds i8, ptr %buf, i64 0
  %1 = load i8, ptr %arrayidx2, align 1, !tbaa !4
  %conv3 = zext i8 %1 to i32
  %and = and i32 %conv3, 15
  %conv4 = trunc i32 %and to i16
  %argc = getelementptr inbounds %struct.amp_t, ptr %msg, i32 0, i32 1
  store i16 %conv4, ptr %argc, align 2, !tbaa !11
  %add.ptr = getelementptr inbounds i8, ptr %buf, i64 1
  %buf5 = getelementptr inbounds %struct.amp_t, ptr %msg, i32 0, i32 2
  store ptr %add.ptr, ptr %buf5, align 8, !tbaa !12
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local ptr @amp_decode_arg(ptr noundef %msg) #0 {
entry:
  %buf = getelementptr inbounds %struct.amp_t, ptr %msg, i32 0, i32 2
  %0 = load ptr, ptr %buf, align 8, !tbaa !12
  %call = call i32 @read_u32_be(ptr noundef %0)
  %buf1 = getelementptr inbounds %struct.amp_t, ptr %msg, i32 0, i32 2
  %1 = load ptr, ptr %buf1, align 8, !tbaa !12
  %add.ptr = getelementptr inbounds i8, ptr %1, i64 4
  store ptr %add.ptr, ptr %buf1, align 8, !tbaa !12
  %conv = zext i32 %call to i64
  %call3 = call noalias ptr @malloc(i64 noundef %conv) #9
  %tobool = icmp ne ptr %call3, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  br label %cleanup

if.end:                                           ; preds = %entry
  %buf4 = getelementptr inbounds %struct.amp_t, ptr %msg, i32 0, i32 2
  %2 = load ptr, ptr %buf4, align 8, !tbaa !12
  %conv5 = zext i32 %call to i64
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %call3, ptr align 1 %2, i64 %conv5, i1 false)
  %buf6 = getelementptr inbounds %struct.amp_t, ptr %msg, i32 0, i32 2
  %3 = load ptr, ptr %buf6, align 8, !tbaa !12
  %idx.ext = zext i32 %call to i64
  %add.ptr7 = getelementptr inbounds i8, ptr %3, i64 %idx.ext
  store ptr %add.ptr7, ptr %buf6, align 8, !tbaa !12
  br label %cleanup

cleanup:                                          ; preds = %if.end, %if.then
  %retval.0 = phi ptr [ %call3, %if.end ], [ null, %if.then ]
  ret ptr %retval.0
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nounwind uwtable
define internal i32 @read_u32_be(ptr noundef %buf) #0 {
entry:
  %arrayidx = getelementptr inbounds i8, ptr %buf, i64 0
  %0 = load i8, ptr %arrayidx, align 1, !tbaa !4
  %conv = zext i8 %0 to i32
  %shl = shl i32 %conv, 24
  %or = or i32 0, %shl
  %arrayidx1 = getelementptr inbounds i8, ptr %buf, i64 1
  %1 = load i8, ptr %arrayidx1, align 1, !tbaa !4
  %conv2 = zext i8 %1 to i32
  %shl3 = shl i32 %conv2, 16
  %or4 = or i32 %or, %shl3
  %arrayidx5 = getelementptr inbounds i8, ptr %buf, i64 2
  %2 = load i8, ptr %arrayidx5, align 1, !tbaa !4
  %conv6 = zext i8 %2 to i32
  %shl7 = shl i32 %conv6, 8
  %or8 = or i32 %or4, %shl7
  %arrayidx9 = getelementptr inbounds i8, ptr %buf, i64 3
  %3 = load i8, ptr %arrayidx9, align 1, !tbaa !4
  %conv10 = zext i8 %3 to i32
  %or11 = or i32 %or8, %conv10
  ret i32 %or11
}

; Function Attrs: nounwind allocsize(0)
declare dso_local noalias ptr @malloc(i64 noundef) #2

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local ptr @amp_encode(ptr noundef %argv, i32 noundef %argc) #0 {
entry:
  %0 = zext i32 %argc to i64
  %1 = call ptr @llvm.stacksave()
  %vla = alloca i64, i64 %0, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %len.0 = phi i64 [ 1, %entry ], [ %add5, %for.inc ]
  %cmp = icmp slt i32 %i.0, %argc
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %add = add i64 %len.0, 4
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds ptr, ptr %argv, i64 %idxprom
  %2 = load ptr, ptr %arrayidx, align 8, !tbaa !13
  %call = call i64 @strlen(ptr noundef %2) #10
  %idxprom1 = sext i32 %i.0 to i64
  %arrayidx2 = getelementptr inbounds i64, ptr %vla, i64 %idxprom1
  store i64 %call, ptr %arrayidx2, align 8, !tbaa !14
  %idxprom3 = sext i32 %i.0 to i64
  %arrayidx4 = getelementptr inbounds i64, ptr %vla, i64 %idxprom3
  %3 = load i64, ptr %arrayidx4, align 8, !tbaa !14
  %add5 = add i64 %add, %3
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond, !llvm.loop !16

for.end:                                          ; preds = %for.cond.cleanup
  %call6 = call noalias ptr @malloc(i64 noundef %len.0) #9
  %tobool = icmp ne ptr %call6, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %for.end
  br label %cleanup

if.end:                                           ; preds = %for.end
  %or = or i32 16, %argc
  %conv = trunc i32 %or to i8
  %incdec.ptr = getelementptr inbounds i8, ptr %call6, i32 1
  store i8 %conv, ptr %call6, align 1, !tbaa !4
  br label %for.cond8

for.cond8:                                        ; preds = %for.inc20, %if.end
  %buf.0 = phi ptr [ %incdec.ptr, %if.end ], [ %add.ptr19, %for.inc20 ]
  %i7.0 = phi i32 [ 0, %if.end ], [ %inc21, %for.inc20 ]
  %cmp9 = icmp slt i32 %i7.0, %argc
  br i1 %cmp9, label %for.body12, label %for.cond.cleanup11

for.cond.cleanup11:                               ; preds = %for.cond8
  br label %for.end22

for.body12:                                       ; preds = %for.cond8
  %idxprom14 = sext i32 %i7.0 to i64
  %arrayidx15 = getelementptr inbounds i64, ptr %vla, i64 %idxprom14
  %4 = load i64, ptr %arrayidx15, align 8, !tbaa !14
  %conv16 = trunc i64 %4 to i32
  call void @write_u32_be(ptr noundef %buf.0, i32 noundef %conv16)
  %add.ptr = getelementptr inbounds i8, ptr %buf.0, i64 4
  %idxprom17 = sext i32 %i7.0 to i64
  %arrayidx18 = getelementptr inbounds ptr, ptr %argv, i64 %idxprom17
  %5 = load ptr, ptr %arrayidx18, align 8, !tbaa !13
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %add.ptr, ptr align 1 %5, i64 %4, i1 false)
  %add.ptr19 = getelementptr inbounds i8, ptr %add.ptr, i64 %4
  br label %for.inc20

for.inc20:                                        ; preds = %for.body12
  %inc21 = add nsw i32 %i7.0, 1
  br label %for.cond8, !llvm.loop !19

for.end22:                                        ; preds = %for.cond.cleanup11
  br label %cleanup

cleanup:                                          ; preds = %for.end22, %if.then
  %retval.0 = phi ptr [ %call6, %for.end22 ], [ null, %if.then ]
  call void @llvm.stackrestore(ptr %1)
  ret ptr %retval.0
}

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare ptr @llvm.stacksave() #4

; Function Attrs: nounwind willreturn memory(read)
declare dso_local i64 @strlen(ptr noundef) #5

; Function Attrs: nounwind uwtable
define internal void @write_u32_be(ptr noundef %buf, i32 noundef %n) #0 {
entry:
  %shr = lshr i32 %n, 24
  %and = and i32 %shr, 255
  %conv = trunc i32 %and to i8
  %arrayidx = getelementptr inbounds i8, ptr %buf, i64 0
  store i8 %conv, ptr %arrayidx, align 1, !tbaa !4
  %shr1 = lshr i32 %n, 16
  %and2 = and i32 %shr1, 255
  %conv3 = trunc i32 %and2 to i8
  %arrayidx4 = getelementptr inbounds i8, ptr %buf, i64 1
  store i8 %conv3, ptr %arrayidx4, align 1, !tbaa !4
  %shr5 = lshr i32 %n, 8
  %and6 = and i32 %shr5, 255
  %conv7 = trunc i32 %and6 to i8
  %arrayidx8 = getelementptr inbounds i8, ptr %buf, i64 2
  store i8 %conv7, ptr %arrayidx8, align 1, !tbaa !4
  %and9 = and i32 %n, 255
  %conv10 = trunc i32 %and9 to i8
  %arrayidx11 = getelementptr inbounds i8, ptr %buf, i64 3
  store i8 %conv10, ptr %arrayidx11, align 1, !tbaa !4
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare void @llvm.stackrestore(ptr) #4

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 {
entry:
  %args = alloca [3 x ptr], align 8
  %msg = alloca %struct.amp_t, align 8
  call void @llvm.lifetime.start.p0(i64 24, ptr %args) #11
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %args, ptr align 8 @__const.main.args, i64 24, i1 false)
  %arraydecay = getelementptr inbounds [3 x ptr], ptr %args, i64 0, i64 0
  %call = call ptr @amp_encode(ptr noundef %arraydecay, i32 noundef 3)
  call void @llvm.lifetime.start.p0(i64 16, ptr %msg) #11
  call void @llvm.memset.p0.i64(ptr align 8 %msg, i8 0, i64 16, i1 false)
  call void @amp_decode(ptr noundef %msg, ptr noundef %call)
  %version = getelementptr inbounds %struct.amp_t, ptr %msg, i32 0, i32 0
  %0 = load i16, ptr %version, align 8, !tbaa !7
  %conv = sext i16 %0 to i32
  %cmp = icmp eq i32 1, %conv
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  br label %if.end

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str.3, ptr noundef @.str.4, i32 noundef 145, ptr noundef @__PRETTY_FUNCTION__.main) #12
  unreachable

if.end:                                           ; preds = %if.then
  %argc = getelementptr inbounds %struct.amp_t, ptr %msg, i32 0, i32 1
  %1 = load i16, ptr %argc, align 2, !tbaa !11
  %conv2 = sext i16 %1 to i32
  %cmp3 = icmp eq i32 3, %conv2
  br i1 %cmp3, label %if.then5, label %if.else6

if.then5:                                         ; preds = %if.end
  br label %if.end7

if.else6:                                         ; preds = %if.end
  call void @__assert_fail(ptr noundef @.str.5, ptr noundef @.str.4, i32 noundef 146, ptr noundef @__PRETTY_FUNCTION__.main) #12
  unreachable

if.end7:                                          ; preds = %if.then5
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end7
  %i.0 = phi i32 [ 0, %if.end7 ], [ %inc, %for.inc ]
  %argc8 = getelementptr inbounds %struct.amp_t, ptr %msg, i32 0, i32 1
  %2 = load i16, ptr %argc8, align 2, !tbaa !11
  %conv9 = sext i16 %2 to i32
  %cmp10 = icmp slt i32 %i.0, %conv9
  br i1 %cmp10, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %call12 = call ptr @amp_decode_arg(ptr noundef %msg)
  switch i32 %i.0, label %sw.epilog [
    i32 0, label %sw.bb
    i32 1, label %sw.bb19
    i32 2, label %sw.bb26
  ]

sw.bb:                                            ; preds = %for.body
  %call13 = call i32 @strcmp(ptr noundef @.str, ptr noundef %call12) #10
  %cmp14 = icmp eq i32 0, %call13
  br i1 %cmp14, label %if.then16, label %if.else17

if.then16:                                        ; preds = %sw.bb
  br label %if.end18

if.else17:                                        ; preds = %sw.bb
  call void @__assert_fail(ptr noundef @.str.6, ptr noundef @.str.4, i32 noundef 153, ptr noundef @__PRETTY_FUNCTION__.main) #12
  unreachable

if.end18:                                         ; preds = %if.then16
  br label %sw.epilog

sw.bb19:                                          ; preds = %for.body
  %call20 = call i32 @strcmp(ptr noundef @.str.1, ptr noundef %call12) #10
  %cmp21 = icmp eq i32 0, %call20
  br i1 %cmp21, label %if.then23, label %if.else24

if.then23:                                        ; preds = %sw.bb19
  br label %if.end25

if.else24:                                        ; preds = %sw.bb19
  call void @__assert_fail(ptr noundef @.str.7, ptr noundef @.str.4, i32 noundef 156, ptr noundef @__PRETTY_FUNCTION__.main) #12
  unreachable

if.end25:                                         ; preds = %if.then23
  br label %sw.epilog

sw.bb26:                                          ; preds = %for.body
  %call27 = call i32 @strcmp(ptr noundef @.str.2, ptr noundef %call12) #10
  %cmp28 = icmp eq i32 0, %call27
  br i1 %cmp28, label %if.then30, label %if.else31

if.then30:                                        ; preds = %sw.bb26
  br label %if.end32

if.else31:                                        ; preds = %sw.bb26
  call void @__assert_fail(ptr noundef @.str.8, ptr noundef @.str.4, i32 noundef 159, ptr noundef @__PRETTY_FUNCTION__.main) #12
  unreachable

if.end32:                                         ; preds = %if.then30
  br label %sw.epilog

sw.epilog:                                        ; preds = %if.end32, %if.end25, %if.end18, %for.body
  br label %for.inc

for.inc:                                          ; preds = %sw.epilog
  %inc = add nsw i32 %i.0, 1
  br label %for.cond, !llvm.loop !20

for.end:                                          ; preds = %for.cond.cleanup
  %call33 = call i32 (ptr, ...) @printf(ptr noundef @.str.9)
  call void @llvm.lifetime.end.p0(i64 16, ptr %msg) #11
  call void @llvm.lifetime.end.p0(i64 24, ptr %args) #11
  ret i32 0
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #6

; Function Attrs: cold noreturn nounwind
declare dso_local void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #7

; Function Attrs: nounwind willreturn memory(read)
declare dso_local i32 @strcmp(ptr noundef, ptr noundef) #5

declare dso_local i32 @printf(ptr noundef, ...) #8

attributes #0 = { nounwind uwtable "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nounwind allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #3 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { nocallback nofree nosync nounwind willreturn }
attributes #5 = { nounwind willreturn memory(read) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #6 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #7 = { cold noreturn nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #8 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #9 = { nounwind allocsize(0) }
attributes #10 = { nounwind willreturn memory(read) }
attributes #11 = { nounwind }
attributes #12 = { cold noreturn nounwind }

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
!8 = !{!"", !9, i64 0, !9, i64 2, !10, i64 8}
!9 = !{!"short", !5, i64 0}
!10 = !{!"any pointer", !5, i64 0}
!11 = !{!8, !9, i64 2}
!12 = !{!8, !10, i64 8}
!13 = !{!10, !10, i64 0}
!14 = !{!15, !15, i64 0}
!15 = !{!"long", !5, i64 0}
!16 = distinct !{!16, !17, !18}
!17 = !{!"llvm.loop.mustprogress"}
!18 = !{!"llvm.loop.unroll.disable"}
!19 = distinct !{!19, !17, !18}
!20 = distinct !{!20, !17, !18}
