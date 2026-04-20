# &inator

## Getting Started

This implementation of &inator provides a command-line utility for running benchmarks.
This imlpementation is written in Rust, and uses the [z3](https://github.com/z3prover/z3) and [LLVM](https://llvm.org/) (version 17) native libraries.

The &inator command-line utility searches for benchmarks in the `benchmarks` directory under the current working directory.
To run &inator with the C source code file `benchmarks/running-example/source.c` (i.e., the benchmark named `running-example`) as input:
```sh
cargo run -r -- running-example
```

## Command-Line Usage

To run a specific set of benchmarks, run the command-line tool with a space-separated list of benchmark names as arguments (if using `cargo run`, put the arguments to the &inator command-line tool after the `--`):

```sh
cargo run -r -- <benchmarks>
```

The command-line utility takes the followng options.
- `--all, -a`: Runs all of the benchmarks.
- `--trials, -t <TRIALS>`: Repeats the specified benchmarks multiples times and creates an entry in the `summaries` directory, describing the average of the times of all of the trials. This will still store each individual benchmark run in `results`.

### Benchmark Structure

Each benchmark is a subdirectory in the `benchmarks` directory containing a C source code file named `source.c`.
To create your own benchmark, create a new directory under `benchmarks` containing a `source.c` file.
After running the benchmark runner on a benchmark, the benchmark's directory will contain other files and directories (e.g., `source.ll`, `results`, `summaries`).

The benchmark runner compiles `source.c` to LLVM IR (`source.ll`), runs &inator's analysis with `source.ll` as its input.
If `source.ll` is already present in a benchmark's directory, `source.ll` will be used as-is instead of compiling from `source.c`.

The benchmark runner writes its analysis results for each trial in the `results` directory, and writes performance results for multi-trial runs in the `summaries` directory.

The following directory structure is representative of a benchmark (named `my-benchmark`):
```
my-benchmark/
├── source.c                           # Input C source code
├── source.ll                          # Input LLVM IR, obtained by compiling
│                                      # source.c with LLVM.
│
├── results/                           # Analysis results for individual trials
│   │
│   ├── <timestamp-1>/                 # Analysis results from the trial at time
│   │                                  # <timestamp-1>
⁞   ⁞   /-- snip --/
│   ├── <timestamp-n>/
│   │   ├── assertion-stats.txt        # Breakdown of SMT assertions generated
│   │   │
│   │   ├── num-instructions.txt       # Number of instructions after conversion
│   │   │                              # to &inator's source language.
│   │   │
│   │   ├── rtypes.tex                 # Results of &inator's analysis, shown in
│   │   ├── rtypes.txt                 # &inator's source language with Rust
│   │   │                              # type fragments.
│   │   │
│   │   ├── stypes.tex                 # Conversion of source.ll to &inator's
│   │   ├── stypes.txt                 # source language     
│   │   │
│   │   ├── time-readable.txt          # Performance metrics (human-readable)
│   │   └── times.txt                  # Performance metrics (ns)
│   │
│   └── latest -> <timestamp-n>        # Symlink to most recent trial
│
└── summaries/                         # Analysis results for multi-trial runs
    │
    └── <timestamp>/                   # Performance results for the multi-trial
        │                              # run at time <timestamp>
        │
        ├── time-readable-<timestamp>.txt
        └── times-<timestamp>.txt
```

## Architecture Overview

This implementation includes a library with modules for
1. working with &inator's source language, including conversion from LLVM IR to &inator's source language (`src/{lang.rs, lang/*}`); 
2. static analyses on &inator's source language that are pertinent to &inator's constraint generation (`src/{analysis.rs, analysis/*}`);
3. generating &inator's constraint system from a program in &inator's source language (`src/{constraints.rs, constraints/*`);
4. working with &inator's analysis results, including extracting results from a Z3 model (`src/{results.rs, results/*}`); and
5. outputting &inator's analysis results in human-readable format (`src/{format.rs, format/*}`).

The `crate::constraints` module (`src/{constraints.rs, constraints/*}`) contains
1. definitions of the SMT datatypes, functions, and relations used (`src/constraints/{datatypes.rs, datatypes/*, functions.rs, functions/*, relations.rs, relations/*}`); and
2. a data structure containing SMT constructs and static analysis results used during constraint generation (`src/constraints/context.rs`).
3. procedures to generate each kind of constraint described in the paper (`src/constraints/{borrowing, consistency, lifetimes, loans, optimality, semantic}.rs`); and
4. a procedure to generate the entire constraint system from a program in &inator's source language (`ConstraintSystem::construct` in `src/constraints.rs`).

The benchmarking logic used in the command-line utility is in the `crate::benchmark` module (`src/benchmark.rs`).

### Library Usage Example

The following is a minimal example that uses the &inator library to analyze the LLVM IR file `source.ll`, and prints the results in human-readable format to `stdout`:
```rust
use refinator::{
    constraints::ConstraintSystem,
    format::program::{ProgramConsoleFormatter, ProgramWithRustTypes},
    lang::program::Program,
    results::{Results, rtype::RTypeFrag},
};

fn main() -> Result<(), String> {
    // Produce a llvm_ir::Module by reading `source.ll`
    let module = llvm_ir::Module::from_ir_path("source.ll")?;

    // Convert to &inator's source language
    let program = Program::construct(&module);

    // Construct &inator's constraint system.
    let constraints = ConstraintSystem::construct(&program);

    // Input the constraint system into a Z3 solver.
    let solver = z3::Optimize::new();

    for assertion in constraints.constraints.values().flatten() {
        solver.assert(assertion);
    }

    for objective in constraints
        .objectives
        .iter()
        .map(|(_, objective)| objective)
    {
        solver.minimize(objective);
    }

    // Solve the constraints using Z3.
    solver.check(&[]);

    // Extract results from the Z3 model.
    let results = Results::pull(
        &constraints,
        &solver.get_model().ok_or("Failed to retrieve model.")?,
    );

    // Print the results.
    ProgramConsoleFormatter::<RTypeFrag>::format(
        &ProgramWithRustTypes::new(program, results),
        &mut std::io::stdout(),
    )
    .map_err(|e| e.to_string())
}
```

## Limitations

This implementation does not support all LLVM or C features (more specifically, it does not support LLVM IR generated from C programs that use certain C features).
The following C features are unsupported:
- function pointers,
- polymorphic pointers (`void*` pointers that are cast into multiple other pointer types or struct pointers used as pointers to the first element of a struct at the LLVM IR level),
- `union` types,
- variadic functions,
- ternary operators.

Limitations of &inator that are not specific to this implementation (e.g., freedom from panics and memory leaks) are described in detail in the paper.

## Building from Source

### Docker

Use `docker build` to build &inator's Docker image:
```
$ docker build -t refinator .
```

### Native Builds

#### Installing dependencies

&inator requires Rust and a C/C++ compiler to build, and the Clang 17, LLVM 17 and Z3 system libraries.
Depending on your system, additional libraries might be necessary, and `cargo build` will fail when linking.

&inator transitively depends on the `llvm-sys` crate, which requires a compatible copy of `llvm-config`.
See the [`llvm-sys` documentation](https://crates.io/crates/llvm-sys#build-requirements) for workarounds.
Typically, setting the `LLVM_SYS_170_PREFIX` environment variable to the install prefix for a copy of LLVM 17 before building will work.

<details>
<summary>Linux (Debian/Ubuntu)</summary>

1. Install Rust and a C/C++ compiler:
    ```
    # apt install rustup clang
    $ rustup install stable
    ```
2. Install required libraries:
    ```
    # apt install -y llvm-17-dev clang-17 libclang-17-dev libllvm17 pkg-config \
          libpolly-17-dev libz3-dev zlib1g-dev libzstd-dev libssl-dev
    ```
</details>

<details>
<summary>Linux (Fedora/RHEL)</summary>

1. Install Rust and a C/C++ compiler:
    ```
    # dnf install -y rustup clang
    $ rustup-init -y
    ```
2. Install required libraries:
    ```
    # dnf install -y zlib-ng-compat zlib-ng-compat-devel clang17 clang17-devel \
          llvm17 llvm17-devel z3 z3-devel
    ```
</details>

#### Building

Build &inator using Cargo:
```
$ cargo build --release
```

## License

This software, exclusive of the datasets (`benchmarks`, `manual-translations`), is licensed under MIT license. See [LICENSE](LICENSE) for details.

The source code and manual translations for each benchmark (`benchmarks/*`, `manual-translations/*`), except for `running-example`, is adapted from [CRUST-Bench](https://github.com/anirudhkhatry/CRUST-bench) by [Anirudh Khatry](https://github.com/anirudhkhatry) et al., used under [GNU GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html). The source code and manual translations for each benchmark, except for `running-example`, is licensed under [GNU GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html).

