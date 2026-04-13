//! &inator inferred lifetimes

use std::{collections::HashSet, fmt::Debug};

use crate::lang::instruction::InstrLab;

/// A lifetime parameter (in struct field types) or a lifetime variable (in
/// variable, rvalue expression, and function return types.)
#[derive(Clone, Copy, PartialEq, Eq, Hash, PartialOrd, Ord)]
pub enum Lifetime {
    Parameter(u64),
    Variable(u64),
}

impl Debug for Lifetime {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let n = match self {
            Self::Parameter(n) | Self::Variable(n) => n,
        };
        match self {
            Self::Parameter(_) => write!(f, "Parameter({n})"),
            Self::Variable(_) => write!(f, "Variable({n})"),
        }
    }
}

/// A set of program points and universal regions.
pub struct Region {
    pub points: HashSet<InstrLab>,
    pub u_regions: HashSet<Lifetime>,
}
