; ModuleID = 'benchmarks/nandc/source.ll'
source_filename = "benchmarks/nandc/source.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"false\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"a      : %s\0A\00", align 1
@.str.3 = private unnamed_addr constant [13 x i8] c"b      : %s\0A\00", align 1
@.str.4 = private unnamed_addr constant [13 x i8] c"carry  : %s\0A\00", align 1
@.str.5 = private unnamed_addr constant [10 x i8] c"result :\0A\00", align 1
@.str.6 = private unnamed_addr constant [13 x i8] c"  bit  : %s\0A\00", align 1
@.str.7 = private unnamed_addr constant [13 x i8] c"  carry: %s\0A\00", align 1
@stderr = external global ptr, align 8
@.str.8 = private unnamed_addr constant [31 x i8] c"ERROR: Add failed with %d+%d:\0A\00", align 1
@.str.9 = private unnamed_addr constant [12 x i8] c"  My  : %d\0A\00", align 1
@.str.10 = private unnamed_addr constant [12 x i8] c"  Real: %d\0A\00", align 1
@.str.11 = private unnamed_addr constant [21 x i8] c"Add works correctly\0A\00", align 1
@.str.12 = private unnamed_addr constant [31 x i8] c"ERROR: Sub failed with %d-%d:\0A\00", align 1
@.str.13 = private unnamed_addr constant [21 x i8] c"Sub works correctly\0A\00", align 1

; Function Attrs: nounwind uwtable
define dso_local ptr @bll(i1 noundef zeroext %x) #0 {
entry:
  %frombool = zext i1 %x to i8
  %tobool = trunc i8 %frombool to i1
  br i1 %tobool, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %return

if.end:                                           ; preds = %entry
  br label %return

return:                                           ; preds = %if.end, %if.then
  %retval.0 = phi ptr [ @.str, %if.then ], [ @.str.1, %if.end ]
  ret ptr %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local void @print_add_bit(i1 noundef zeroext %a, i1 noundef zeroext %b, i1 noundef zeroext %carry) #0 {
entry:
  %res_carry = alloca i8, align 1
  %frombool = zext i1 %a to i8
  %frombool1 = zext i1 %b to i8
  %frombool2 = zext i1 %carry to i8
  %tobool = trunc i8 %frombool to i1
  %call = call ptr @bll(i1 noundef zeroext %tobool)
  %call3 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, ptr noundef %call)
  %tobool4 = trunc i8 %frombool1 to i1
  %call5 = call ptr @bll(i1 noundef zeroext %tobool4)
  %call6 = call i32 (ptr, ...) @printf(ptr noundef @.str.3, ptr noundef %call5)
  %tobool7 = trunc i8 %frombool2 to i1
  %call8 = call ptr @bll(i1 noundef zeroext %tobool7)
  %call9 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef %call8)
  call void @llvm.lifetime.start.p0(i64 1, ptr %res_carry) #3
  %call10 = call i32 (ptr, ...) @printf(ptr noundef @.str.5)
  %tobool11 = trunc i8 %frombool to i1
  %tobool12 = trunc i8 %frombool1 to i1
  %tobool13 = trunc i8 %frombool2 to i1
  %call14 = call zeroext i1 @add_bit(i1 noundef zeroext %tobool11, i1 noundef zeroext %tobool12, i1 noundef zeroext %tobool13, ptr noundef %res_carry)
  %call15 = call ptr @bll(i1 noundef zeroext %call14)
  %call16 = call i32 (ptr, ...) @printf(ptr noundef @.str.6, ptr noundef %call15)
  %0 = load i8, ptr %res_carry, align 1, !tbaa !5, !range !9, !noundef !10
  %tobool17 = trunc i8 %0 to i1
  %call18 = call ptr @bll(i1 noundef zeroext %tobool17)
  %call19 = call i32 (ptr, ...) @printf(ptr noundef @.str.7, ptr noundef %call18)
  call void @llvm.lifetime.end.p0(i64 1, ptr %res_carry) #3
  ret void
}

