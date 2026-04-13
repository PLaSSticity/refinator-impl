//! # Rvalue expression analysis.
//!
//! This module provides convenience functions for working with rvalue
//! expressions that appear in a program.

use std::collections::{HashMap, HashSet};

use crate::{
    analysis::path::Path,
    lang::{
        function::FuncIdent,
        instruction::{InstrLab, Instruction},
        program::Program,
        stype::TypeLab,
    },
};

/// Provides convenience functions for working with rvalue expressions that
/// appear in a program.
#[derive(Default)]
pub struct Rvalues {
    paths: HashMap<TypeLab, Path>,
    labs: HashMap<TypeLab, InstrLab>,
    funcs: HashMap<TypeLab, FuncIdent>,
    borrowing: HashSet<TypeLab>,
    borrowed_path: HashMap<TypeLab, Path>,
}

impl Rvalues {
    /// Creates a `Self` for working with rvalue expressions in `program`.
    pub fn new(program: &Program) -> Self {
        let mut paths = HashMap::new();
        let mut labs = HashMap::new();
        let mut funcs = HashMap::new();
        let mut borrowing = HashSet::new();
        let mut borrowed_path = HashMap::new();

        for func in program.functions() {
            for bb in &func.basic_blocks {
                for instr in &bb.instructions {
                    match instr {
                        Instruction::Alloca { .. } | Instruction::Br { .. } => (),
                        Instruction::Load {
                            id,
                            rhs_typelab,
                            rhs_var,
                            ..
                        } => {
                            paths.insert(*rhs_typelab, Path::deref(*rhs_var));
                            labs.insert(*rhs_typelab, *id);
                            funcs.insert(*rhs_typelab, func.id.clone());
                            if program.lab_stype(rhs_typelab).is_ptr() {
                                borrowing.insert(*rhs_typelab);
                                borrowed_path.insert(*rhs_typelab, Path::dderef(*rhs_var));
                            }
                        }
                        Instruction::Store {
                            id,
                            rhs_typelab,
                            rhs_var,
                            ..
                        }
                        | Instruction::CondBr {
                            id,
                            cond_typelab: rhs_typelab,
                            cond_var: rhs_var,
                            ..
                        }
                        | Instruction::Ret {
                            id,
                            rhs_typelab,
                            rhs_var,
                            ..
                        } => {
                            labs.insert(*rhs_typelab, *id);
                            funcs.insert(*rhs_typelab, func.id.clone());
                            if program.lab_stype(rhs_typelab).is_ptr() {
                                borrowing.insert(*rhs_typelab);
                            }
                            if let Some(rhs_var) = rhs_var {
                                paths.insert(*rhs_typelab, Path::var(*rhs_var));
                                if program.lab_stype(rhs_typelab).is_ptr() {
                                    borrowed_path.insert(*rhs_typelab, Path::deref(*rhs_var));
                                }
                            }
                        }
                        Instruction::Field {
                            id,
                            rhs_typelab,
                            rhs_var,
                            field_idx,
                            ..
                        } => {
                            let path = Path::field(*rhs_var, *field_idx);
                            paths.insert(*rhs_typelab, path);
                            labs.insert(*rhs_typelab, *id);
                            funcs.insert(*rhs_typelab, func.id.clone());
                            borrowing.insert(*rhs_typelab);
                            borrowed_path.insert(*rhs_typelab, path);
                        }
                        Instruction::Element {
                            id,
                            rhs_typelab,
                            rhs_var,
                            ..
                        } => {
                            let path = Path::elem(*rhs_var);
                            paths.insert(*rhs_typelab, path);
                            labs.insert(*rhs_typelab, *id);
                            funcs.insert(*rhs_typelab, func.id.clone());
                            borrowing.insert(*rhs_typelab);
                            borrowed_path.insert(*rhs_typelab, path);
                        }
                        Instruction::Call {
                            id,
                            arg_typelabs: typelabs,
                            arg_vars: vars,
                            ..
                        }
                        | Instruction::Use {
                            id,
                            operand_typelabs: typelabs,
                            operand_vars: vars,
                            ..
                        }
                        | Instruction::Phi {
                            id,
                            operand_typelabs: typelabs,
                            operand_vars: vars,
                            ..
                        } => {
                            for (typelab, var) in typelabs.iter().zip(vars.iter()) {
                                labs.insert(*typelab, *id);
                                funcs.insert(*typelab, func.id.clone());
                                if program.lab_stype(typelab).is_ptr() {
                                    borrowing.insert(*typelab);
                                }
                                if let Some(var) = var {
                                    paths.insert(*typelab, Path::var(*var));
                                    if program.lab_stype(typelab).is_ptr() {
                                        borrowed_path.insert(*typelab, Path::deref(*var));
                                    }
                                }
                            }
                        }
                        _ => (),
                    }
                }
            }
        }

        Self {
            paths,
            labs,
            funcs,
            borrowing,
            borrowed_path,
        }
    }

