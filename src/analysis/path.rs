//! # Paths
//!
//! In this module, we define the `Path` struct to represent paths that may
//! appear as part of the input program as an rvalue expression, or as part of
//! the (abstract) constraints as a path borrowed by a loan.

use std::collections::HashMap;

use crate::lang::{
    function::FuncIdent,
    instruction::{InstrLab, Instruction},
    program::Program,
    r#struct::StructIdent,
    stype::{STypeFrag, TypeLab},
    variable::VarIdent,
};

/// A path that may be borrowed by a loan appear as an rvalue expression.
#[derive(Clone, Copy, PartialEq, Eq, Hash)]
pub enum Path {
    Var {
        /* v */
        var: VarIdent,
    },
    Deref {
        /* *v */
        var: VarIdent,
    },
    DDeref {
        /* **v */
        var: VarIdent,
    },
    Elem {
        /* &v[e], which is the same as v in the case of array decay */
        var: VarIdent,
    },
    Field {
        /* &*(*v).f */
        var: VarIdent,
        field: usize,
    },
}

impl Path {
    /// Creates a `Var` variant `Path` for the variable `var`.
    pub fn var(var: VarIdent) -> Self {
        Self::Var { var }
    }

    /// Creates a `Deref` variant `Path` for the variable `var`.
    pub fn deref(var: VarIdent) -> Self {
        Self::Deref { var }
    }

    /// Creates a `DDeref` variant `Path` for the variable `var`.
    pub fn dderef(var: VarIdent) -> Self {
        Self::DDeref { var }
    }

    /// Creates a `Elem` variant `Path` for the variable `var`.
    pub fn elem(var: VarIdent) -> Self {
        Self::Elem { var }
    }

    /// Creates a `Field` variant `Path` for the variable `var` and field
    /// `field`.
    pub fn field(var: VarIdent, field: usize) -> Self {
        Self::Field { var, field }
    }

    /// Determines if `self` is a `Var` variant.
    pub fn is_var(&self) -> bool {
        matches!(self, Self::Var { .. })
    }

    /// Determines if `self` is a `Deref` variant.
    pub fn is_deref(&self) -> bool {
        matches!(self, Self::Deref { .. })
    }

    /// Determines if `self` is a `DDeref` variant.
    pub fn is_dderef(&self) -> bool {
        matches!(self, Self::DDeref { .. })
    }

    /// Determines if `self` is a `Elem` variant.
    pub fn is_elem(&self) -> bool {
        matches!(self, Self::Elem { .. })
    }

    /// Determines if `self` is a `Field` variant.
    pub fn is_field(&self) -> bool {
        matches!(self, Self::Field { .. })
    }

    /// Gets the `var` field of `self`.
    pub fn get_var(&self) -> VarIdent {
        match self {
            Self::Var { var } => *var,
            Self::Deref { var } => *var,
            Self::DDeref { var } => *var,
            Self::Elem { var, .. } => *var,
            Self::Field { var, .. } => *var,
        }
    }

    /// Gets the `field` field of `self`.
    pub fn try_get_field(&self) -> Option<usize> {
        match self {
            Self::Var { .. } => None,
            Self::Deref { .. } => None,
            Self::DDeref { .. } => None,
            Self::Elem { .. } => None,
            Self::Field { field, .. } => Some(*field),
        }
    }

    /// Gets the `field` field of `self`.
    ///
    /// # Panics
    /// - if `self` is not the `Field` variant.
    pub fn get_field(&self) -> usize {
        self.try_get_field().unwrap()
    }