declare i32 @printf(ptr noundef, ...) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #2

; Function Attrs: nounwind uwtable
define internal zeroext i1 @add_bit(i1 noundef zeroext %a, i1 noundef zeroext %b, i1 noundef zeroext %carry, ptr noundef %carry_result) #0 {
entry:
  %frombool = zext i1 %a to i8
  %frombool1 = zext i1 %b to i8
  %frombool2 = zext i1 %carry to i8
  %tobool = trunc i8 %frombool to i1
  %tobool3 = trunc i8 %frombool1 to i1
  %call = call zeroext i1 @or(i1 noundef zeroext %tobool, i1 noundef zeroext %tobool3)
  %tobool4 = trunc i8 %frombool to i1
  %tobool5 = trunc i8 %frombool1 to i1
  %call6 = call zeroext i1 @and(i1 noundef zeroext %tobool4, i1 noundef zeroext %tobool5)
  %tobool7 = trunc i8 %frombool2 to i1
  %call8 = call zeroext i1 @or(i1 noundef zeroext %call6, i1 noundef zeroext %tobool7)
  %call9 = call zeroext i1 @and(i1 noundef zeroext %call, i1 noundef zeroext %call8)
  %frombool10 = zext i1 %call9 to i8
  store i8 %frombool10, ptr %carry_result, align 1, !tbaa !5
  %tobool11 = trunc i8 %frombool to i1
  %tobool12 = trunc i8 %frombool1 to i1
  %call13 = call zeroext i1 @xor(i1 noundef zeroext %tobool11, i1 noundef zeroext %tobool12)
  %tobool14 = trunc i8 %frombool2 to i1
  %call15 = call zeroext i1 @xor(i1 noundef zeroext %call13, i1 noundef zeroext %tobool14)
  ret i1 %call15
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #2

