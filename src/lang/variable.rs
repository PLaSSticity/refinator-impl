//! # Source Language Variables

use std::fmt::Display;

use crate::lang::function::FuncIdent;

pub mod global;
pub mod local;

/// Newtype for variable identifiers.
#[derive(Clone, Copy, PartialOrd, Ord, PartialEq, Eq, Hash)]
pub struct VarIdent(pub usize);

impl VarIdent {
    /// Increments the underlying index of `self` by `base`.
    pub fn offset(&mut self, base: usize) {
        self.0 += base;
    }
}

impl Display for VarIdent {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0)
    }
}

/// Methods for source language variables.
pub trait Variable {
    /// Gets the `VarIdent` of `self`.
    fn id(&self) -> VarIdent;

    /// Gets a `Some` containing the `FuncIdent` of the function where `self` is
    /// declared if `self` is a local variable, and `None` otherwise.
    fn try_func_id(&self) -> Option<FuncIdent>;

    /// Gets the name of `self`.
    fn name(&self) -> &str;
}
