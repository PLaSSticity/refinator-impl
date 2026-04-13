//! # In-scope Loan Inference Constraints
//!
//! In this module are functions that generate the constraint on `Loans`, as
//! described in the paper.

use std::collections::HashMap;

use z3::ast::{Bool, Set};

use crate::{
    analysis::path::Path,
    constraints::{
        Context,
        datatypes::{
            InterpDatatype, OpaqueDatatype, lab::InterpLab, loan::InterpLoan, point::InterpPoint,
        },
        functions::{
            SingletonFunction, lifetime::Lifetime, loans::Loans, ref_lifetime::RefLifetime,
        },
    },
    lang::{
        instruction::{InstrLab, Instruction},
        program::Program,
        stype::TypeLab,
    },
};

/// Generates the control-flow merge constraints.
pub fn gen_merge(ctx: &Context) -> Vec<Bool> {
    let mut assertions = vec![];
    for cfg in ctx.control_flow.values() {
        for node in cfg.nodes() {
            let predecessors = node.predecessors(cfg);

            if !predecessors.is_empty() {
                let first_lab = node.basic_block.instructions.first().unwrap().id();
                let first_loans = Loans::apply(
                    ctx,
                    &(InterpPoint::r#in(InterpLab::new(*first_lab)).opaquify(ctx),),
                );

                let predecessor_loans: Vec<_> = predecessors
                    .into_iter()
                    .map(|node| {
                        let predecessor_lab = node.basic_block.instructions.last().unwrap().id();
                        Loans::apply(
                            ctx,
                            &(InterpPoint::out(InterpLab::new(*predecessor_lab)).opaquify(ctx),),
                        )
                    })
                    .collect();

                assertions.push(first_loans.eq(Set::set_union(&predecessor_loans)));
            }

            // Relations between Labs in the same basic block.
            let (mut instr_before, rest) = node.basic_block.instructions.split_first().unwrap();
            for instr_after in rest {
                let out_loans = Loans::apply(
                    ctx,
                    &(InterpPoint::out(InterpLab::new(*instr_before.id())).opaquify(ctx),),
                );
                let in_loans = Loans::apply(
                    ctx,
                    &(InterpPoint::r#in(InterpLab::new(*instr_after.id())).opaquify(ctx),),
                );
                assertions.push(in_loans.eq(out_loans));

                instr_before = instr_after;
            }
        }
    }
    assertions
}

/// Generates the transfer function constraints.
pub fn gen_transfer(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut gen_borrow = HashMap::<InstrLab, Vec<TypeLab>>::new();

    for typelab in ctx.rvals.borrow_typelabs() {
        let loans = gen_borrow.entry(ctx.rvals.get_lab(typelab)).or_default();
        loans.push(typelab);
    }

    let mut assertions = vec![];

    for func in program.functions() {
        for bb in &func.basic_blocks {
            for instr in &bb.instructions {
                let lab = InterpLab::new(*instr.id());
                let in_point = InterpPoint::r#in(lab);
                let out_point = InterpPoint::out(lab);
                let in_loans = Loans::apply(ctx, &(in_point.opaquify(ctx),));
                let out_loans = Loans::apply(ctx, &(out_point.opaquify(ctx),));

                let gen_borrow = gen_borrow.get(instr.id());

                let kill_assign = match instr {
                    Instruction::Store { lhs_var, .. } => Some(Path::deref(*lhs_var)),
                    _ => None,
                };

                for typelab in ctx
                    .rvals
                    .borrow_typelabs()
                    .filter(|typelab| ctx.rvals.get_func(*typelab) == &func.id)
                {
                    let path = match ctx.rvals.try_get_borrowed_path(typelab) {
                        Some(path) => path,
                        None => continue,
                    };
                    let loan = InterpLoan::new(typelab).opaquify(ctx);
                    let assertion = if let Some(kill_path) = &kill_assign
                        && (&path == kill_path)
                    {
                        out_loans.member(loan.ast()).not()
                    } else if let Some(gen_borrow) = gen_borrow
                        && gen_borrow.contains(&typelab)
                    {
                        // Sometimes, a loan doesn't extend past one instruction.
                        // This can happen at call sites where loans produced by
                        // borrowing argument variables don't extend into the
                        // caller.
                        let lifetime = RefLifetime::apply(ctx, &(loan.get_typelab().into(),));
                        let borrow_extends = Lifetime::apply(ctx, &(lifetime,))
                            .member(out_point.opaquify(ctx).ast());
                        borrow_extends.implies(out_loans.member(loan.ast()))
                    } else {
                        // let base_type = LabRType::apply(ctx, &(loan.get_typelab().into(),));
                        let lifetime = RefLifetime::apply(ctx, &(loan.get_typelab().into(),));
                        let lifetime_preserve = Lifetime::apply(ctx, &(lifetime,))
                            .member(out_point.opaquify(ctx).ast());

                        out_loans
                            .member(loan.ast())
                            .iff(Bool::and(&[in_loans.member(loan.ast()), lifetime_preserve]))
                    };
                    assertions.push(assertion);
                }
            }
        }
    }

    assertions
}
