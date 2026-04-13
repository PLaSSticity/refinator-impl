//! # Source Language Functions

use std::fmt::Display;

use either::Either;

use crate::lang::{
    basic_block::BasicBlock, instruction::Instruction, stype::TypeLab, variable::VarIdent,
};

/// Newtype for function identifiers.
#[derive(Clone, PartialOrd, Ord, PartialEq, Eq, Hash)]
pub struct FuncIdent(pub String);

impl Display for FuncIdent {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0)
    }
}

/// A function in the source language.
pub struct Function<'a> {
    pub id: FuncIdent,
    pub llvm_func: Either<&'a llvm_ir::Function, &'a llvm_ir::function::FunctionDeclaration>,
    pub ret_typelabs: Vec<TypeLab>,
    pub param_vars: Vec<VarIdent>,
    pub basic_blocks: Vec<BasicBlock<'a>>,
}

impl Function<'_> {
    /// Gets the stack variables declared in `self`.
    pub fn decl_stack_vars(&self) -> Vec<VarIdent> {
        let mut result = vec![];
        for basic_block in &self.basic_blocks {
            for instr in &basic_block.instructions {
                if let Instruction::Alloca { lhs_var, .. } = instr {
                    result.push(*lhs_var);
                }
            }
        }
        result
    }

    /// Gets the register variables declared in `self`.
    pub fn decl_reg_vars(&self) -> Vec<VarIdent> {
        let mut result = vec![];
        result.append(&mut self.param_vars.clone());

        for basic_block in &self.basic_blocks {
            for instr in &basic_block.instructions {
                match instr {
                    Instruction::Load { lhs_var, .. }
                    | Instruction::Field { lhs_var, .. }
                    | Instruction::Element { lhs_var, .. }
                    | Instruction::Call {
                        lhs_var: Some(lhs_var),
                        ..
                    }
                    | Instruction::Phi { lhs_var, .. }
                    | Instruction::Use {
                        lhs_var: Some(lhs_var),
                        ..
                    } => result.push(*lhs_var),
                    _ => (),
                }
            }
        }
        result
    }

    /// Gets all variables declared in `self`.
    pub fn decl_vars(&self) -> Vec<VarIdent> {
        let mut result = self.decl_stack_vars();
        result.append(&mut self.decl_reg_vars());
        result
    }

    /// Gets the number of instructions in `self`.
    pub fn num_instrs(&self) -> usize {
        self.basic_blocks.iter().map(|bb| bb.num_instrs()).sum()
    }
}