; Function Attrs: nounwind uwtable
define dso_local zeroext i8 @add_u4(i8 noundef zeroext %a, i8 noundef zeroext %b) #0 {
entry:
  %carry = alloca i8, align 1
  call void @llvm.lifetime.start.p0(i64 1, ptr %carry) #3
  store i8 0, ptr %carry, align 1, !tbaa !5
  %conv = zext i8 %a to i32
  %shr = ashr i32 %conv, 0
  %and = and i32 %shr, 1
  %tobool = icmp ne i32 %and, 0
  %conv1 = zext i8 %b to i32
  %shr2 = ashr i32 %conv1, 0
  %and3 = and i32 %shr2, 1
  %tobool4 = icmp ne i32 %and3, 0
  %0 = load i8, ptr %carry, align 1, !tbaa !5, !range !9, !noundef !10
  %tobool5 = trunc i8 %0 to i1
  %call = call zeroext i1 @add_bit(i1 noundef zeroext %tobool, i1 noundef zeroext %tobool4, i1 noundef zeroext %tobool5, ptr noundef %carry)
  %conv6 = zext i1 %call to i8
  %conv7 = zext i8 %conv6 to i32
  %shl = shl i32 %conv7, 0
  %conv8 = zext i8 0 to i32
  %or = or i32 %conv8, %shl
  %conv9 = trunc i32 %or to i8
  %conv10 = zext i8 %a to i32
  %shr11 = ashr i32 %conv10, 1
  %and12 = and i32 %shr11, 1
  %tobool13 = icmp ne i32 %and12, 0
  %conv14 = zext i8 %b to i32
  %shr15 = ashr i32 %conv14, 1
  %and16 = and i32 %shr15, 1
  %tobool17 = icmp ne i32 %and16, 0
  %1 = load i8, ptr %carry, align 1, !tbaa !5, !range !9, !noundef !10
  %tobool18 = trunc i8 %1 to i1
  %call19 = call zeroext i1 @add_bit(i1 noundef zeroext %tobool13, i1 noundef zeroext %tobool17, i1 noundef zeroext %tobool18, ptr noundef %carry)
  %conv20 = zext i1 %call19 to i8
  %conv21 = zext i8 %conv20 to i32
  %shl22 = shl i32 %conv21, 1
  %conv23 = zext i8 %conv9 to i32
  %or24 = or i32 %conv23, %shl22
  %conv25 = trunc i32 %or24 to i8
  %conv26 = zext i8 %a to i32
  %shr27 = ashr i32 %conv26, 2
  %and28 = and i32 %shr27, 1
  %tobool29 = icmp ne i32 %and28, 0
  %conv30 = zext i8 %b to i32
  %shr31 = ashr i32 %conv30, 2
  %and32 = and i32 %shr31, 1
  %tobool33 = icmp ne i32 %and32, 0
  %2 = load i8, ptr %carry, align 1, !tbaa !5, !range !9, !noundef !10
  %tobool34 = trunc i8 %2 to i1
  %call35 = call zeroext i1 @add_bit(i1 noundef zeroext %tobool29, i1 noundef zeroext %tobool33, i1 noundef zeroext %tobool34, ptr noundef %carry)
  %conv36 = zext i1 %call35 to i8
  %conv37 = zext i8 %conv36 to i32
  %shl38 = shl i32 %conv37, 2
  %conv39 = zext i8 %conv25 to i32
  %or40 = or i32 %conv39, %shl38
  %conv41 = trunc i32 %or40 to i8
  %conv42 = zext i8 %a to i32
  %shr43 = ashr i32 %conv42, 3
  %and44 = and i32 %shr43, 1
  %tobool45 = icmp ne i32 %and44, 0
  %conv46 = zext i8 %b to i32
  %shr47 = ashr i32 %conv46, 3
  %and48 = and i32 %shr47, 1
  %tobool49 = icmp ne i32 %and48, 0
  %3 = load i8, ptr %carry, align 1, !tbaa !5, !range !9, !noundef !10
  %tobool50 = trunc i8 %3 to i1
  %call51 = call zeroext i1 @add_bit(i1 noundef zeroext %tobool45, i1 noundef zeroext %tobool49, i1 noundef zeroext %tobool50, ptr noundef %carry)
  %conv52 = zext i1 %call51 to i8
  %conv53 = zext i8 %conv52 to i32
  %shl54 = shl i32 %conv53, 3
  %conv55 = zext i8 %conv41 to i32
  %or56 = or i32 %conv55, %shl54
  %conv57 = trunc i32 %or56 to i8
  call void @llvm.lifetime.end.p0(i64 1, ptr %carry) #3
  ret i8 %conv57
}

