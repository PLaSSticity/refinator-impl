//! # Drop analysis
//!
//! This module implements an analysis which infers where to insert drops of
//! variables into the program.
//!
//! For stack variables (i.e. those allocated with alloca), those are dropped
//! at EXIT.
//!
//! For each register variable `x`, `x` is dropped at the beginning of the basic
//! block that is the immediate postdominator of the nearest common
//! postdominator of all basic blocks where `x` is live.

use std::collections::{HashMap, HashSet, VecDeque};

use petgraph::{Graph, algo::dominators, graph::NodeIndex};

use crate::{
    analysis::{
        control_flow::{ControlFlowGraph, ControlFlowNode},
        live_variables::LiveVariables,
    },
    lang::{
        basic_block::{BasicBlock, BasicBlockIdent},
        function::{FuncIdent, Function},
        instruction::Instruction,
        variable::VarIdent,
    },
};

/// A node in the control flow graph, used in this analysis.
#[derive(Clone)]
pub enum DropControlFlowNode<'a> {
    Entry,
    Exit,
    Interior(&'a ControlFlowNode<'a>),
}

/// A `DROP` insertion analysis.
pub struct DropAnalysis {
    pub func: FuncIdent,
    interior_drops: HashMap<BasicBlockIdent, Vec<VarIdent>>,
    exit_drops: Vec<VarIdent>,
}

