; ModuleID = 'benchmarks/rbtree/source.ll'
source_filename = "benchmarks/rbtree/source.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.node_t = type { i32, i32, ptr, ptr, ptr }
%struct.rbtree = type { ptr, ptr }

@RBTREE_RED = dso_local global i32 0, align 4
@RBTREE_BLACK = dso_local global i32 1, align 4

; Function Attrs: nounwind uwtable
define dso_local ptr @new_rbtree() #0 {
entry:
  %call = call ptr (...) @REFINATOR_MALLOC_rbtree()
  %call1 = call ptr (...) @REFINATOR_MALLOC_node_t()
  %0 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %color = getelementptr inbounds %struct.node_t, ptr %call1, i32 0, i32 0
  store i32 %0, ptr %color, align 8, !tbaa !9
  %nil = getelementptr inbounds %struct.rbtree, ptr %call, i32 0, i32 1
  store ptr %call1, ptr %nil, align 8, !tbaa !12
  %root = getelementptr inbounds %struct.rbtree, ptr %call, i32 0, i32 0
  store ptr %call1, ptr %root, align 8, !tbaa !14
  ret ptr %call
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

declare ptr @REFINATOR_MALLOC_rbtree(...) #2

declare ptr @REFINATOR_MALLOC_node_t(...) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local void @right_rotation(ptr noundef %tree, ptr noundef %x) #0 {
entry:
  %left = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 3
  %0 = load ptr, ptr %left, align 8, !tbaa !15
  %right = getelementptr inbounds %struct.node_t, ptr %0, i32 0, i32 4
  %1 = load ptr, ptr %right, align 8, !tbaa !16
  %left1 = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 3
  store ptr %1, ptr %left1, align 8, !tbaa !15
  %right2 = getelementptr inbounds %struct.node_t, ptr %0, i32 0, i32 4
  %2 = load ptr, ptr %right2, align 8, !tbaa !16
  %nil = getelementptr inbounds %struct.rbtree, ptr %tree, i32 0, i32 1
  %3 = load ptr, ptr %nil, align 8, !tbaa !12
  %cmp = icmp ne ptr %2, %3
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %right3 = getelementptr inbounds %struct.node_t, ptr %0, i32 0, i32 4
  %4 = load ptr, ptr %right3, align 8, !tbaa !16
  %parent = getelementptr inbounds %struct.node_t, ptr %4, i32 0, i32 2
  store ptr %x, ptr %parent, align 8, !tbaa !17
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %parent4 = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 2
  %5 = load ptr, ptr %parent4, align 8, !tbaa !17
  %parent5 = getelementptr inbounds %struct.node_t, ptr %0, i32 0, i32 2
  store ptr %5, ptr %parent5, align 8, !tbaa !17
  %parent6 = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 2
  %6 = load ptr, ptr %parent6, align 8, !tbaa !17
  %nil7 = getelementptr inbounds %struct.rbtree, ptr %tree, i32 0, i32 1
  %7 = load ptr, ptr %nil7, align 8, !tbaa !12
  %cmp8 = icmp eq ptr %6, %7
  br i1 %cmp8, label %if.then9, label %if.else

if.then9:                                         ; preds = %if.end
  %root = getelementptr inbounds %struct.rbtree, ptr %tree, i32 0, i32 0
  store ptr %0, ptr %root, align 8, !tbaa !14
  br label %if.end20

if.else:                                          ; preds = %if.end
  %parent10 = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 2
  %8 = load ptr, ptr %parent10, align 8, !tbaa !17
  %left11 = getelementptr inbounds %struct.node_t, ptr %8, i32 0, i32 3
  %9 = load ptr, ptr %left11, align 8, !tbaa !15
  %cmp12 = icmp eq ptr %x, %9
  br i1 %cmp12, label %if.then13, label %if.else16

if.then13:                                        ; preds = %if.else
  %parent14 = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 2
  %10 = load ptr, ptr %parent14, align 8, !tbaa !17
  %left15 = getelementptr inbounds %struct.node_t, ptr %10, i32 0, i32 3
  store ptr %0, ptr %left15, align 8, !tbaa !15
  br label %if.end19

if.else16:                                        ; preds = %if.else
  %parent17 = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 2
  %11 = load ptr, ptr %parent17, align 8, !tbaa !17
  %right18 = getelementptr inbounds %struct.node_t, ptr %11, i32 0, i32 4
  store ptr %0, ptr %right18, align 8, !tbaa !16
  br label %if.end19

if.end19:                                         ; preds = %if.else16, %if.then13
  br label %if.end20

if.end20:                                         ; preds = %if.end19, %if.then9
  %right21 = getelementptr inbounds %struct.node_t, ptr %0, i32 0, i32 4
  store ptr %x, ptr %right21, align 8, !tbaa !16
  %parent22 = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 2
  store ptr %0, ptr %parent22, align 8, !tbaa !17
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @left_rotation(ptr noundef %tree, ptr noundef %x) #0 {
entry:
  %right = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 4
  %0 = load ptr, ptr %right, align 8, !tbaa !16
  %left = getelementptr inbounds %struct.node_t, ptr %0, i32 0, i32 3
  %1 = load ptr, ptr %left, align 8, !tbaa !15
  %right1 = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 4
  store ptr %1, ptr %right1, align 8, !tbaa !16
  %left2 = getelementptr inbounds %struct.node_t, ptr %0, i32 0, i32 3
  %2 = load ptr, ptr %left2, align 8, !tbaa !15
  %nil = getelementptr inbounds %struct.rbtree, ptr %tree, i32 0, i32 1
  %3 = load ptr, ptr %nil, align 8, !tbaa !12
  %cmp = icmp ne ptr %2, %3
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %left3 = getelementptr inbounds %struct.node_t, ptr %0, i32 0, i32 3
  %4 = load ptr, ptr %left3, align 8, !tbaa !15
  %parent = getelementptr inbounds %struct.node_t, ptr %4, i32 0, i32 2
  store ptr %x, ptr %parent, align 8, !tbaa !17
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %parent4 = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 2
  %5 = load ptr, ptr %parent4, align 8, !tbaa !17
  %parent5 = getelementptr inbounds %struct.node_t, ptr %0, i32 0, i32 2
  store ptr %5, ptr %parent5, align 8, !tbaa !17
  %parent6 = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 2
  %6 = load ptr, ptr %parent6, align 8, !tbaa !17
  %nil7 = getelementptr inbounds %struct.rbtree, ptr %tree, i32 0, i32 1
  %7 = load ptr, ptr %nil7, align 8, !tbaa !12
  %cmp8 = icmp eq ptr %6, %7
  br i1 %cmp8, label %if.then9, label %if.else

if.then9:                                         ; preds = %if.end
  %root = getelementptr inbounds %struct.rbtree, ptr %tree, i32 0, i32 0
  store ptr %0, ptr %root, align 8, !tbaa !14
  br label %if.end20

if.else:                                          ; preds = %if.end
  %parent10 = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 2
  %8 = load ptr, ptr %parent10, align 8, !tbaa !17
  %left11 = getelementptr inbounds %struct.node_t, ptr %8, i32 0, i32 3
  %9 = load ptr, ptr %left11, align 8, !tbaa !15
  %cmp12 = icmp eq ptr %x, %9
  br i1 %cmp12, label %if.then13, label %if.else16

