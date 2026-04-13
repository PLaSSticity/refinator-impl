; ModuleID = 'source.ll'
source_filename = "source.c"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

@.str = private unnamed_addr constant [11 x i8] c"kidx < nel\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"source.c\00", align 1
@__PRETTY_FUNCTION__.gca_qselect = private unnamed_addr constant [63 x i8] c"void *gca_qselect(void *, size_t, size_t, size_t, int, void *)\00", align 1

; Function Attrs: nounwind uwtable
define dso_local i32 @gca_calc_GCD(i32 noundef %a, i32 noundef %b) #0 {
entry:
  %cmp = icmp eq i32 %a, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %cleanup

if.end:                                           ; preds = %entry
  %cmp1 = icmp eq i32 %b, 0
  br i1 %cmp1, label %if.then2, label %if.end3

if.then2:                                         ; preds = %if.end
  br label %cleanup

if.end3:                                          ; preds = %if.end
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end3
  %shift.0 = phi i32 [ 0, %if.end3 ], [ %inc, %for.inc ]
  %b.addr.0 = phi i32 [ %b, %if.end3 ], [ %shr5, %for.inc ]
  %a.addr.0 = phi i32 [ %a, %if.end3 ], [ %shr, %for.inc ]
  %or = or i32 %a.addr.0, %b.addr.0
  %and = and i32 %or, 1
  %cmp4 = icmp eq i32 %and, 0
  br i1 %cmp4, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %shr = lshr i32 %a.addr.0, 1
  %shr5 = lshr i32 %b.addr.0, 1
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add i32 %shift.0, 1
  br label %for.cond, !llvm.loop !6

for.end:                                          ; preds = %for.cond
  br label %while.cond

while.cond:                                       ; preds = %while.body, %for.end
  %a.addr.1 = phi i32 [ %a.addr.0, %for.end ], [ %shr8, %while.body ]
  %and6 = and i32 %a.addr.1, 1
  %cmp7 = icmp eq i32 %and6, 0
  br i1 %cmp7, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %shr8 = lshr i32 %a.addr.1, 1
  br label %while.cond, !llvm.loop !9

while.end:                                        ; preds = %while.cond
  br label %do.body

do.body:                                          ; preds = %do.cond19, %while.end
  %b.addr.1 = phi i32 [ %b.addr.0, %while.end ], [ %sub, %do.cond19 ]
  %a.addr.2 = phi i32 [ %a.addr.1, %while.end ], [ %a.addr.3, %do.cond19 ]
  br label %while.cond9

while.cond9:                                      ; preds = %while.body12, %do.body
  %b.addr.2 = phi i32 [ %b.addr.1, %do.body ], [ %shr13, %while.body12 ]
  %and10 = and i32 %b.addr.2, 1
  %cmp11 = icmp eq i32 %and10, 0
  br i1 %cmp11, label %while.body12, label %while.end14

while.body12:                                     ; preds = %while.cond9
  %shr13 = lshr i32 %b.addr.2, 1
  br label %while.cond9, !llvm.loop !10

while.end14:                                      ; preds = %while.cond9
  %cmp15 = icmp ugt i32 %a.addr.2, %b.addr.2
  br i1 %cmp15, label %if.then16, label %if.end18

if.then16:                                        ; preds = %while.end14
  br label %do.body17

do.body17:                                        ; preds = %if.then16
  br label %do.cond

do.cond:                                          ; preds = %do.body17
  br label %do.end

do.end:                                           ; preds = %do.cond
  br label %if.end18

if.end18:                                         ; preds = %do.end, %while.end14
  %b.addr.3 = phi i32 [ %a.addr.2, %do.end ], [ %b.addr.2, %while.end14 ]
  %a.addr.3 = phi i32 [ %b.addr.2, %do.end ], [ %a.addr.2, %while.end14 ]
  %sub = sub i32 %b.addr.3, %a.addr.3
  br label %do.cond19

do.cond19:                                        ; preds = %if.end18
  %cmp20 = icmp ne i32 %sub, 0
  br i1 %cmp20, label %do.body, label %do.end21, !llvm.loop !11

do.end21:                                         ; preds = %do.cond19
  %shl = shl i32 %a.addr.3, %shift.0
  br label %cleanup

cleanup:                                          ; preds = %do.end21, %if.then2, %if.then
  %retval.0 = phi i32 [ %b, %if.then ], [ %a, %if.then2 ], [ %shl, %do.end21 ]
  ret i32 %retval.0
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local void @gca_cycle_left(ptr noundef %_ptr, i64 noundef %n, i64 noundef %es, i64 noundef %shift) #0 {
entry:
  %cmp = icmp ule i64 %n, 1
  br i1 %cmp, label %if.then, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %entry
  %tobool = icmp ne i64 %shift, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %lor.lhs.false, %entry
  br label %cleanup

if.end:                                           ; preds = %lor.lhs.false
  %rem = urem i64 %shift, %n
  %conv = trunc i64 %n to i32
  %conv1 = trunc i64 %rem to i32
  %call = call i32 @gca_calc_GCD(i32 noundef %conv, i32 noundef %conv1)
  %conv2 = zext i32 %call to i64
  %0 = call ptr @llvm.stacksave()
  %vla = alloca i8, i64 %es, align 1
  br label %for.cond

for.cond:                                         ; preds = %for.inc21, %if.end
  %i.0 = phi i64 [ 0, %if.end ], [ %inc, %for.inc21 ]
  %cmp3 = icmp ult i64 %i.0, %conv2
  br i1 %cmp3, label %for.body, label %for.end22

for.body:                                         ; preds = %for.cond
  %mul = mul i64 %es, %i.0
  %add.ptr = getelementptr inbounds i8, ptr %_ptr, i64 %mul
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %vla, ptr align 1 %add.ptr, i64 %es, i1 false)
  br label %for.cond5

for.cond5:                                        ; preds = %for.inc, %for.body
  %j.0 = phi i64 [ %i.0, %for.body ], [ %k.0, %for.inc ]
  br i1 true, label %for.body6, label %for.end

for.body6:                                        ; preds = %for.cond5
  %add = add i64 %j.0, %rem
  %cmp7 = icmp uge i64 %add, %n
  br i1 %cmp7, label %if.then9, label %if.end10

if.then9:                                         ; preds = %for.body6
  %sub = sub i64 %add, %n
  br label %if.end10

if.end10:                                         ; preds = %if.then9, %for.body6
  %k.0 = phi i64 [ %sub, %if.then9 ], [ %add, %for.body6 ]
  %cmp11 = icmp eq i64 %k.0, %i.0
  br i1 %cmp11, label %if.then13, label %if.end14

if.then13:                                        ; preds = %if.end10
  br label %for.end

if.end14:                                         ; preds = %if.end10
  %mul15 = mul i64 %es, %j.0
  %add.ptr16 = getelementptr inbounds i8, ptr %_ptr, i64 %mul15
  %mul17 = mul i64 %es, %k.0
  %add.ptr18 = getelementptr inbounds i8, ptr %_ptr, i64 %mul17
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %add.ptr16, ptr align 1 %add.ptr18, i64 %es, i1 false)
  br label %for.inc

for.inc:                                          ; preds = %if.end14
  br label %for.cond5, !llvm.loop !12

for.end:                                          ; preds = %if.then13, %for.cond5
  %mul19 = mul i64 %es, %j.0
  %add.ptr20 = getelementptr inbounds i8, ptr %_ptr, i64 %mul19
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %add.ptr20, ptr align 1 %vla, i64 %es, i1 false)
  br label %for.inc21

