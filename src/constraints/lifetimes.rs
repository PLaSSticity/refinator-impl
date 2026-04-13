//! # Lifetime Inference Constraints
//!
//! In this module are functions that generate the constraint on `Lifetime`, as
//! described in the paper.

use z3::ast::{Bool, Int};

use crate::{
    analysis::path::Path,
    constraints::{
        Context,
        datatypes::{
            InterpDatatype, OpaqueDatatype, lab::InterpLab, lifetime::OpaqueLifetime,
            point::InterpPoint, r#struct::InterpStruct,
        },
        functions::{
            InlineFunction, SingletonFunction, labrtype::LabRType, lifetime::Lifetime,
            lifetime_end::LifetimeEnd, ref_bind::RefBind, ref_lifetime::RefLifetime,
            struct_bind::StructBind, struct_generics::StructGenerics,
            struct_lifetime::StructLifetime,
        },
        relations::{lab_cell::LabCell, lifetime_outlives::LifetimeOutlives},
    },
    lang::{
        instruction::Instruction,
        program::Program,
        r#struct::StructIdent,
        stype::{STypeFrag, TypeLab},
    },
};

/// Generates the liveness constraints.
pub fn gen_liveness(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut assertions = vec![];
    for (function, live_variables) in &ctx.live_variables {
        let function = program.get_function(function);
        let mut ptr_items = vec![];
        let mut struct_items = vec![];
        for basic_block in &function.basic_blocks {
            for instr in &basic_block.instructions {
                let in_point = InterpPoint::r#in(InterpLab::new(*instr.id())).opaquify(ctx);
                let out_point = InterpPoint::out(InterpLab::new(*instr.id())).opaquify(ctx);
                for var in live_variables.before(instr.id()) {
                    for typelab in program.var_typelabs(var) {
                        match program.lab_stype(typelab) {
                            STypeFrag::Pointer => {
                                ptr_items.push((in_point.clone(), typelab));
                            }
                            STypeFrag::Struct(s) => {
                                struct_items.push((in_point.clone(), s, typelab));
                            }
                            _ => continue,
                        }
                    }
                }
                for var in live_variables.after(instr.id()) {
                    for typelab in program.var_typelabs(var) {
                        match program.lab_stype(typelab) {
                            STypeFrag::Pointer => {
                                ptr_items.push((out_point.clone(), typelab));
                            }
                            STypeFrag::Struct(s) => {
                                struct_items.push((out_point.clone(), s, typelab));
                            }
                            _ => continue,
                        }
                    }
                }
            }
        }
        for (point, typelab) in ptr_items {
            let frag = <LabRType as SingletonFunction>::apply(ctx, &(typelab.into(),));
            let lifetime = <RefLifetime as SingletonFunction>::apply(ctx, &(typelab.into(),));
            assertions.push(frag.is_ref(ctx).implies(
                <Lifetime as SingletonFunction>::apply(ctx, &(lifetime,)).member(point.ast()),
            ));
        }
        for (point, r#struct, typelab) in struct_items {
            let struct_generics = <StructGenerics as SingletonFunction>::apply(
                ctx,
                &(InterpStruct::from(r#struct).opaquify(ctx),),
            );
            for j in (0..ctx.list_capacity).map(Int::from_u64) {
                let lifetime =
                    <StructLifetime as SingletonFunction>::apply(ctx, &(typelab.into(), j.clone()));
                assertions.push(j.lt(&struct_generics).implies(
                    <Lifetime as SingletonFunction>::apply(ctx, &(lifetime,)).member(point.ast()),
                ));
            }
        }
    }
    assertions
}

/// Generates the subtyping constraints (forwards direction).
pub fn gen_subtyping(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut assertions = vec![];

    for (function, pairs) in &ctx.typelab_pairs {
        let lifetime_outlives = LifetimeOutlives::new(program, function.clone());
        for assign_pairs in pairs.assigns() {
            let rval_typelab = assign_pairs
                .first()
                .expect("Assignments relate non-empty sequences of `TypeLab`s")
                .0;
            for (i, (src_typelab, dst_typelab)) in assign_pairs
                .iter()
                .enumerate()
                .map(|(i, typelabs)| (Int::from_u64(i as u64), typelabs))
            {
                match program.lab_stype(src_typelab) {
                    STypeFrag::Pointer => {
                        let src_frag =
                            <LabRType as SingletonFunction>::apply(ctx, &(src_typelab.into(),));
                        let dst_frag =
                            <LabRType as SingletonFunction>::apply(ctx, &(dst_typelab.into(),));
                        let src_lifetime = <RefBind as SingletonFunction>::apply(
                            ctx,
                            &(rval_typelab.into(), i.clone()),
                        );
                        let dst_lifetime =
                            <RefLifetime as SingletonFunction>::apply(ctx, &(dst_typelab.into(),));
                        assertions.push(
                            Bool::and(&[src_frag.is_ref(ctx), dst_frag.is_ref(ctx)]).implies(
                                lifetime_outlives.inline(ctx, &(src_lifetime, dst_lifetime)),
                            ),
                        );
                    }
                    STypeFrag::Struct(s) => {
                        let struct_generics = <StructGenerics as SingletonFunction>::apply(
                            ctx,
                            &(InterpStruct::from(s).opaquify(ctx),),
                        );
                        for j in (0..ctx.list_capacity).map(Int::from_u64) {
                            let src_lifetime = <StructBind as SingletonFunction>::apply(
                                ctx,
                                &(rval_typelab.into(), i.clone(), j.clone()),
                            );
                            let dst_lifetime = <StructLifetime as SingletonFunction>::apply(
                                ctx,
                                &(dst_typelab.into(), j.clone()),
                            );
                            assertions.push(j.lt(&struct_generics).implies(
                                lifetime_outlives.inline(ctx, &(src_lifetime, dst_lifetime)),
                            ));
                        }
                    }
                    _ => continue,
                }
            }
        }
    }

    assertions
}

/// Generates a Z3 formula that evaluates of the type assigned to `TypeLab`
/// is invariant in its inner type.
pub fn ast_is_invariant(ctx: &Context, typelab: TypeLab) -> Bool {
    Bool::or(&[
        <LabRType as SingletonFunction>::apply(ctx, &(typelab.into(),)).is_mut(ctx),
        <LabCell as SingletonFunction>::apply(ctx, &(typelab.into(),)),
    ])
}

/// Generates the subtyping constraints (backwards direction).
pub fn gen_invariance(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut assertions = vec![];

    for (function, pairs) in &ctx.typelab_pairs {
        let lifetime_outlives = LifetimeOutlives::new(program, function.clone());
        for assign_pairs in pairs.assigns() {
            let rval_typelab = assign_pairs
                .first()
                .expect("Assignments relate non-empty sequences of `TypeLab`s")
                .0;
            for (i, (src_typelab, dst_typelab)) in assign_pairs.iter().enumerate() {
                for (outer_src_typelab, outer_dst_typelab) in &assign_pairs[..i] {
                    if !program.lab_stype(outer_src_typelab).is_ptr() {
                        continue;
                    }

                    let outer_is_invariant = Bool::or(&[
                        ast_is_invariant(ctx, *outer_src_typelab),
                        ast_is_invariant(ctx, *outer_dst_typelab),
                    ]);

                    match program.lab_stype(src_typelab) {
                        STypeFrag::Pointer => {
                            let src_frag =
                                <LabRType as SingletonFunction>::apply(ctx, &(src_typelab.into(),));
                            let dst_frag =
                                <LabRType as SingletonFunction>::apply(ctx, &(dst_typelab.into(),));
                            let src_lifetime = <RefBind as SingletonFunction>::apply(
                                ctx,
                                &(rval_typelab.into(), Int::from_u64(i as u64)),
                            );
                            let dst_lifetime = <RefLifetime as SingletonFunction>::apply(
                                ctx,
                                &(dst_typelab.into(),),
                            );
                            assertions.push(
                                Bool::and(&[
                                    src_frag.is_ref(ctx),
                                    dst_frag.is_ref(ctx),
                                    outer_is_invariant,
                                ])
                                .implies(
                                    lifetime_outlives.inline(ctx, &(dst_lifetime, src_lifetime)),
                                ),
                            );
                        }
                        STypeFrag::Struct(s) => {
                            let struct_generics = <StructGenerics as SingletonFunction>::apply(
                                ctx,
                                &(InterpStruct::from(s).opaquify(ctx),),
                            );
                            for j in (0..ctx.list_capacity).map(Int::from_u64) {
                                let src_lifetime = <StructBind as SingletonFunction>::apply(
                                    ctx,
                                    &(
                                        rval_typelab.into(),
                                        Int::from_u64(i as u64),
                                        j.clone(),
                                    ),
                                );
                                let dst_lifetime = <StructLifetime as SingletonFunction>::apply(
                                    ctx,
                                    &(dst_typelab.into(), j.clone()),
                                );
                                let assertion = j.lt(&struct_generics).implies(
                                    outer_is_invariant.implies(
                                        lifetime_outlives
                                            .inline(ctx, &(dst_lifetime, src_lifetime)),
                                    ),
                                );
                                assertions.push(assertion);
                            }
                        }
                        _ => continue,
                    }
                }
            }
        }
    }

    assertions
}

/// Generates the reborrowing constraints.
pub fn gen_reborrowing(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut assertions = vec![];

    for rval_typelab in ctx.rvals.borrow_typelabs() {
        let function = ctx.rvals.get_func(rval_typelab);
        let rval_frag = <LabRType as SingletonFunction>::apply(ctx, &(rval_typelab.into(),));
        let rval_lifetime = <RefLifetime as SingletonFunction>::apply(ctx, &(rval_typelab.into(),));
        let rval_path = match ctx.rvals.try_get_path(rval_typelab) {
            Some(p) => p,
            None => continue,
        };

        if let Path::Var { var }
        | Path::Deref { var }
        | Path::Elem { var }
        | Path::Field { var, field: _ } = rval_path
        {
            let src_typelab = program
                .var_typelabs(&var)
                .first()
                .expect("Every variable is associated with a non-empty list of `TypeLab`s");
            let src_frag = <LabRType as SingletonFunction>::apply(ctx, &(src_typelab.into(),));
            let src_lifetime =
                <RefLifetime as SingletonFunction>::apply(ctx, &(src_typelab.into(),));
            assertions.push(
                Bool::and(&[src_frag.is_ref(ctx), rval_frag.is_ref(ctx)]).implies(
                    LifetimeOutlives::new(program, function.clone())
                        .inline(ctx, &(src_lifetime, rval_lifetime.clone())),
                ),
            );
        }

        match rval_path {
            Path::Var { .. } => continue,
            Path::Deref { var } => {
                let src_typelab = program
                    .var_typelabs(&var)
                    .get(1)
                    .expect("First `TypeLab` of `var` has `ptr` type.");
                let src_frag = <LabRType as SingletonFunction>::apply(ctx, &(src_typelab.into(),));
                let src_lifetime =
                    <RefLifetime as SingletonFunction>::apply(ctx, &(src_typelab.into(),));
                assertions.push(
                    Bool::and(&[src_frag.is_ref(ctx), rval_frag.is_ref(ctx)]).implies(
                        LifetimeOutlives::new(program, function.clone())
                            .inline(ctx, &(src_lifetime, rval_lifetime)),
                    ),
                );
            }
            Path::DDeref { .. } => continue,
            Path::Elem { .. } => continue,
            Path::Field { var, field } => {
                let struct_typelab = program
                    .var_typelabs(&var)
                    .get(1)
                    .expect("First `TypeLab` of `var` has `ptr` type.");
                let struct_kind = program.lab_stype(struct_typelab).struct_kind();
                let struct_kind = StructIdent(String::from(struct_kind));
                let src_typelab = program
                    .field_typelabs(&struct_kind, &field)
                    .first()
                    .expect("Every field is associated with a non-empty list of `TypeLab`s");
                let src_frag = <LabRType as SingletonFunction>::apply(ctx, &(src_typelab.into(),));
                let src_lifetime =
                    <RefLifetime as SingletonFunction>::apply(ctx, &(src_typelab.into(),));
                assertions.push(
                    Bool::and(&[src_frag.is_ref(ctx), rval_frag.is_ref(ctx)]).implies(
                        LifetimeOutlives::new(program, function.clone())
                            .inline(ctx, &(src_lifetime, rval_lifetime)),
                    ),
                );
            }
        }
    }

    assertions
}

/// Generates the lifetime parameter constraints.
pub fn gen_parameters(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut assertions = vec![];

    for func in program.functions() {
        // Pull the ptr and struct TypeLabs from the function signature.
        let mut ptr_typelabs = vec![];
        let mut struct_typelabs = vec![];

        for &typelab in func
            .param_vars
            .iter()
            .flat_map(|param| program.var_typelabs(param))
            .chain(func.ret_typelabs.iter())
        {
            match program.lab_stype(&typelab) {
                STypeFrag::Pointer => ptr_typelabs.push(typelab),
                STypeFrag::Struct(s) => {
                    struct_typelabs.push((s, typelab));
                }
                _ => continue,
            }
        }

        for typelab in &ptr_typelabs {
            let frag = <LabRType as SingletonFunction>::apply(ctx, &(typelab.into(),));
            let lifetime = <RefLifetime as SingletonFunction>::apply(ctx, &(typelab.into(),));
            assertions.push(frag.is_ref(ctx).implies(
                <LifetimeEnd as SingletonFunction>::apply(ctx, &(lifetime,)).member(
                    <RefLifetime as SingletonFunction>::apply(ctx, &(typelab.into(),)).ast(),
                ),
            ));
        }

        for &(s, typelab) in &struct_typelabs {
            let struct_generics = <StructGenerics as SingletonFunction>::apply(
                ctx,
                &(InterpStruct::from(s).opaquify(ctx),),
            );
            for j in (0..ctx.list_capacity).map(Int::from_u64) {
                let lifetime =
                    <StructLifetime as SingletonFunction>::apply(ctx, &(typelab.into(), j.clone()));
                assertions.push(
                    j.lt(&struct_generics).implies(
                        <LifetimeEnd as SingletonFunction>::apply(ctx, &(lifetime,)).member(
                            <StructLifetime as SingletonFunction>::apply(ctx, &(typelab.into(), j))
                                .ast(),
                        ),
                    ),
                );
            }
        }

        for basic_block in &func.basic_blocks {
            for instr in &basic_block.instructions {
                let lab = InterpLab::new(*instr.id());
                for point in [
                    InterpPoint::r#in(lab).opaquify(ctx),
                    InterpPoint::out(lab).opaquify(ctx),
                ] {
                    for typelab in &ptr_typelabs {
                        let frag = <LabRType as SingletonFunction>::apply(ctx, &(typelab.into(),));
                        let lifetime =
                            <RefLifetime as SingletonFunction>::apply(ctx, &(typelab.into(),));
                        assertions.push(
                            frag.is_ref(ctx).implies(
                                <Lifetime as SingletonFunction>::apply(ctx, &(lifetime,))
                                    .member(point.ast()),
                            ),
                        );
                    }
                    for &(s, typelab) in &struct_typelabs {
                        let struct_generics = <StructGenerics as SingletonFunction>::apply(
                            ctx,
                            &(InterpStruct::from(s).opaquify(ctx),),
                        );
                        for j in (0..ctx.list_capacity).map(Int::from_u64) {
                            let lifetime = <StructLifetime as SingletonFunction>::apply(
                                ctx,
                                &(typelab.into(), j.clone()),
                            );
                            assertions.push(
                                j.lt(&struct_generics).implies(
                                    <Lifetime as SingletonFunction>::apply(ctx, &(lifetime,))
                                        .member(point.ast()),
                                ),
                            );
                        }
                    }
                }
            }
        }
    }

    assertions
}

/// Obtains a vector of triples `(callee_lifetime, caller_lifetime, j)`, where
/// `callee_lifetime` and `caller_lifetime` correspond, and `j` is the index of
/// of the lifetimes in the struct lifetime lists.
///
/// Takes corresponding `TypeLabs` `callee_typelab` and `caller_typelab`, which
/// have source type `stype`, and if  `rval` is `Some(rval_typelab, i)`, then
/// the `caller_typelab = rval_typelabs(rval_typelab)[i]`.
///
/// Requires that `stype` matches `STypeFrag::Pointer` or
/// `STypeFrag::Struct(_)`.
fn lifetime_terms(
    ctx: &Context,
    callee_typelab: &TypeLab,
    caller_typelab: &TypeLab,
    stype: &STypeFrag,
    rval: &Option<(TypeLab, usize)>,
) -> Vec<(OpaqueLifetime, OpaqueLifetime, Option<Int>)> {
    match stype {
        STypeFrag::Pointer => vec![(
            <RefLifetime as SingletonFunction>::apply(ctx, &(callee_typelab.into(),)),
            match rval {
                Some((rval_typelab, i)) => <RefBind as SingletonFunction>::apply(
                    ctx,
                    &(rval_typelab.into(), Int::from_u64(*i as u64)),
                ),
                None => <RefLifetime as SingletonFunction>::apply(ctx, &(caller_typelab.into(),)),
            },
            None,
        )],
        STypeFrag::Struct(_) => {
            Vec::from_iter((0..ctx.list_capacity).map(Int::from_u64).map(|j| {
                (
                    <StructLifetime as SingletonFunction>::apply(
                        ctx,
                        &(callee_typelab.into(), j.clone()),
                    ),
                    match rval {
                        Some((rval_typelab, i)) => <StructBind as SingletonFunction>::apply(
                            ctx,
                            &(rval_typelab.into(), Int::from_u64(*i as u64), j.clone()),
                        ),
                        None => <StructLifetime as SingletonFunction>::apply(
                            ctx,
                            &(caller_typelab.into(), j.clone()),
                        ),
                    },
                    Some(j),
                )
            }))
        }
        _ => unreachable!(),
    }
}

/// Generates the caller-callee lifetime homomorphism constraints.
pub fn gen_homomorphic(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut assertions = vec![];

    for caller in program.functions() {
        let lifetime_outlives = LifetimeOutlives::new(program, caller.id.clone());
        for (lhs_var, callee, arg_typelabs) in caller
            .basic_blocks
            .iter()
            .flat_map(|bb| bb.instructions.iter())
            .filter_map(|instr| match instr {
                Instruction::Call {
                    id: _,
                    llvm_instr: _,
                    lhs_var,
                    callee,
                    arg_vars: _,
                    arg_typelabs,
                } => Some((lhs_var, callee, arg_typelabs)),
                _ => None,
            })
        {
            let callee = program.get_function(callee);

            // A list of tuples (callee_typelab, caller_typelab, stype, rval)
            let mut hom = vec![];

            // 1. Relate argument rvalue expressions and callee parameters.
            for (p_typelabs, a_typelabs) in callee
                .param_vars
                .iter()
                .map(|var| program.var_typelabs(var))
                .zip(
                    arg_typelabs
                        .iter()
                        .map(|typelab| program.rval_typelabs(typelab)),
                )
            {
                let rval_typelab = a_typelabs
                    .first()
                    .expect("Every rvalue has a non-empty list of `TypeLab`s");
                hom.extend(
                    p_typelabs
                        .iter()
                        .zip(a_typelabs.iter())
                        .enumerate()
                        .filter_map(|(i, (p_typelab, a_typelab))| {
                            let p_stype = program.lab_stype(p_typelab);
                            let a_stype = program.lab_stype(a_typelab);
                            (p_stype == a_stype
                                && matches!(p_stype, STypeFrag::Pointer | STypeFrag::Struct(_)))
                            .then_some((
                                *p_typelab,
                                *a_typelab,
                                p_stype.clone(),
                                Some((*rval_typelab, i)),
                            ))
                        }),
                );
            }

            // 2. Relate the returned expressions and declared return type.
            if let Some(lhs_var) = lhs_var {
                hom.extend(
                    callee
                        .ret_typelabs
                        .iter()
                        .zip(program.var_typelabs(lhs_var).iter())
                        .filter_map(|(r_typelab, v_typelab)| {
                            let r_stype = program.lab_stype(r_typelab);
                            let v_stype = program.lab_stype(v_typelab);
                            (r_stype == v_stype
                                && matches!(r_stype, STypeFrag::Pointer | STypeFrag::Struct(_)))
                            .then_some((*r_typelab, *v_typelab, r_stype.clone(), None))
                        }),
                );
            }

            let lifetimes = Vec::from_iter(hom.iter().flat_map(
                |(callee_typelab, caller_typelab, stype, rval)| {
                    lifetime_terms(ctx, callee_typelab, caller_typelab, stype, rval)
                        .into_iter()
                        .map(|(callee_term, caller_term, j)| {
                            (stype.clone(), callee_term, caller_term, j)
                        })
                },
            ));

            for (lhs_stype, lhs_callee_lifetime, lhs_caller_lifetime, lhs_j) in &lifetimes {
                for (rhs_stype, rhs_callee_lifetime, rhs_caller_lifetime, rhs_j) in &lifetimes {
                    // let callee_outlives = lifetime_outlives.inline(
                    //     ctx,
                    //     &(lhs_callee_lifetime.clone(), rhs_callee_lifetime.clone()),
                    // );
                    let callee_outlives = <LifetimeEnd as SingletonFunction>::apply(
                        ctx,
                        &(lhs_callee_lifetime.clone(),),
                    )
                    .member(rhs_callee_lifetime.ast());
                    let caller_outlives = lifetime_outlives.inline(
                        ctx,
                        &(lhs_caller_lifetime.clone(), rhs_caller_lifetime.clone()),
                    );
                    let assertion = callee_outlives.implies(caller_outlives);
                    let mut struct_guard = vec![];
                    if let Some(lhs_j) = lhs_j {
                        let lhs_struct_generics = <StructGenerics as SingletonFunction>::apply(
                            ctx,
                            &(InterpStruct::from(lhs_stype.struct_kind()).opaquify(ctx),),
                        );
                        struct_guard.push(lhs_j.lt(lhs_struct_generics));
                    }
                    if let Some(rhs_j) = rhs_j {
                        let rhs_struct_generics = <StructGenerics as SingletonFunction>::apply(
                            ctx,
                            &(InterpStruct::from(rhs_stype.struct_kind()).opaquify(ctx),),
                        );
                        struct_guard.push(rhs_j.lt(rhs_struct_generics));
                    }
                    let assertion = if struct_guard.is_empty() {
                        assertion
                    } else {
                        Bool::and(&struct_guard).implies(assertion)
                    };
                    assertions.push(assertion);
                }
            }
        }
    }

    assertions
}