if.then13:                                        ; preds = %if.else
  %parent14 = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 2
  %10 = load ptr, ptr %parent14, align 8, !tbaa !17
  %left15 = getelementptr inbounds %struct.node_t, ptr %10, i32 0, i32 3
  store ptr %0, ptr %left15, align 8, !tbaa !15
  br label %if.end19

if.else16:                                        ; preds = %if.else
  %parent17 = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 2
  %11 = load ptr, ptr %parent17, align 8, !tbaa !17
  %right18 = getelementptr inbounds %struct.node_t, ptr %11, i32 0, i32 4
  store ptr %0, ptr %right18, align 8, !tbaa !16
  br label %if.end19

if.end19:                                         ; preds = %if.else16, %if.then13
  br label %if.end20

if.end20:                                         ; preds = %if.end19, %if.then9
  %left21 = getelementptr inbounds %struct.node_t, ptr %0, i32 0, i32 3
  store ptr %x, ptr %left21, align 8, !tbaa !15
  %parent22 = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 2
  store ptr %0, ptr %parent22, align 8, !tbaa !17
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @REFINATOR_FREE_node(ptr noundef %t, ptr noundef %x) #0 {
entry:
  %left = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 3
  %0 = load ptr, ptr %left, align 8, !tbaa !15
  %nil = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 1
  %1 = load ptr, ptr %nil, align 8, !tbaa !12
  %cmp = icmp ne ptr %0, %1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %left1 = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 3
  %2 = load ptr, ptr %left1, align 8, !tbaa !15
  call void @REFINATOR_FREE_node(ptr noundef %t, ptr noundef %2)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %right = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 4
  %3 = load ptr, ptr %right, align 8, !tbaa !16
  %nil2 = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 1
  %4 = load ptr, ptr %nil2, align 8, !tbaa !12
  %cmp3 = icmp ne ptr %3, %4
  br i1 %cmp3, label %if.then4, label %if.end6

if.then4:                                         ; preds = %if.end
  %right5 = getelementptr inbounds %struct.node_t, ptr %x, i32 0, i32 4
  %5 = load ptr, ptr %right5, align 8, !tbaa !16
  call void @REFINATOR_FREE_node(ptr noundef %t, ptr noundef %5)
  br label %if.end6

if.end6:                                          ; preds = %if.then4, %if.end
  %call = call i32 @REFINATOR_FREE_node_t(ptr noundef %x)
  ret void
}

declare i32 @REFINATOR_FREE_node_t(ptr noundef) #2

; Function Attrs: nounwind uwtable
define dso_local void @delete_rbtree(ptr noundef %t) #0 {
entry:
  %root = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 0
  %0 = load ptr, ptr %root, align 8, !tbaa !14
  %nil = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 1
  %1 = load ptr, ptr %nil, align 8, !tbaa !12
  %cmp = icmp ne ptr %0, %1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %root1 = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 0
  %2 = load ptr, ptr %root1, align 8, !tbaa !14
  call void @REFINATOR_FREE_node(ptr noundef %t, ptr noundef %2)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %nil2 = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 1
  %3 = load ptr, ptr %nil2, align 8, !tbaa !12
  %call = call i32 @REFINATOR_FREE_node_t(ptr noundef %3)
  %call3 = call i32 @REFINATOR_FREE_rbtree(ptr noundef %t)
  ret void
}

declare i32 @REFINATOR_FREE_rbtree(ptr noundef) #2

; Function Attrs: nounwind uwtable
define dso_local void @rbtree_insert_fixup(ptr noundef %t, ptr noundef %z) #0 {
entry:
  br label %while.cond

while.cond:                                       ; preds = %if.end61, %entry
  %z.addr.0 = phi ptr [ %z, %entry ], [ %z.addr.5, %if.end61 ]
  %parent = getelementptr inbounds %struct.node_t, ptr %z.addr.0, i32 0, i32 2
  %0 = load ptr, ptr %parent, align 8, !tbaa !17
  %color = getelementptr inbounds %struct.node_t, ptr %0, i32 0, i32 0
  %1 = load i32, ptr %color, align 8, !tbaa !9
  %2 = load i32, ptr @RBTREE_RED, align 4, !tbaa !5
  %cmp = icmp eq i32 %1, %2
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %parent1 = getelementptr inbounds %struct.node_t, ptr %z.addr.0, i32 0, i32 2
  %3 = load ptr, ptr %parent1, align 8, !tbaa !17
  %parent2 = getelementptr inbounds %struct.node_t, ptr %z.addr.0, i32 0, i32 2
  %4 = load ptr, ptr %parent2, align 8, !tbaa !17
  %parent3 = getelementptr inbounds %struct.node_t, ptr %4, i32 0, i32 2
  %5 = load ptr, ptr %parent3, align 8, !tbaa !17
  %left = getelementptr inbounds %struct.node_t, ptr %5, i32 0, i32 3
  %6 = load ptr, ptr %left, align 8, !tbaa !15
  %cmp4 = icmp eq ptr %3, %6
  br i1 %cmp4, label %if.then, label %if.else31

if.then:                                          ; preds = %while.body
  %parent5 = getelementptr inbounds %struct.node_t, ptr %z.addr.0, i32 0, i32 2
  %7 = load ptr, ptr %parent5, align 8, !tbaa !17
  %parent6 = getelementptr inbounds %struct.node_t, ptr %7, i32 0, i32 2
  %8 = load ptr, ptr %parent6, align 8, !tbaa !17
  %right = getelementptr inbounds %struct.node_t, ptr %8, i32 0, i32 4
  %9 = load ptr, ptr %right, align 8, !tbaa !16
  %color7 = getelementptr inbounds %struct.node_t, ptr %9, i32 0, i32 0
  %10 = load i32, ptr %color7, align 8, !tbaa !9
  %11 = load i32, ptr @RBTREE_RED, align 4, !tbaa !5
  %cmp8 = icmp eq i32 %10, %11
  br i1 %cmp8, label %if.then9, label %if.else

if.then9:                                         ; preds = %if.then
  %12 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %parent10 = getelementptr inbounds %struct.node_t, ptr %z.addr.0, i32 0, i32 2
  %13 = load ptr, ptr %parent10, align 8, !tbaa !17
  %color11 = getelementptr inbounds %struct.node_t, ptr %13, i32 0, i32 0
  store i32 %12, ptr %color11, align 8, !tbaa !9
  %14 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %color12 = getelementptr inbounds %struct.node_t, ptr %9, i32 0, i32 0
  store i32 %14, ptr %color12, align 8, !tbaa !9
  %15 = load i32, ptr @RBTREE_RED, align 4, !tbaa !5
  %parent13 = getelementptr inbounds %struct.node_t, ptr %z.addr.0, i32 0, i32 2
  %16 = load ptr, ptr %parent13, align 8, !tbaa !17
  %parent14 = getelementptr inbounds %struct.node_t, ptr %16, i32 0, i32 2
  %17 = load ptr, ptr %parent14, align 8, !tbaa !17
  %color15 = getelementptr inbounds %struct.node_t, ptr %17, i32 0, i32 0
  store i32 %15, ptr %color15, align 8, !tbaa !9
  %parent16 = getelementptr inbounds %struct.node_t, ptr %z.addr.0, i32 0, i32 2
  %18 = load ptr, ptr %parent16, align 8, !tbaa !17
  %parent17 = getelementptr inbounds %struct.node_t, ptr %18, i32 0, i32 2
  %19 = load ptr, ptr %parent17, align 8, !tbaa !17
  br label %if.end30