for.inc21:                                        ; preds = %for.end
  %inc = add i64 %i.0, 1
  br label %for.cond, !llvm.loop !13

for.end22:                                        ; preds = %for.cond
  call void @llvm.stackrestore(ptr %0)
  br label %cleanup

cleanup:                                          ; preds = %for.end22, %if.then
  %cleanup.dest.slot.0 = phi i32 [ 1, %if.then ], [ 0, %for.end22 ]
  switch i32 %cleanup.dest.slot.0, label %unreachable [
    i32 0, label %cleanup.cont
    i32 1, label %cleanup.cont
  ]

cleanup.cont:                                     ; preds = %cleanup, %cleanup
  ret void

unreachable:                                      ; preds = %cleanup
  unreachable
}

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare ptr @llvm.stacksave() #2

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare void @llvm.stackrestore(ptr) #2

; Function Attrs: nounwind uwtable
define dso_local void @gca_cycle_right(ptr noundef %_ptr, i64 noundef %n, i64 noundef %es, i64 noundef %shift) #0 {
entry:
  %tobool = icmp ne i64 %n, 0
  br i1 %tobool, label %lor.lhs.false, label %if.then

lor.lhs.false:                                    ; preds = %entry
  %tobool1 = icmp ne i64 %shift, 0
  br i1 %tobool1, label %if.end, label %if.then

if.then:                                          ; preds = %lor.lhs.false, %entry
  br label %return

if.end:                                           ; preds = %lor.lhs.false
  %rem = urem i64 %shift, %n
  %sub = sub i64 %n, %rem
  call void @gca_cycle_left(ptr noundef %_ptr, i64 noundef %n, i64 noundef %es, i64 noundef %sub)
  br label %return

return:                                           ; preds = %if.end, %if.then
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @gca_reverse(ptr noundef %_ptr, i64 noundef %n, i64 noundef %es) #0 {
entry:
  %cmp = icmp ule i64 %n, 1
  br i1 %cmp, label %if.then, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %entry
  %tobool = icmp ne i64 %es, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %lor.lhs.false, %entry
  br label %return

if.end:                                           ; preds = %lor.lhs.false
  %sub = sub i64 %n, 1
  %mul = mul i64 %es, %sub
  %add.ptr = getelementptr inbounds i8, ptr %_ptr, i64 %mul
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end
  %a.0 = phi ptr [ %_ptr, %if.end ], [ %add.ptr2, %for.inc ]
  %b.0 = phi ptr [ %add.ptr, %if.end ], [ %add.ptr3, %for.inc ]
  %cmp1 = icmp ult ptr %a.0, %b.0
  br i1 %cmp1, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  call void @gca_swapm(ptr noundef %a.0, ptr noundef %b.0, i64 noundef %es)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %add.ptr2 = getelementptr inbounds i8, ptr %a.0, i64 %es
  %idx.neg = sub i64 0, %es
  %add.ptr3 = getelementptr inbounds i8, ptr %b.0, i64 %idx.neg
  br label %for.cond, !llvm.loop !14

for.end:                                          ; preds = %for.cond
  br label %return

return:                                           ; preds = %for.end, %if.then
  ret void
}

; Function Attrs: inlinehint nounwind uwtable
define internal void @gca_swapm(ptr noundef %aa, ptr noundef %bb, i64 noundef %es) #4 {
entry:
  %add.ptr = getelementptr inbounds i8, ptr %aa, i64 %es
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %a.0 = phi ptr [ %aa, %entry ], [ %incdec.ptr, %for.inc ]
  %b.0 = phi ptr [ %bb, %entry ], [ %incdec.ptr1, %for.inc ]
  %cmp = icmp ult ptr %a.0, %add.ptr
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %0 = load i8, ptr %a.0, align 1, !tbaa !15
  %1 = load i8, ptr %b.0, align 1, !tbaa !15
  store i8 %1, ptr %a.0, align 1, !tbaa !15
  store i8 %0, ptr %b.0, align 1, !tbaa !15
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %incdec.ptr = getelementptr inbounds i8, ptr %a.0, i32 1
  %incdec.ptr1 = getelementptr inbounds i8, ptr %b.0, i32 1
  br label %for.cond, !llvm.loop !18

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @gca_shuffle(ptr noundef %base, i64 noundef %n, i64 noundef %es) #0 {
entry:
  call void @gca_sample(ptr noundef %base, i64 noundef %n, i64 noundef %es, i64 noundef %n)
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @gca_sample(ptr noundef %base, i64 noundef %n, i64 noundef %es, i64 noundef %m) #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp ult i64 %i.0, %m
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %conv = uitofp i64 %i.0 to double
  %sub = sub i64 %n, %i.0
  %conv1 = uitofp i64 %sub to double
  %call = call double @drand48() #9
  %0 = call double @llvm.fmuladd.f64(double %conv1, double %call, double %conv)
  %conv2 = fptoui double %0 to i64
  %mul = mul i64 %es, %i.0
  %add.ptr = getelementptr inbounds i8, ptr %base, i64 %mul
  %mul3 = mul i64 %es, %conv2
  %add.ptr4 = getelementptr inbounds i8, ptr %base, i64 %mul3
  call void @gca_swapm(ptr noundef %add.ptr, ptr noundef %add.ptr4, i64 noundef %es)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add i64 %i.0, 1
  br label %for.cond, !llvm.loop !19

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind
declare double @drand48() #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.fmuladd.f64(double, double, double) #6

; Function Attrs: nounwind uwtable
define dso_local void @gca_merge(ptr noundef %_dst, i64 noundef %ndst, i64 noundef %nsrc, i64 noundef %es, i32 noundef %compar_id, ptr noundef %arg) #0 {
entry:
  %mul = mul i64 %es, %ndst
  %add.ptr = getelementptr inbounds i8, ptr %_dst, i64 %mul
  %add = add i64 %ndst, %nsrc
  %mul1 = mul i64 %es, %add
  %add.ptr2 = getelementptr inbounds i8, ptr %_dst, i64 %mul1
  %tobool = icmp ne i64 %nsrc, 0
  br i1 %tobool, label %lor.lhs.false, label %if.then

lor.lhs.false:                                    ; preds = %entry
  %tobool3 = icmp ne i64 %ndst, 0
  br i1 %tobool3, label %if.else, label %if.then

if.then:                                          ; preds = %lor.lhs.false, %entry
  br label %if.end20

if.else:                                          ; preds = %lor.lhs.false
  %idx.neg = sub i64 0, %es
  %add.ptr4 = getelementptr inbounds i8, ptr %add.ptr, i64 %idx.neg
  %call = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %add.ptr4, ptr noundef %add.ptr, ptr noundef %arg)
  %cmp = icmp sle i32 %call, 0
  br i1 %cmp, label %if.then5, label %if.else6

if.then5:                                         ; preds = %if.else
  br label %if.end19

if.else6:                                         ; preds = %if.else
  %idx.neg7 = sub i64 0, %es
  %add.ptr8 = getelementptr inbounds i8, ptr %add.ptr2, i64 %idx.neg7
  %call9 = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %_dst, ptr noundef %add.ptr8, ptr noundef %arg)
  %cmp10 = icmp sge i32 %call9, 0
  br i1 %cmp10, label %if.then11, label %if.else12

if.then11:                                        ; preds = %if.else6
  call void @gca_cycle_left(ptr noundef %_dst, i64 noundef %ndst, i64 noundef %es, i64 noundef %ndst)
  br label %if.end18

if.else12:                                        ; preds = %if.else6
  %add13 = add i64 %ndst, %nsrc
  %cmp14 = icmp ult i64 %add13, 6
  br i1 %cmp14, label %if.then15, label %if.else16

