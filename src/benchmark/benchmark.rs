use crate::format::program::{ProgramConsoleFormatter, ProgramTexFormatter};
use crate::lang::program::Program;
use crate::lang::stype::{STypeFrag, TypeLab};
use crate::results::Results;
use crate::results::rtype::RTypeFrag;
use crate::{constraints::ConstraintSystem, format::program::ProgramWithRustTypes};
use chrono::prelude::*;
use console::style;
use humantime::format_duration;
use indicatif::{ProgressBar, ProgressStyle};
use llvm_ir::Module;
use std::os;
use std::{
    collections::HashMap,
    fs::{self, File},
    io::Write,
    path::{Path, PathBuf},
    process::Command,
    time::{Duration, Instant},
};
use z3::{Optimize, SatResult};

pub fn run_benchmarks(paths: Vec<PathBuf>, trials: i32) -> Result<(), String> {
    let mut benchmark_results: HashMap<String, Vec<BenchmarkData>> = HashMap::new();
    for benchmark in paths {
        println!("Running benchmark {:?}...", benchmark);
        let mut results: Vec<BenchmarkData> = vec![];
        for t in 0..trials {
            println!("Trial {} of {}:", t + 1, trials);
            let result = run_benchmark(&benchmark)?;
            results.push(result);
        }
        if trials > 1 {
            store_summary(&benchmark, &results);
        }
        benchmark_results.insert(format!("{:?}", benchmark), results);
    }
    println!("{}", style("Summary").bold().underlined());
    for name in benchmark_results.keys() {
        let results = benchmark_results.get(name).unwrap();
        let statuses = results
            .iter()
            .map(|r| match r.status {
                BenchmarkStatus::Correct => style("✓").green().bold().to_string(),
                BenchmarkStatus::Unsure => style("?").yellow().bold().to_string(),
            })
            .collect::<Vec<String>>()
            .join(", ");
        println!("({}) {}", statuses, name);
    }
    Ok(())
}

pub fn run_all_benchmarks(trials: i32) -> Result<(), String> {
    match fs::read_dir("benchmarks") {
        Ok(benchmarks) => run_benchmarks(benchmarks.map(|b| b.unwrap().path()).collect(), trials),
        Err(_) => Err("The 'benchmarks' folder doesn't exist.".to_string()),
    }
}