    /// Determines if borrowing `self` conflicts with a loan of `other`.
    pub fn borrow_conflicts(&self, other: &Self) -> bool {
        match self {
            Self::Var { var: svar } | Self::Deref { var: svar } | Self::Elem { var: svar } => {
                match other {
                    Self::Var { var: ovar } => svar == ovar,
                    Self::Deref { var: ovar } => svar == ovar,
                    Self::DDeref { var: ovar } => svar == ovar,
                    Self::Elem { var: ovar } => svar == ovar,
                    Self::Field {
                        var: ovar,
                        field: _,
                    } => svar == ovar,
                }
            }
            Self::DDeref { var: svar } => match other {
                Self::Var { var: ovar } => svar == ovar,
                Self::Deref { var: ovar } => svar == ovar,
                Self::DDeref { var: ovar } => svar == ovar,
                Self::Elem { var: ovar } => svar == ovar,
                Self::Field { var: _, field: _ } => false,
            },
            Self::Field {
                var: svar,
                field: sfield,
            } => match other {
                Self::Var { var: ovar } => svar == ovar,
                Self::Deref { var: ovar } => svar == ovar,
                Self::DDeref { var: _ } => false,
                Self::Elem { var: ovar } => svar == ovar,
                Self::Field {
                    var: ovar,
                    field: ofield,
                } => svar == ovar && sfield == ofield,
            },
        }
    }

    /// Determines if assigning into `self` conflicts with a loan of `other`.
    pub fn assign_conflicts(&self, other: &Self) -> bool {
        match self {
            Self::Var { var: svar } => match other {
                Self::Var { var: ovar } => svar == ovar,
                Self::Deref { var: _ } => false,
                Self::DDeref { var: _ } => false,
                Self::Elem { var: ovar } => svar == ovar,
                Self::Field { var: _, field: _ } => false,
            },
            Self::Deref { var: svar } => match other {
                Self::Var { var: ovar } => svar == ovar,
                Self::Deref { var: ovar } => svar == ovar,
                Self::DDeref { var: _ } => false,
                Self::Elem { var: ovar } => svar == ovar,
                Self::Field {
                    var: ovar,
                    field: _,
                } => svar == ovar,
            },
            Self::DDeref { var: svar } => match other {
                Self::Var { var: ovar } => svar == ovar,
                Self::Deref { var: ovar } => svar == ovar,
                Self::DDeref { var: ovar } => svar == ovar,
                Self::Elem { var: ovar } => svar == ovar,
                Self::Field { var: _, field: _ } => false,
            },
            Self::Elem { var: svar } => match other {
                Self::Var { var: ovar } => svar == ovar,
                Self::Deref { var: ovar } => svar == ovar,
                Self::DDeref { var: _ } => false,
                Self::Elem { var: ovar } => svar == ovar,
                Self::Field { var: _, field: _ } => false,
            },
            Self::Field {
                var: svar,
                field: sfield,
            } => match other {
                Self::Var { var: ovar } => svar == ovar,
                Self::Deref { var: ovar } => svar == ovar,
                Self::DDeref { var: _ } => false,
                Self::Elem { var: ovar } => svar == ovar,
                Self::Field {
                    var: ovar,
                    field: ofield,
                } => svar == ovar && sfield == ofield,
            },
        }
    }

    /// Computes the `Path`s whose borrows would conflict with borrows of this
    /// `Path`.
    pub fn find_borrow_conflicts(&self, program: &Program) -> Vec<Self> {
        let mut result = vec![];
        match self {
            Self::Var { var } | Self::Deref { var } | Self::Elem { var } => {
                result.push(Self::var(*var));
                result.push(Self::deref(*var));
                result.push(Self::dderef(*var));
                result.push(Self::elem(*var));
                if let Some(STypeFrag::Struct(s)) = program.var_stype(var).get(1) {
                    for field in 0..program
                        .get_struct(&StructIdent(s.clone()))
                        .field_typelabs
                        .len()
                    {
                        result.push(Self::field(*var, field));
                    }
                }
            }
            Self::DDeref { var } => {
                result.push(Self::var(*var));
                result.push(Self::deref(*var));
                result.push(Self::dderef(*var));
                result.push(Self::elem(*var));
            }
            Self::Field { var, field } => {
                result.push(Self::var(*var));
                result.push(Self::deref(*var));
                result.push(Self::elem(*var));
                result.push(Self::field(*var, *field));
            }
        }
        result
    }