if.else:                                          ; preds = %if.then
  %parent18 = getelementptr inbounds %struct.node_t, ptr %z.addr.0, i32 0, i32 2
  %20 = load ptr, ptr %parent18, align 8, !tbaa !17
  %right19 = getelementptr inbounds %struct.node_t, ptr %20, i32 0, i32 4
  %21 = load ptr, ptr %right19, align 8, !tbaa !16
  %cmp20 = icmp eq ptr %z.addr.0, %21
  br i1 %cmp20, label %if.then21, label %if.end

if.then21:                                        ; preds = %if.else
  %parent22 = getelementptr inbounds %struct.node_t, ptr %z.addr.0, i32 0, i32 2
  %22 = load ptr, ptr %parent22, align 8, !tbaa !17
  call void @left_rotation(ptr noundef %t, ptr noundef %22)
  br label %if.end

if.end:                                           ; preds = %if.then21, %if.else
  %z.addr.1 = phi ptr [ %22, %if.then21 ], [ %z.addr.0, %if.else ]
  %23 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %parent23 = getelementptr inbounds %struct.node_t, ptr %z.addr.1, i32 0, i32 2
  %24 = load ptr, ptr %parent23, align 8, !tbaa !17
  %color24 = getelementptr inbounds %struct.node_t, ptr %24, i32 0, i32 0
  store i32 %23, ptr %color24, align 8, !tbaa !9
  %25 = load i32, ptr @RBTREE_RED, align 4, !tbaa !5
  %parent25 = getelementptr inbounds %struct.node_t, ptr %z.addr.1, i32 0, i32 2
  %26 = load ptr, ptr %parent25, align 8, !tbaa !17
  %parent26 = getelementptr inbounds %struct.node_t, ptr %26, i32 0, i32 2
  %27 = load ptr, ptr %parent26, align 8, !tbaa !17
  %color27 = getelementptr inbounds %struct.node_t, ptr %27, i32 0, i32 0
  store i32 %25, ptr %color27, align 8, !tbaa !9
  %parent28 = getelementptr inbounds %struct.node_t, ptr %z.addr.1, i32 0, i32 2
  %28 = load ptr, ptr %parent28, align 8, !tbaa !17
  %parent29 = getelementptr inbounds %struct.node_t, ptr %28, i32 0, i32 2
  %29 = load ptr, ptr %parent29, align 8, !tbaa !17
  call void @right_rotation(ptr noundef %t, ptr noundef %29)
  br label %if.end30

if.end30:                                         ; preds = %if.end, %if.then9
  %z.addr.2 = phi ptr [ %19, %if.then9 ], [ %z.addr.1, %if.end ]
  br label %if.end61

if.else31:                                        ; preds = %while.body
  %parent32 = getelementptr inbounds %struct.node_t, ptr %z.addr.0, i32 0, i32 2
  %30 = load ptr, ptr %parent32, align 8, !tbaa !17
  %parent33 = getelementptr inbounds %struct.node_t, ptr %30, i32 0, i32 2
  %31 = load ptr, ptr %parent33, align 8, !tbaa !17
  %left34 = getelementptr inbounds %struct.node_t, ptr %31, i32 0, i32 3
  %32 = load ptr, ptr %left34, align 8, !tbaa !15
  %color35 = getelementptr inbounds %struct.node_t, ptr %32, i32 0, i32 0
  %33 = load i32, ptr %color35, align 8, !tbaa !9
  %34 = load i32, ptr @RBTREE_RED, align 4, !tbaa !5
  %cmp36 = icmp eq i32 %33, %34
  br i1 %cmp36, label %if.then37, label %if.else46

if.then37:                                        ; preds = %if.else31
  %35 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %parent38 = getelementptr inbounds %struct.node_t, ptr %z.addr.0, i32 0, i32 2
  %36 = load ptr, ptr %parent38, align 8, !tbaa !17
  %color39 = getelementptr inbounds %struct.node_t, ptr %36, i32 0, i32 0
  store i32 %35, ptr %color39, align 8, !tbaa !9
  %37 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %color40 = getelementptr inbounds %struct.node_t, ptr %32, i32 0, i32 0
  store i32 %37, ptr %color40, align 8, !tbaa !9
  %38 = load i32, ptr @RBTREE_RED, align 4, !tbaa !5
  %parent41 = getelementptr inbounds %struct.node_t, ptr %z.addr.0, i32 0, i32 2
  %39 = load ptr, ptr %parent41, align 8, !tbaa !17
  %parent42 = getelementptr inbounds %struct.node_t, ptr %39, i32 0, i32 2
  %40 = load ptr, ptr %parent42, align 8, !tbaa !17
  %color43 = getelementptr inbounds %struct.node_t, ptr %40, i32 0, i32 0
  store i32 %38, ptr %color43, align 8, !tbaa !9
  %parent44 = getelementptr inbounds %struct.node_t, ptr %z.addr.0, i32 0, i32 2
  %41 = load ptr, ptr %parent44, align 8, !tbaa !17
  %parent45 = getelementptr inbounds %struct.node_t, ptr %41, i32 0, i32 2
  %42 = load ptr, ptr %parent45, align 8, !tbaa !17
  br label %if.end60

if.else46:                                        ; preds = %if.else31
  %parent47 = getelementptr inbounds %struct.node_t, ptr %z.addr.0, i32 0, i32 2
  %43 = load ptr, ptr %parent47, align 8, !tbaa !17
  %left48 = getelementptr inbounds %struct.node_t, ptr %43, i32 0, i32 3
  %44 = load ptr, ptr %left48, align 8, !tbaa !15
  %cmp49 = icmp eq ptr %z.addr.0, %44
  br i1 %cmp49, label %if.then50, label %if.end52

if.then50:                                        ; preds = %if.else46
  %parent51 = getelementptr inbounds %struct.node_t, ptr %z.addr.0, i32 0, i32 2
  %45 = load ptr, ptr %parent51, align 8, !tbaa !17
  call void @right_rotation(ptr noundef %t, ptr noundef %45)
  br label %if.end52

if.end52:                                         ; preds = %if.then50, %if.else46
  %z.addr.3 = phi ptr [ %45, %if.then50 ], [ %z.addr.0, %if.else46 ]
  %46 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %parent53 = getelementptr inbounds %struct.node_t, ptr %z.addr.3, i32 0, i32 2
  %47 = load ptr, ptr %parent53, align 8, !tbaa !17
  %color54 = getelementptr inbounds %struct.node_t, ptr %47, i32 0, i32 0
  store i32 %46, ptr %color54, align 8, !tbaa !9
  %48 = load i32, ptr @RBTREE_RED, align 4, !tbaa !5
  %parent55 = getelementptr inbounds %struct.node_t, ptr %z.addr.3, i32 0, i32 2
  %49 = load ptr, ptr %parent55, align 8, !tbaa !17
  %parent56 = getelementptr inbounds %struct.node_t, ptr %49, i32 0, i32 2
  %50 = load ptr, ptr %parent56, align 8, !tbaa !17
  %color57 = getelementptr inbounds %struct.node_t, ptr %50, i32 0, i32 0
  store i32 %48, ptr %color57, align 8, !tbaa !9
  %parent58 = getelementptr inbounds %struct.node_t, ptr %z.addr.3, i32 0, i32 2
  %51 = load ptr, ptr %parent58, align 8, !tbaa !17
  %parent59 = getelementptr inbounds %struct.node_t, ptr %51, i32 0, i32 2
  %52 = load ptr, ptr %parent59, align 8, !tbaa !17
  call void @left_rotation(ptr noundef %t, ptr noundef %52)
  br label %if.end60

