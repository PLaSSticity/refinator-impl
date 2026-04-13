//! # Type Precision Constraints
//!
//! In this module are functions that generate the type optimality constraints,
//! as described in the paper.

use z3::ast::Int;

use crate::{
    constraints::{
        Context,
        functions::{
            InlineSingletonFunction, SingletonFunction,
            cost::{
                dynamic_overhead::DynamicOverheadCost, transform_depth::TransformDepthCost,
                transform_height::TransformHeightCost,
            },
            labrtype::LabRType,
        },
        relations::{lab_array::LabArray, lab_cell::LabCell},
    },
    lang::program::Program,
};

/// Produces the optimality objective for base type fragments where only
/// signature types are considered based on transformations.
pub fn gen_base_transform_sig(ctx: &Context, program: &Program) -> Int {
    let summands = Vec::from_iter(
        program
            .inner_typelabs()
            .iter()
            .map(|typelab| {
                TransformDepthCost::inline(ctx, &(LabRType::apply(ctx, &(typelab.into(),)),))
            })
            .chain(program.outer_typelabs().iter().map(|typelab| {
                TransformHeightCost::inline(ctx, &(LabRType::apply(ctx, &(typelab.into(),)),))
            })),
    );
    Int::add(&summands)
}

/// Produces the optimality objective for base type fragments where only
/// signature types are considered based on runtime overhead.
pub fn gen_base_overhead_sig(ctx: &Context, program: &Program) -> Int {
    let summands = Vec::from_iter(program.signature_typelabs().iter().map(|typelab| {
        DynamicOverheadCost::inline(ctx, &(LabRType::apply(ctx, &(typelab.into(),)),))
    }));
    Int::add(&summands)
}

/// Produces the optimality objective for array qualifiers.
pub fn gen_array(ctx: &Context, program: &Program) -> Int {
    let summands = Vec::from_iter(program.typelabs().iter().map(|typelab| {
        LabArray::apply(ctx, &(typelab.into(),)).ite(&Int::from_u64(1), &Int::from_u64(0))
    }));
    Int::add(&summands)
}

/// Produces the optimality objective for array qualifiers where only signature
/// types are considered.
pub fn gen_array_sig(ctx: &Context, program: &Program) -> Int {
    let summands = Vec::from_iter(program.signature_typelabs().iter().map(|typelab| {
        LabArray::apply(ctx, &(typelab.into(),)).ite(&Int::from_u64(1), &Int::from_u64(0))
    }));
    Int::add(&summands)
}

/// Produces the optimality objective for `Cell` qualifiers.
pub fn gen_cell(ctx: &Context, program: &Program) -> Int {
    let summands = Vec::from_iter(program.typelabs().iter().map(|typelab| {
        LabCell::apply(ctx, &(typelab.into(),)).ite(&Int::from_u64(1), &Int::from_u64(0))
    }));
    Int::add(&summands)
}

/// Produces the optimality objective for `Cell` qualifiers where only signature
/// types are considered.
pub fn gen_cell_sig(ctx: &Context, program: &Program) -> Int {
    let summands = Vec::from_iter(program.signature_typelabs().iter().map(|typelab| {
        LabCell::apply(ctx, &(typelab.into(),)).ite(&Int::from_u64(1), &Int::from_u64(0))
    }));
    Int::add(&summands)
}