; Function Attrs: nounwind uwtable
define dso_local zeroext i8 @sub_u4(i8 noundef zeroext %a, i8 noundef zeroext %b) #0 {
entry:
  %carry = alloca i8, align 1
  call void @llvm.lifetime.start.p0(i64 1, ptr %carry) #3
  store i8 0, ptr %carry, align 1, !tbaa !5
  %conv = zext i8 %a to i32
  %shr = ashr i32 %conv, 0
  %and = and i32 %shr, 1
  %tobool = icmp ne i32 %and, 0
  %conv1 = zext i8 %b to i32
  %shr2 = ashr i32 %conv1, 0
  %and3 = and i32 %shr2, 1
  %tobool4 = icmp ne i32 %and3, 0
  %0 = load i8, ptr %carry, align 1, !tbaa !5, !range !9, !noundef !10
  %tobool5 = trunc i8 %0 to i1
  %call = call zeroext i1 @sub_bit(i1 noundef zeroext %tobool, i1 noundef zeroext %tobool4, i1 noundef zeroext %tobool5, ptr noundef %carry)
  %conv6 = zext i1 %call to i8
  %conv7 = zext i8 %conv6 to i32
  %shl = shl i32 %conv7, 0
  %conv8 = zext i8 0 to i32
  %or = or i32 %conv8, %shl
  %conv9 = trunc i32 %or to i8
  %conv10 = zext i8 %a to i32
  %shr11 = ashr i32 %conv10, 1
  %and12 = and i32 %shr11, 1
  %tobool13 = icmp ne i32 %and12, 0
  %conv14 = zext i8 %b to i32
  %shr15 = ashr i32 %conv14, 1
  %and16 = and i32 %shr15, 1
  %tobool17 = icmp ne i32 %and16, 0
  %1 = load i8, ptr %carry, align 1, !tbaa !5, !range !9, !noundef !10
  %tobool18 = trunc i8 %1 to i1
  %call19 = call zeroext i1 @sub_bit(i1 noundef zeroext %tobool13, i1 noundef zeroext %tobool17, i1 noundef zeroext %tobool18, ptr noundef %carry)
  %conv20 = zext i1 %call19 to i8
  %conv21 = zext i8 %conv20 to i32
  %shl22 = shl i32 %conv21, 1
  %conv23 = zext i8 %conv9 to i32
  %or24 = or i32 %conv23, %shl22
  %conv25 = trunc i32 %or24 to i8
  %conv26 = zext i8 %a to i32
  %shr27 = ashr i32 %conv26, 2
  %and28 = and i32 %shr27, 1
  %tobool29 = icmp ne i32 %and28, 0
  %conv30 = zext i8 %b to i32
  %shr31 = ashr i32 %conv30, 2
  %and32 = and i32 %shr31, 1
  %tobool33 = icmp ne i32 %and32, 0
  %2 = load i8, ptr %carry, align 1, !tbaa !5, !range !9, !noundef !10
  %tobool34 = trunc i8 %2 to i1
  %call35 = call zeroext i1 @sub_bit(i1 noundef zeroext %tobool29, i1 noundef zeroext %tobool33, i1 noundef zeroext %tobool34, ptr noundef %carry)
  %conv36 = zext i1 %call35 to i8
  %conv37 = zext i8 %conv36 to i32
  %shl38 = shl i32 %conv37, 2
  %conv39 = zext i8 %conv25 to i32
  %or40 = or i32 %conv39, %shl38
  %conv41 = trunc i32 %or40 to i8
  %conv42 = zext i8 %a to i32
  %shr43 = ashr i32 %conv42, 3
  %and44 = and i32 %shr43, 1
  %tobool45 = icmp ne i32 %and44, 0
  %conv46 = zext i8 %b to i32
  %shr47 = ashr i32 %conv46, 3
  %and48 = and i32 %shr47, 1
  %tobool49 = icmp ne i32 %and48, 0
  %3 = load i8, ptr %carry, align 1, !tbaa !5, !range !9, !noundef !10
  %tobool50 = trunc i8 %3 to i1
  %call51 = call zeroext i1 @sub_bit(i1 noundef zeroext %tobool45, i1 noundef zeroext %tobool49, i1 noundef zeroext %tobool50, ptr noundef %carry)
  %conv52 = zext i1 %call51 to i8
  %conv53 = zext i8 %conv52 to i32
  %shl54 = shl i32 %conv53, 3
  %conv55 = zext i8 %conv41 to i32
  %or56 = or i32 %conv55, %shl54
  %conv57 = trunc i32 %or56 to i8
  call void @llvm.lifetime.end.p0(i64 1, ptr %carry) #3
  ret i8 %conv57
}