if.then15:                                        ; preds = %if.else12
  call void @gca_imerge(ptr noundef %_dst, i64 noundef %ndst, i64 noundef %nsrc, i64 noundef %es, i32 noundef %compar_id, ptr noundef %arg)
  br label %if.end

if.else16:                                        ; preds = %if.else12
  %add17 = add i64 %ndst, %nsrc
  call void @gca_qsort(ptr noundef %_dst, i64 noundef %add17, i64 noundef %es, i32 noundef %compar_id, ptr noundef %arg)
  br label %if.end

if.end:                                           ; preds = %if.else16, %if.then15
  br label %if.end18

if.end18:                                         ; preds = %if.end, %if.then11
  br label %if.end19

if.end19:                                         ; preds = %if.end18, %if.then5
  br label %if.end20

if.end20:                                         ; preds = %if.end19, %if.then
  ret void
}

; Function Attrs: nounwind uwtable
define internal i32 @call_compar(i32 noundef %compar_id, ptr noundef %a, ptr noundef %b, ptr noundef %arg) #0 {
entry:
  ret i32 0
}

; Function Attrs: inlinehint nounwind uwtable
define internal void @gca_imerge(ptr noundef %_ptr, i64 noundef %n, i64 noundef %m, i64 noundef %el, i32 noundef %compar_id, ptr noundef %arg) #4 {
entry:
  %add = add i64 %n, %m
  %mul = mul i64 %el, %add
  %add.ptr = getelementptr inbounds i8, ptr %_ptr, i64 %mul
  %mul1 = mul i64 %el, %n
  %add.ptr2 = getelementptr inbounds i8, ptr %_ptr, i64 %mul1
  br label %for.cond

for.cond:                                         ; preds = %for.inc13, %entry
  %pi.0 = phi ptr [ %add.ptr2, %entry ], [ %add.ptr14, %for.inc13 ]
  %cmp = icmp ult ptr %pi.0, %add.ptr
  br i1 %cmp, label %for.body, label %for.end15

for.body:                                         ; preds = %for.cond
  br label %for.cond3

for.cond3:                                        ; preds = %for.inc, %for.body
  %pj.0 = phi ptr [ %pi.0, %for.body ], [ %add.ptr11, %for.inc ]
  %cmp4 = icmp ugt ptr %pj.0, %_ptr
  br i1 %cmp4, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %for.cond3
  %idx.neg = sub i64 0, %el
  %add.ptr5 = getelementptr inbounds i8, ptr %pj.0, i64 %idx.neg
  %call = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %add.ptr5, ptr noundef %pj.0, ptr noundef %arg)
  %cmp6 = icmp sgt i32 %call, 0
  br label %land.end

land.end:                                         ; preds = %land.rhs, %for.cond3
  %0 = phi i1 [ false, %for.cond3 ], [ %cmp6, %land.rhs ]
  br i1 %0, label %for.body7, label %for.end

for.body7:                                        ; preds = %land.end
  %idx.neg8 = sub i64 0, %el
  %add.ptr9 = getelementptr inbounds i8, ptr %pj.0, i64 %idx.neg8
  call void @gca_swapm(ptr noundef %add.ptr9, ptr noundef %pj.0, i64 noundef %el)
  br label %for.inc

for.inc:                                          ; preds = %for.body7
  %idx.neg10 = sub i64 0, %el
  %add.ptr11 = getelementptr inbounds i8, ptr %pj.0, i64 %idx.neg10
  br label %for.cond3, !llvm.loop !20

for.end:                                          ; preds = %land.end
  %cmp12 = icmp eq ptr %pj.0, %pi.0
  br i1 %cmp12, label %if.then, label %if.end

if.then:                                          ; preds = %for.end
  br label %for.end15

if.end:                                           ; preds = %for.end
  br label %for.inc13

for.inc13:                                        ; preds = %if.end
  %add.ptr14 = getelementptr inbounds i8, ptr %pi.0, i64 %el
  br label %for.cond, !llvm.loop !21

for.end15:                                        ; preds = %if.then, %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @gca_qsort(ptr noundef %base, i64 noundef %nel, i64 noundef %es, i32 noundef %compar_id, ptr noundef %arg) #0 {
entry:
  %cmp = icmp ult i64 %nel, 6
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  call void @gca_isortr(ptr noundef %base, i64 noundef 0, i64 noundef %nel, i64 noundef %es, i32 noundef %compar_id, ptr noundef %arg)
  br label %if.end

if.else:                                          ; preds = %entry
  %div = udiv i64 %nel, 2
  %mul = mul i64 %es, %div
  %add.ptr = getelementptr inbounds i8, ptr %base, i64 %mul
  %sub = sub i64 %nel, 1
  %mul1 = mul i64 %es, %sub
  %add.ptr2 = getelementptr inbounds i8, ptr %base, i64 %mul1
  %call = call ptr @gca_median3(ptr noundef %base, ptr noundef %add.ptr, ptr noundef %add.ptr2, i32 noundef %compar_id, ptr noundef %arg)
  call void @gca_swapm(ptr noundef %base, ptr noundef %call, i64 noundef %es)
  %call3 = call i64 @gca_qpart(ptr noundef %base, i64 noundef %nel, i64 noundef %es, i32 noundef %compar_id, ptr noundef %arg)
  call void @gca_qsort(ptr noundef %base, i64 noundef %call3, i64 noundef %es, i32 noundef %compar_id, ptr noundef %arg)
  %add = add i64 %call3, 1
  %mul4 = mul i64 %es, %add
  %add.ptr5 = getelementptr inbounds i8, ptr %base, i64 %mul4
  %add6 = add i64 %call3, 1
  %sub7 = sub i64 %nel, %add6
  call void @gca_qsort(ptr noundef %add.ptr5, i64 noundef %sub7, i64 noundef %es, i32 noundef %compar_id, ptr noundef %arg)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local ptr @gca_bsearch(ptr noundef %_ptr, i64 noundef %n, i64 noundef %es, i32 noundef %searchf_id, ptr noundef %arg) #0 {
entry:
  %cmp = icmp eq i64 %n, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %return

if.end:                                           ; preds = %entry
  %sub = sub i64 %n, 1
  br label %while.cond

while.cond:                                       ; preds = %if.end20, %if.end
  %l.0 = phi i64 [ 0, %if.end ], [ %l.2, %if.end20 ]
  %r.0 = phi i64 [ %sub, %if.end ], [ %r.1, %if.end20 ]
  br label %while.body

while.body:                                       ; preds = %while.cond
  %sub2 = sub i64 %r.0, %l.0
  %div = udiv i64 %sub2, 2
  %add = add i64 %l.0, %div
  %mul = mul i64 %es, %add
  %add.ptr = getelementptr inbounds i8, ptr %_ptr, i64 %mul
  %call = call i32 @call_searchf(i32 noundef %searchf_id, ptr noundef %add.ptr, ptr noundef %arg)
  %cmp3 = icmp eq i32 %call, 0
  br i1 %cmp3, label %if.then4, label %if.else

if.then4:                                         ; preds = %while.body
  br label %cleanup

if.else:                                          ; preds = %while.body
  %cmp5 = icmp sgt i32 %call, 0
  br i1 %cmp5, label %if.then6, label %if.else10

if.then6:                                         ; preds = %if.else
  %tobool = icmp ne i64 %add, 0
  br i1 %tobool, label %if.end8, label %if.then7

if.then7:                                         ; preds = %if.then6
  br label %cleanup

if.end8:                                          ; preds = %if.then6
  %sub9 = sub i64 %add, 1
  br label %if.end19

