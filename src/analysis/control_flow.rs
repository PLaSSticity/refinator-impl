//! # Intraprocedural Control Flow Graphs
//!
//! This module implements intraprocedural control flow graph generation from
//! a `crate::program::Function`.

use std::{
    collections::{HashMap, HashSet},
    io::Result,
};

use crate::lang::{
    basic_block::{BasicBlock, BasicBlockIdent},
    function::Function,
    instruction::Instruction,
};

/// A node in the control flow graph.
/// Each node in the control flow graph corresponds to a basic block in the
/// program.
pub struct ControlFlowNode<'a> {
    pub id: BasicBlockIdent,
    pub basic_block: &'a BasicBlock<'a>,
    successors: Vec<BasicBlockIdent>,
    predecessors: Vec<BasicBlockIdent>,
}

impl<'a> ControlFlowNode<'a> {
    /// Gets a vector of CFG nodes that are successors of this node in `cfg`.
    pub fn successors<'b>(&self, cfg: &'b ControlFlowGraph) -> Vec<&'b ControlFlowNode<'b>> {
        self.successors
            .iter()
            .map(|id| cfg.nodes.get(id).unwrap())
            .collect()
    }

    /// Gets a vector of CFG nodes that are predecessors of this node in `cfg`.
    pub fn predecessors<'b>(&self, cfg: &'b ControlFlowGraph) -> Vec<&'b ControlFlowNode<'b>> {
        self.predecessors
            .iter()
            .map(|id| cfg.nodes.get(id).unwrap())
            .collect()
    }

    /// Prints this node to `out` formatted as a DOT node.
    pub fn dot_print(&self, out: &mut impl std::io::Write) -> Result<()> {
        write!(
            out,
            "{} [shape=box, label=\"{}\"]",
            self.id.0, self.basic_block.llvm_bb.name
        )
    }
}

/// An intraprocedural control flow graph for the function `function`.
pub struct ControlFlowGraph<'a> {
    pub function: &'a Function<'a>,
    nodes: HashMap<BasicBlockIdent, ControlFlowNode<'a>>,
    entry: BasicBlockIdent,
    exits: Vec<BasicBlockIdent>,
}

impl<'a> ControlFlowGraph<'a> {
    /// Constructs an intraprocedural control flow graph for function `function`.
    ///
    /// # Panics
    /// - If `function` has no body (no basic blocks).
    pub fn construct(function: &'a Function<'a>) -> ControlFlowGraph<'a> {
        // 1. Produce CFG nodes.
        let mut nodes = HashMap::new();

        // `BasicBlockIdent` of the first basic block.
        let entry = function
            .basic_blocks
            .first()
            .expect("`function` should have at least one basic block.")
            .id;
        // `BasicBlockIdent`s of the exit nodes.
        let mut exits = vec![];

        for basic_block in &function.basic_blocks {
            nodes.insert(
                basic_block.id,
                ControlFlowNode {
                    id: basic_block.id,
                    basic_block,
                    successors: vec![],
                    predecessors: vec![],
                },
            );
            if matches!(
                basic_block.instructions.last().unwrap(),
                Instruction::Ret { .. }
            ) {
                exits.push(basic_block.id);
            }
        }

        // 2. Insert CFG edges.
        let mut edges = HashSet::new();
        for node in nodes.values() {
            match node
                .basic_block
                .instructions
                .last()
                .expect("Each basic block should be non-empty")
            {
                /* Non-terminators ------------------------------------------ */
                Instruction::Alloca { .. } => unreachable!(),
                Instruction::Load { .. } => unreachable!(),
                Instruction::Store { .. } => unreachable!(),
                Instruction::Field { .. } => unreachable!(),
                Instruction::Element { .. } => unreachable!(),
                Instruction::Call { .. } => unreachable!(),
                Instruction::Phi { .. } => unreachable!(),
                /* Terminators ---------------------------------------------- */
                Instruction::Br {
                    id: _,
                    llvm_instr: _,
                    target,
                } => {
                    edges.insert((node.id, *target));
                }
                Instruction::CondBr {
                    id: _,
                    llvm_instr: _,
                    cond_var: _,
                    cond_typelab: _,
                    then_target,
                    else_target,
                } => {
                    edges.insert((node.id, *then_target));
                    edges.insert((node.id, *else_target));
                }
                Instruction::Ret {
                    id: _,
                    llvm_instr: _,
                    rhs_var: _,
                    rhs_typelab: _,
                } => continue,
                Instruction::Switch {
                    id: _,
                    llvm_instr: _,
                    cond_var: _,
                    cond_typelab: _,
                    targets,
                } => {
                    for target in targets {
                        edges.insert((node.id, *target));
                    }
                }
                Instruction::Unreachable {
                    id: _,
                    llvm_instr: _,
                } => continue,
                /* Use ------------------------------------------------------ */
                Instruction::Use {
                    id: _,
                    llvm_instr: _,
                    llvm_operands: _,
                    lhs_var: _,
                    operand_vars: _,
                    operand_typelabs: _,
                    successors,
                } => match successors {
                    Some(successors) => {
                        for target in successors {
                            edges.insert((node.id, *target));
                        }
                    }
                    None => continue,
                },
            };
        }

        for (src, dst) in edges {
            nodes
                .get_mut(&src)
                .expect(
                    "Every `BasicBlockIdent` of a basic block in this function \
                    is a key in `nodes`.",
                )
                .successors
                .push(dst);
            nodes
                .get_mut(&dst)
                .expect(
                    "Every `BasicBlockIdent` of a basic block in this function \
                    is a key in `nodes`.",
                )
                .predecessors
                .push(src);
        }

        ControlFlowGraph {
            function,
            nodes,
            entry,
            exits,
        }
    }

    /// Gets the CFG node with id `id`.
    ///
    /// # Panics
    /// - if `id` is not the id of a node in `self`
    pub fn get(&'a self, id: &BasicBlockIdent) -> &'a ControlFlowNode<'a> {
        self.nodes.get(id).unwrap()
    }

    /// Gets a vector of all CFG nodes.
    pub fn nodes(&'a self) -> Vec<&'a ControlFlowNode<'a>> {
        self.nodes.values().collect()
    }

    /// Gets the entry CFG node.
    pub fn entry(&'a self) -> &'a ControlFlowNode<'a> {
        self.nodes.get(&self.entry).unwrap()
    }

    /// Gets a vector of exit CFG nodes; that is, nodes corresponding to basic
    /// blocks that end with a return.
    pub fn exits(&'a self) -> Vec<&'a ControlFlowNode<'a>> {
        self.exits
            .iter()
            .map(|id| self.nodes.get(id).unwrap())
            .collect()
    }

    /// Gets a vector of CFG nodes that are successors of `node`.
    pub fn successors(&'a self, node: &ControlFlowNode) -> Vec<&'a ControlFlowNode<'a>> {
        node.successors(self)
    }

    /// Gets a vector of CFG nodes that are predecessors of `node`.
    pub fn predecessors(&'a self, node: &ControlFlowNode) -> Vec<&'a ControlFlowNode<'a>> {
        node.predecessors(self)
    }

    /// Prints this CFG to `out` formatted as a DOT digraph.
    pub fn dot_print(&self, out: &mut impl std::io::Write) -> Result<()> {
        writeln!(out, "digraph {{")?;
        for node in self.nodes.values() {
            node.dot_print(out)?;
            writeln!(out)?;
        }
        for node in self.nodes.values() {
            for target in &node.successors {
                writeln!(out, "{} -> {}", node.id.0, target.0)?;
            }
        }
        writeln!(out, "}}")
    }
}