    /// Computes the `Path`s whose borrows would conflict with assignments into
    /// this `Path`.
    pub fn find_assign_conflicts(&self, program: &Program) -> Vec<Self> {
        let mut result = vec![];
        match self {
            Self::Var { var } => {
                result.push(Self::var(*var));
                result.push(Self::elem(*var));
            }
            Self::Deref { var } => {
                result.push(Self::var(*var));
                result.push(Self::deref(*var));
                result.push(Self::elem(*var));
                if let Some(STypeFrag::Struct(s)) = program.var_stype(var).get(1) {
                    for field in 0..program
                        .get_struct(&StructIdent(s.clone()))
                        .field_typelabs
                        .len()
                    {
                        result.push(Self::field(*var, field));
                    }
                }
            }
            Self::DDeref { var } => {
                result.push(Self::var(*var));
                result.push(Self::deref(*var));
                result.push(Self::dderef(*var));
                result.push(Self::elem(*var));
            }
            Self::Elem { var } => {
                result.push(Self::var(*var));
                result.push(Self::deref(*var));
                result.push(Self::elem(*var));
            }
            Self::Field { var, field } => {
                result.push(Self::var(*var));
                result.push(Self::deref(*var));
                result.push(Self::elem(*var));
                result.push(Self::field(*var, *field));
            }
        }
        result
    }
}

pub type Borrows = HashMap<TypeLab, (FuncIdent, InstrLab, Path)>;

/// Computes all `Path`s that may be borrowed in `program`.
///
/// For each entry in the return value, the key is the unique `TypeLab` for the
/// borrowing rvalue expression. The value is a triple of `FunctionID`, `Lab`,
/// and `Path`.
///
/// The `FunctionID` is the function containing the instruction with label
/// `Lab`, which is the instruction where the borrowing rvalue expression
/// occurs. The `Path` is the path borrowed by the rvalue expression.
pub fn find_borrows(program: &Program) -> Borrows {
    let mut result = HashMap::new();

    for func in program.functions() {
        for bb in &func.basic_blocks {
            for instr in &bb.instructions {
                match instr {
                    Instruction::Load {
                        id,
                        rhs_var,
                        rhs_typelab,
                        ..
                    } if STypeFrag::is_ptr(program.lab_stype(rhs_typelab)) => {
                        result.insert(*rhs_typelab, (func.id.clone(), *id, Path::dderef(*rhs_var)));
                    }
                    Instruction::Store {
                        id,
                        rhs_var: Some(rhs_var),
                        rhs_typelab,
                        ..
                    }
                    | Instruction::Ret {
                        id,
                        rhs_var: Some(rhs_var),
                        rhs_typelab,
                        ..
                    }
                    | Instruction::Switch {
                        id,
                        cond_var: Some(rhs_var),
                        cond_typelab: rhs_typelab,
                        ..
                    } if STypeFrag::is_ptr(program.lab_stype(rhs_typelab)) => {
                        result.insert(*rhs_typelab, (func.id.clone(), *id, Path::deref(*rhs_var)));
                    }
                    Instruction::Field {
                        id,
                        rhs_var,
                        field_idx,
                        rhs_typelab,
                        ..
                    } => {
                        result.insert(
                            *rhs_typelab,
                            (func.id.clone(), *id, Path::field(*rhs_var, *field_idx)),
                        );
                    }
                    Instruction::Element {
                        id,
                        rhs_var,
                        rhs_typelab,
                        ..
                    } => {
                        result.insert(
                            *rhs_typelab,
                            (func.id.clone(), *id, Path::field(*rhs_var, 0)),
                        );
                    }
                    Instruction::Call {
                        id,
                        arg_vars: vars,
                        arg_typelabs: typelabs,
                        ..
                    }
                    | Instruction::Use {
                        id,
                        operand_vars: vars,
                        operand_typelabs: typelabs,
                        ..
                    } => {
                        for (var, typelab) in
                            vars.iter()
                                .zip(typelabs.iter())
                                .filter_map(|(var, typelab)| {
                                    if STypeFrag::is_ptr(program.lab_stype(typelab)) {
                                        var.map(|var| (var, typelab))
                                    } else {
                                        None
                                    }
                                })
                        {
                            result.insert(*typelab, (func.id.clone(), *id, Path::deref(var)));
                        }
                    }
                    _ => (),
                }
            }
        }
    }

    result
}