if.else10:                                        ; preds = %if.else
  %cmp11 = icmp slt i32 %call, 0
  br i1 %cmp11, label %if.then12, label %if.end18

if.then12:                                        ; preds = %if.else10
  %add13 = add i64 %add, 1
  %cmp14 = icmp eq i64 %add13, %n
  br i1 %cmp14, label %if.then15, label %if.end16

if.then15:                                        ; preds = %if.then12
  br label %cleanup

if.end16:                                         ; preds = %if.then12
  %add17 = add i64 %add, 1
  br label %if.end18

if.end18:                                         ; preds = %if.end16, %if.else10
  %l.1 = phi i64 [ %add17, %if.end16 ], [ %l.0, %if.else10 ]
  br label %if.end19

if.end19:                                         ; preds = %if.end18, %if.end8
  %l.2 = phi i64 [ %l.0, %if.end8 ], [ %l.1, %if.end18 ]
  %r.1 = phi i64 [ %sub9, %if.end8 ], [ %r.0, %if.end18 ]
  br label %if.end20

if.end20:                                         ; preds = %if.end19
  br label %while.cond, !llvm.loop !22

cleanup:                                          ; preds = %if.then15, %if.then7, %if.then4
  %retval.0 = phi ptr [ %add.ptr, %if.then4 ], [ null, %if.then7 ], [ null, %if.then15 ]
  br label %return

return:                                           ; preds = %cleanup, %if.then
  %retval.1 = phi ptr [ null, %if.then ], [ %retval.0, %cleanup ]
  ret ptr %retval.1
}

; Function Attrs: nounwind uwtable
define internal i32 @call_searchf(i32 noundef %compar_id, ptr noundef %_val, ptr noundef %_arg) #0 {
entry:
  ret i32 0
}

; Function Attrs: nounwind uwtable
define dso_local ptr @gca_lsearch(ptr noundef %base, i64 noundef %n, i64 noundef %es, i32 noundef %searchf_id, ptr noundef %arg) #0 {
entry:
  %mul = mul i64 %es, %n
  %add.ptr = getelementptr inbounds i8, ptr %base, i64 %mul
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %b.0 = phi ptr [ %base, %entry ], [ %incdec.ptr, %for.inc ]
  %cmp = icmp ult ptr %b.0, %add.ptr
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %call = call i32 @call_searchf(i32 noundef %searchf_id, ptr noundef %b.0, ptr noundef %arg)
  %cmp1 = icmp eq i32 %call, 0
  br i1 %cmp1, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  br label %cleanup

if.end:                                           ; preds = %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %incdec.ptr = getelementptr inbounds i8, ptr %b.0, i32 1
  br label %for.cond, !llvm.loop !23

for.end:                                          ; preds = %for.cond
  br label %cleanup

cleanup:                                          ; preds = %for.end, %if.then
  %retval.0 = phi ptr [ %b.0, %if.then ], [ null, %for.end ]
  ret ptr %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local i64 @gca_qpart(ptr noundef %base, i64 noundef %nel, i64 noundef %es, i32 noundef %compar_id, ptr noundef %arg) #0 {
entry:
  %cmp = icmp ule i64 %nel, 1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %return

if.end:                                           ; preds = %entry
  %0 = call ptr @llvm.stacksave()
  %vla = alloca i8, i64 %es, align 1
  %sub = sub i64 %nel, 1
  %mul = mul i64 %es, %sub
  %add.ptr = getelementptr inbounds i8, ptr %base, i64 %mul
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %vla, ptr align 1 %base, i64 %es, i1 false)
  br label %while.cond

while.cond:                                       ; preds = %for.end19, %if.end
  %pl.0 = phi ptr [ %base, %if.end ], [ %pl.2, %for.end19 ]
  %pr.0 = phi ptr [ %add.ptr, %if.end ], [ %pr.2, %for.end19 ]
  %cmp1 = icmp ult ptr %pl.0, %pr.0
  br i1 %cmp1, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %while.body
  %pr.1 = phi ptr [ %pr.0, %while.body ], [ %add.ptr7, %for.inc ]
  %cmp2 = icmp ult ptr %pl.0, %pr.1
  br i1 %cmp2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %call = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %pr.1, ptr noundef %vla, ptr noundef %arg)
  %cmp3 = icmp slt i32 %call, 0
  br i1 %cmp3, label %if.then4, label %if.end6

if.then4:                                         ; preds = %for.body
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %pl.0, ptr align 1 %pr.1, i64 %es, i1 false)
  %add.ptr5 = getelementptr inbounds i8, ptr %pl.0, i64 %es
  br label %for.end

if.end6:                                          ; preds = %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end6
  %idx.neg = sub i64 0, %es
  %add.ptr7 = getelementptr inbounds i8, ptr %pr.1, i64 %idx.neg
  br label %for.cond, !llvm.loop !24

for.end:                                          ; preds = %if.then4, %for.cond
  %pl.1 = phi ptr [ %add.ptr5, %if.then4 ], [ %pl.0, %for.cond ]
  br label %for.cond8

for.cond8:                                        ; preds = %for.inc17, %for.end
  %pl.2 = phi ptr [ %pl.1, %for.end ], [ %add.ptr18, %for.inc17 ]
  %cmp9 = icmp ult ptr %pl.2, %pr.1
  br i1 %cmp9, label %for.body10, label %for.end19

for.body10:                                       ; preds = %for.cond8
  %call11 = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %pl.2, ptr noundef %vla, ptr noundef %arg)
  %cmp12 = icmp sgt i32 %call11, 0
  br i1 %cmp12, label %if.then13, label %if.end16

if.then13:                                        ; preds = %for.body10
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %pr.1, ptr align 1 %pl.2, i64 %es, i1 false)
  %idx.neg14 = sub i64 0, %es
  %add.ptr15 = getelementptr inbounds i8, ptr %pr.1, i64 %idx.neg14
  br label %for.end19

if.end16:                                         ; preds = %for.body10
  br label %for.inc17

for.inc17:                                        ; preds = %if.end16
  %add.ptr18 = getelementptr inbounds i8, ptr %pl.2, i64 %es
  br label %for.cond8, !llvm.loop !25

for.end19:                                        ; preds = %if.then13, %for.cond8
  %pr.2 = phi ptr [ %add.ptr15, %if.then13 ], [ %pr.1, %for.cond8 ]
  br label %while.cond, !llvm.loop !26

while.end:                                        ; preds = %while.cond
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %pl.0, ptr align 1 %vla, i64 %es, i1 false)
  call void @llvm.stackrestore(ptr %0)
  br label %return

return:                                           ; preds = %while.end, %if.then
  ret i64 0
}

; Function Attrs: inlinehint nounwind uwtable
define internal void @gca_isortr(ptr noundef %_ptr, i64 noundef %n, i64 noundef %m, i64 noundef %el, i32 noundef %compar_id, ptr noundef %arg) #4 {
entry:
  %add = add i64 %n, %m
  %mul = mul i64 %el, %add
  %add.ptr = getelementptr inbounds i8, ptr %_ptr, i64 %mul
  %mul1 = mul i64 %el, %n
  %add.ptr2 = getelementptr inbounds i8, ptr %_ptr, i64 %mul1
  br label %for.cond

for.cond:                                         ; preds = %for.inc12, %entry
  %pi.0 = phi ptr [ %add.ptr2, %entry ], [ %add.ptr13, %for.inc12 ]
  %cmp = icmp ult ptr %pi.0, %add.ptr
  br i1 %cmp, label %for.body, label %for.end14

for.body:                                         ; preds = %for.cond
  br label %for.cond3

