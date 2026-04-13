#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <benchmark-name> [EXTRA_CLANG_ARGS]" >&2
    exit 1
fi

bench="$1"
shift

cd "benchmarks/$bench"

clang-17 \
    -fno-discard-value-names \
    -O \
    --target=aarch64-unknown-linux-gnu \
    -Xclang -disable-llvm-passes \
    -S -emit-llvm \
    "$@" \
    "source.c" \
    -o "source.ll"

opt-17 \
    -S \
    -p=mem2reg \
    "source.ll" \
    -o "source.ll"