if.end60:                                         ; preds = %if.end52, %if.then37
  %z.addr.4 = phi ptr [ %42, %if.then37 ], [ %z.addr.3, %if.end52 ]
  br label %if.end61

if.end61:                                         ; preds = %if.end60, %if.end30
  %z.addr.5 = phi ptr [ %z.addr.2, %if.end30 ], [ %z.addr.4, %if.end60 ]
  br label %while.cond, !llvm.loop !18

while.end:                                        ; preds = %while.cond
  %53 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %root = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 0
  %54 = load ptr, ptr %root, align 8, !tbaa !14
  %color62 = getelementptr inbounds %struct.node_t, ptr %54, i32 0, i32 0
  store i32 %53, ptr %color62, align 8, !tbaa !9
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local ptr @rbtree_insert(ptr noundef %t, i32 noundef %key) #0 {
entry:
  %nil = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 1
  %0 = load ptr, ptr %nil, align 8, !tbaa !12
  %root = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 0
  %1 = load ptr, ptr %root, align 8, !tbaa !14
  %call = call ptr (...) @REFINATOR_MALLOC_node_t()
  %key1 = getelementptr inbounds %struct.node_t, ptr %call, i32 0, i32 1
  store i32 %key, ptr %key1, align 4, !tbaa !21
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %y.0 = phi ptr [ %0, %entry ], [ %x.0, %if.end ]
  %x.0 = phi ptr [ %1, %entry ], [ %x.1, %if.end ]
  %nil2 = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 1
  %2 = load ptr, ptr %nil2, align 8, !tbaa !12
  %cmp = icmp ne ptr %x.0, %2
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %key3 = getelementptr inbounds %struct.node_t, ptr %call, i32 0, i32 1
  %3 = load i32, ptr %key3, align 4, !tbaa !21
  %key4 = getelementptr inbounds %struct.node_t, ptr %x.0, i32 0, i32 1
  %4 = load i32, ptr %key4, align 4, !tbaa !21
  %cmp5 = icmp slt i32 %3, %4
  br i1 %cmp5, label %if.then, label %if.else

if.then:                                          ; preds = %while.body
  %left = getelementptr inbounds %struct.node_t, ptr %x.0, i32 0, i32 3
  %5 = load ptr, ptr %left, align 8, !tbaa !15
  br label %if.end

if.else:                                          ; preds = %while.body
  %right = getelementptr inbounds %struct.node_t, ptr %x.0, i32 0, i32 4
  %6 = load ptr, ptr %right, align 8, !tbaa !16
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %x.1 = phi ptr [ %5, %if.then ], [ %6, %if.else ]
  br label %while.cond, !llvm.loop !22

while.end:                                        ; preds = %while.cond
  %parent = getelementptr inbounds %struct.node_t, ptr %call, i32 0, i32 2
  store ptr %y.0, ptr %parent, align 8, !tbaa !17
  %nil6 = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 1
  %7 = load ptr, ptr %nil6, align 8, !tbaa !12
  %cmp7 = icmp eq ptr %y.0, %7
  br i1 %cmp7, label %if.then8, label %if.else10

if.then8:                                         ; preds = %while.end
  %root9 = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 0
  store ptr %call, ptr %root9, align 8, !tbaa !14
  br label %if.end19

if.else10:                                        ; preds = %while.end
  %key11 = getelementptr inbounds %struct.node_t, ptr %call, i32 0, i32 1
  %8 = load i32, ptr %key11, align 4, !tbaa !21
  %key12 = getelementptr inbounds %struct.node_t, ptr %y.0, i32 0, i32 1
  %9 = load i32, ptr %key12, align 4, !tbaa !21
  %cmp13 = icmp slt i32 %8, %9
  br i1 %cmp13, label %if.then14, label %if.else16

if.then14:                                        ; preds = %if.else10
  %left15 = getelementptr inbounds %struct.node_t, ptr %y.0, i32 0, i32 3
  store ptr %call, ptr %left15, align 8, !tbaa !15
  br label %if.end18

if.else16:                                        ; preds = %if.else10
  %right17 = getelementptr inbounds %struct.node_t, ptr %y.0, i32 0, i32 4
  store ptr %call, ptr %right17, align 8, !tbaa !16
  br label %if.end18

if.end18:                                         ; preds = %if.else16, %if.then14
  br label %if.end19

if.end19:                                         ; preds = %if.end18, %if.then8
  %nil20 = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 1
  %10 = load ptr, ptr %nil20, align 8, !tbaa !12
  %left21 = getelementptr inbounds %struct.node_t, ptr %call, i32 0, i32 3
  store ptr %10, ptr %left21, align 8, !tbaa !15
  %nil22 = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 1
  %11 = load ptr, ptr %nil22, align 8, !tbaa !12
  %right23 = getelementptr inbounds %struct.node_t, ptr %call, i32 0, i32 4
  store ptr %11, ptr %right23, align 8, !tbaa !16
  %12 = load i32, ptr @RBTREE_RED, align 4, !tbaa !5
  %color = getelementptr inbounds %struct.node_t, ptr %call, i32 0, i32 0
  store i32 %12, ptr %color, align 8, !tbaa !9
  call void @rbtree_insert_fixup(ptr noundef %t, ptr noundef %call)
  ret ptr %call
}

; Function Attrs: nounwind uwtable
define dso_local ptr @rbtree_find(ptr noundef %t, i32 noundef %key) #0 {
entry:
  %root = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 0
  %0 = load ptr, ptr %root, align 8, !tbaa !14
  br label %while.cond

while.cond:                                       ; preds = %if.end6, %entry
  %current.0 = phi ptr [ %0, %entry ], [ %current.1, %if.end6 ]
  %nil = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 1
  %1 = load ptr, ptr %nil, align 8, !tbaa !12
  %cmp = icmp ne ptr %current.0, %1
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %key1 = getelementptr inbounds %struct.node_t, ptr %current.0, i32 0, i32 1
  %2 = load i32, ptr %key1, align 4, !tbaa !21
  %cmp2 = icmp eq i32 %2, %key
  br i1 %cmp2, label %if.then, label %if.end

if.then:                                          ; preds = %while.body
  br label %cleanup

if.end:                                           ; preds = %while.body
  %key3 = getelementptr inbounds %struct.node_t, ptr %current.0, i32 0, i32 1
  %3 = load i32, ptr %key3, align 4, !tbaa !21
  %cmp4 = icmp slt i32 %3, %key
  br i1 %cmp4, label %if.then5, label %if.else