for.cond3:                                        ; preds = %for.inc, %for.body
  %pj.0 = phi ptr [ %pi.0, %for.body ], [ %add.ptr11, %for.inc ]
  %cmp4 = icmp ugt ptr %pj.0, %_ptr
  br i1 %cmp4, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %for.cond3
  %idx.neg = sub i64 0, %el
  %add.ptr5 = getelementptr inbounds i8, ptr %pj.0, i64 %idx.neg
  %call = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %add.ptr5, ptr noundef %pj.0, ptr noundef %arg)
  %cmp6 = icmp sgt i32 %call, 0
  br label %land.end

land.end:                                         ; preds = %land.rhs, %for.cond3
  %0 = phi i1 [ false, %for.cond3 ], [ %cmp6, %land.rhs ]
  br i1 %0, label %for.body7, label %for.end

for.body7:                                        ; preds = %land.end
  %idx.neg8 = sub i64 0, %el
  %add.ptr9 = getelementptr inbounds i8, ptr %pj.0, i64 %idx.neg8
  call void @gca_swapm(ptr noundef %add.ptr9, ptr noundef %pj.0, i64 noundef %el)
  br label %for.inc

for.inc:                                          ; preds = %for.body7
  %idx.neg10 = sub i64 0, %el
  %add.ptr11 = getelementptr inbounds i8, ptr %pj.0, i64 %idx.neg10
  br label %for.cond3, !llvm.loop !27

for.end:                                          ; preds = %land.end
  br label %for.inc12

for.inc12:                                        ; preds = %for.end
  %add.ptr13 = getelementptr inbounds i8, ptr %pi.0, i64 %el
  br label %for.cond, !llvm.loop !28

for.end14:                                        ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local ptr @gca_median3(ptr noundef %p0, ptr noundef %p1, ptr noundef %p2, i32 noundef %compar_id, ptr noundef %arg) #0 {
entry:
  %call = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %p0, ptr noundef %p1, ptr noundef %arg)
  %cmp = icmp sgt i32 %call, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %do.body

do.body:                                          ; preds = %if.then
  br label %do.end

do.end:                                           ; preds = %do.body
  br label %if.end

if.end:                                           ; preds = %do.end, %entry
  %p1.addr.0 = phi ptr [ %p0, %do.end ], [ %p1, %entry ]
  %p0.addr.0 = phi ptr [ %p1, %do.end ], [ %p0, %entry ]
  %call1 = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %p1.addr.0, ptr noundef %p2, ptr noundef %arg)
  %cmp2 = icmp sgt i32 %call1, 0
  br i1 %cmp2, label %if.then3, label %if.end14

if.then3:                                         ; preds = %if.end
  br label %do.body4

do.body4:                                         ; preds = %if.then3
  br label %do.end6

do.end6:                                          ; preds = %do.body4
  %call7 = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %p0.addr.0, ptr noundef %p2, ptr noundef %arg)
  %cmp8 = icmp sgt i32 %call7, 0
  br i1 %cmp8, label %if.then9, label %if.end13

if.then9:                                         ; preds = %do.end6
  br label %do.body10

do.body10:                                        ; preds = %if.then9
  br label %do.end12

do.end12:                                         ; preds = %do.body10
  br label %if.end13

if.end13:                                         ; preds = %do.end12, %do.end6
  %p1.addr.1 = phi ptr [ %p0.addr.0, %do.end12 ], [ %p2, %do.end6 ]
  br label %if.end14

if.end14:                                         ; preds = %if.end13, %if.end
  %p1.addr.2 = phi ptr [ %p1.addr.1, %if.end13 ], [ %p1.addr.0, %if.end ]
  ret ptr %p1.addr.2
}

; Function Attrs: nounwind uwtable
define dso_local ptr @gca_qselect(ptr noundef %base, i64 noundef %nel, i64 noundef %es, i64 noundef %kidx, i32 noundef %compar_id, ptr noundef %arg) #0 {
entry:
  %sub = sub i64 %nel, 1
  %cmp = icmp ult i64 %kidx, %nel
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  br label %if.end

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 250, ptr noundef @__PRETTY_FUNCTION__.gca_qselect) #10
  unreachable

if.end:                                           ; preds = %if.then
  %cmp1 = icmp ule i64 %nel, 1
  br i1 %cmp1, label %if.then2, label %if.end3

if.then2:                                         ; preds = %if.end
  br label %cleanup30

if.end3:                                          ; preds = %if.end
  br label %while.cond

while.cond:                                       ; preds = %cleanup.cont, %if.end3
  %l.0 = phi i64 [ 0, %if.end3 ], [ %l.2, %cleanup.cont ]
  %r.0 = phi i64 [ %sub, %if.end3 ], [ %r.2, %cleanup.cont ]
  br label %while.body

while.body:                                       ; preds = %while.cond
  %mul = mul i64 %es, %l.0
  %add.ptr = getelementptr inbounds i8, ptr %base, i64 %mul
  %sub4 = sub i64 %r.0, %l.0
  %add = add i64 %sub4, 1
  %div = udiv i64 %add, 2
  %add5 = add i64 %l.0, %div
  %mul6 = mul i64 %es, %add5
  %add.ptr7 = getelementptr inbounds i8, ptr %base, i64 %mul6
  %mul8 = mul i64 %es, %r.0
  %add.ptr9 = getelementptr inbounds i8, ptr %base, i64 %mul8
  %call = call ptr @gca_median3(ptr noundef %add.ptr, ptr noundef %add.ptr7, ptr noundef %add.ptr9, i32 noundef %compar_id, ptr noundef %arg)
  %mul10 = mul i64 %es, %l.0
  %add.ptr11 = getelementptr inbounds i8, ptr %base, i64 %mul10
  call void @gca_swapm(ptr noundef %add.ptr11, ptr noundef %call, i64 noundef %es)
  %mul12 = mul i64 %es, %l.0
  %add.ptr13 = getelementptr inbounds i8, ptr %base, i64 %mul12
  %sub14 = sub i64 %r.0, %l.0
  %add15 = add i64 %sub14, 1
  %call16 = call i64 @gca_qpart(ptr noundef %add.ptr13, i64 noundef %add15, i64 noundef %es, i32 noundef %compar_id, ptr noundef %arg)
  %add17 = add i64 %l.0, %call16
  %cmp18 = icmp ugt i64 %add17, %kidx
  br i1 %cmp18, label %if.then19, label %if.else21

if.then19:                                        ; preds = %while.body
  %sub20 = sub i64 %add17, 1
  br label %if.end27

if.else21:                                        ; preds = %while.body
  %cmp22 = icmp ult i64 %add17, %kidx
  br i1 %cmp22, label %if.then23, label %if.else25

if.then23:                                        ; preds = %if.else21
  %add24 = add i64 %add17, 1
  br label %if.end26

if.else25:                                        ; preds = %if.else21
  br label %cleanup

if.end26:                                         ; preds = %if.then23
  br label %if.end27

if.end27:                                         ; preds = %if.end26, %if.then19
  %l.1 = phi i64 [ %l.0, %if.then19 ], [ %add24, %if.end26 ]
  %r.1 = phi i64 [ %sub20, %if.then19 ], [ %r.0, %if.end26 ]
  br label %cleanup

cleanup:                                          ; preds = %if.end27, %if.else25
  %l.2 = phi i64 [ %l.1, %if.end27 ], [ %l.0, %if.else25 ]
  %r.2 = phi i64 [ %r.1, %if.end27 ], [ %r.0, %if.else25 ]
  %cleanup.dest.slot.0 = phi i32 [ 0, %if.end27 ], [ 3, %if.else25 ]
  switch i32 %cleanup.dest.slot.0, label %unreachable [
    i32 0, label %cleanup.cont
    i32 3, label %while.end
  ]

