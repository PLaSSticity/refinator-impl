//! # Source Language Instructions

use std::sync::LazyLock;

use either::Either;
use llvm_ir::instruction::{BinaryOp, HasResult, UnaryOp};
use regex::Regex;

use crate::lang::{
    basic_block::BasicBlockIdent, function::FuncIdent, program::Labels, r#struct::StructIdent,
    stype::TypeLab, variable::VarIdent,
};

/// Regex string that matches call instructions to throw out when generating
/// `Instruction`s from with `Instruction::from_instr`.
static BAD_CALL_REGEX: LazyLock<Regex> =
    LazyLock::new(|| Regex::new(r"^llvm\.lifetime\..*$").expect("Valid regex."));

/// Newtype for instruction labels.
#[derive(Clone, Copy, PartialOrd, Ord, PartialEq, Eq, Hash, Default, Debug)]
pub struct InstrLab(pub usize);

pub enum Instruction<'a> {
    /* Non-terminators ------------------------------------------------------ */
    Alloca {
        id: InstrLab,
        llvm_instr: &'a llvm_ir::instruction::Alloca,
        lhs_var: VarIdent,
    },
    Load {
        id: InstrLab,
        llvm_instr: &'a llvm_ir::instruction::Load,
        lhs_var: VarIdent,
        rhs_var: VarIdent,
        rhs_typelab: TypeLab,
    },
    Store {
        id: InstrLab,
        llvm_instr: &'a llvm_ir::instruction::Store,
        lhs_var: VarIdent,
        rhs_var: Option<VarIdent>,
        rhs_typelab: TypeLab,
    },
    Field {
        id: InstrLab,
        llvm_instr: &'a llvm_ir::instruction::GetElementPtr,
        lhs_var: VarIdent,
        struct_id: StructIdent,
        rhs_var: VarIdent,
        field_idx: usize,
        rhs_typelab: TypeLab,
    },
    Element {
        id: InstrLab,
        llvm_instr: &'a llvm_ir::instruction::GetElementPtr,
        lhs_var: VarIdent,
        rhs_var: VarIdent,
        elem_var: Option<VarIdent>,
        rhs_typelab: TypeLab,
    },
    Call {
        id: InstrLab,
        llvm_instr: &'a llvm_ir::instruction::Call,
        lhs_var: Option<VarIdent>,
        callee: FuncIdent,
        arg_vars: Vec<Option<VarIdent>>,
        arg_typelabs: Vec<TypeLab>,
    },
    Phi {
        id: InstrLab,
        llvm_instr: &'a llvm_ir::instruction::Phi,
        lhs_var: VarIdent,
        operand_vars: Vec<Option<VarIdent>>,
        operand_typelabs: Vec<TypeLab>,
    },
    Use {
        id: InstrLab,
        llvm_instr: Either<&'a llvm_ir::Instruction, &'a llvm_ir::Terminator>,
        llvm_operands: Vec<llvm_ir::Operand>,
        lhs_var: Option<VarIdent>,
        operand_vars: Vec<Option<VarIdent>>,
        operand_typelabs: Vec<TypeLab>,
        successors: Option<Vec<BasicBlockIdent>>,
    },
    /* Terminators ---------------------------------------------------------- */
    Br {
        id: InstrLab,
        llvm_instr: &'a llvm_ir::terminator::Br,
        target: BasicBlockIdent,
    },
    CondBr {
        id: InstrLab,
        llvm_instr: &'a llvm_ir::terminator::CondBr,
        cond_var: Option<VarIdent>,
        cond_typelab: TypeLab,
        then_target: BasicBlockIdent,
        else_target: BasicBlockIdent,
    },
    Ret {
        id: InstrLab,
        llvm_instr: &'a llvm_ir::terminator::Ret,
        rhs_var: Option<VarIdent>,
        rhs_typelab: TypeLab,
    },
    Switch {
        id: InstrLab,
        llvm_instr: &'a llvm_ir::terminator::Switch,
        cond_var: Option<VarIdent>,
        cond_typelab: TypeLab,
        targets: Vec<BasicBlockIdent>,
    },
    Unreachable {
        id: InstrLab,
        llvm_instr: &'a llvm_ir::terminator::Unreachable,
    },
}