; Function Attrs: nounwind uwtable
define internal zeroext i1 @sub_bit(i1 noundef zeroext %a, i1 noundef zeroext %b, i1 noundef zeroext %carry, ptr noundef %carry_result) #0 {
entry:
  %b1 = alloca i8, align 1
  %b2 = alloca i8, align 1
  %frombool = zext i1 %a to i8
  %frombool1 = zext i1 %b to i8
  %frombool2 = zext i1 %carry to i8
  call void @llvm.lifetime.start.p0(i64 1, ptr %b1) #3
  call void @llvm.lifetime.start.p0(i64 1, ptr %b2) #3
  %tobool = trunc i8 %frombool to i1
  %tobool3 = trunc i8 %frombool1 to i1
  %call = call zeroext i1 @half_sub(i1 noundef zeroext %tobool, i1 noundef zeroext %tobool3, ptr noundef %b1)
  %tobool4 = trunc i8 %frombool2 to i1
  %call5 = call zeroext i1 @half_sub(i1 noundef zeroext %call, i1 noundef zeroext %tobool4, ptr noundef %b2)
  %frombool6 = zext i1 %call5 to i8
  %0 = load i8, ptr %b1, align 1, !tbaa !5, !range !9, !noundef !10
  %tobool7 = trunc i8 %0 to i1
  %1 = load i8, ptr %b2, align 1, !tbaa !5, !range !9, !noundef !10
  %tobool8 = trunc i8 %1 to i1
  %call9 = call zeroext i1 @or(i1 noundef zeroext %tobool7, i1 noundef zeroext %tobool8)
  %frombool10 = zext i1 %call9 to i8
  store i8 %frombool10, ptr %carry_result, align 1, !tbaa !5
  %tobool11 = trunc i8 %frombool6 to i1
  call void @llvm.lifetime.end.p0(i64 1, ptr %b2) #3
  call void @llvm.lifetime.end.p0(i64 1, ptr %b1) #3
  ret i1 %tobool11
}

; Function Attrs: nounwind uwtable
define dso_local zeroext i1 @check_add() #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc25, %entry
  %a.0 = phi i8 [ 0, %entry ], [ %inc26, %for.inc25 ]
  %retval.0 = phi i1 [ undef, %entry ], [ %retval.3, %for.inc25 ]
  %conv = zext i8 %a.0 to i32
  %cmp = icmp slt i32 %conv, 15
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %cleanup27

for.body:                                         ; preds = %for.cond
  br label %for.cond2

for.cond2:                                        ; preds = %for.inc, %for.body
  %b.0 = phi i8 [ 0, %for.body ], [ %inc, %for.inc ]
  %retval.1 = phi i1 [ %retval.0, %for.body ], [ %retval.2, %for.inc ]
  %conv3 = zext i8 %b.0 to i32
  %cmp4 = icmp slt i32 %conv3, 15
  br i1 %cmp4, label %for.body7, label %for.cond.cleanup6

for.cond.cleanup6:                                ; preds = %for.cond2
  br label %cleanup23

for.body7:                                        ; preds = %for.cond2
  %call = call zeroext i8 @add_u4(i8 noundef zeroext %a.0, i8 noundef zeroext %b.0)
  %conv8 = zext i8 %a.0 to i32
  %conv9 = zext i8 %b.0 to i32
  %add = add nsw i32 %conv8, %conv9
  %and = and i32 %add, 15
  %conv10 = trunc i32 %and to i8
  %conv11 = zext i8 %call to i32
  %conv12 = zext i8 %conv10 to i32
  %cmp13 = icmp ne i32 %conv11, %conv12
  br i1 %cmp13, label %if.then, label %if.end

if.then:                                          ; preds = %for.body7
  %0 = load ptr, ptr @stderr, align 8, !tbaa !11
  %conv15 = zext i8 %a.0 to i32
  %conv16 = zext i8 %b.0 to i32
  %call17 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %0, ptr noundef @.str.8, i32 noundef %conv15, i32 noundef %conv16)
  %1 = load ptr, ptr @stderr, align 8, !tbaa !11
  %conv18 = zext i8 %call to i32
  %call19 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %1, ptr noundef @.str.9, i32 noundef %conv18)
  %2 = load ptr, ptr @stderr, align 8, !tbaa !11
  %conv20 = zext i8 %call to i32
  %call21 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %2, ptr noundef @.str.10, i32 noundef %conv20)
  br label %cleanup

if.end:                                           ; preds = %for.body7
  br label %cleanup

cleanup:                                          ; preds = %if.end, %if.then
  %cleanup.dest.slot.0 = phi i32 [ 1, %if.then ], [ 0, %if.end ]
  %retval.2 = phi i1 [ false, %if.then ], [ %retval.1, %if.end ]
  switch i32 %cleanup.dest.slot.0, label %cleanup23 [
    i32 0, label %cleanup.cont
  ]

