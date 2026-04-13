//! # Type Consistency Constraints
//!
//! In this module are functions that generate the type consistency constraints,
//! as described in the paper.

use z3::ast::{Bool, Int};

use crate::{
    analysis::path::Path,
    constraints::{
        Context,
        datatypes::{InterpDatatype, OpaqueDatatype, r#struct::InterpStruct},
        functions::{
            InlineSingletonFunction, SingletonFunction, labrtype::LabRType, ref_param::RefParam,
            struct_generics::StructGenerics, struct_param::StructParam, struct_rank::StructRank,
        },
        relations::{lab_array::LabArray, lab_cell::LabCell, pointer_transform::GeneralTransform},
    },
    lang::{instruction::Instruction, program::Program, stype::STypeFrag},
};

/// Produces the parity constraints.
pub fn gen_parity(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut assertions = vec![];
    for typelab in program.typelabs() {
        let frag = <LabRType as SingletonFunction>::apply(ctx, &(typelab.into(),));
        let assertion = match program.lab_stype(&typelab) {
            STypeFrag::Void => frag.is_void(ctx),
            STypeFrag::Bool => frag.is_bool(ctx),
            STypeFrag::Int8 => frag.is_i8(ctx),
            STypeFrag::Int16 => frag.is_i16(ctx),
            STypeFrag::Int32 => frag.is_i32(ctx),
            STypeFrag::Int64 => frag.is_i64(ctx),
            STypeFrag::Float32 => frag.is_f32(ctx),
            STypeFrag::Float64 => frag.is_f64(ctx),
            STypeFrag::Pointer => frag.is_ptr(ctx),
            STypeFrag::Unknown => frag.is_unknown(ctx),
            STypeFrag::Struct(kind) => {
                frag.is_struct_kind(ctx, &InterpStruct::from(kind).opaquify(ctx))
            }
        };
        assertions.push(assertion);
    }
    assertions
}

/// Produces the array constraints.
pub fn gen_array(ctx: &Context) -> Vec<Bool> {
    let mut assertions = vec![];
    for typelab in ctx.rvals.typelabs() {
        if let Path::Elem { var: _ } = ctx.rvals.get_path(typelab) {
            assertions.push(LabArray::apply(ctx, &(typelab.into(),)));
        }
    }
    assertions
}

/// Produces the bare slice constraints.
pub fn gen_slice(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut assertions = vec![];
    for typelab in program
        .typelabs()
        .iter()
        .filter(|&typelab| program.lab_stype(typelab).is_ptr())
    {
        let base_type = LabRType::apply(ctx, &(typelab.into(),));
        assertions.push(
            LabArray::apply(ctx, &(typelab.into(),))
                .implies(base_type.is_ghost(ctx).not()),
        );
    }
    assertions
}

/// Produces the struct well-formedness and type-definition consistency
/// constraints.
pub fn gen_struct(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut assertions = vec![];
    for r#struct in program.structs() {
        let struct_generics = <StructGenerics as SingletonFunction>::apply(
            ctx,
            &(InterpStruct::new(r#struct.id.clone()).opaquify(ctx),),
        );

        assertions.push(Int::from_u64(0).le(&struct_generics));
        assertions.push(struct_generics.le(Int::from_u64(ctx.list_capacity)));

        for typelab in r#struct.field_typelabs.iter().flatten().cloned() {
            let frag = <LabRType as SingletonFunction>::apply(ctx, &(typelab.into(),));
            match program.lab_stype(&typelab) {
                STypeFrag::Pointer => {
                    /* C-LifeParam-Ptr */
                    let param = <RefParam as SingletonFunction>::apply(ctx, &(typelab.into(),));
                    assertions.push(Int::from_u64(0).le(&param));
                    assertions.push(frag.is_ref(ctx).implies(param.lt(&struct_generics)));
                }
                STypeFrag::Struct(_) => {
                    /* C-LifeParam-Struct */
                    for param in (0..ctx.list_capacity).map(|j| {
                        <StructParam as SingletonFunction>::apply(
                            ctx,
                            &(typelab.into(), Int::from_u64(j)),
                        )
                    }) {
                        assertions.push(Int::from_u64(0).le(&param));
                        assertions.push(param.lt(&struct_generics));
                    }
                }
                _ => continue,
            }
        }
    }
    assertions
}

/// Produces the recursive struct definition constraints.
pub fn gen_struct_rec(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut assertions = vec![];
    for r#struct in program.structs() {
        for typelabs in &r#struct.field_typelabs {
            let (last_typelab, outer_typelabs) = typelabs
                .split_last()
                .expect("All struct fields have a non-empty list of `TypeLab`s.");
            if let STypeFrag::Struct(s) = program.lab_stype(last_typelab) {
                let clauses = Vec::from_iter(outer_typelabs.iter().cloned().map(|typelab| {
                    <LabRType as SingletonFunction>::apply(ctx, &(typelab.into(),)).is_ghost(ctx)
                }));
                let antecedent = Bool::and(&clauses);
                let consequent = <StructRank as SingletonFunction>::apply(
                    ctx,
                    &(InterpStruct::from(s).opaquify(ctx),),
                )
                .lt(<StructRank as SingletonFunction>::apply(
                    ctx,
                    &(InterpStruct::new(r#struct.id.clone()).opaquify(ctx),),
                ));
                let assertion = antecedent.implies(consequent);
                assertions.push(assertion);
            }
        }
    }
    assertions
}

/// Produces the Rust type equivalence constraints.
pub fn gen_equiv(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut assertions = vec![];
    let mut pairs = vec![];

    for func in program.functions() {
        for basic_block in &func.basic_blocks {
            for instr in &basic_block.instructions {
                if let Some(pair_vec) = match instr {
                    Instruction::Load {
                        lhs_var,
                        rhs_typelab,
                        ..
                    }
                    | Instruction::Field {
                        lhs_var,
                        rhs_typelab,
                        ..
                    }
                    | Instruction::Element {
                        lhs_var,
                        rhs_typelab,
                        ..
                    } => {
                        let pairs: Vec<_> = program
                            .var_typelabs(lhs_var)
                            .iter()
                            .zip(program.rval_typelabs(rhs_typelab))
                            .collect();
                        Some(pairs)
                    }
                    Instruction::Store {
                        lhs_var,
                        rhs_typelab,
                        ..
                    } => {
                        let pairs: Vec<_> = program.var_typelabs(lhs_var)[1..]
                            .iter()
                            .zip(program.rval_typelabs(rhs_typelab))
                            .collect();
                        Some(pairs)
                    }
                    Instruction::Call {
                        lhs_var,
                        callee,
                        arg_typelabs,
                        ..
                    } => {
                        let mut pairs: Vec<_> = vec![];

                        // 1. Relate the Rust types of the argument rvalues and
                        //    parameter variables.
                        for (param_typelabs, arg_typelabs) in program
                            .get_function(callee)
                            .param_vars
                            .iter()
                            .zip(arg_typelabs)
                            .map(|(param_var, arg_typelab)| {
                                (
                                    program.var_typelabs(param_var),
                                    program.rval_typelabs(arg_typelab),
                                )
                            })
                        {
                            param_typelabs
                                .iter()
                                .zip(arg_typelabs.iter())
                                .for_each(|p| pairs.push(p));
                        }

                        // 2. Relate the Rust types of the return variable and
                        //    the declared return type.
                        if let Some(lhs_var) = lhs_var {
                            program
                                .var_typelabs(lhs_var)
                                .iter()
                                .zip(program.get_function(callee).ret_typelabs.iter())
                                .for_each(|p| pairs.push(p));
                        }

                        Some(pairs)
                    }
                    Instruction::Phi {
                        lhs_var,
                        operand_typelabs,
                        ..
                    } => {
                        let mut pairs = vec![];
                        for rhs_typelab in operand_typelabs {
                            for pair in program
                                .rval_typelabs(rhs_typelab)
                                .iter()
                                .zip(program.var_typelabs(lhs_var).iter())
                            {
                                pairs.push(pair);
                            }
                        }
                        Some(pairs)
                    }
                    Instruction::Ret { rhs_typelab, .. } => {
                        let pairs: Vec<_> = func
                            .ret_typelabs
                            .iter()
                            .zip(program.rval_typelabs(rhs_typelab))
                            .collect();
                        Some(pairs)
                    }
                    _ => None,
                } {
                    pair_vec.into_iter().for_each(|p| pairs.push(p));
                }
            }
        }
    }

    for (lhs_typelab, rhs_typelab) in pairs {
        let lhs_frag = program.lab_stype(lhs_typelab);
        let rhs_frag = program.lab_stype(rhs_typelab);

        if lhs_frag.is_unknown() || rhs_frag.is_unknown() {
            eprintln!(
                "WARN: Encountered unknown type while generating type \
                equivalence constraints, ignoring..."
            );
            eprintln!(
                "      {}: {} == {}: {}",
                lhs_typelab.0,
                program.lab_stype(lhs_typelab),
                rhs_typelab.0,
                program.lab_stype(rhs_typelab)
            );
            continue;
        }

        if lhs_frag != rhs_frag {
            eprintln!(
                "WARN: Encountered incompatible types while generating type \
                equivalence constraints, ignoring..."
            );
            eprintln!(
                "      {}: {} == {}: {}",
                lhs_typelab.0,
                program.lab_stype(lhs_typelab),
                rhs_typelab.0,
                program.lab_stype(rhs_typelab)
            );
            continue;
        }

        if !lhs_frag.is_ptr() {
            // The parity constraints are suffucient to deal with the other case.
            continue;
        }

        assertions.push(
            LabRType::apply(ctx, &(lhs_typelab.into(),))
                .ast()
                .eq(LabRType::apply(ctx, &(rhs_typelab.into(),)).ast()),
        );
        assertions.push(
            <LabArray as SingletonFunction>::apply(ctx, &(lhs_typelab.into(),)).iff(
                <LabArray as SingletonFunction>::apply(ctx, &(rhs_typelab.into(),)),
            ),
        );
        assertions.push(
            <LabCell as SingletonFunction>::apply(ctx, &(lhs_typelab.into(),)).iff(
                <LabCell as SingletonFunction>::apply(ctx, &(rhs_typelab.into(),)),
            ),
        );
    }

    assertions
}

/// Produces the pointer transformation constraints.
pub fn gen_transform(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut typelab_pairs = vec![];
    for function in program.functions() {
        for basic_block in &function.basic_blocks {
            for instr in &basic_block.instructions {
                match instr {
                    Instruction::Alloca { .. } => continue,
                    Instruction::Load {
                        rhs_var,
                        rhs_typelab,
                        ..
                    } => {
                        if STypeFrag::is_ptr(program.lab_stype(rhs_typelab)) {
                            typelab_pairs.push((&program.var_typelabs(rhs_var)[1], rhs_typelab));
                        }
                    }
                    Instruction::Store {
                        rhs_var: Some(rhs_var),
                        rhs_typelab,
                        ..
                    }
                    | Instruction::Element {
                        id: _,
                        llvm_instr: _,
                        lhs_var: _,
                        rhs_var,
                        elem_var: _,
                        rhs_typelab,
                    }
                    | Instruction::Ret {
                        rhs_var: Some(rhs_var),
                        rhs_typelab,
                        ..
                    } => {
                        if STypeFrag::is_ptr(program.lab_stype(rhs_typelab)) {
                            typelab_pairs.push((&program.var_typelabs(rhs_var)[0], rhs_typelab));
                        }
                    }
                    Instruction::Store { .. } => continue,
                    Instruction::Field {
                        id: _,
                        llvm_instr: _,
                        lhs_var: _,
                        struct_id,
                        rhs_var: _,
                        field_idx,
                        rhs_typelab,
                    } => {
                        let fld_typelab = program
                            .field_typelabs(struct_id, field_idx)
                            .first()
                            .expect("Fields have a non-empty list of `TypeLab`s.");
                        typelab_pairs.push((fld_typelab, rhs_typelab));
                    }
                    Instruction::Call {
                        arg_vars: vars,
                        arg_typelabs: typelabs,
                        ..
                    }
                    | Instruction::Phi {
                        operand_vars: vars,
                        operand_typelabs: typelabs,
                        ..
                    } => {
                        for (var_typelab, rval_typelab) in vars
                            .iter()
                            .zip(typelabs.iter())
                            .filter_map(|(var, typelab)| {
                                if let Some(var) = var
                                    && STypeFrag::is_ptr(program.lab_stype(typelab))
                                {
                                    Some((&program.var_typelabs(var)[0], typelab))
                                } else {
                                    None
                                }
                            })
                        {
                            typelab_pairs.push((var_typelab, rval_typelab));
                        }
                    }
                    Instruction::Use { .. } => continue,
                    Instruction::Ret { .. } => continue,
                    Instruction::Br { .. } => continue,
                    Instruction::CondBr { .. } => continue,
                    Instruction::Switch { .. } => continue,
                    Instruction::Unreachable { .. } => continue,
                }
            }
        }
    }
    Vec::from_iter(
        typelab_pairs
            .into_iter()
            .map(|(var_typelab, rval_typelab)| {
                <GeneralTransform as InlineSingletonFunction>::inline(
                    ctx,
                    &(var_typelab.into(), rval_typelab.into()),
                )
            }),
    )
}

/// Produces the constraints to prevent taking `mut` references out of `shared`
/// and `Rc` pointers.
pub fn gen_immutable(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut assertions = vec![];

    let mut items = vec![];
    for typelab in ctx.rvals.borrow_typelabs() {
        match ctx.rvals.try_get_borrowed_path(typelab) {
            Some(Path::Var { .. }) => unreachable!(),
            Some(Path::Deref { .. }) => continue,
            Some(Path::DDeref { var }) | Some(Path::Field { var, field: _ }) => {
                items.push((program.var_typelabs(&var)[0], typelab));
            }
            Some(Path::Elem { var: _ }) => continue,
            None => continue,
        }
    }

    for (v_typelab, r_typelab) in items {
        let v_type = LabRType::apply(ctx, &(v_typelab.into(),));
        let r_type = LabRType::apply(ctx, &(r_typelab.into(),));
        assertions.push(
            Bool::and(&[
                Bool::or(&[v_type.is_shared(ctx), v_type.is_rc(ctx)]),
                LabCell::apply(ctx, &(v_typelab.into(),)).not(),
            ])
            .implies(r_type.is_mut(ctx).not()),
        );
    }

    assertions
}

/// Produces the mutability constraints.
pub fn gen_mutable(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut assertions = vec![];
    for function in program.functions() {
        for basic_block in &function.basic_blocks {
            for instr in &basic_block.instructions {
                if let Instruction::Store { lhs_var, .. } = instr {
                    let typelab = program
                        .var_typelabs(lhs_var)
                        .first()
                        .expect("Each variable has a non-empty list of `TypeLab`s.");
                    let frag = LabRType::apply(ctx, &(typelab.into(),));
                    assertions.push(Bool::or(&[
                        frag.is_ghost(ctx),
                        frag.is_box(ctx),
                        frag.is_mut(ctx),
                        LabCell::apply(ctx, &(typelab.into(),)),
                    ]));
                }
            }
        }
    }
    assertions
}