impl<'a> Instruction<'a> {
    /// Gets the instruction label for `self`.
    pub fn id(&self) -> &InstrLab {
        match self {
            Instruction::Alloca { id, .. } => id,
            Instruction::Load { id, .. } => id,
            Instruction::Store { id, .. } => id,
            Instruction::Field { id, .. } => id,
            Instruction::Element { id, .. } => id,
            Instruction::Call { id, .. } => id,
            Instruction::Phi { id, .. } => id,
            Instruction::Use { id, .. } => id,
            Instruction::Br { id, .. } => id,
            Instruction::CondBr { id, .. } => id,
            Instruction::Ret { id, .. } => id,
            Instruction::Switch { id, .. } => id,
            Instruction::Unreachable { id, .. } => id,
        }
    }

    /// Sets the instruction label for `self`.
    pub fn set_id(&mut self, new_id: InstrLab) {
        match self {
            Instruction::Alloca { id, .. } => *id = new_id,
            Instruction::Load { id, .. } => *id = new_id,
            Instruction::Store { id, .. } => *id = new_id,
            Instruction::Field { id, .. } => *id = new_id,
            Instruction::Element { id, .. } => *id = new_id,
            Instruction::Call { id, .. } => *id = new_id,
            Instruction::Phi { id, .. } => *id = new_id,
            Instruction::Use { id, .. } => *id = new_id,
            Instruction::Br { id, .. } => *id = new_id,
            Instruction::CondBr { id, .. } => *id = new_id,
            Instruction::Ret { id, .. } => *id = new_id,
            Instruction::Switch { id, .. } => *id = new_id,
            Instruction::Unreachable { id, .. } => *id = new_id,
        }
    }

    /// Gets the local variable declared by `self`.
    pub fn try_decl(&self) -> Option<VarIdent> {
        match self {
            Self::Alloca {
                id: _,
                llvm_instr: _,
                lhs_var,
            } => Some(*lhs_var),
            Self::Load {
                id: _,
                llvm_instr: _,
                lhs_var,
                rhs_var: _,
                rhs_typelab: _,
            } => Some(*lhs_var),
            Self::Store { .. } => None,
            Self::Field {
                id: _,
                llvm_instr: _,
                lhs_var,
                struct_id: _,
                rhs_var: _,
                field_idx: _,
                rhs_typelab: _,
            } => Some(*lhs_var),
            Self::Element {
                id: _,
                llvm_instr: _,
                lhs_var,
                rhs_var: _,
                elem_var: _,
                rhs_typelab: _,
            } => Some(*lhs_var),
            Self::Call {
                id: _,
                llvm_instr: _,
                lhs_var,
                callee: _,
                arg_vars: _,
                arg_typelabs: _,
            } => *lhs_var,
            Self::Phi {
                id: _,
                llvm_instr: _,
                lhs_var,
                operand_vars: _,
                operand_typelabs: _,
            } => Some(*lhs_var),
            Self::Use {
                id: _,
                llvm_instr: _,
                llvm_operands: _,
                lhs_var,
                operand_vars: _,
                operand_typelabs: _,
                successors: _,
            } => *lhs_var,
            Self::Br { .. } => None,
            Self::CondBr { .. } => None,
            Self::Ret { .. } => None,
            Self::Switch { .. } => None,
            Self::Unreachable { .. } => None,
        }
    }