impl DropAnalysis {
    pub fn find_drop_points<'a>(
        function: &Function,
        control_flow: &'a ControlFlowGraph<'a>,
        live_variables: &LiveVariables,
    ) -> HashMap<VarIdent, DropControlFlowNode<'a>> {
        let orig_cfg = control_flow;
        let orig_func = function;

        // Construct the control flow graph using `DropControlFlowNode`.
        let mut cfg = Graph::<DropControlFlowNode, ()>::new();

        let entry = cfg.add_node(DropControlFlowNode::Entry);
        let exit = cfg.add_node(DropControlFlowNode::Exit);

        let mut node_idx = HashMap::<BasicBlockIdent, NodeIndex>::new();
        for node in orig_cfg.nodes() {
            let idx = cfg.add_node(DropControlFlowNode::Interior(node));
            node_idx.insert(node.id, idx);
        }

        cfg.add_edge(entry, *node_idx.get(&orig_cfg.entry().id).unwrap(), ());

        for node in orig_cfg.nodes() {
            let src_idx = *node_idx.get(&node.id).unwrap();
            for successor in orig_cfg.successors(node) {
                let dst_idx = *node_idx.get(&successor.id).unwrap();
                cfg.add_edge(src_idx, dst_idx, ());
            }
        }

        for node in orig_cfg.exits() {
            cfg.add_edge(*node_idx.get(&node.id).unwrap(), exit, ());
        }

        // Pull the stack and register variables declared in this function.
        let stack_vars = orig_func.decl_stack_vars();
        let reg_vars = orig_func.decl_reg_vars();

        // For each register variable, find the set of control flow graph nodes
        // in which it is live.
        let mut blocks_live = HashMap::<VarIdent, HashSet<NodeIndex>>::new();

        for var in &reg_vars {
            blocks_live.insert(*var, HashSet::new());
        }

        for (node_id, node_idx) in &node_idx {
            let orig_node = orig_cfg.get(node_id);
            for instr in &orig_node.basic_block.instructions {
                let lab = instr.id();

                for var in live_variables
                    .before(lab)
                    .into_iter()
                    .chain(live_variables.after(lab).into_iter())
                    .filter(|var| reg_vars.contains(*var))
                {
                    blocks_live.get_mut(var).unwrap().insert(*node_idx);
                }
            }
        }

        // Compute the post-domination relation.
        cfg.reverse();
        let post_dominators = dominators::simple_fast(&cfg, exit);

        // For each variable `x`, compute the nearest common post-dominator of
        // all the CFG nodes where `x` is live; that is, find the nearest common
        // ancestor of all the CFG nodes where `x` is live in the post-dominator
        // tree:
        // 1. for each CFG node `n` where `x` is live, find the path from EXIT
        //    to `n` in the post-dominator tree.
        // 2. compute the common prefix for all of these paths,
        // 3. take the last node in the path as the nearest common
        //    post-dominator.
        let mut common_prefixes = HashMap::<VarIdent, VecDeque<NodeIndex>>::new();

        for (var, live_nodes) in blocks_live.into_iter().filter(|(_, v)| !v.is_empty()) {
            for live_node in live_nodes {
                let mut postdominator_ancestry = VecDeque::from([live_node]);
                let mut n = live_node;
                while let Some(next_n) = post_dominators.immediate_dominator(n) {
                    postdominator_ancestry.push_front(next_n);
                    n = next_n;
                }
                match common_prefixes.get_mut(&var) {
                    None => {
                        // If this variable hasn't been analyzed before, insert
                        // `postdominator_ancestry`.
                        common_prefixes.insert(var, postdominator_ancestry);
                    }
                    Some(prefix) => {
                        // If this variable has been analyzed before, truncate
                        // `prefix` appropriately.
                        let mut i = 0;
                        while i < prefix.len()
                            && i < postdominator_ancestry.len()
                            && prefix[i] == postdominator_ancestry[i]
                        {
                            i += 1;
                        }
                        let _ = prefix.split_off(i);
                    }
                }
            }
        }

        // For each variable `x`, get the immediate post-dominator of the
        // nearest common post-dominator of all CFG nodes where `x` is live.
        let mut drop_points = HashMap::<VarIdent, DropControlFlowNode>::new();

        for (var, prefix) in common_prefixes {
            let node_idx = match prefix.into_iter().last() {
                Some(idx) => idx,
                None => {
                    drop_points.insert(var, DropControlFlowNode::Exit);
                    continue;
                }
            };
            let node_idx = match post_dominators.immediate_dominator(node_idx) {
                Some(node_idx) => node_idx,
                None => node_idx,
            };

            let node = cfg.node_weight(node_idx).unwrap();
            drop_points.insert(var, node.clone());
        }

        // For stack variables, drop at EXIT.
        for var in stack_vars {
            drop_points.insert(var, DropControlFlowNode::Exit);
        }

        drop_points
    }

    /// Computes the order in which variables are allocated in `func`, from
    /// end to beginning.
    fn find_order(func: &Function) -> Vec<VarIdent> {
        let mut result = func.param_vars.clone();
        for basic_block in &func.basic_blocks {
            for instr in &basic_block.instructions {
                match instr {
                    Instruction::Alloca { lhs_var, .. } => result.push(*lhs_var),
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
        result.reverse();
        result
    }

    /// Orders `allocs` by the opposite of `order`.
    fn reverse_alloc_order(order: &[VarIdent], allocs: &[VarIdent]) -> Vec<VarIdent> {
        let mut result = vec![];
        for candidate in order.iter() {
            for alloc in allocs {
                if candidate == alloc {
                    result.push(*alloc);
                }
            }
        }
        result
    }

    /// Computes a map from Basic Block ID to a vector of variables to drop, in reverse
    /// allocation order.
    fn find_drops(
        basic_blocks: &[BasicBlock],
        order: &[VarIdent],
        drop_points: &HashMap<VarIdent, DropControlFlowNode>,
    ) -> (HashMap<BasicBlockIdent, Vec<VarIdent>>, Vec<VarIdent>) {
        let mut interior_unsorted = HashMap::new();
        let mut exit_unsorted = vec![];

        for basic_block in basic_blocks {
            interior_unsorted.insert(basic_block.id, vec![]);
        }

        for (var, node) in drop_points {
            match node {
                DropControlFlowNode::Interior(node) => {
                    let bb_id = node.basic_block.id;
                    interior_unsorted.get_mut(&bb_id).unwrap().push(*var);
                }
                DropControlFlowNode::Exit => {
                    exit_unsorted.push(*var);
                }
                _ => unreachable!(),
            };
        }

        let mut interior = HashMap::new();
        for (bb_id, vars) in interior_unsorted {
            interior.insert(bb_id, Self::reverse_alloc_order(order, &vars));
        }

        let exit = Self::reverse_alloc_order(order, &exit_unsorted);

        (interior, exit)
    }

    /// Computes the drops to insert at each basic block of the function in
    /// `live_variables`.
    pub fn analyze(
        function: &Function,
        control_flow: &ControlFlowGraph,
        live_variables: &LiveVariables,
    ) -> Self {
        let drop_points = Self::find_drop_points(function, control_flow, live_variables);
        let order = Self::find_order(function);
        let (interior_drops, exit_drops) =
            Self::find_drops(&control_flow.function.basic_blocks, &order, &drop_points);

        Self {
            func: function.id.clone(),
            interior_drops,
            exit_drops,
        }
    }

    /// Gets the drops to insert at the beginning of the basic block with id
    /// `id`.
    ///
    /// # Panics
    /// - if `id` is not the id of a basic block in the function analyzed by
    ///   `self`
    pub fn interior_drops(&self, id: BasicBlockIdent) -> &[VarIdent] {
        self.interior_drops.get(&id).unwrap()
    }

    /// Gets the drops to insert at the EXIT of the function analyzed by `self`.
    pub fn exit_drops(&self) -> &[VarIdent] {
        &self.exit_drops
    }
}
