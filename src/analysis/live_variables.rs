//! # Live Variables Analysis
//!
//! This module implements live-variables analysis.

use std::collections::{HashMap, HashSet};

use crate::{
    analysis::control_flow::ControlFlowGraph,
    lang::{
        function::FuncIdent,
        instruction::{InstrLab, Instruction},
        variable::VarIdent,
    },
};

/// A live-variables analysis of the function in `cfg`.
pub struct LiveVariables {
    pub func: FuncIdent,
    facts_before: HashMap<InstrLab, HashSet<VarIdent>>,
    facts_after: HashMap<InstrLab, HashSet<VarIdent>>,
}

impl LiveVariables {
    /// Computes a live-variables analysis of the function in `cfg`.
    pub fn analyze(cfg: &ControlFlowGraph) -> LiveVariables {
        // Initialize facts_before, facts_after to L |-> { } for each L ∈ InstrLab.
        let mut facts_before = HashMap::<InstrLab, HashSet<VarIdent>>::new();
        let mut facts_after = HashMap::<InstrLab, HashSet<VarIdent>>::new();

        for cfg_node in cfg.nodes() {
            for instr in &cfg_node.basic_block.instructions {
                facts_before.insert(*instr.id(), HashSet::new());
                facts_after.insert(*instr.id(), HashSet::new());
            }
        }

        // The usual fixed-point algorithm.
        let mut worklist: Vec<_> = cfg.nodes();
        while let Some(cfg_node) = worklist.pop() {
            let mut changed = false;

            let mut facts = HashSet::new();
            for successor_node in cfg_node.successors(cfg) {
                for var in facts_before
                    .get(
                        successor_node
                            .basic_block
                            .instructions
                            .first()
                            .unwrap()
                            .id(),
                    )
                    .unwrap()
                {
                    facts.insert(*var);
                }
            }

            let lab = *cfg_node.basic_block.instructions.last().unwrap().id();
            if facts != *facts_after.get(&lab).unwrap() {
                changed = true;
                facts_after.insert(lab, facts);
            }

            let mut instrs: Vec<_> = cfg_node.basic_block.instructions.iter().collect();

            while let Some(instr) = instrs.pop() {
                let id = instr.id();
                let mut facts = facts_after.get(id).unwrap().clone();
                match instr {
                    Instruction::Alloca { lhs_var, .. } => {
                        facts.remove(lhs_var);
                    }
                    Instruction::Load {
                        lhs_var, rhs_var, ..
                    } => {
                        facts.remove(lhs_var);
                        facts.insert(*rhs_var);
                    }
                    Instruction::Store {
                        lhs_var, rhs_var, ..
                    } => {
                        facts.insert(*lhs_var);
                        if let Some(rhs_var) = rhs_var {
                            facts.insert(*rhs_var);
                        }
                    }
                    Instruction::Field {
                        lhs_var, rhs_var, ..
                    } => {
                        facts.remove(lhs_var);
                        facts.insert(*rhs_var);
                    }
                    Instruction::Element {
                        lhs_var,
                        rhs_var,
                        elem_var,
                        ..
                    } => {
                        facts.remove(lhs_var);
                        facts.insert(*rhs_var);
                        if let Some(elem_var) = elem_var {
                            facts.insert(*elem_var);
                        }
                    }
                    Instruction::Call {
                        lhs_var, arg_vars, ..
                    } => {
                        if let Some(lhs_var) = lhs_var {
                            facts.remove(lhs_var);
                        }
                        for arg_var in arg_vars.iter().flatten() {
                            facts.insert(*arg_var);
                        }
                    }
                    Instruction::Phi {
                        lhs_var,
                        operand_vars,
                        ..
                    } => {
                        facts.remove(lhs_var);
                        for operand_var in operand_vars.iter().flatten() {
                            facts.insert(*operand_var);
                        }
                    }
                    Instruction::Use {
                        lhs_var,
                        operand_vars,
                        ..
                    } => {
                        if let Some(lhs_var) = lhs_var {
                            facts.remove(lhs_var);
                        }
                        for operand_var in operand_vars.iter().flatten() {
                            facts.insert(*operand_var);
                        }
                    }
                    Instruction::Br { .. } => (),
                    Instruction::CondBr { cond_var, .. } => {
                        if let Some(cond_var) = cond_var {
                            facts.insert(*cond_var);
                        }
                    }
                    Instruction::Ret { rhs_var, .. } => {
                        if let Some(rhs_var) = rhs_var {
                            facts.insert(*rhs_var);
                        }
                    }
                    Instruction::Switch { cond_var, .. } => {
                        if let Some(cond_var) = cond_var {
                            facts.insert(*cond_var);
                        }
                    }
                    Instruction::Unreachable { .. } => (),
                }
                if let Some(instr) = instrs.last() {
                    facts_after.insert(*instr.id(), facts.clone());
                } else {
                    changed |= facts != *facts_before.get(id).unwrap();
                }
                facts_before.insert(*id, facts);
            }

            if changed {
                for pred_node in cfg_node.predecessors(cfg) {
                    worklist.push(pred_node);
                }
            }
        }

        LiveVariables {
            func: cfg.function.id.clone(),
            facts_before,
            facts_after,
        }
    }

    /// Gets a list of variables live immediately before `lab`.
    ///
    /// # Panics
    /// If `lab` is not the label of any instruction in the function
    /// `self.function`.
    pub fn before(&self, lab: &InstrLab) -> Vec<&VarIdent> {
        self.facts_before.get(lab).unwrap().iter().collect()
    }

    /// Gets a list of variables live immediately after `lab`.
    ///
    /// # Panics
    /// If `lab` is not the label of any instruction in the function
    /// `self.function`.
    pub fn after(&self, lab: &InstrLab) -> Vec<&VarIdent> {
        self.facts_after.get(lab).unwrap().iter().collect()
    }

    /// Checks if `var` is live immediately before `lab`.
    ///
    /// # Panics
    /// If `lab` is not the label of any instruction in the function
    /// `self.function`.
    pub fn live_before(&self, var: &VarIdent, lab: &InstrLab) -> bool {
        self.facts_before.get(lab).unwrap().contains(var)
    }

    /// Checks if `var` is live immediately after `lab`.
    ///
    /// # Panics
    /// If `lab` is not the label of any instruction in the function
    /// `self.function`.
    pub fn live_after(&self, var: &VarIdent, lab: &InstrLab) -> bool {
        self.facts_after.get(lab).unwrap().contains(var)
    }
}
