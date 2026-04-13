//! Borrowing Conflicts.
//!
//! In this module are functions that generate the constraints based on
//! borrowing conflicts, as described in the paper.

use std::collections::{HashMap, HashSet};

use z3::ast::Bool;

use crate::{
    analysis::path::Path,
    constraints::{
        Context,
        datatypes::{
            InterpDatatype, OpaqueDatatype, lab::InterpLab, loan::InterpLoan, point::InterpPoint,
        },
        functions::{InlineSingletonFunction, SingletonFunction, labrtype::LabRType, loans::Loans},
        relations::pointer_transform::NondestructiveTransform,
        semantic::ast_is_clonable,
    },
    lang::{
        instruction::{InstrLab, Instruction},
        program::Program,
        stype::TypeLab,
        variable::VarIdent,
    },
};

pub type BorrowConflicts = HashMap<TypeLab, HashSet<TypeLab>>;

/// Finds, for each rvalue expression `TypeLab`, `r_typelab`, the `TypeLab`s
/// that uniquely identify the loans that can conflict with a borrow by
/// `r_typelab`.
pub fn find_borrow_conflicts(ctx: &Context) -> BorrowConflicts {
    let mut result = HashMap::new();

    for r_typelab in ctx.rvals.typelabs() {
        let mut conflicts = HashSet::new();

        // Look for rvalue expressions which copy a pointer, which we will turn
        // into re-borrow expressions.
        let r_path = match if ctx.rvals.is_borrowing(r_typelab) {
            ctx.rvals.try_get_borrowed_path(r_typelab)
        } else {
            ctx.rvals.try_get_path(r_typelab)
        } {
            Some(path) => path,
            None => continue,
        };

        for l_typelab in ctx.rvals.borrow_typelabs() {
            let l_path = match ctx.rvals.try_get_borrowed_path(l_typelab) {
                Some(path) => path,
                None => continue,
            };
            if r_path.borrow_conflicts(&l_path) {
                conflicts.insert(l_typelab);
            }
        }

        result.insert(r_typelab, conflicts);
    }

    result
}

pub type AssignConflicts = Vec<(InstrLab, VarIdent, HashSet<TypeLab>)>;

/// Finds, for each store instruction, with `Lab` `lab`, the `TypeLab`s that
/// uniquely identify the loans that can conflict with the assignment at `lab`.
pub fn find_assign_conflicts(ctx: &Context, program: &Program) -> AssignConflicts {
    let mut result = vec![];

    for func in program.functions() {
        for instr in func.basic_blocks.iter().flat_map(|bb| &bb.instructions) {
            if let Instruction::Store { id, lhs_var, .. } = instr {
                let mut conflicts = HashSet::new();

                for l_typelab in ctx.rvals.borrow_typelabs() {
                    let l_path = match ctx.rvals.try_get_borrowed_path(l_typelab) {
                        Some(path) => path,
                        None => continue,
                    };
                    if Path::deref(*lhs_var).assign_conflicts(&l_path) {
                        conflicts.insert(l_typelab);
                    }
                }

                result.push((*id, *lhs_var, conflicts));
            }
        }
    }

    result
}

/// Generates the constraints to prevent illegal borrows.
pub fn gen_borrow(ctx: &Context, conflicts: &BorrowConflicts) -> Vec<Bool> {
    let mut assertions = vec![];

    for (r_typelab, conflicts) in conflicts {
        let r_lab = ctx.rvals.get_lab(*r_typelab);
        let r_point = InterpPoint::r#in(InterpLab::new(r_lab)).opaquify(ctx);
        let r_frag = LabRType::apply(ctx, &(r_typelab.into(),));
        for l_typelab in conflicts {
            let l_frag = LabRType::apply(ctx, &(l_typelab.into(),));
            let loan = InterpLoan::new(*l_typelab).opaquify(ctx);

            assertions.push(
                Bool::and(&[
                    l_frag.is_ref(ctx),
                    Loans::apply(ctx, &(r_point.clone(),)).member(loan.ast()),
                ])
                .implies(Bool::and(&[&l_frag.is_shared(ctx), &r_frag.is_shared(ctx)])),
            );
        }
    }

    assertions
}

