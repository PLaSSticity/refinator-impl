; ModuleID = 'benchmarks/running-example/source.ll'
source_filename = "benchmarks/running-example/source.c"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-redhat-linux-gnu"

%struct.node_t = type { i32, ptr }

; Function Attrs: nounwind uwtable
define dso_local ptr @new() #0 {
entry:
  %call = call noalias ptr @malloc(i64 noundef 16) #3
  %next = getelementptr inbounds %struct.node_t, ptr %call, i32 0, i32 1
  store ptr null, ptr %next, align 8, !tbaa !4
  ret ptr %call
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nounwind allocsize(0)
declare dso_local noalias ptr @malloc(i64 noundef) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local void @push(ptr noundef %list, i32 noundef %x) #0 {
entry:
  %call = call noalias ptr @malloc(i64 noundef 16) #3
  %data = getelementptr inbounds %struct.node_t, ptr %call, i32 0, i32 0
  store i32 %x, ptr %data, align 8, !tbaa !10
  %next = getelementptr inbounds %struct.node_t, ptr %list, i32 0, i32 1
  %0 = load ptr, ptr %next, align 8, !tbaa !4
  %next1 = getelementptr inbounds %struct.node_t, ptr %call, i32 0, i32 1
  store ptr %0, ptr %next1, align 8, !tbaa !4
  %next2 = getelementptr inbounds %struct.node_t, ptr %list, i32 0, i32 1
  store ptr %call, ptr %next2, align 8, !tbaa !4
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @replace(ptr noundef %dst, i32 noundef %x) #0 {
entry:
  store i32 %x, ptr %dst, align 4, !tbaa !11
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @replace_first(ptr noundef %list, i32 noundef %x) #0 {
entry:
  %next = getelementptr inbounds %struct.node_t, ptr %list, i32 0, i32 1
  %0 = load ptr, ptr %next, align 8, !tbaa !4
  %data = getelementptr inbounds %struct.node_t, ptr %0, i32 0, i32 0
  call void @replace(ptr noundef %data, i32 noundef %x)
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local i32 @first(ptr noundef %list) #0 {
entry:
  %next = getelementptr inbounds %struct.node_t, ptr %list, i32 0, i32 1
  %0 = load ptr, ptr %next, align 8, !tbaa !4
  %data = getelementptr inbounds %struct.node_t, ptr %0, i32 0, i32 0
  %1 = load i32, ptr %data, align 8, !tbaa !10
  ret i32 %1
}

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 {
entry:
  %call = call ptr @new()
  call void @push(ptr noundef %call, i32 noundef 1)
  %next = getelementptr inbounds %struct.node_t, ptr %call, i32 0, i32 1
  %0 = load ptr, ptr %next, align 8, !tbaa !4
  call void @push(ptr noundef %0, i32 noundef 2)
  call void @replace_first(ptr noundef %call, i32 noundef 3)
  call void @replace_first(ptr noundef %0, i32 noundef 4)
  ret i32 0
}

attributes #0 = { nounwind uwtable "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nounwind allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #3 = { nounwind allocsize(0) }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 2}
!2 = !{i32 7, !"frame-pointer", i32 1}
!3 = !{!"clang version 17.0.6 (Fedora 17.0.6-9.fc42)"}
!4 = !{!5, !9, i64 8}
!5 = !{!"node_t", !6, i64 0, !9, i64 8}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = !{!"any pointer", !7, i64 0}
!10 = !{!5, !6, i64 0}
!11 = !{!6, !6, i64 0}