cleanup.cont:                                     ; preds = %cleanup
  br label %for.inc

for.inc:                                          ; preds = %cleanup.cont
  %inc = add i8 %b.0, 1
  br label %for.cond2, !llvm.loop !13

cleanup23:                                        ; preds = %cleanup, %for.cond.cleanup6
  %cleanup.dest.slot.1 = phi i32 [ %cleanup.dest.slot.0, %cleanup ], [ 5, %for.cond.cleanup6 ]
  %retval.3 = phi i1 [ %retval.2, %cleanup ], [ %retval.1, %for.cond.cleanup6 ]
  switch i32 %cleanup.dest.slot.1, label %cleanup27 [
    i32 5, label %for.end
  ]

for.end:                                          ; preds = %cleanup23
  br label %for.inc25

for.inc25:                                        ; preds = %for.end
  %inc26 = add i8 %a.0, 1
  br label %for.cond, !llvm.loop !16

cleanup27:                                        ; preds = %cleanup23, %for.cond.cleanup
  %cleanup.dest.slot.2 = phi i32 [ %cleanup.dest.slot.1, %cleanup23 ], [ 2, %for.cond.cleanup ]
  %retval.4 = phi i1 [ %retval.3, %cleanup23 ], [ %retval.0, %for.cond.cleanup ]
  switch i32 %cleanup.dest.slot.2, label %unreachable [
    i32 2, label %for.end29
    i32 1, label %return
  ]

for.end29:                                        ; preds = %cleanup27
  %3 = load ptr, ptr @stderr, align 8, !tbaa !11
  %call30 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %3, ptr noundef @.str.11)
  br label %return

return:                                           ; preds = %for.end29, %cleanup27
  %retval.5 = phi i1 [ %retval.4, %cleanup27 ], [ true, %for.end29 ]
  ret i1 %retval.5

unreachable:                                      ; preds = %cleanup27
  unreachable
}

declare i32 @fprintf(ptr noundef, ptr noundef, ...) #1

; Function Attrs: nounwind uwtable
define dso_local zeroext i1 @check_sub() #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc25, %entry
  %a.0 = phi i8 [ 0, %entry ], [ %inc26, %for.inc25 ]
  %retval.0 = phi i1 [ undef, %entry ], [ %retval.3, %for.inc25 ]
  %conv = zext i8 %a.0 to i32
  %cmp = icmp slt i32 %conv, 15
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %cleanup27

for.body:                                         ; preds = %for.cond
  br label %for.cond2

for.cond2:                                        ; preds = %for.inc, %for.body
  %b.0 = phi i8 [ 0, %for.body ], [ %inc, %for.inc ]
  %retval.1 = phi i1 [ %retval.0, %for.body ], [ %retval.2, %for.inc ]
  %conv3 = zext i8 %b.0 to i32
  %cmp4 = icmp slt i32 %conv3, 15
  br i1 %cmp4, label %for.body7, label %for.cond.cleanup6

for.cond.cleanup6:                                ; preds = %for.cond2
  br label %cleanup23

for.body7:                                        ; preds = %for.cond2
  %call = call zeroext i8 @sub_u4(i8 noundef zeroext %a.0, i8 noundef zeroext %b.0)
  %conv8 = zext i8 %a.0 to i32
  %conv9 = zext i8 %b.0 to i32
  %sub = sub nsw i32 %conv8, %conv9
  %and = and i32 %sub, 15
  %conv10 = trunc i32 %and to i8
  %conv11 = zext i8 %call to i32
  %conv12 = zext i8 %conv10 to i32
  %cmp13 = icmp ne i32 %conv11, %conv12
  br i1 %cmp13, label %if.then, label %if.end

