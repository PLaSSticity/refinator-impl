//! # Assign-paired `TypeLab` analysis.
//!
//! This module implements a pass over a function that finds all pairs of
//! `TypeLabs`, `(s_typelab, d_typelab)`, where `s_typelab` and `d_typelab`
//! correspond to each other on the source and destination sides, respectively,
//! of an assignment instruction.
//!
//! For example, if the type of `d_var` has `TypeLab`s `[1, 2, 3]`, and the type
//! of the rvalue expression `[s_var]^7` has `TypeLab`s `[7, 5, 6]`, and there
//! is an assignment `d_var = [s_var]^7;` then we get the `TypeLab` pairs
//! `(7, 1)`, `(5, 2)`, and `(6, 3)`.
//!
//! This includes implicit assignments; namely:
//! - For a return `return [expr];`, which appears inside the body of a function
//!   with signature `T func(...) { ... }`, the `TypeLab`s of `[expr]` and `T`
//!   are paired.

use std::collections::{HashMap, HashSet};

use crate::lang::{
    function::{FuncIdent, Function},
    instruction::{InstrLab, Instruction},
    program::Program,
    stype::TypeLab,
};

/// The results of an assign-paired `TypeLab`s analysis on `func`.
pub struct AssignTypeLabPairs {
    pub func: FuncIdent,
    assigns: HashMap<InstrLab, HashSet<Vec<(TypeLab, TypeLab)>>>,
}

impl AssignTypeLabPairs {
    /// Analyze `func`.
    pub fn analyze(program: &Program, func: &Function) -> Self {
        let mut assigns: HashMap<InstrLab, HashSet<Vec<(TypeLab, TypeLab)>>> = HashMap::new();
        for basic_block in &func.basic_blocks {
            for instr in &basic_block.instructions {
                match instr {
                    Instruction::Load {
                        id,
                        lhs_var,
                        rhs_typelab,
                        ..
                    }
                    | Instruction::Field {
                        id,
                        lhs_var,
                        rhs_typelab,
                        ..
                    }
                    | Instruction::Element {
                        id,
                        lhs_var,
                        rhs_typelab,
                        ..
                    } => {
                        let pairs: Vec<(TypeLab, TypeLab)> = program
                            .rval_typelabs(rhs_typelab)
                            .iter()
                            .cloned()
                            .zip(program.var_typelabs(lhs_var).iter().cloned())
                            .collect();
                        assigns.entry(*id).or_default().insert(pairs);
                    }
                    Instruction::Store {
                        id,
                        lhs_var,
                        rhs_typelab,
                        ..
                    } => {
                        let pairs: Vec<(TypeLab, TypeLab)> = program
                            .rval_typelabs(rhs_typelab)
                            .iter()
                            .cloned()
                            .zip(program.var_typelabs(lhs_var)[1..].iter().cloned())
                            .collect();
                        assigns.entry(*id).or_default().insert(pairs);
                    }
                    Instruction::Phi {
                        id,
                        lhs_var,
                        operand_typelabs,
                        ..
                    } => {
                        for rhs_typelab in operand_typelabs {
                            let pairs: Vec<(TypeLab, TypeLab)> = program
                                .rval_typelabs(rhs_typelab)
                                .iter()
                                .cloned()
                                .zip(program.var_typelabs(lhs_var).iter().cloned())
                                .collect();
                            assigns.entry(*id).or_default().insert(pairs);
                        }
                    }
                    // TODO: Add this case to the paper.
                    Instruction::Ret {
                        id, rhs_typelab, ..
                    } => {
                        let pairs: Vec<(TypeLab, TypeLab)> = program
                            .rval_typelabs(rhs_typelab)
                            .iter()
                            .cloned()
                            .zip(func.ret_typelabs.iter().cloned())
                            .collect();
                        assigns.entry(*id).or_default().insert(pairs);
                    }
                    _ => (),
                };
            }
        }

        Self {
            func: func.id.clone(),
            assigns,
        }
    }

    /// Gets the paired `TypeLab`s due to the assignment at the instruction with
    /// `Lab` `lab`.
    pub fn try_get_pairs(
        &self,
        lab: &InstrLab,
    ) -> Option<impl Iterator<Item = &(TypeLab, TypeLab)>> {
        self.assigns.get(lab).map(|s| s.iter().flatten())
    }

    /// Gets the paired `TypeLab`s due to the assignment at the instruction with
    /// `Lab` `lab`.
    ///
    /// # Panics
    /// - if `lab` isn't the `Lab` for any instruction in `self.func`.
    pub fn get_pairs(&self, lab: &InstrLab) -> impl Iterator<Item = &(TypeLab, TypeLab)> {
        self.try_get_pairs(lab).unwrap()
    }

    /// Gets an iterator over slices of paired `TypeLab`s, where each slice
    /// corresponds to an assignment.
    pub fn assigns(&self) -> impl Iterator<Item = &[(TypeLab, TypeLab)]> {
        self.assigns.values().flat_map(|s| s.iter().map(|v| &**v))
    }
}