if.then5:                                         ; preds = %if.end
  %right = getelementptr inbounds %struct.node_t, ptr %current.0, i32 0, i32 4
  %4 = load ptr, ptr %right, align 8, !tbaa !16
  br label %if.end6

if.else:                                          ; preds = %if.end
  %left = getelementptr inbounds %struct.node_t, ptr %current.0, i32 0, i32 3
  %5 = load ptr, ptr %left, align 8, !tbaa !15
  br label %if.end6

if.end6:                                          ; preds = %if.else, %if.then5
  %current.1 = phi ptr [ %4, %if.then5 ], [ %5, %if.else ]
  br label %while.cond, !llvm.loop !23

while.end:                                        ; preds = %while.cond
  br label %cleanup

cleanup:                                          ; preds = %while.end, %if.then
  %retval.0 = phi ptr [ %current.0, %if.then ], [ null, %while.end ]
  ret ptr %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local ptr @rbtree_min(ptr noundef %t) #0 {
entry:
  %root = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 0
  %0 = load ptr, ptr %root, align 8, !tbaa !14
  %nil = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 1
  %1 = load ptr, ptr %nil, align 8, !tbaa !12
  %cmp = icmp eq ptr %0, %1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %return

if.end:                                           ; preds = %entry
  %root1 = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 0
  %2 = load ptr, ptr %root1, align 8, !tbaa !14
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %curr.0 = phi ptr [ %2, %if.end ], [ %5, %while.body ]
  %left = getelementptr inbounds %struct.node_t, ptr %curr.0, i32 0, i32 3
  %3 = load ptr, ptr %left, align 8, !tbaa !15
  %nil2 = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 1
  %4 = load ptr, ptr %nil2, align 8, !tbaa !12
  %cmp3 = icmp ne ptr %3, %4
  br i1 %cmp3, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %left4 = getelementptr inbounds %struct.node_t, ptr %curr.0, i32 0, i32 3
  %5 = load ptr, ptr %left4, align 8, !tbaa !15
  br label %while.cond, !llvm.loop !24

while.end:                                        ; preds = %while.cond
  br label %return

return:                                           ; preds = %while.end, %if.then
  %retval.0 = phi ptr [ null, %if.then ], [ %curr.0, %while.end ]
  ret ptr %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local ptr @rbtree_max(ptr noundef %t) #0 {
entry:
  %root = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 0
  %0 = load ptr, ptr %root, align 8, !tbaa !14
  %nil = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 1
  %1 = load ptr, ptr %nil, align 8, !tbaa !12
  %cmp = icmp eq ptr %0, %1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %return

if.end:                                           ; preds = %entry
  %root1 = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 0
  %2 = load ptr, ptr %root1, align 8, !tbaa !14
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %curr.0 = phi ptr [ %2, %if.end ], [ %5, %while.body ]
  %right = getelementptr inbounds %struct.node_t, ptr %curr.0, i32 0, i32 4
  %3 = load ptr, ptr %right, align 8, !tbaa !16
  %nil2 = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 1
  %4 = load ptr, ptr %nil2, align 8, !tbaa !12
  %cmp3 = icmp ne ptr %3, %4
  br i1 %cmp3, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %right4 = getelementptr inbounds %struct.node_t, ptr %curr.0, i32 0, i32 4
  %5 = load ptr, ptr %right4, align 8, !tbaa !16
  br label %while.cond, !llvm.loop !25

while.end:                                        ; preds = %while.cond
  br label %return

return:                                           ; preds = %while.end, %if.then
  %retval.0 = phi ptr [ null, %if.then ], [ %curr.0, %while.end ]
  ret ptr %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local void @rbtree_transplant(ptr noundef %t, ptr noundef %u, ptr noundef %v) #0 {
entry:
  %parent = getelementptr inbounds %struct.node_t, ptr %u, i32 0, i32 2
  %0 = load ptr, ptr %parent, align 8, !tbaa !17
  %nil = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 1
  %1 = load ptr, ptr %nil, align 8, !tbaa !12
  %cmp = icmp eq ptr %0, %1
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %root = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 0
  store ptr %v, ptr %root, align 8, !tbaa !14
  br label %if.end8

if.else:                                          ; preds = %entry
  %parent1 = getelementptr inbounds %struct.node_t, ptr %u, i32 0, i32 2
  %2 = load ptr, ptr %parent1, align 8, !tbaa !17
  %left = getelementptr inbounds %struct.node_t, ptr %2, i32 0, i32 3
  %3 = load ptr, ptr %left, align 8, !tbaa !15
  %cmp2 = icmp eq ptr %u, %3
  br i1 %cmp2, label %if.then3, label %if.else6

if.then3:                                         ; preds = %if.else
  %parent4 = getelementptr inbounds %struct.node_t, ptr %u, i32 0, i32 2
  %4 = load ptr, ptr %parent4, align 8, !tbaa !17
  %left5 = getelementptr inbounds %struct.node_t, ptr %4, i32 0, i32 3
  store ptr %v, ptr %left5, align 8, !tbaa !15
  br label %if.end

if.else6:                                         ; preds = %if.else
  %parent7 = getelementptr inbounds %struct.node_t, ptr %u, i32 0, i32 2
  %5 = load ptr, ptr %parent7, align 8, !tbaa !17
  %right = getelementptr inbounds %struct.node_t, ptr %5, i32 0, i32 4
  store ptr %v, ptr %right, align 8, !tbaa !16
  br label %if.end

if.end:                                           ; preds = %if.else6, %if.then3
  br label %if.end8

if.end8:                                          ; preds = %if.end, %if.then
  %parent9 = getelementptr inbounds %struct.node_t, ptr %u, i32 0, i32 2
  %6 = load ptr, ptr %parent9, align 8, !tbaa !17
  %parent10 = getelementptr inbounds %struct.node_t, ptr %v, i32 0, i32 2
  store ptr %6, ptr %parent10, align 8, !tbaa !17
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @rbtree_delete_fixup(ptr noundef %t, ptr noundef %x) #0 {
entry:
  br label %while.cond

while.cond:                                       ; preds = %if.end87, %entry
  %x.addr.0 = phi ptr [ %x, %entry ], [ %x.addr.3, %if.end87 ]
  %root = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 0
  %0 = load ptr, ptr %root, align 8, !tbaa !14
  %cmp = icmp ne ptr %x.addr.0, %0
  br i1 %cmp, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %while.cond
  %color = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 0
  %1 = load i32, ptr %color, align 8, !tbaa !9
  %2 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %cmp1 = icmp eq i32 %1, %2
  br label %land.end

land.end:                                         ; preds = %land.rhs, %while.cond
  %3 = phi i1 [ false, %while.cond ], [ %cmp1, %land.rhs ]
  br i1 %3, label %while.body, label %while.end

while.body:                                       ; preds = %land.end
  %parent = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %4 = load ptr, ptr %parent, align 8, !tbaa !17
  %left = getelementptr inbounds %struct.node_t, ptr %4, i32 0, i32 3
  %5 = load ptr, ptr %left, align 8, !tbaa !15
  %cmp2 = icmp eq ptr %x.addr.0, %5
  br i1 %cmp2, label %if.then, label %if.else42