/// Generates the constraints to prevent illegal assignments.
pub fn gen_assign(ctx: &Context, program: &Program, conflicts: &AssignConflicts) -> Vec<Bool> {
    let mut assertions = vec![];

    for (a_lab, a_var, conflicts) in conflicts {
        let a_point = InterpPoint::r#in(InterpLab::new(*a_lab)).opaquify(ctx);
        let a_frag = LabRType::apply(ctx, &(program.var_typelabs(a_var)[0].into(),));
        for l_typelab in conflicts {
            let l_frag = LabRType::apply(ctx, &(l_typelab.into(),));
            let loan = InterpLoan::new(*l_typelab).opaquify(ctx);

            assertions.push(
                Bool::and(&[
                    l_frag.is_ref(ctx),
                    Loans::apply(ctx, &(a_point.clone(),)).member(loan.ast()),
                ])
                .implies(Bool::and(&[&a_frag.is_shared(ctx), &l_frag.is_shared(ctx)])),
            );
        }
    }

    assertions
}

/// Generates the constraints to prevent illegal moves out of pointers based on
/// borrowing conflicts.
pub fn gen_move(ctx: &Context, program: &Program, conflicts: &BorrowConflicts) -> Vec<Bool> {
    // Each entry is a pair `(lab, r_typelab, v_typelab)`, where `v_typelab` is
    // the `TypeLab` of a variable that corresponds to the rvalue expression
    // `TypeLab` `r_typelab`, and `lab` is the `Lab` where the rvalue expression
    // occurs.
    //
    // We expand each item to a set of constraints:
    //
    // for all `l_typelab` in `TypeLab` where `LabRType(l_typelab) in ref+`,
    // for all `a` in `Path` where `a` in `borrow_conflicts(path(r_typelab))`,
    //     LabRType(l_typelab) in ref+(rho)
    //     => (rho, a) in Borrows(lab_in)
    //     => v_typelab ~>_N r_typelab
    let mut ptr_items = vec![];

    // Each entry is a pair `(lab, r_typelab)` which corresponds to an rvalue
    // expression with potentially non-clonable type, where the rvalue
    // expression is uniquely identified by `TypeLab` `r_typelab`, and `lab` is
    // the `Lab` where the rvalue expression occurs.
    //
    // We expand each item to a set of constraints:
    //
    // for all `l_typelab` in `TypeLab` where `LabRType(l_typelab) in ref+`,
    // for all `a` in `Path` where `a` in `borrow_conflicts(path(r_typelab))`,
    //     LabRType(l_typelab) in ref+(rho)
    //     => (rho, a) in Borrows(lab_in)
    //     => type of rvalue expression is shallowly clonable
    let mut nonptr_items = vec![];

    for r_typelab in ctx.rvals.typelabs() {
        let lab = ctx.rvals.get_lab(r_typelab);
        if ctx.rvals.is_borrowing(r_typelab) {
            match ctx.rvals.get_path(r_typelab) {
                Path::Var { var } => {
                    ptr_items.push((lab, r_typelab, program.var_typelabs(&var)[0]));
                }
                Path::Deref { var } => {
                    ptr_items.push((lab, r_typelab, program.var_typelabs(&var)[1]));
                }
                Path::Elem { var } => {
                    ptr_items.push((lab, r_typelab, program.var_typelabs(&var)[0]));
                }
                Path::DDeref { .. } => unreachable!(),
                Path::Field { .. } => (),
            }
        } else {
            let r_type = program.lab_stype(&r_typelab);
            if r_type.is_struct() {
                nonptr_items.push((lab, r_typelab));
            }
        }
    }

    let mut assertions = vec![];

    for (lab, r_typelab, v_typelab) in ptr_items {
        let point = InterpPoint::r#in(InterpLab::new(lab)).opaquify(ctx);
        let conflicts = conflicts.get(&r_typelab).unwrap();
        for l_typelab in conflicts {
            let l_frag = LabRType::apply(ctx, &(l_typelab.into(),));
            let loan = InterpLoan::new(*l_typelab).opaquify(ctx);
            assertions.push(
                Bool::and(&[
                    l_frag.is_ref(ctx),
                    Loans::apply(ctx, &(point.clone(),)).member(loan.ast()),
                ])
                .implies(NondestructiveTransform::inline(
                    ctx,
                    &(v_typelab.into(), r_typelab.into()),
                )),
            );
        }
    }

    for (lab, r_typelab) in nonptr_items {
        let point = InterpPoint::r#in(InterpLab::new(lab)).opaquify(ctx);
        let conflicts = conflicts.get(&r_typelab).unwrap();
        for l_typelab in conflicts {
            let l_frag = LabRType::apply(ctx, &(l_typelab.into(),));
            let loan = InterpLoan::new(*l_typelab).opaquify(ctx);
            assertions.push(
                Bool::and(&[
                    l_frag.is_ref(ctx),
                    Loans::apply(ctx, &(point.clone(),)).member(loan.ast()),
                ])
                .implies(ast_is_clonable(
                    ctx,
                    program,
                    program.rval_typelabs(&r_typelab),
                )),
            );
        }
    }

    assertions
}