fn run_benchmark(path: &Path) -> Result<BenchmarkData, String> {
    let source_path = path.join("source.c");

    if !fs::exists(&source_path).unwrap() {
        return Err(
            format!("The file '{:?}' is missing in '{:?}'.", source_path, &path).to_string(),
        );
    }

    let date_string = Utc::now().to_string();

    let all_results_path = path.join("results");

    let results_path = all_results_path.join(&date_string);
    fs::create_dir_all(&results_path).unwrap();

    let latest_results_path = all_results_path.join("latest");
    if latest_results_path.is_symlink() {
        fs::remove_dir_all(&latest_results_path).unwrap();
    }
    os::unix::fs::symlink(Path::new(&date_string), &latest_results_path).unwrap();

    let ir_path = path.join("source.ll");

    if !fs::exists(&ir_path).unwrap() {
        let command = format!(
            "clang-17 -fno-discard-value-names -O --target=aarch64-unknown-linux-gnu -Xclang -disable-llvm-passes -S -emit-llvm {} -o {}",
            source_path.into_os_string().into_string().unwrap(),
            ir_path.clone().into_os_string().into_string().unwrap(),
        );

        Command::new("sh").arg("-c").arg(command).output().unwrap();

        let command = format!(
            "opt-17 -S -p=mem2reg {} -o {}",
            ir_path.clone().into_os_string().into_string().unwrap(),
            ir_path.clone().into_os_string().into_string().unwrap(),
        );

        Command::new("sh").arg("-c").arg(command).output().unwrap();
    }

    let m: Module = Module::from_ir_path(ir_path)?;

    let (program, representation_time) =
        with_spinner("constructing program representation", || {
            Program::construct(&m)
        });

    // For debugging.
    // for var in program.locals() {
    //     eprintln!("v{} [shape=box, label=\"var {}::{}\"]", var.id, var.function, var.name);
    // }
    // for var in program.globals() {
    //     eprintln!("v{} [shape=box, label=\"var {}\"]", var.id, var.name);
    // }

    let mut stypes = File::create(results_path.join("stypes.txt")).unwrap();
    ProgramConsoleFormatter::<STypeFrag>::format(&program, &mut stypes).unwrap();

    let mut stypes = File::create(results_path.join("stypes.tex")).unwrap();
    ProgramTexFormatter::<STypeFrag>::format(&program, &mut stypes).unwrap();

    let mut instructions_file = File::create(results_path.join("num-instructions.txt")).unwrap();
    writeln!(instructions_file, "Num instructions: {}", program.num_instrs()).unwrap();
    writeln!(instructions_file, "Num interface vars: {}", program.signature_outer_typelabs().len()).unwrap();
    writeln!(instructions_file, "Num typelabs: {}", program.typelabs().len()).unwrap();

    let (constraints, constraints_time) = with_spinner("generating constraints", || {
        ConstraintSystem::construct(&program)
    });

    let mut assertions_file = File::create(results_path.join("assertion-stats.txt")).unwrap();
    let solver = create_solver(&constraints, &mut assertions_file);

    let (sat_result, solve_time) = with_spinner("solving constraints", || solver.check(&[]));

    let mut time_file_readable = File::create(results_path.join("time-readable.txt")).unwrap();

    let mut time_file = File::create(results_path.join("times.txt")).unwrap();

    writeln!(
        time_file_readable,
        "Representation generation time: {}",
        format_duration(representation_time)
    )
    .unwrap();
    writeln!(
        time_file_readable,
        "Constraint generation time: {}",
        format_duration(constraints_time)
    )
    .unwrap();
    writeln!(
        time_file_readable,
        "Solve time: {}",
        format_duration(solve_time)
    )
    .unwrap();

    writeln!(
        time_file,
        "{} {} {}",
        representation_time.as_nanos(),
        constraints_time.as_nanos(),
        solve_time.as_nanos()
    )
    .unwrap();

    match sat_result {
        SatResult::Sat => {
            let model = solver.get_model().unwrap();
            let results = Results::pull(&constraints, &model);

            let mut signature_assignment: HashMap<TypeLab, usize> = HashMap::new();

            for typelab in program.signature_typelabs() {
                signature_assignment.insert(
                    typelab,
                    results
                        .rust_types
                        .get(&typelab)
                        .unwrap()
                        .to_benchmark_representation(),
                );
            }

            let mut signature_assignment_file =
                File::create(results_path.join("signature-assignment.txt")).unwrap();

            let mut keys = signature_assignment.keys().collect::<Vec<_>>();
            keys.sort();

            for k in keys {
                writeln!(
                    signature_assignment_file,
                    "{} {}",
                    k.0,
                    signature_assignment.get(k).unwrap()
                )
                .unwrap();
            }

            let program = ProgramWithRustTypes::new(program, results);

            let mut rtypes = File::create(results_path.join("rtypes.txt")).unwrap();
            ProgramConsoleFormatter::<RTypeFrag>::format(&program, &mut rtypes).unwrap();

            let mut rtypes = File::create(results_path.join("rtypes.tex")).unwrap();
            ProgramTexFormatter::<RTypeFrag>::format(&program, &mut rtypes).unwrap();

            let status = if is_correct_type_assignment(
                &path.join("correct-type-assignments"),
                &signature_assignment,
            ) {
                BenchmarkStatus::Correct
            } else {
                BenchmarkStatus::Unsure
            };

            Ok(BenchmarkData {
                status,
                signature_assignment,
                timing_data: BenchmarkTiming {
                    representation_time,
                    constraints_time,
                    solve_time,
                },
            })
        }
        SatResult::Unknown => {
            eprintln!(
                "Reason for Unknown: {}",
                solver.get_reason_unknown().unwrap_or_default()
            );
            let stats = solver.get_statistics();
            eprintln!("Solver statistics:\n{:?}", stats);
            Err("The solver returned unknown.\n".to_string())
        }
        SatResult::Unsat => {
            eprintln!("Dumping unsat core...");
            eprintln!("{:?}", solver.get_unsat_core());
            Err("The solver returned unsat.\n".to_string())
        }
    }
}