if.then:                                          ; preds = %while.body
  %parent3 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %6 = load ptr, ptr %parent3, align 8, !tbaa !17
  %right = getelementptr inbounds %struct.node_t, ptr %6, i32 0, i32 4
  %7 = load ptr, ptr %right, align 8, !tbaa !16
  %color4 = getelementptr inbounds %struct.node_t, ptr %7, i32 0, i32 0
  %8 = load i32, ptr %color4, align 8, !tbaa !9
  %9 = load i32, ptr @RBTREE_RED, align 4, !tbaa !5
  %cmp5 = icmp eq i32 %8, %9
  br i1 %cmp5, label %if.then6, label %if.end

if.then6:                                         ; preds = %if.then
  %10 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %color7 = getelementptr inbounds %struct.node_t, ptr %7, i32 0, i32 0
  store i32 %10, ptr %color7, align 8, !tbaa !9
  %11 = load i32, ptr @RBTREE_RED, align 4, !tbaa !5
  %parent8 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %12 = load ptr, ptr %parent8, align 8, !tbaa !17
  %color9 = getelementptr inbounds %struct.node_t, ptr %12, i32 0, i32 0
  store i32 %11, ptr %color9, align 8, !tbaa !9
  %parent10 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %13 = load ptr, ptr %parent10, align 8, !tbaa !17
  call void @left_rotation(ptr noundef %t, ptr noundef %13)
  %parent11 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %14 = load ptr, ptr %parent11, align 8, !tbaa !17
  %right12 = getelementptr inbounds %struct.node_t, ptr %14, i32 0, i32 4
  %15 = load ptr, ptr %right12, align 8, !tbaa !16
  br label %if.end

if.end:                                           ; preds = %if.then6, %if.then
  %w.0 = phi ptr [ %15, %if.then6 ], [ %7, %if.then ]
  %left13 = getelementptr inbounds %struct.node_t, ptr %w.0, i32 0, i32 3
  %16 = load ptr, ptr %left13, align 8, !tbaa !15
  %color14 = getelementptr inbounds %struct.node_t, ptr %16, i32 0, i32 0
  %17 = load i32, ptr %color14, align 8, !tbaa !9
  %18 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %cmp15 = icmp eq i32 %17, %18
  br i1 %cmp15, label %land.lhs.true, label %if.else

land.lhs.true:                                    ; preds = %if.end
  %right16 = getelementptr inbounds %struct.node_t, ptr %w.0, i32 0, i32 4
  %19 = load ptr, ptr %right16, align 8, !tbaa !16
  %color17 = getelementptr inbounds %struct.node_t, ptr %19, i32 0, i32 0
  %20 = load i32, ptr %color17, align 8, !tbaa !9
  %21 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %cmp18 = icmp eq i32 %20, %21
  br i1 %cmp18, label %if.then19, label %if.else

if.then19:                                        ; preds = %land.lhs.true
  %22 = load i32, ptr @RBTREE_RED, align 4, !tbaa !5
  %color20 = getelementptr inbounds %struct.node_t, ptr %w.0, i32 0, i32 0
  store i32 %22, ptr %color20, align 8, !tbaa !9
  %parent21 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %23 = load ptr, ptr %parent21, align 8, !tbaa !17
  br label %if.end41

if.else:                                          ; preds = %land.lhs.true, %if.end
  %right22 = getelementptr inbounds %struct.node_t, ptr %w.0, i32 0, i32 4
  %24 = load ptr, ptr %right22, align 8, !tbaa !16
  %color23 = getelementptr inbounds %struct.node_t, ptr %24, i32 0, i32 0
  %25 = load i32, ptr %color23, align 8, !tbaa !9
  %26 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %cmp24 = icmp eq i32 %25, %26
  br i1 %cmp24, label %if.then25, label %if.end31

if.then25:                                        ; preds = %if.else
  %27 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %left26 = getelementptr inbounds %struct.node_t, ptr %w.0, i32 0, i32 3
  %28 = load ptr, ptr %left26, align 8, !tbaa !15
  %color27 = getelementptr inbounds %struct.node_t, ptr %28, i32 0, i32 0
  store i32 %27, ptr %color27, align 8, !tbaa !9
  %29 = load i32, ptr @RBTREE_RED, align 4, !tbaa !5
  %color28 = getelementptr inbounds %struct.node_t, ptr %w.0, i32 0, i32 0
  store i32 %29, ptr %color28, align 8, !tbaa !9
  call void @right_rotation(ptr noundef %t, ptr noundef %w.0)
  %parent29 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %30 = load ptr, ptr %parent29, align 8, !tbaa !17
  %right30 = getelementptr inbounds %struct.node_t, ptr %30, i32 0, i32 4
  %31 = load ptr, ptr %right30, align 8, !tbaa !16
  br label %if.end31

if.end31:                                         ; preds = %if.then25, %if.else
  %w.1 = phi ptr [ %31, %if.then25 ], [ %w.0, %if.else ]
  %parent32 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %32 = load ptr, ptr %parent32, align 8, !tbaa !17
  %color33 = getelementptr inbounds %struct.node_t, ptr %32, i32 0, i32 0
  %33 = load i32, ptr %color33, align 8, !tbaa !9
  %color34 = getelementptr inbounds %struct.node_t, ptr %w.1, i32 0, i32 0
  store i32 %33, ptr %color34, align 8, !tbaa !9
  %34 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %parent35 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %35 = load ptr, ptr %parent35, align 8, !tbaa !17
  %color36 = getelementptr inbounds %struct.node_t, ptr %35, i32 0, i32 0
  store i32 %34, ptr %color36, align 8, !tbaa !9
  %36 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %right37 = getelementptr inbounds %struct.node_t, ptr %w.1, i32 0, i32 4
  %37 = load ptr, ptr %right37, align 8, !tbaa !16
  %color38 = getelementptr inbounds %struct.node_t, ptr %37, i32 0, i32 0
  store i32 %36, ptr %color38, align 8, !tbaa !9
  %parent39 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %38 = load ptr, ptr %parent39, align 8, !tbaa !17
  call void @left_rotation(ptr noundef %t, ptr noundef %38)
  %root40 = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 0
  %39 = load ptr, ptr %root40, align 8, !tbaa !14
  br label %if.end41

if.end41:                                         ; preds = %if.end31, %if.then19
  %x.addr.1 = phi ptr [ %23, %if.then19 ], [ %39, %if.end31 ]
  br label %if.end87

if.else42:                                        ; preds = %while.body
  %parent44 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %40 = load ptr, ptr %parent44, align 8, !tbaa !17
  %left45 = getelementptr inbounds %struct.node_t, ptr %40, i32 0, i32 3
  %41 = load ptr, ptr %left45, align 8, !tbaa !15
  %color46 = getelementptr inbounds %struct.node_t, ptr %41, i32 0, i32 0
  %42 = load i32, ptr %color46, align 8, !tbaa !9
  %43 = load i32, ptr @RBTREE_RED, align 4, !tbaa !5
  %cmp47 = icmp eq i32 %42, %43
  br i1 %cmp47, label %if.then48, label %if.end55