if.then:                                          ; preds = %for.body7
  %0 = load ptr, ptr @stderr, align 8, !tbaa !11
  %conv15 = zext i8 %a.0 to i32
  %conv16 = zext i8 %b.0 to i32
  %call17 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %0, ptr noundef @.str.12, i32 noundef %conv15, i32 noundef %conv16)
  %1 = load ptr, ptr @stderr, align 8, !tbaa !11
  %conv18 = zext i8 %call to i32
  %call19 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %1, ptr noundef @.str.9, i32 noundef %conv18)
  %2 = load ptr, ptr @stderr, align 8, !tbaa !11
  %conv20 = zext i8 %conv10 to i32
  %call21 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %2, ptr noundef @.str.10, i32 noundef %conv20)
  br label %cleanup

if.end:                                           ; preds = %for.body7
  br label %cleanup

cleanup:                                          ; preds = %if.end, %if.then
  %cleanup.dest.slot.0 = phi i32 [ 1, %if.then ], [ 0, %if.end ]
  %retval.2 = phi i1 [ false, %if.then ], [ %retval.1, %if.end ]
  switch i32 %cleanup.dest.slot.0, label %cleanup23 [
    i32 0, label %cleanup.cont
  ]

cleanup.cont:                                     ; preds = %cleanup
  br label %for.inc

for.inc:                                          ; preds = %cleanup.cont
  %inc = add i8 %b.0, 1
  br label %for.cond2, !llvm.loop !17

cleanup23:                                        ; preds = %cleanup, %for.cond.cleanup6
  %cleanup.dest.slot.1 = phi i32 [ %cleanup.dest.slot.0, %cleanup ], [ 5, %for.cond.cleanup6 ]
  %retval.3 = phi i1 [ %retval.2, %cleanup ], [ %retval.1, %for.cond.cleanup6 ]
  switch i32 %cleanup.dest.slot.1, label %cleanup27 [
    i32 5, label %for.end
  ]

for.end:                                          ; preds = %cleanup23
  br label %for.inc25

for.inc25:                                        ; preds = %for.end
  %inc26 = add i8 %a.0, 1
  br label %for.cond, !llvm.loop !18

cleanup27:                                        ; preds = %cleanup23, %for.cond.cleanup
  %cleanup.dest.slot.2 = phi i32 [ %cleanup.dest.slot.1, %cleanup23 ], [ 2, %for.cond.cleanup ]
  %retval.4 = phi i1 [ %retval.3, %cleanup23 ], [ %retval.0, %for.cond.cleanup ]
  switch i32 %cleanup.dest.slot.2, label %unreachable [
    i32 2, label %for.end29
    i32 1, label %return
  ]

for.end29:                                        ; preds = %cleanup27
  %3 = load ptr, ptr @stderr, align 8, !tbaa !11
  %call30 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %3, ptr noundef @.str.13)
  br label %return

return:                                           ; preds = %for.end29, %cleanup27
  %retval.5 = phi i1 [ %retval.4, %cleanup27 ], [ true, %for.end29 ]
  ret i1 %retval.5

unreachable:                                      ; preds = %cleanup27
  unreachable
}

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 {
entry:
  %call = call zeroext i1 @check_add()
  %call1 = call zeroext i1 @check_sub()
  ret i32 0
}

; Function Attrs: nounwind uwtable
define internal zeroext i1 @and(i1 noundef zeroext %a, i1 noundef zeroext %b) #0 {
entry:
  %frombool = zext i1 %a to i8
  %frombool1 = zext i1 %b to i8
  %tobool = trunc i8 %frombool to i1
  %tobool2 = trunc i8 %frombool1 to i1
  %call = call zeroext i1 @nand(i1 noundef zeroext %tobool, i1 noundef zeroext %tobool2)
  %call3 = call zeroext i1 @not(i1 noundef zeroext %call)
  ret i1 %call3
}

