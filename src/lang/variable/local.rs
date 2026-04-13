//! # Source Language Local Variables

use crate::lang::{
    function::FuncIdent,
    instruction::InstrLab,
    stype::TypeLab,
    variable::{VarIdent, Variable},
};

/// A local variable in the source language.
pub struct LocalVar {
    pub id: VarIdent,
    pub name: String,
    pub func: FuncIdent,
    pub instr: Option<InstrLab>,
    pub typelabs: Vec<TypeLab>,
}

impl Variable for LocalVar {
    fn id(&self) -> VarIdent {
        self.id
    }

    fn try_func_id(&self) -> Option<FuncIdent> {
        Some(self.func.clone())
    }

    fn name(&self) -> &str {
        &self.name
    }
}

impl LocalVar {
    /// Checks if `self` is a parameter of the function that declared it.
    pub fn is_param(&self) -> bool {
        self.instr.is_none()
    }
}
