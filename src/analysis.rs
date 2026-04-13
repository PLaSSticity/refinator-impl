//! # Static Analyses on LabLLVM
//!
//! In this module, we implement the static analyses we perform on LabLLVM
//! programs. This includes (I)CFG generation and live variables analysis.

pub mod control_flow;
pub mod drop;
pub mod live_variables;
pub mod local_typelabs;
pub mod path;
pub mod rvals;
pub mod typelab_pairs;