    /// Gets the LLVM name of local variable declared by `self`.
    pub fn try_result(&self) -> Option<&llvm_ir::Name> {
        match self {
            Self::Alloca {
                id: _,
                llvm_instr,
                lhs_var: _,
            } => Some(llvm_instr.get_result()),
            Self::Load {
                id: _,
                llvm_instr,
                lhs_var: _,
                rhs_var: _,
                rhs_typelab: _,
            } => Some(llvm_instr.get_result()),
            Self::Store { .. } => None,
            Self::Field {
                id: _,
                llvm_instr,
                lhs_var: _,
                struct_id: _,
                rhs_var: _,
                field_idx: _,
                rhs_typelab: _,
            } => Some(llvm_instr.get_result()),
            Self::Element {
                id: _,
                llvm_instr,
                lhs_var: _,
                rhs_var: _,
                elem_var: _,
                rhs_typelab: _,
            } => Some(llvm_instr.get_result()),
            Self::Call {
                id: _,
                llvm_instr,
                lhs_var: _,
                callee: _,
                arg_vars: _,
                arg_typelabs: _,
            } => llvm_instr.dest.as_ref(),
            Self::Phi {
                id: _,
                llvm_instr,
                lhs_var: _,
                operand_vars: _,
                operand_typelabs: _,
            } => Some(llvm_instr.get_result()),
            Self::Use {
                id: _,
                llvm_instr,
                llvm_operands: _,
                lhs_var: _,
                operand_vars: _,
                operand_typelabs: _,
                successors: _,
            } => match llvm_instr {
                Either::Left(instr) => instr.try_get_result(),
                Either::Right(term) => term.try_get_result(),
            },
            Self::Br { .. } => None,
            Self::CondBr { .. } => None,
            Self::Ret { .. } => None,
            Self::Switch { .. } => None,
            Self::Unreachable { .. } => None,
        }
    }

    /// Produces an incomplete `Self::Use` from a LLVM IR binary operator
    /// instruction.
    ///
    /// # Panics
    /// - If `instr` isn't a binary op.
    fn from_binop(labels: &Labels, func: &FuncIdent, instr: &'a llvm_ir::Instruction) -> Self {
        let id = InstrLab::default();
        let as_binop = TryInto::<llvm_ir::instruction::groups::BinaryOp>::try_into(instr.clone())
            .expect("`instr` should be a binary op");
        Self::Use {
            id,
            llvm_instr: Either::Left(instr),
            llvm_operands: vec![
                as_binop.get_operand0().clone(),
                as_binop.get_operand1().clone(),
            ],
            lhs_var: Some(labels.find_var(func, as_binop.get_result())),
            operand_vars: vec![
                labels.extract_var(func, as_binop.get_operand0()),
                labels.extract_var(func, as_binop.get_operand1()),
            ],
            operand_typelabs: vec![],
            successors: None,
        }
    }

    /// Produces an incomplete `Self::Use` from a LLVM IR unary operator
    /// instruction.
    ///
    /// # Panics
    /// - If `instr` isn't a unary op.
    fn from_unop(labels: &Labels, func: &FuncIdent, instr: &'a llvm_ir::Instruction) -> Self {
        let id = InstrLab::default();
        let as_unop = TryInto::<llvm_ir::instruction::groups::UnaryOp>::try_into(instr.clone())
            .expect("`instr` should be a unary op");
        Self::Use {
            id,
            llvm_instr: Either::Left(instr),
            llvm_operands: vec![as_unop.get_operand().clone()],
            lhs_var: Some(labels.find_var(func, as_unop.get_result())),
            operand_vars: vec![labels.extract_var(func, as_unop.get_operand())],
            operand_typelabs: vec![],
            successors: None,
        }
    }

    /// Extracts the callee identifier from an operand.
    ///
    /// # Panics
    /// - if the operand isn't a global reference.
    fn extract_callee(operand: &llvm_ir::Operand) -> FuncIdent {
        match operand {
            llvm_ir::Operand::ConstantOperand(c) => match &**c {
                llvm_ir::Constant::GlobalReference { name, ty: _ } => match name {
                    llvm_ir::Name::Name(name) => FuncIdent(name.to_string()),
                    _ => unreachable!(),
                },
                _ => panic!(" ERR: Function callee isn't a global reference."),
            },
            _ => panic!(" ERR: Function pointers unsupported."),
        }
    }