    /// Gets the `Path` of the rvalue expression uniquely identified by `rval`.
    pub fn try_get_path(&self, rval: TypeLab) -> Option<Path> {
        self.paths.get(&rval).cloned()
    }

    /// Gets the `Path` of the rvalue expression uniquely identified by `rval`.
    ///
    /// # Panics
    /// - if no rvalue expression in `self.program` is identified by `rval`
    pub fn get_path(&self, rval: TypeLab) -> Path {
        self.try_get_path(rval).unwrap()
    }

    /// Finds the `Lab` of the instruction that contains the rvalue expression
    /// uniquely identified by `rval`.
    pub fn try_get_lab(&self, rval: TypeLab) -> Option<InstrLab> {
        self.labs.get(&rval).cloned()
    }

    /// Finds the `Lab` of the instruction that contains the rvalue expression
    /// uniquely identified by `rval`.
    ///
    /// # Panics
    /// - if the rvalue expression uniquely identified by `rval` isn't in any
    ///   instruction in `self.program`
    pub fn get_lab(&self, rval: TypeLab) -> InstrLab {
        self.try_get_lab(rval).unwrap()
    }

    /// Finds the id of the `Function` that contains the rvalue expression
    /// uniquely identified by `rval`.
    pub fn try_get_func(&self, rval: TypeLab) -> Option<&FuncIdent> {
        self.funcs.get(&rval)
    }

    /// Finds the id of the `Function` that contains the rvalue expression
    /// uniquely identified by `rval`.
    ///
    /// # Panics
    /// - if the rvalue expression uniquely identified by `rval` isn't in any
    ///   instruction in `self.program`
    pub fn get_func(&self, rval: TypeLab) -> &FuncIdent {
        self.try_get_func(rval).unwrap()
    }

    /// Checks if the instruction that contains the rvalue expression uniquely
    /// identified by `rval` borrows a path.
    pub fn is_borrowing(&self, rval: TypeLab) -> bool {
        self.borrowing.contains(&rval)
    }

    /// Gets the path borrowed by the rvalue expression uniquely identified by
    /// `rval`.
    pub fn try_get_borrowed_path(&self, rval: TypeLab) -> Option<Path> {
        self.borrowed_path.get(&rval).cloned()
    }

    /// Gets the path borrowed by the rvalue expression uniquely identified by
    /// `rval`.
    ///
    /// # Panics
    /// - if `!self.is_borrowing(rval)`
    pub fn get_borrowed_path(&self, rval: TypeLab) -> Path {
        assert!(self.is_borrowing(rval));
        self.try_get_borrowed_path(rval).unwrap()
    }

    /// Gets an iterator over `TypeLab`s of all rvalue expressions.
    pub fn typelabs(&self) -> impl Iterator<Item = TypeLab> {
        self.paths.keys().cloned()
    }

    /// Gets an iterator over `TypeLab`s of all borrowing rvalue expressions.
    pub fn borrow_typelabs(&self) -> impl Iterator<Item = TypeLab> {
        self.borrowing.iter().cloned()
    }
}
