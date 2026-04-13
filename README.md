# &inator

#### Getting started

Assuming you have a C source file `test.c`:

```bash
mkdir -p benchmarks/test
cp test.c benchmarks/test/source.c
cargo run test
```

#### Dependencies

Needed packages (may be Ubuntu specific):

```
llvm-17-dev clang-17 libclang-17-dev libllvm17 pkg-config libpolly-17-dev libz3-dev zlib1g-dev libzstd-dev libssl-dev
```

Apparently needed exports (might be subsumed by `config.toml` below):

```
export LLVM_CONFIG_PATH=/usr/lib/llvm-17/bin/llvm-config
export LLVM_SYS_170_PREFIX=/usr/lib/llvm-17
export LIBCLANG_PATH=/usr/lib/llvm-17/lib
export Z3_SYS_USE_PKG_CONFIG=1
```

Optional:

```
export CC=clang-17
export CXX=clang++-17
```

Putting these in `$WORKSPACE_ROOT/.cargo/config.toml`, i.e.,

```
[env]
LLVM_CONFIG_PATH = "/usr/lib/llvm-17/bin/llvm-config"
LIBCLANG_PATH    = "/usr/lib/llvm-17/lib"
CC               = "clang-17"
CXX              = "clang++-17"
LLVM_SYS_170_PREFIX = "/usr/lib/llvm-17"
Z3_SYS_USE_PKG_CONFIG = "1"
```

helps both `cargo` and Rust Analyzer know where stuff is.

#### Benchmark Structure

Benchmarks are in the `benchmarks` directory. There is one subdirectory per benchmark. Before running a benchmark, it must have a `source.c` file. The benchmark runner will compile this to an LLVM-IR file `source.ll` and then &inate it. It will also create a `results` directory, where it will store per-run results. There is also a `summaries` directory, used for multi-trial runs (see the `--trials` flag below).

Note: For efficiency, the runner will assume that if `source.ll` exists in a benchmark folder, it is the result of compiling `source.c`. Hence, if `source.c` is modified, the old `source.ll` should be deleted, or it will continue to be used.

Each directory in `results` has the following files:

- `stypes.txt`: The inferred STypes of the program.
- `rtypes.txt`: The inferred RTypes of the program.
- `times-readable.txt`: How long it took the artifact took to do various tasks.
- `times.txt`: The same as `times-redable`, but in a machine-friendly format.
- `assertion-stats.txt`: A description of the number of constraints generated.
- `num-instructions.txt`: The number of instructions in the LLVM-IR source program.
- `signature-assignment.txt`: A mapping of TypeLabs to RTypes (without any lifetime data). This mapping is used for regression testing. If the benchmark runner outputs a `?`, you should verify that the RTypes are correct, and if they are, you should copy this file to `correct-type-assignments`.

To run a specific set of benchmarks, include the benchmark names space-separated as command-line arguments:

```bash
cargo run benchmark1 benchmark2 benchmark3
```

There are two optional flags:

- `--all, -a`: Runs all of the benchmarks.
- `--trials, -t <TRIALS>`: Repeats the specified benchmarks multiples times and creates an entry in the `summaries` directory, describing the average of the times of all of the trials. This will still store each individual benchmark run in `results`.

If you're using `cargo run`, you may have to add `--` after in order for the flags to be interpreted as arguments to the executable. For instance,

```bash
cargo run -- --trials 3 test
```