    /// Produces an incomplete `Self` from an LLVM IR instruction.
    ///
    /// All fields that involve `TypeLab`s or `InstrLab`s are unset in the
    /// return value. `func` is the identifier of the function that contains
    /// this instruction.
    pub fn from_instr(
        labels: &Labels,
        func: &FuncIdent,
        instr: &'a llvm_ir::Instruction,
    ) -> Option<Self> {
        let id = InstrLab::default();
        let typelab = TypeLab::default();
        match instr {
            /* Unsupported instructions (for now) --------------------------- */
            llvm_ir::Instruction::ExtractElement(_llvm_instr) => todo!(),
            llvm_ir::Instruction::InsertElement(_llvm_instr) => todo!(),
            llvm_ir::Instruction::ShuffleVector(_llvm_instr) => todo!(),
            llvm_ir::Instruction::ExtractValue(_llvm_instr) => todo!(),
            llvm_ir::Instruction::InsertValue(_llvm_instr) => todo!(),
            llvm_ir::Instruction::Fence(_llvm_instr) => todo!(),
            llvm_ir::Instruction::CmpXchg(_llvm_instr) => todo!(),
            llvm_ir::Instruction::AtomicRMW(_llvm_instr) => todo!(),
            llvm_ir::Instruction::Select(_llvm_instr) => todo!(),
            llvm_ir::Instruction::VAArg(_llvm_instr) => todo!(),
            llvm_ir::Instruction::LandingPad(_llvm_instr) => todo!(),
            llvm_ir::Instruction::CatchPad(_llvm_instr) => todo!(),
            llvm_ir::Instruction::CleanupPad(_llvm_instr) => todo!(),
            /* Binary operator instructions --------------------------------- */
            llvm_ir::Instruction::Add(_)
            | llvm_ir::Instruction::Sub(_)
            | llvm_ir::Instruction::Mul(_)
            | llvm_ir::Instruction::UDiv(_)
            | llvm_ir::Instruction::SDiv(_)
            | llvm_ir::Instruction::URem(_)
            | llvm_ir::Instruction::SRem(_)
            | llvm_ir::Instruction::And(_)
            | llvm_ir::Instruction::Or(_)
            | llvm_ir::Instruction::Xor(_)
            | llvm_ir::Instruction::Shl(_)
            | llvm_ir::Instruction::LShr(_)
            | llvm_ir::Instruction::AShr(_)
            | llvm_ir::Instruction::FAdd(_)
            | llvm_ir::Instruction::FSub(_)
            | llvm_ir::Instruction::FMul(_)
            | llvm_ir::Instruction::FDiv(_)
            | llvm_ir::Instruction::FRem(_) => Some(Self::from_binop(labels, func, instr)),
            /* Unary operator instructions ---------------------------------- */
            llvm_ir::Instruction::FNeg(_)
            | llvm_ir::Instruction::FPExt(_)
            | llvm_ir::Instruction::FPToSI(_)
            | llvm_ir::Instruction::FPToUI(_)
            | llvm_ir::Instruction::FPTrunc(_)
            | llvm_ir::Instruction::SExt(_)
            | llvm_ir::Instruction::SIToFP(_)
            | llvm_ir::Instruction::Trunc(_)
            | llvm_ir::Instruction::UIToFP(_)
            | llvm_ir::Instruction::ZExt(_) => Some(Self::from_unop(labels, func, instr)),
            /* Unsupported unary operator instructions ---------------------- */
            llvm_ir::Instruction::AddrSpaceCast(_) => todo!(),
            llvm_ir::Instruction::BitCast(_) => todo!(),
            llvm_ir::Instruction::Freeze(_) => todo!(),
            llvm_ir::Instruction::IntToPtr(_) => todo!(),
            llvm_ir::Instruction::PtrToInt(_) => todo!(),
            /* Other instructions --------------------------------------------*/
            llvm_ir::Instruction::ICmp(llvm_instr) => Some(Self::Use {
                id,
                llvm_instr: Either::Left(instr),
                llvm_operands: vec![llvm_instr.operand0.clone(), llvm_instr.operand1.clone()],
                lhs_var: Some(labels.find_var(func, &llvm_instr.dest)),
                operand_vars: vec![
                    labels.extract_var(func, &llvm_instr.operand0),
                    labels.extract_var(func, &llvm_instr.operand1),
                ],
                operand_typelabs: vec![],
                successors: None,
            }),
            llvm_ir::Instruction::FCmp(llvm_instr) => Some(Self::Use {
                id,
                llvm_instr: Either::Left(instr),
                llvm_operands: vec![llvm_instr.operand0.clone(), llvm_instr.operand1.clone()],
                lhs_var: Some(labels.find_var(func, &llvm_instr.dest)),
                operand_vars: vec![
                    labels.extract_var(func, &llvm_instr.operand0),
                    labels.extract_var(func, &llvm_instr.operand1),
                ],
                operand_typelabs: vec![],
                successors: None,
            }),
            /* Memory access instructions ----------------------------------- */
            llvm_ir::Instruction::Alloca(llvm_instr) => Some(Self::Alloca {
                id,
                llvm_instr,
                lhs_var: labels.find_var(func, &llvm_instr.dest),
            }),
            llvm_ir::Instruction::Load(llvm_instr) => Some(Self::Load {
                id,
                llvm_instr,
                lhs_var: labels.find_var(func, &llvm_instr.dest),
                rhs_var: labels
                    .extract_var(func, &llvm_instr.address)
                    .expect("`load` should always have a variable RHS"),
                rhs_typelab: typelab,
            }),
            llvm_ir::Instruction::Store(llvm_instr) => {
                match labels.extract_var(func, &llvm_instr.address) {
                    Some(lhs_var) => Some(Self::Store {
                        id,
                        llvm_instr,
                        lhs_var,
                        rhs_var: labels.extract_var(func, &llvm_instr.value),
                        rhs_typelab: typelab,
                    }),
                    None => {
                        eprintln!("WARN: Encountered `store` with non-variable LHS");
                        None
                    }
                }
            }
            llvm_ir::Instruction::GetElementPtr(llvm_instr) => {
                let lhs_var = labels.find_var(func, &llvm_instr.dest);
                let rhs_var = labels
                    .extract_var(func, &llvm_instr.address)
                    .expect("Operand of `getelementptr` should always be a variable");
                if llvm_instr.indices.len() == 2
                    && let llvm_ir::Type::NamedStructType { name } =
                        &*llvm_instr.source_element_type
                {
                    let struct_id = StructIdent(name.to_string());
                    let field_idx = match llvm_instr
                        .indices
                        .get(1)
                        .expect("Guarded by if-condition")
                        .as_constant()
                        .expect(
                            "The second index of `getelementptr` on a struct type \
                            should be constant.",
                        ) {
                        llvm_ir::Constant::Int { bits: _, value } => *value as usize,
                        _ => unreachable!(),
                    };
                    Some(Self::Field {
                        id,
                        llvm_instr,
                        lhs_var,
                        struct_id,
                        rhs_var,
                        field_idx,
                        rhs_typelab: typelab,
                    })
                } else {
                    let elem_var = labels.extract_var(
                        func,
                        llvm_instr
                            .indices
                            .last()
                            .expect("`getelementptr` always has at least one index."),
                    );
                    Some(Self::Element {
                        id,
                        llvm_instr,
                        lhs_var,
                        rhs_var,
                        elem_var,
                        rhs_typelab: TypeLab::default(),
                    })
                }
            }
            /* Otherwise relevant instructions ------------------------------ */
            llvm_ir::Instruction::Call(llvm_instr) => {
                let lhs_var = llvm_instr
                    .dest
                    .as_ref()
                    .map(|name| labels.find_var(func, name));
                let callee = match &llvm_instr.function {
                    Either::Left(_) => panic!(" ERR: Inline assembly unsupported."),
                    Either::Right(operand) => Self::extract_callee(operand),
                };

                if BAD_CALL_REGEX.is_match(&callee.0) {
                    None
                } else {
                    let arg_vars: Vec<Option<VarIdent>> = llvm_instr
                        .arguments
                        .iter()
                        .map(|(operand, _)| labels.extract_var(func, operand))
                        .collect();
                    Some(Self::Call {
                        id,
                        llvm_instr,
                        lhs_var,
                        callee,
                        arg_vars,
                        arg_typelabs: Vec::default(),
                    })
                }
            }
            llvm_ir::Instruction::Phi(llvm_instr) => {
                let lhs_var = labels.find_var(func, &llvm_instr.dest);
                let operand_vars: Vec<Option<VarIdent>> = llvm_instr
                    .incoming_values
                    .iter()
                    .map(|(operand, _)| labels.extract_var(func, operand))
                    .collect();
                Some(Self::Phi {
                    id,
                    llvm_instr,
                    lhs_var,
                    operand_vars,
                    operand_typelabs: Vec::default(),
                })
            }
        }
    }