cleanup.cont:                                     ; preds = %cleanup
  br label %while.cond, !llvm.loop !29

while.end:                                        ; preds = %cleanup
  %mul28 = mul i64 %es, %kidx
  %add.ptr29 = getelementptr inbounds i8, ptr %base, i64 %mul28
  br label %cleanup30

cleanup30:                                        ; preds = %while.end, %if.then2
  %retval.0 = phi ptr [ %base, %if.then2 ], [ %add.ptr29, %while.end ]
  ret ptr %retval.0

unreachable:                                      ; preds = %cleanup
  unreachable
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #7

; Function Attrs: nounwind uwtable
define dso_local void @gca_heap_pushup(ptr noundef %heap, i64 noundef %nel, i64 noundef %es, i32 noundef %compar_id, ptr noundef %arg) #0 {
entry:
  %0 = call ptr @llvm.stacksave()
  %vla = alloca i8, i64 %es, align 1
  %sub = sub i64 %nel, 1
  %mul = mul i64 %es, %sub
  %add.ptr = getelementptr inbounds i8, ptr %heap, i64 %mul
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %vla, ptr align 1 %add.ptr, i64 %es, i1 false)
  %sub1 = sub i64 %nel, 1
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %chi.0 = phi i64 [ %sub1, %entry ], [ %div, %for.inc ]
  %cmp = icmp ugt i64 %chi.0, 0
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %sub2 = sub i64 %chi.0, 1
  %div = udiv i64 %sub2, 2
  %mul3 = mul i64 %es, %div
  %add.ptr4 = getelementptr inbounds i8, ptr %heap, i64 %mul3
  %call = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %add.ptr4, ptr noundef %vla, ptr noundef %arg)
  %cmp5 = icmp sge i32 %call, 0
  br i1 %cmp5, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  br label %for.end

if.end:                                           ; preds = %for.body
  %mul6 = mul i64 %es, %chi.0
  %add.ptr7 = getelementptr inbounds i8, ptr %heap, i64 %mul6
  %mul8 = mul i64 %es, %div
  %add.ptr9 = getelementptr inbounds i8, ptr %heap, i64 %mul8
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %add.ptr7, ptr align 1 %add.ptr9, i64 %es, i1 false)
  br label %for.inc

for.inc:                                          ; preds = %if.end
  br label %for.cond, !llvm.loop !30

for.end:                                          ; preds = %if.then, %for.cond
  %mul10 = mul i64 %es, %chi.0
  %add.ptr11 = getelementptr inbounds i8, ptr %heap, i64 %mul10
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %add.ptr11, ptr align 1 %vla, i64 %es, i1 false)
  call void @llvm.stackrestore(ptr %0)
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @gca_heap_pushdwn(ptr noundef %heap, i64 noundef %nel, i64 noundef %es, i32 noundef %compar_id, ptr noundef %arg) #0 {
entry:
  %0 = call ptr @llvm.stacksave()
  %vla = alloca i8, i64 %es, align 1
  %sub = sub i64 %nel, 1
  %mul = mul i64 %es, %sub
  %add.ptr = getelementptr inbounds i8, ptr %heap, i64 %mul
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %vla, ptr align 1 %add.ptr, i64 %es, i1 false)
  %add.ptr1 = getelementptr inbounds i8, ptr %heap, i64 %es
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %p.0 = phi ptr [ %heap, %entry ], [ %cond, %for.inc ]
  %ch.0 = phi ptr [ %add.ptr1, %entry ], [ %add.ptr9, %for.inc ]
  %cmp = icmp ult ptr %ch.0, %add.ptr
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %add.ptr2 = getelementptr inbounds i8, ptr %ch.0, i64 %es
  %cmp3 = icmp ult ptr %add.ptr2, %add.ptr
  br i1 %cmp3, label %land.lhs.true, label %cond.false

land.lhs.true:                                    ; preds = %for.body
  %add.ptr4 = getelementptr inbounds i8, ptr %ch.0, i64 %es
  %call = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %ch.0, ptr noundef %add.ptr4, ptr noundef %arg)
  %cmp5 = icmp slt i32 %call, 0
  br i1 %cmp5, label %cond.true, label %cond.false

cond.true:                                        ; preds = %land.lhs.true
  %add.ptr6 = getelementptr inbounds i8, ptr %ch.0, i64 %es
  br label %cond.end

cond.false:                                       ; preds = %land.lhs.true, %for.body
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi ptr [ %add.ptr6, %cond.true ], [ %ch.0, %cond.false ]
  %call7 = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %vla, ptr noundef %cond, ptr noundef %arg)
  %cmp8 = icmp sge i32 %call7, 0
  br i1 %cmp8, label %if.then, label %if.end

if.then:                                          ; preds = %cond.end
  br label %for.end

if.end:                                           ; preds = %cond.end
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %p.0, ptr align 1 %cond, i64 %es, i1 false)
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %add.ptr9 = getelementptr inbounds i8, ptr %cond, i64 %es
  br label %for.cond, !llvm.loop !31

for.end:                                          ; preds = %if.then, %for.cond
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %p.0, ptr align 1 %vla, i64 %es, i1 false)
  call void @llvm.stackrestore(ptr %0)
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @gca_heap_make(ptr noundef %heap, i64 noundef %nel, i64 noundef %es, i32 noundef %compar_id, ptr noundef %arg) #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %n.0 = phi i64 [ 2, %entry ], [ %inc, %for.inc ]
  %cmp = icmp ule i64 %n.0, %nel
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  call void @gca_heap_pushup(ptr noundef %heap, i64 noundef %n.0, i64 noundef %es, i32 noundef %compar_id, ptr noundef %arg)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add i64 %n.0, 1
  br label %for.cond, !llvm.loop !32

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @gca_heap_sort(ptr noundef %heap, i64 noundef %nel, i64 noundef %es, i32 noundef %compar_id, ptr noundef %arg) #0 {
entry:
  %cmp = icmp ule i64 %nel, 1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %return

if.end:                                           ; preds = %entry
  %sub = sub i64 %nel, 1
  %mul = mul i64 %es, %sub
  %add.ptr = getelementptr inbounds i8, ptr %heap, i64 %mul
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end
  %end.0 = phi ptr [ %add.ptr, %if.end ], [ %add.ptr2, %for.inc ]
  %n.0 = phi i64 [ %sub, %if.end ], [ %dec, %for.inc ]
  %cmp1 = icmp ugt i64 %n.0, 1
  br i1 %cmp1, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  call void @gca_swapm(ptr noundef %heap, ptr noundef %end.0, i64 noundef %es)
  call void @gca_heap_pushdwn(ptr noundef %heap, i64 noundef %n.0, i64 noundef %es, i32 noundef %compar_id, ptr noundef %arg)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %dec = add i64 %n.0, -1
  %idx.neg = sub i64 0, %es
  %add.ptr2 = getelementptr inbounds i8, ptr %end.0, i64 %idx.neg
  br label %for.cond, !llvm.loop !33

for.end:                                          ; preds = %for.cond
  %add.ptr3 = getelementptr inbounds i8, ptr %heap, i64 %es
  call void @gca_swapm(ptr noundef %heap, ptr noundef %add.ptr3, i64 noundef %es)
  br label %return

return:                                           ; preds = %for.end, %if.then
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local ptr @gca_median5(ptr noundef %p0, ptr noundef %p1, ptr noundef %p2, ptr noundef %p3, ptr noundef %p4, i32 noundef %compar_id, ptr noundef %arg) #0 {
entry:
  %call = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %p0, ptr noundef %p1, ptr noundef %arg)
  %cmp = icmp sgt i32 %call, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %do.body

