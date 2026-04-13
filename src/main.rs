use clap::Parser;
use refinator::benchmark::benchmark::{run_all_benchmarks, run_benchmarks};
use std::path::{Path, PathBuf};

#[derive(Parser)]
struct Cli {
    benchmarks: Vec<String>,

    #[arg(long, short)]
    all: bool,

    #[arg(long, short, default_value("1"))]
    trials: i32,
}

fn main() -> Result<(), ()> {
    let cli = Cli::parse();
    let args: Vec<String> = cli.benchmarks;

    let res = if cli.all {
        run_all_benchmarks(cli.trials)
    } else {
        let benchmarks_path = Path::new("benchmarks");
        let benchmarks: Vec<PathBuf> = args.iter().map(|b| benchmarks_path.join(b)).collect();
        run_benchmarks(benchmarks, cli.trials)
    };

    match res {
        Ok(_) => Ok(()),
        Err(ref e) => {
            eprint!("{}", e);
            Err(())
        }
    }
}
