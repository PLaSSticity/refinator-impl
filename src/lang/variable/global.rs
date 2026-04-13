//! # Source Language Global Variables

use crate::lang::{
    function::FuncIdent,
    stype::TypeLab,
    variable::{VarIdent, Variable},
};

/// A global variable in the source language.
pub struct GlobalVar<'a> {
    pub id: VarIdent,
    pub llvm_glob: &'a llvm_ir::module::GlobalVariable,
    pub name: String,
    pub lhs_typelabs: Vec<TypeLab>,
    pub rhs_typelab: Option<TypeLab>,
}

impl Variable for GlobalVar<'_> {
    fn id(&self) -> VarIdent {
        self.id
    }

    fn try_func_id(&self) -> Option<FuncIdent> {
        None
    }

    fn name(&self) -> &str {
        &self.name
    }
}

impl GlobalVar<'_> {
    /// Checks if `self` is defined at its declaration.
    pub fn is_defined(&self) -> bool {
        self.rhs_typelab.is_some()
    }
}