; Function Attrs: nounwind uwtable
define internal zeroext i1 @or(i1 noundef zeroext %a, i1 noundef zeroext %b) #0 {
entry:
  %frombool = zext i1 %a to i8
  %frombool1 = zext i1 %b to i8
  %tobool = trunc i8 %frombool to i1
  %call = call zeroext i1 @not(i1 noundef zeroext %tobool)
  %tobool2 = trunc i8 %frombool1 to i1
  %call3 = call zeroext i1 @not(i1 noundef zeroext %tobool2)
  %call4 = call zeroext i1 @nand(i1 noundef zeroext %call, i1 noundef zeroext %call3)
  ret i1 %call4
}

; Function Attrs: nounwind uwtable
define internal zeroext i1 @xor(i1 noundef zeroext %a, i1 noundef zeroext %b) #0 {
entry:
  %frombool = zext i1 %a to i8
  %frombool1 = zext i1 %b to i8
  %tobool = trunc i8 %frombool to i1
  %tobool2 = trunc i8 %frombool1 to i1
  %call = call zeroext i1 @not(i1 noundef zeroext %tobool2)
  %call3 = call zeroext i1 @and(i1 noundef zeroext %tobool, i1 noundef zeroext %call)
  %tobool4 = trunc i8 %frombool to i1
  %call5 = call zeroext i1 @not(i1 noundef zeroext %tobool4)
  %tobool6 = trunc i8 %frombool1 to i1
  %call7 = call zeroext i1 @and(i1 noundef zeroext %call5, i1 noundef zeroext %tobool6)
  %call8 = call zeroext i1 @or(i1 noundef zeroext %call3, i1 noundef zeroext %call7)
  ret i1 %call8
}

; Function Attrs: nounwind uwtable
define internal zeroext i1 @not(i1 noundef zeroext %a) #0 {
entry:
  %frombool = zext i1 %a to i8
  %tobool = trunc i8 %frombool to i1
  %call = call zeroext i1 @nand(i1 noundef zeroext %tobool, i1 noundef zeroext true)
  ret i1 %call
}

; Function Attrs: nounwind uwtable
define internal zeroext i1 @nand(i1 noundef zeroext %a, i1 noundef zeroext %b) #0 {
entry:
  %frombool = zext i1 %a to i8
  %frombool1 = zext i1 %b to i8
  %tobool = trunc i8 %frombool to i1
  br i1 %tobool, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %entry
  %tobool2 = trunc i8 %frombool1 to i1
  br label %land.end

land.end:                                         ; preds = %land.rhs, %entry
  %0 = phi i1 [ false, %entry ], [ %tobool2, %land.rhs ]
  %lnot = xor i1 %0, true
  ret i1 %lnot
}

; Function Attrs: nounwind uwtable
define internal zeroext i1 @half_sub(i1 noundef zeroext %a, i1 noundef zeroext %b, ptr noundef %carry_result) #0 {
entry:
  %frombool = zext i1 %a to i8
  %frombool1 = zext i1 %b to i8
  %tobool = trunc i8 %frombool to i1
  %call = call zeroext i1 @not(i1 noundef zeroext %tobool)
  %tobool2 = trunc i8 %frombool1 to i1
  %call3 = call zeroext i1 @and(i1 noundef zeroext %call, i1 noundef zeroext %tobool2)
  %frombool4 = zext i1 %call3 to i8
  store i8 %frombool4, ptr %carry_result, align 1, !tbaa !5
  %tobool5 = trunc i8 %frombool to i1
  %tobool6 = trunc i8 %frombool1 to i1
  %call7 = call zeroext i1 @xor(i1 noundef zeroext %tobool5, i1 noundef zeroext %tobool6)
  ret i1 %call7
}

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 17.0.6 (22build1)"}
!5 = !{!6, !6, i64 0}
!6 = !{!"_Bool", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = !{i8 0, i8 2}
!10 = !{}
!11 = !{!12, !12, i64 0}
!12 = !{!"any pointer", !7, i64 0}
!13 = distinct !{!13, !14, !15}
!14 = !{!"llvm.loop.mustprogress"}
!15 = !{!"llvm.loop.unroll.disable"}
!16 = distinct !{!16, !14, !15}
!17 = distinct !{!17, !14, !15}
!18 = distinct !{!18, !14, !15}
