//! # Local `TypeLab`s analysis.
//!
//! This module implements a pass over a function that finds all of the
//! `TypeLab`s that are local to a function.
//!
//! For a function `F`, a `TypeLab` `typelab` is local to `F` if:
//! - `typelab` appears in the type of a variable declared in `F`, or
//! - `typelab` uniquely identifies an rvalue expression in `F`.  

use std::{
    collections::{HashMap, HashSet, hash_set::Iter},
    iter::Cloned,
};

use crate::lang::{
    function::{FuncIdent, Function},
    instruction::{InstrLab, Instruction},
    program::Program,
    stype::TypeLab,
};

/// Results of a local `TypeLab`s analysis.
pub struct LocalTypeLabs {
    pub func: FuncIdent,
    locals: HashSet<TypeLab>,
    to_lab: HashMap<TypeLab, InstrLab>,
}

impl LocalTypeLabs {
    /// Perform the analysis on `func`.
    pub fn analyze(program: &Program, func: &Function) -> Self {
        let mut locals = HashSet::new();
        let mut to_lab = HashMap::new();

        for typelab in &func.ret_typelabs {
            locals.insert(*typelab);
        }

        for param in &func.param_vars {
            for typelab in program.var_typelabs(param) {
                locals.insert(*typelab);
            }
        }

        for bb in &func.basic_blocks {
            for instr in &bb.instructions {
                match instr {
                    Instruction::Alloca { id, lhs_var, .. } => {
                        for typelab in program.var_typelabs(lhs_var) {
                            locals.insert(*typelab);
                            to_lab.insert(*typelab, *id);
                        }
                    }
                    Instruction::Load {
                        id,
                        lhs_var,
                        rhs_var,
                        rhs_typelab,
                        ..
                    }
                    | Instruction::Field {
                        id,
                        lhs_var,
                        rhs_var,
                        rhs_typelab,
                        ..
                    } => {
                        for typelab in program
                            .var_typelabs(lhs_var)
                            .iter()
                            .cloned()
                            .chain(program.var_typelabs(rhs_var).iter().cloned())
                            .chain([rhs_typelab].into_iter().cloned())
                        {
                            locals.insert(typelab);
                            to_lab.insert(typelab, *id);
                        }
                    }
                    Instruction::Store {
                        id,
                        lhs_var,
                        rhs_var,
                        rhs_typelab,
                        ..
                    } => {
                        for typelab in program
                            .var_typelabs(lhs_var)
                            .iter()
                            .cloned()
                            .chain([rhs_typelab].into_iter().cloned())
                        {
                            locals.insert(typelab);
                        }
                        if let Some(rhs_var) = rhs_var {
                            for typelab in program.var_typelabs(rhs_var).iter().cloned() {
                                locals.insert(typelab);
                                to_lab.insert(typelab, *id);
                            }
                        }
                    }
                    Instruction::Element {
                        id,
                        lhs_var,
                        rhs_var,
                        rhs_typelab,
                        elem_var,
                        ..
                    } => {
                        for typelab in program
                            .var_typelabs(lhs_var)
                            .iter()
                            .cloned()
                            .chain(program.var_typelabs(rhs_var).iter().cloned())
                            .chain([rhs_typelab].into_iter().cloned())
                        {
                            locals.insert(typelab);
                            to_lab.insert(typelab, *id);
                        }
                        if let Some(elem_var) = elem_var {
                            for typelab in program.var_typelabs(elem_var).iter().cloned() {
                                locals.insert(typelab);
                                to_lab.insert(typelab, *id);
                            }
                        }
                    }
                    Instruction::Call {
                        id,
                        lhs_var,
                        arg_vars: rval_vars,
                        arg_typelabs: rval_typelabs,
                        ..
                    }
                    | Instruction::Use {
                        id,
                        lhs_var,
                        operand_vars: rval_vars,
                        operand_typelabs: rval_typelabs,
                        ..
                    } => {
                        for var in lhs_var.iter().chain(rval_vars.iter().flatten()) {
                            for typelab in program.var_typelabs(var).iter().cloned() {
                                locals.insert(typelab);
                                to_lab.insert(typelab, *id);
                            }
                        }
                        for typelab in rval_typelabs.iter().cloned() {
                            locals.insert(typelab);
                            to_lab.insert(typelab, *id);
                        }
                    }
                    Instruction::CondBr {
                        id,
                        cond_var: var,
                        cond_typelab: rval_typelab,
                        ..
                    }
                    | Instruction::Ret {
                        id,
                        rhs_var: var,
                        rhs_typelab: rval_typelab,
                        ..
                    } => {
                        locals.insert(*rval_typelab);
                        if let Some(var) = var {
                            for typelab in program.var_typelabs(var).iter().cloned() {
                                locals.insert(typelab);
                                to_lab.insert(typelab, *id);
                            }
                        }
                    }
                    _ => (),
                }
            }
        }

        Self {
            func: func.id.clone(),
            locals,
            to_lab,
        }
    }

    /// Finds the `Lab` of the instruction that contains the rvalue expression
    /// uniquely identified by `rval`.
    pub fn try_get_lab(&self, rval: TypeLab) -> Option<InstrLab> {
        self.to_lab.get(&rval).cloned()
    }

    /// Finds the `Lab` of the instruction that contains the rvalue expression
    /// uniquely identified by `rval`.
    ///
    /// # Panics
    /// - if the rvalue expression uniquely identified by `rval` isn't in any
    ///   instruction in `self.func`
    pub fn get_lab(&self, rval: TypeLab) -> InstrLab {
        self.to_lab.get(&rval).cloned().unwrap()
    }
}

impl<'a> IntoIterator for &'a LocalTypeLabs {
    type Item = TypeLab;
    type IntoIter = Cloned<Iter<'a, TypeLab>>;
    fn into_iter(self) -> Self::IntoIter {
        self.locals.iter().cloned()
    }
}