    /// Produces an incomplete `Self` from an LLVM IR terminator.
    ///
    /// All fields that involve `TypeLab`s or `InstrLab`s are unset in the
    /// return value. `func` is the identifier of the function that contains
    /// this instruction.
    pub fn from_term(labels: &Labels, func: &FuncIdent, term: &'a llvm_ir::Terminator) -> Self {
        let id = InstrLab::default();
        let typelab = TypeLab::default();
        match term {
            /* Unsupported instructions (for now) --------------------------- */
            llvm_ir::Terminator::Invoke(_) => todo!(),
            llvm_ir::Terminator::Resume(_) => todo!(),
            llvm_ir::Terminator::CallBr(_) => todo!(),
            llvm_ir::Terminator::CatchRet(_) => todo!(),
            llvm_ir::Terminator::CatchSwitch(_) => todo!(),
            llvm_ir::Terminator::CleanupRet(_) => todo!(),
            llvm_ir::Terminator::IndirectBr(_) => todo!(),
            /* Supported instructions --------------------------------------- */
            llvm_ir::Terminator::Br(llvm_instr) => Self::Br {
                id,
                llvm_instr,
                target: labels.find_bb(func, &llvm_instr.dest),
            },
            llvm_ir::Terminator::CondBr(llvm_instr) => Self::CondBr {
                id,
                llvm_instr,
                cond_var: labels.extract_var(func, &llvm_instr.condition),
                cond_typelab: typelab,
                then_target: labels.find_bb(func, &llvm_instr.true_dest),
                else_target: labels.find_bb(func, &llvm_instr.false_dest),
            },
            llvm_ir::Terminator::Switch(llvm_instr) => Self::Switch {
                id,
                llvm_instr,
                cond_var: labels.extract_var(func, &llvm_instr.operand),
                cond_typelab: typelab,
                targets: llvm_instr
                    .dests
                    .iter()
                    .map(|(_, name)| labels.find_bb(func, name))
                    .collect(),
            },
            llvm_ir::Terminator::Ret(llvm_instr) => Self::Ret {
                id,
                llvm_instr,
                rhs_var: llvm_instr
                    .return_operand
                    .as_ref()
                    .and_then(|operand| labels.extract_var(func, operand)),
                rhs_typelab: typelab,
            },
            llvm_ir::Terminator::Unreachable(llvm_instr) => Self::Unreachable { id, llvm_instr },
        }
    }
}