do.body:                                          ; preds = %if.then
  br label %do.end

do.end:                                           ; preds = %do.body
  br label %if.end

if.end:                                           ; preds = %do.end, %entry
  %p1.addr.0 = phi ptr [ %p0, %do.end ], [ %p1, %entry ]
  %p0.addr.0 = phi ptr [ %p1, %do.end ], [ %p0, %entry ]
  %call1 = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %p2, ptr noundef %p3, ptr noundef %arg)
  %cmp2 = icmp sgt i32 %call1, 0
  br i1 %cmp2, label %if.then3, label %if.end7

if.then3:                                         ; preds = %if.end
  br label %do.body4

do.body4:                                         ; preds = %if.then3
  br label %do.end6

do.end6:                                          ; preds = %do.body4
  br label %if.end7

if.end7:                                          ; preds = %do.end6, %if.end
  %p3.addr.0 = phi ptr [ %p2, %do.end6 ], [ %p3, %if.end ]
  %p2.addr.0 = phi ptr [ %p3, %do.end6 ], [ %p2, %if.end ]
  %call8 = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %p0.addr.0, ptr noundef %p2.addr.0, ptr noundef %arg)
  %cmp9 = icmp slt i32 %call8, 0
  br i1 %cmp9, label %if.then10, label %if.else

if.then10:                                        ; preds = %if.end7
  %call11 = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %p4, ptr noundef %p1.addr.0, ptr noundef %arg)
  %cmp12 = icmp sgt i32 %call11, 0
  br i1 %cmp12, label %if.then13, label %if.end17

if.then13:                                        ; preds = %if.then10
  br label %do.body14

do.body14:                                        ; preds = %if.then13
  br label %do.end16

do.end16:                                         ; preds = %do.body14
  br label %if.end17

if.end17:                                         ; preds = %do.end16, %if.then10
  %p1.addr.1 = phi ptr [ %p4, %do.end16 ], [ %p1.addr.0, %if.then10 ]
  %p0.addr.1 = phi ptr [ %p1.addr.0, %do.end16 ], [ %p4, %if.then10 ]
  br label %if.end25

if.else:                                          ; preds = %if.end7
  %call18 = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %p4, ptr noundef %p3.addr.0, ptr noundef %arg)
  %cmp19 = icmp sgt i32 %call18, 0
  br i1 %cmp19, label %if.then20, label %if.end24

if.then20:                                        ; preds = %if.else
  br label %do.body21

do.body21:                                        ; preds = %if.then20
  br label %do.end23

do.end23:                                         ; preds = %do.body21
  br label %if.end24

if.end24:                                         ; preds = %do.end23, %if.else
  %p3.addr.1 = phi ptr [ %p4, %do.end23 ], [ %p3.addr.0, %if.else ]
  %p2.addr.1 = phi ptr [ %p3.addr.0, %do.end23 ], [ %p4, %if.else ]
  br label %if.end25

if.end25:                                         ; preds = %if.end24, %if.end17
  %p3.addr.2 = phi ptr [ %p3.addr.0, %if.end17 ], [ %p3.addr.1, %if.end24 ]
  %p2.addr.2 = phi ptr [ %p2.addr.0, %if.end17 ], [ %p2.addr.1, %if.end24 ]
  %p1.addr.2 = phi ptr [ %p1.addr.1, %if.end17 ], [ %p1.addr.0, %if.end24 ]
  %p0.addr.2 = phi ptr [ %p0.addr.1, %if.end17 ], [ %p0.addr.0, %if.end24 ]
  %call26 = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %p0.addr.2, ptr noundef %p2.addr.2, ptr noundef %arg)
  %cmp27 = icmp slt i32 %call26, 0
  br i1 %cmp27, label %if.then28, label %if.else31

if.then28:                                        ; preds = %if.end25
  %call29 = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %p1.addr.2, ptr noundef %p2.addr.2, ptr noundef %arg)
  %cmp30 = icmp slt i32 %call29, 0
  br i1 %cmp30, label %cond.true, label %cond.false

cond.true:                                        ; preds = %if.then28
  br label %cond.end

cond.false:                                       ; preds = %if.then28
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi ptr [ %p1.addr.2, %cond.true ], [ %p2.addr.2, %cond.false ]
  br label %return

if.else31:                                        ; preds = %if.end25
  %call32 = call i32 @call_compar(i32 noundef %compar_id, ptr noundef %p3.addr.2, ptr noundef %p0.addr.2, ptr noundef %arg)
  %cmp33 = icmp slt i32 %call32, 0
  br i1 %cmp33, label %cond.true34, label %cond.false35

cond.true34:                                      ; preds = %if.else31
  br label %cond.end36

cond.false35:                                     ; preds = %if.else31
  br label %cond.end36

cond.end36:                                       ; preds = %cond.false35, %cond.true34
  %cond37 = phi ptr [ %p3.addr.2, %cond.true34 ], [ %p0.addr.2, %cond.false35 ]
  br label %return

return:                                           ; preds = %cond.end36, %cond.end
  %retval.0 = phi ptr [ %cond, %cond.end ], [ %cond37, %cond.end36 ]
  ret ptr %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local ptr @gca_itr_reset(ptr noundef %p, i64 noundef %n) #0 {
entry:
  %tobool = icmp ne ptr %p, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %mul = mul i64 %n, 8
  %call = call noalias ptr @malloc(i64 noundef %mul) #11
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %p.addr.0 = phi ptr [ %p, %entry ], [ %call, %if.then ]
  %tobool1 = icmp ne ptr %p.addr.0, null
  br i1 %tobool1, label %land.lhs.true, label %if.end4

land.lhs.true:                                    ; preds = %if.end
  %tobool2 = icmp ne i64 %n, 0
  br i1 %tobool2, label %if.then3, label %if.end4

if.then3:                                         ; preds = %land.lhs.true
  %arrayidx = getelementptr inbounds i64, ptr %p.addr.0, i64 0
  store i64 -1, ptr %arrayidx, align 8, !tbaa !34
  br label %if.end4

if.end4:                                          ; preds = %if.then3, %land.lhs.true, %if.end
  ret ptr %p.addr.0
}

; Function Attrs: nounwind allocsize(0)
declare noalias ptr @malloc(i64 noundef) #8

; Function Attrs: nounwind uwtable
define dso_local ptr @gca_itr_next(ptr noundef %pp, i64 noundef %n, ptr noundef %init) #0 {
entry:
  %0 = load ptr, ptr %pp, align 8, !tbaa !36
  %tobool = icmp ne i64 %n, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  br label %cleanup

if.end:                                           ; preds = %entry
  %1 = load ptr, ptr %pp, align 8, !tbaa !36
  %tobool1 = icmp ne ptr %1, null
  br i1 %tobool1, label %if.end3, label %if.then2

if.then2:                                         ; preds = %if.end
  %mul = mul i64 %n, 8
  %call = call noalias ptr @malloc(i64 noundef %mul) #11
  store ptr %call, ptr %pp, align 8, !tbaa !36
  %arrayidx = getelementptr inbounds i64, ptr %call, i64 0
  store i64 -1, ptr %arrayidx, align 8, !tbaa !34
  br label %if.end3

if.end3:                                          ; preds = %if.then2, %if.end
  %p.0 = phi ptr [ %0, %if.end ], [ %call, %if.then2 ]
  %arrayidx4 = getelementptr inbounds i64, ptr %p.0, i64 0
  %2 = load i64, ptr %arrayidx4, align 8, !tbaa !34
  %cmp = icmp eq i64 %2, -1
  br i1 %cmp, label %if.then5, label %if.end12

