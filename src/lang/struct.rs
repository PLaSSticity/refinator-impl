//! # Source Language Struct Type Identifiers

use std::fmt::Display;

use crate::lang::stype::TypeLab;

/// Newtype for struct type identifiers.
#[derive(Clone, PartialOrd, Ord, PartialEq, Eq, Hash)]
pub struct StructIdent(pub String);

impl Display for StructIdent {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0)
    }
}

/// Struct definitions in the source language.
pub struct Struct /* <'a> */ {
    pub id: StructIdent,
    // pub llvm_def: &'a llvm_ir::types::NamedStructDef,
    // pub llvm_ty: &'a llvm_ir::types::Type,
    pub field_typelabs: Vec<Vec<TypeLab>>,
}