if.then48:                                        ; preds = %if.else42
  %44 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %color49 = getelementptr inbounds %struct.node_t, ptr %41, i32 0, i32 0
  store i32 %44, ptr %color49, align 8, !tbaa !9
  %45 = load i32, ptr @RBTREE_RED, align 4, !tbaa !5
  %parent50 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %46 = load ptr, ptr %parent50, align 8, !tbaa !17
  %color51 = getelementptr inbounds %struct.node_t, ptr %46, i32 0, i32 0
  store i32 %45, ptr %color51, align 8, !tbaa !9
  %parent52 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %47 = load ptr, ptr %parent52, align 8, !tbaa !17
  call void @right_rotation(ptr noundef %t, ptr noundef %47)
  %parent53 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %48 = load ptr, ptr %parent53, align 8, !tbaa !17
  %left54 = getelementptr inbounds %struct.node_t, ptr %48, i32 0, i32 3
  %49 = load ptr, ptr %left54, align 8, !tbaa !15
  br label %if.end55

if.end55:                                         ; preds = %if.then48, %if.else42
  %w43.0 = phi ptr [ %49, %if.then48 ], [ %41, %if.else42 ]
  %right56 = getelementptr inbounds %struct.node_t, ptr %w43.0, i32 0, i32 4
  %50 = load ptr, ptr %right56, align 8, !tbaa !16
  %color57 = getelementptr inbounds %struct.node_t, ptr %50, i32 0, i32 0
  %51 = load i32, ptr %color57, align 8, !tbaa !9
  %52 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %cmp58 = icmp eq i32 %51, %52
  br i1 %cmp58, label %land.lhs.true59, label %if.else66

land.lhs.true59:                                  ; preds = %if.end55
  %left60 = getelementptr inbounds %struct.node_t, ptr %w43.0, i32 0, i32 3
  %53 = load ptr, ptr %left60, align 8, !tbaa !15
  %color61 = getelementptr inbounds %struct.node_t, ptr %53, i32 0, i32 0
  %54 = load i32, ptr %color61, align 8, !tbaa !9
  %55 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %cmp62 = icmp eq i32 %54, %55
  br i1 %cmp62, label %if.then63, label %if.else66

if.then63:                                        ; preds = %land.lhs.true59
  %56 = load i32, ptr @RBTREE_RED, align 4, !tbaa !5
  %color64 = getelementptr inbounds %struct.node_t, ptr %w43.0, i32 0, i32 0
  store i32 %56, ptr %color64, align 8, !tbaa !9
  %parent65 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %57 = load ptr, ptr %parent65, align 8, !tbaa !17
  br label %if.end86

if.else66:                                        ; preds = %land.lhs.true59, %if.end55
  %left67 = getelementptr inbounds %struct.node_t, ptr %w43.0, i32 0, i32 3
  %58 = load ptr, ptr %left67, align 8, !tbaa !15
  %color68 = getelementptr inbounds %struct.node_t, ptr %58, i32 0, i32 0
  %59 = load i32, ptr %color68, align 8, !tbaa !9
  %60 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %cmp69 = icmp eq i32 %59, %60
  br i1 %cmp69, label %if.then70, label %if.end76

if.then70:                                        ; preds = %if.else66
  %61 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %right71 = getelementptr inbounds %struct.node_t, ptr %w43.0, i32 0, i32 4
  %62 = load ptr, ptr %right71, align 8, !tbaa !16
  %color72 = getelementptr inbounds %struct.node_t, ptr %62, i32 0, i32 0
  store i32 %61, ptr %color72, align 8, !tbaa !9
  %63 = load i32, ptr @RBTREE_RED, align 4, !tbaa !5
  %color73 = getelementptr inbounds %struct.node_t, ptr %w43.0, i32 0, i32 0
  store i32 %63, ptr %color73, align 8, !tbaa !9
  call void @left_rotation(ptr noundef %t, ptr noundef %w43.0)
  %parent74 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %64 = load ptr, ptr %parent74, align 8, !tbaa !17
  %left75 = getelementptr inbounds %struct.node_t, ptr %64, i32 0, i32 3
  %65 = load ptr, ptr %left75, align 8, !tbaa !15
  br label %if.end76

if.end76:                                         ; preds = %if.then70, %if.else66
  %w43.1 = phi ptr [ %65, %if.then70 ], [ %w43.0, %if.else66 ]
  %parent77 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %66 = load ptr, ptr %parent77, align 8, !tbaa !17
  %color78 = getelementptr inbounds %struct.node_t, ptr %66, i32 0, i32 0
  %67 = load i32, ptr %color78, align 8, !tbaa !9
  %color79 = getelementptr inbounds %struct.node_t, ptr %w43.1, i32 0, i32 0
  store i32 %67, ptr %color79, align 8, !tbaa !9
  %68 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %parent80 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %69 = load ptr, ptr %parent80, align 8, !tbaa !17
  %color81 = getelementptr inbounds %struct.node_t, ptr %69, i32 0, i32 0
  store i32 %68, ptr %color81, align 8, !tbaa !9
  %70 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %left82 = getelementptr inbounds %struct.node_t, ptr %w43.1, i32 0, i32 3
  %71 = load ptr, ptr %left82, align 8, !tbaa !15
  %color83 = getelementptr inbounds %struct.node_t, ptr %71, i32 0, i32 0
  store i32 %70, ptr %color83, align 8, !tbaa !9
  %parent84 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 2
  %72 = load ptr, ptr %parent84, align 8, !tbaa !17
  call void @right_rotation(ptr noundef %t, ptr noundef %72)
  %root85 = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 0
  %73 = load ptr, ptr %root85, align 8, !tbaa !14
  br label %if.end86

if.end86:                                         ; preds = %if.end76, %if.then63
  %x.addr.2 = phi ptr [ %57, %if.then63 ], [ %73, %if.end76 ]
  br label %if.end87

if.end87:                                         ; preds = %if.end86, %if.end41
  %x.addr.3 = phi ptr [ %x.addr.1, %if.end41 ], [ %x.addr.2, %if.end86 ]
  br label %while.cond, !llvm.loop !26

while.end:                                        ; preds = %land.end
  %74 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %color88 = getelementptr inbounds %struct.node_t, ptr %x.addr.0, i32 0, i32 0
  store i32 %74, ptr %color88, align 8, !tbaa !9
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local i32 @rbtree_erase(ptr noundef %t, ptr noundef %p) #0 {
entry:
  %color = getelementptr inbounds %struct.node_t, ptr %p, i32 0, i32 0
  %0 = load i32, ptr %color, align 8, !tbaa !9
  %left = getelementptr inbounds %struct.node_t, ptr %p, i32 0, i32 3
  %1 = load ptr, ptr %left, align 8, !tbaa !15
  %nil = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 1
  %2 = load ptr, ptr %nil, align 8, !tbaa !12
  %cmp = icmp eq ptr %1, %2
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %right = getelementptr inbounds %struct.node_t, ptr %p, i32 0, i32 4
  %3 = load ptr, ptr %right, align 8, !tbaa !16
  %right1 = getelementptr inbounds %struct.node_t, ptr %p, i32 0, i32 4
  %4 = load ptr, ptr %right1, align 8, !tbaa !16
  call void @rbtree_transplant(ptr noundef %t, ptr noundef %p, ptr noundef %4)
  br label %if.end32