if.then5:                                         ; preds = %if.end3
  %tobool6 = icmp ne ptr %init, null
  br i1 %tobool6, label %if.then7, label %if.else

if.then7:                                         ; preds = %if.then5
  %mul8 = mul i64 %n, 8
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %p.0, ptr align 8 %init, i64 %mul8, i1 false)
  br label %if.end11

if.else:                                          ; preds = %if.then5
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.else
  %i.0 = phi i64 [ 0, %if.else ], [ %inc, %for.inc ]
  %cmp9 = icmp ult i64 %i.0, %n
  br i1 %cmp9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %arrayidx10 = getelementptr inbounds i64, ptr %p.0, i64 %i.0
  store i64 %i.0, ptr %arrayidx10, align 8, !tbaa !34
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add i64 %i.0, 1
  br label %for.cond, !llvm.loop !38

for.end:                                          ; preds = %for.cond
  br label %if.end11

if.end11:                                         ; preds = %for.end, %if.then7
  br label %cleanup

if.end12:                                         ; preds = %if.end3
  %sub = sub i64 %n, 1
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end12
  %i.1 = phi i64 [ %sub, %if.end12 ], [ %dec, %while.body ]
  %cmp13 = icmp ugt i64 %i.1, 0
  br i1 %cmp13, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %while.cond
  %sub14 = sub i64 %i.1, 1
  %arrayidx15 = getelementptr inbounds i64, ptr %p.0, i64 %sub14
  %3 = load i64, ptr %arrayidx15, align 8, !tbaa !34
  %arrayidx16 = getelementptr inbounds i64, ptr %p.0, i64 %i.1
  %4 = load i64, ptr %arrayidx16, align 8, !tbaa !34
  %cmp17 = icmp uge i64 %3, %4
  br label %land.end

land.end:                                         ; preds = %land.rhs, %while.cond
  %5 = phi i1 [ false, %while.cond ], [ %cmp17, %land.rhs ]
  br i1 %5, label %while.body, label %while.end

while.body:                                       ; preds = %land.end
  %dec = add i64 %i.1, -1
  br label %while.cond, !llvm.loop !39

while.end:                                        ; preds = %land.end
  %tobool18 = icmp ne i64 %i.1, 0
  br i1 %tobool18, label %if.end20, label %if.then19

if.then19:                                        ; preds = %while.end
  br label %cleanup

if.end20:                                         ; preds = %while.end
  br label %for.cond21

for.cond21:                                       ; preds = %for.inc31, %if.end20
  %j.0 = phi i64 [ %i.1, %if.end20 ], [ %inc32, %for.inc31 ]
  %add = add i64 %j.0, 1
  %cmp22 = icmp ult i64 %add, %n
  br i1 %cmp22, label %land.rhs23, label %land.end29

land.rhs23:                                       ; preds = %for.cond21
  %sub24 = sub i64 %i.1, 1
  %arrayidx25 = getelementptr inbounds i64, ptr %p.0, i64 %sub24
  %6 = load i64, ptr %arrayidx25, align 8, !tbaa !34
  %add26 = add i64 %j.0, 1
  %arrayidx27 = getelementptr inbounds i64, ptr %p.0, i64 %add26
  %7 = load i64, ptr %arrayidx27, align 8, !tbaa !34
  %cmp28 = icmp ult i64 %6, %7
  br label %land.end29

land.end29:                                       ; preds = %land.rhs23, %for.cond21
  %8 = phi i1 [ false, %for.cond21 ], [ %cmp28, %land.rhs23 ]
  br i1 %8, label %for.body30, label %for.end33

for.body30:                                       ; preds = %land.end29
  br label %for.inc31

for.inc31:                                        ; preds = %for.body30
  %inc32 = add i64 %j.0, 1
  br label %for.cond21, !llvm.loop !40

for.end33:                                        ; preds = %land.end29
  br label %do.body

do.body:                                          ; preds = %for.end33
  %sub34 = sub i64 %i.1, 1
  %arrayidx35 = getelementptr inbounds i64, ptr %p.0, i64 %sub34
  %9 = load i64, ptr %arrayidx35, align 8, !tbaa !34
  %arrayidx36 = getelementptr inbounds i64, ptr %p.0, i64 %j.0
  %10 = load i64, ptr %arrayidx36, align 8, !tbaa !34
  %sub37 = sub i64 %i.1, 1
  %arrayidx38 = getelementptr inbounds i64, ptr %p.0, i64 %sub37
  store i64 %10, ptr %arrayidx38, align 8, !tbaa !34
  %arrayidx39 = getelementptr inbounds i64, ptr %p.0, i64 %j.0
  store i64 %9, ptr %arrayidx39, align 8, !tbaa !34
  br label %do.cond

do.cond:                                          ; preds = %do.body
  br label %do.end

do.end:                                           ; preds = %do.cond
  %add.ptr = getelementptr inbounds i64, ptr %p.0, i64 %i.1
  %sub40 = sub i64 %n, %i.1
  call void @gca_reverse(ptr noundef %add.ptr, i64 noundef %sub40, i64 noundef 8)
  br label %cleanup

cleanup:                                          ; preds = %do.end, %if.then19, %if.end11, %if.then
  %retval.0 = phi ptr [ %p.0, %if.end11 ], [ %p.0, %do.end ], [ null, %if.then19 ], [ null, %if.then ]
  ret ptr %retval.0
}

attributes #0 = { nounwind uwtable "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nocallback nofree nosync nounwind willreturn }
attributes #3 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { inlinehint nounwind uwtable "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #5 = { nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #6 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #7 = { noreturn nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #8 = { nounwind allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #9 = { nounwind }
attributes #10 = { noreturn nounwind }
attributes #11 = { nounwind allocsize(0) }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Ubuntu clang version 17.0.6 (9ubuntu1)"}
!6 = distinct !{!6, !7, !8}
!7 = !{!"llvm.loop.mustprogress"}
!8 = !{!"llvm.loop.unroll.disable"}
!9 = distinct !{!9, !7, !8}
!10 = distinct !{!10, !7, !8}
!11 = distinct !{!11, !7, !8}
!12 = distinct !{!12, !8}
!13 = distinct !{!13, !7, !8}
!14 = distinct !{!14, !7, !8}
!15 = !{!16, !16, i64 0}
!16 = !{!"omnipotent char", !17, i64 0}
!17 = !{!"Simple C/C++ TBAA"}
!18 = distinct !{!18, !7, !8}
!19 = distinct !{!19, !7, !8}
!20 = distinct !{!20, !7, !8}
!21 = distinct !{!21, !7, !8}
!22 = distinct !{!22, !8}
!23 = distinct !{!23, !7, !8}
!24 = distinct !{!24, !7, !8}
!25 = distinct !{!25, !7, !8}
!26 = distinct !{!26, !7, !8}
!27 = distinct !{!27, !7, !8}
!28 = distinct !{!28, !7, !8}
!29 = distinct !{!29, !8}
!30 = distinct !{!30, !7, !8}
!31 = distinct !{!31, !7, !8}
!32 = distinct !{!32, !7, !8}
!33 = distinct !{!33, !7, !8}
!34 = !{!35, !35, i64 0}
!35 = !{!"long", !16, i64 0}
!36 = !{!37, !37, i64 0}
!37 = !{!"any pointer", !16, i64 0}
!38 = distinct !{!38, !7, !8}
!39 = distinct !{!39, !7, !8}
!40 = distinct !{!40, !7, !8}