fn store_summary(path: &Path, results: &[BenchmarkData]) {
    let date_string = Utc::now().to_string();

    let summaries_path = path.join("summaries").join(&date_string);
    fs::create_dir_all(&summaries_path).unwrap();

    let mut time_file_readable =
        File::create(summaries_path.join(format!("time-readable-{}.txt", date_string))).unwrap();

    let mut time_file =
        File::create(summaries_path.join(format!("times-{}.txt", date_string))).unwrap();

    let average_representation_time = results
        .iter()
        .map(|r| r.timing_data.representation_time)
        .reduce(|acc, x| acc + x)
        .unwrap()
        .div_f64(results.len() as f64);

    let average_constraints_time = results
        .iter()
        .map(|r| r.timing_data.constraints_time)
        .reduce(|acc, x| acc + x)
        .unwrap()
        .div_f64(results.len() as f64);

    let average_solve_time = results
        .iter()
        .map(|r| r.timing_data.solve_time)
        .reduce(|acc, x| acc + x)
        .unwrap()
        .div_f64(results.len() as f64);

    writeln!(
        time_file_readable,
        "Representation generation time: {}",
        format_duration(average_representation_time)
    )
    .unwrap();
    writeln!(
        time_file_readable,
        "Constraint generation time: {}",
        format_duration(average_constraints_time)
    )
    .unwrap();
    writeln!(
        time_file_readable,
        "Solve time: {}",
        format_duration(average_solve_time)
    )
    .unwrap();

    writeln!(
        time_file,
        "{} {} {}",
        average_representation_time.as_nanos(),
        average_constraints_time.as_nanos(),
        average_solve_time.as_nanos()
    )
    .unwrap();
}

fn get_correct_type_assignments(path: &Path) -> Vec<HashMap<TypeLab, usize>> {
    if path.exists() {
        let mut maps = vec![];
        for file in fs::read_dir(path).unwrap() {
            let contents = fs::read_to_string(file.unwrap().path()).unwrap();
            let mut map: HashMap<TypeLab, usize> = HashMap::new();
            for line in contents.split("\n") {
                if !line.is_empty() {
                    let split: Vec<usize> = line.split(" ").map(|x| x.parse().unwrap()).collect();
                    let typelab = split[0];
                    let rtype = split[1];
                    map.insert(TypeLab(typelab as u64), rtype);
                }
            }
            maps.push(map);
        }
        maps
    } else {
        fs::create_dir(path).unwrap();
        vec![]
    }
}

fn is_correct_type_assignment(path: &Path, map: &HashMap<TypeLab, usize>) -> bool {
    for other_map in get_correct_type_assignments(path) {
        if *map == other_map {
            return true;
        }
    }
    false
}

struct BenchmarkTiming {
    representation_time: Duration,
    constraints_time: Duration,
    solve_time: Duration,
}

struct BenchmarkData {
    status: BenchmarkStatus,
    signature_assignment: HashMap<TypeLab, usize>,
    timing_data: BenchmarkTiming,
}

#[derive(Clone)]
enum BenchmarkStatus {
    Correct,
    Unsure,
}

fn with_spinner<T>(title: &'static str, do_thing: impl Fn() -> T) -> (T, Duration) {
    let spinner = ProgressBar::new_spinner();
    spinner.enable_steady_tick(Duration::from_millis(50));
    spinner.set_style(ProgressStyle::with_template("{spinner} ({elapsed}) {msg}").unwrap());
    spinner.set_message(title);
    let start_instant = Instant::now();
    let result = do_thing();
    let end_instant = Instant::now();
    spinner.set_style(ProgressStyle::with_template("{msg}").unwrap());
    let duration = end_instant - start_instant;
    spinner.finish_with_message(format!(
        "✔ finished {} in {}",
        title,
        format_duration(end_instant - start_instant)
    ));
    (result, duration)
}

fn create_solver(constraints: &ConstraintSystem, assertions_file: &mut impl Write) -> Optimize {
    let solver = Optimize::new();

    for (key, assertions) in &constraints.constraints {
        for assertion in assertions {
            solver.assert(assertion);
        }
        write!(assertions_file, "    {} assertions from ", assertions.len()).unwrap();
        for name in key.rule_names() {
            write!(assertions_file, "[{}], ", name).unwrap();
        }
        writeln!(assertions_file).unwrap();
    }

    let total_assertions: usize = constraints
        .constraints
        .values()
        .map(|assertions| assertions.len())
        .sum();
    writeln!(assertions_file, "    {} total assertions", total_assertions).unwrap();

    for (key, objective) in &constraints.objectives {
        solver.minimize(objective);
        writeln!(
            assertions_file,
            "    minimizing objective [{}]",
            key.rule_name()
        )
        .unwrap();
    }

    solver
}

impl RTypeFrag {
    fn to_benchmark_representation(&self) -> usize {
        match &self {
            Self::Void => 0,
            Self::Bool => 1,
            Self::Int8 => 2,
            Self::Int16 => 3,
            Self::Int32 => 4,
            Self::Int64 => 5,
            Self::Float32 => 6,
            Self::Float64 => 7,
            Self::Ghost { .. } => 8,
            Self::Box { .. } => 9,
            Self::Rc { .. } => 10,
            Self::Shared { .. } => 11,
            Self::Mut { .. } => 12,
            Self::Struct { .. } => 20,
            Self::Unknown => 22,
        }
    }
}