if.else:                                          ; preds = %entry
  %right2 = getelementptr inbounds %struct.node_t, ptr %p, i32 0, i32 4
  %5 = load ptr, ptr %right2, align 8, !tbaa !16
  %nil3 = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 1
  %6 = load ptr, ptr %nil3, align 8, !tbaa !12
  %cmp4 = icmp eq ptr %5, %6
  br i1 %cmp4, label %if.then5, label %if.else8

if.then5:                                         ; preds = %if.else
  %left6 = getelementptr inbounds %struct.node_t, ptr %p, i32 0, i32 3
  %7 = load ptr, ptr %left6, align 8, !tbaa !15
  %left7 = getelementptr inbounds %struct.node_t, ptr %p, i32 0, i32 3
  %8 = load ptr, ptr %left7, align 8, !tbaa !15
  call void @rbtree_transplant(ptr noundef %t, ptr noundef %p, ptr noundef %8)
  br label %if.end31

if.else8:                                         ; preds = %if.else
  %right9 = getelementptr inbounds %struct.node_t, ptr %p, i32 0, i32 4
  %9 = load ptr, ptr %right9, align 8, !tbaa !16
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.else8
  %y.0 = phi ptr [ %9, %if.else8 ], [ %12, %while.body ]
  %left10 = getelementptr inbounds %struct.node_t, ptr %y.0, i32 0, i32 3
  %10 = load ptr, ptr %left10, align 8, !tbaa !15
  %nil11 = getelementptr inbounds %struct.rbtree, ptr %t, i32 0, i32 1
  %11 = load ptr, ptr %nil11, align 8, !tbaa !12
  %cmp12 = icmp ne ptr %10, %11
  br i1 %cmp12, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %left13 = getelementptr inbounds %struct.node_t, ptr %y.0, i32 0, i32 3
  %12 = load ptr, ptr %left13, align 8, !tbaa !15
  br label %while.cond, !llvm.loop !27

while.end:                                        ; preds = %while.cond
  %color14 = getelementptr inbounds %struct.node_t, ptr %y.0, i32 0, i32 0
  %13 = load i32, ptr %color14, align 8, !tbaa !9
  %right15 = getelementptr inbounds %struct.node_t, ptr %y.0, i32 0, i32 4
  %14 = load ptr, ptr %right15, align 8, !tbaa !16
  %parent = getelementptr inbounds %struct.node_t, ptr %y.0, i32 0, i32 2
  %15 = load ptr, ptr %parent, align 8, !tbaa !17
  %cmp16 = icmp eq ptr %15, %p
  br i1 %cmp16, label %if.then17, label %if.else19

if.then17:                                        ; preds = %while.end
  %parent18 = getelementptr inbounds %struct.node_t, ptr %14, i32 0, i32 2
  store ptr %y.0, ptr %parent18, align 8, !tbaa !17
  br label %if.end

if.else19:                                        ; preds = %while.end
  %right20 = getelementptr inbounds %struct.node_t, ptr %y.0, i32 0, i32 4
  %16 = load ptr, ptr %right20, align 8, !tbaa !16
  call void @rbtree_transplant(ptr noundef %t, ptr noundef %y.0, ptr noundef %16)
  %right21 = getelementptr inbounds %struct.node_t, ptr %p, i32 0, i32 4
  %17 = load ptr, ptr %right21, align 8, !tbaa !16
  %right22 = getelementptr inbounds %struct.node_t, ptr %y.0, i32 0, i32 4
  store ptr %17, ptr %right22, align 8, !tbaa !16
  %right23 = getelementptr inbounds %struct.node_t, ptr %y.0, i32 0, i32 4
  %18 = load ptr, ptr %right23, align 8, !tbaa !16
  %parent24 = getelementptr inbounds %struct.node_t, ptr %18, i32 0, i32 2
  store ptr %y.0, ptr %parent24, align 8, !tbaa !17
  br label %if.end

if.end:                                           ; preds = %if.else19, %if.then17
  call void @rbtree_transplant(ptr noundef %t, ptr noundef %p, ptr noundef %y.0)
  %left25 = getelementptr inbounds %struct.node_t, ptr %p, i32 0, i32 3
  %19 = load ptr, ptr %left25, align 8, !tbaa !15
  %left26 = getelementptr inbounds %struct.node_t, ptr %y.0, i32 0, i32 3
  store ptr %19, ptr %left26, align 8, !tbaa !15
  %left27 = getelementptr inbounds %struct.node_t, ptr %y.0, i32 0, i32 3
  %20 = load ptr, ptr %left27, align 8, !tbaa !15
  %parent28 = getelementptr inbounds %struct.node_t, ptr %20, i32 0, i32 2
  store ptr %y.0, ptr %parent28, align 8, !tbaa !17
  %color29 = getelementptr inbounds %struct.node_t, ptr %p, i32 0, i32 0
  %21 = load i32, ptr %color29, align 8, !tbaa !9
  %color30 = getelementptr inbounds %struct.node_t, ptr %y.0, i32 0, i32 0
  store i32 %21, ptr %color30, align 8, !tbaa !9
  br label %if.end31

if.end31:                                         ; preds = %if.end, %if.then5
  %x.0 = phi ptr [ %7, %if.then5 ], [ %14, %if.end ]
  %yOriginalColor.0 = phi i32 [ %0, %if.then5 ], [ %13, %if.end ]
  br label %if.end32

if.end32:                                         ; preds = %if.end31, %if.then
  %x.1 = phi ptr [ %3, %if.then ], [ %x.0, %if.end31 ]
  %yOriginalColor.1 = phi i32 [ %0, %if.then ], [ %yOriginalColor.0, %if.end31 ]
  %22 = load i32, ptr @RBTREE_BLACK, align 4, !tbaa !5
  %cmp33 = icmp eq i32 %yOriginalColor.1, %22
  br i1 %cmp33, label %if.then34, label %if.end35

if.then34:                                        ; preds = %if.end32
  call void @rbtree_delete_fixup(ptr noundef %t, ptr noundef %x.1)
  br label %if.end35

if.end35:                                         ; preds = %if.then34, %if.end32
  %call = call i32 @REFINATOR_FREE_node_t(ptr noundef %p)
  ret i32 0
}

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 17.0.6 (22build1)"}
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = !{!10, !6, i64 0}
!10 = !{!"node_t", !6, i64 0, !6, i64 4, !11, i64 8, !11, i64 16, !11, i64 24}
!11 = !{!"any pointer", !7, i64 0}
!12 = !{!13, !11, i64 8}
!13 = !{!"", !11, i64 0, !11, i64 8}
!14 = !{!13, !11, i64 0}
!15 = !{!10, !11, i64 16}
!16 = !{!10, !11, i64 24}
!17 = !{!10, !11, i64 8}
!18 = distinct !{!18, !19, !20}
!19 = !{!"llvm.loop.mustprogress"}
!20 = !{!"llvm.loop.unroll.disable"}
!21 = !{!10, !6, i64 4}
!22 = distinct !{!22, !19, !20}
!23 = distinct !{!23, !19, !20}
!24 = distinct !{!24, !19, !20}
!25 = distinct !{!25, !19, !20}
!26 = distinct !{!26, !19, !20}
!27 = distinct !{!27, !19, !20}
