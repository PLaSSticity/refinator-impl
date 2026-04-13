//! # &inator SMT Relations
//!
//! In this module, we declare or define the SMT relations used in &inator's SMT
//! constraints. In Z3, relations are modeled by their characteristic function
//! (i.e. a function with codomain `Bool`).

pub mod lab_array;
pub mod lab_cell;
pub mod lifetime_outlives;
pub mod pointer_transform;
pub mod struct_clonable;
