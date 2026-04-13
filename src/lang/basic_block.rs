//! # Source Language Basic Blocks

use crate::lang::instruction::Instruction;

/// Newtype for basic block identifiers.
#[derive(Clone, Copy, PartialOrd, Ord, PartialEq, Eq, Hash)]
pub struct BasicBlockIdent(pub usize);

/// A basic block in the source language.
pub struct BasicBlock<'a> {
    pub id: BasicBlockIdent,
    pub llvm_bb: &'a llvm_ir::basicblock::BasicBlock,
    pub instructions: Vec<Instruction<'a>>,
}

impl BasicBlock<'_> {
    /// Gets the number of instructions in `self`.
    pub fn num_instrs(&self) -> usize {
        self.instructions.len()
    }
}