/// Generates the constraints to prevent borrowed values from being dropped.
pub fn gen_drop(ctx: &Context, program: &Program) -> Vec<Bool> {
    // Each item is a tuple `(func, paths)`, where `paths` is a map
    // `var -> Vec<typelab, path>`, where `(typelab, path)` is a potential
    // borrow of a path involving `var`.
    let mut items = vec![];

    for func in ctx.drops.keys().map(|id| program.get_function(id)) {
        let declared_vars = HashSet::<VarIdent>::from_iter(func.decl_vars().into_iter());
        let mut inner_paths = HashMap::<VarIdent, Vec<(TypeLab, Path)>>::new();
        for typelab in ctx.rvals.borrow_typelabs() {
            let path = match ctx.rvals.try_get_borrowed_path(typelab) {
                Some(path) => path,
                None => continue,
            };
            match path {
                Path::Deref { var }
                | Path::DDeref { var }
                | Path::Elem { var, .. }
                | Path::Field { var, .. }
                    if declared_vars.contains(&var) =>
                {
                    let items = inner_paths.entry(var).or_default();
                    items.push((typelab, path));
                }
                _ => (),
            }
        }
        items.push((func, inner_paths));
    }

    let mut assertions = vec![];

    for (func, paths) in items {
        // Each item is a tuple `(point, var)`, where `var` is dropped at
        // `point`.
        let mut items = vec![];
        for basic_block in &func.basic_blocks {
            let point =
                InterpPoint::r#in(InterpLab::new(*basic_block.instructions[0].id())).opaquify(ctx);
            for var in ctx
                .drops
                .get(&func.id)
                .unwrap()
                .interior_drops(basic_block.id)
            {
                items.push((point.clone(), var));
            }
        }
        for exit_node in ctx.control_flow.get(&func.id).unwrap().exits() {
            let point = InterpPoint::out(InterpLab::new(
                *exit_node.basic_block.instructions.last().unwrap().id(),
            ))
            .opaquify(ctx);
            for var in ctx.drops.get(&func.id).unwrap().exit_drops() {
                items.push((point.clone(), var));
            }
        }

        for (point, var) in items {
            if let Some(paths) = paths.get(var) {
                for (l_typelab, l_path) in paths {
                    let l_frag = LabRType::apply(ctx, &(l_typelab.into(),));
                    let loan = InterpLoan::new(*l_typelab).opaquify(ctx);
                    match l_path {
                        Path::Var { .. } => unreachable!(),
                        Path::Deref { .. }
                        | Path::DDeref { .. }
                        | Path::Elem { .. }
                        | Path::Field { .. } => {
                            let v_typelab = match l_path {
                                Path::Deref { .. } => program.var_typelabs(var)[0],
                                Path::DDeref { .. } => program.var_typelabs(var)[1],
                                Path::Elem { .. } => program.var_typelabs(var)[0],
                                Path::Field { .. } => program.var_typelabs(var)[0],
                                _ => unreachable!(),
                            };
                            let v_type = LabRType::apply(ctx, &(v_typelab.into(),));
                            let v_is_ref = Bool::or(&[v_type.is_shared(ctx), v_type.is_mut(ctx)]);

                            assertions.push(
                                Bool::and(&[
                                    l_frag.is_ref(ctx),
                                    Loans::apply(ctx, &(point.clone(),)).member(loan.ast()),
                                ])
                                .implies(&v_is_ref),
                            );
                        }
                    }
                }
            }
        }
    }

    assertions
}
