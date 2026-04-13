//! Definition of the `Point` datatype.
//!
//! A `Point` is a program point immediately before or after a `Lab`.

use const_format::formatcp;
use z3::{
    DatatypeAccessor, DatatypeBuilder, Model,
    ast::{Ast, Bool, Datatype},
};

use crate::constraints::{
    Context, ContextKey,
    datatypes::{
        InterpDatatype, OpaqueDatatype,
        lab::{InterpLab, OpaqueLab},
    },
};

/// The name of the `in` variant in Z3.
const IN_VARIANT_NAME: &str = formatcp!("{}.in", OpaquePoint::NAME);

/// The index of the `in` variant in the `DatatypeSort`.
const IN_VARIANT_IDX: usize = 0;

/// The name of the `lab` accessor for the `in` variant in Z3.
const IN_LAB_ACCESSOR_NAME: &str = formatcp!("{IN_VARIANT_NAME}.lab");

/// The index of the `lab` accessor for the `in` variant in Z3.
const IN_LAB_ACCESSOR_IDX: usize = 0;

/// The name of the `out` variant in Z3.
const OUT_VARIANT_NAME: &str = formatcp!("{}.out", OpaquePoint::NAME);

/// The index of the `out` variant in the `DatatypeSort`.
const OUT_VARIANT_IDX: usize = 1;

/// The name of the `lab` accessor for the `out` variant in Z3.
const OUT_LAB_ACCESSOR_NAME: &str = formatcp!("{OUT_VARIANT_NAME}.lab");

/// The index of the `lab` accessor for the `out` variant in Z3.
const OUT_LAB_ACCESSOR_IDX: usize = 0;

/// Opaque Z3 representation of a `Point`.
#[derive(Clone)]
pub struct OpaquePoint(Datatype);

impl OpaqueDatatype for OpaquePoint {
    const CONTEXT_KEY: ContextKey = ContextKey::DatatypePoint;
    const NAME: &str = "Point";
    type Dual = InterpPoint;
    type Options<'a> = ();
    type Z3Ast = Datatype;

    /// Generates the Z3 datatype definition.
    fn define(ctx: &mut Context, _options: &Self::Options<'_>) {
        let sort = DatatypeBuilder::new(Self::NAME)
            .variant(
                IN_VARIANT_NAME,
                vec![(
                    IN_LAB_ACCESSOR_NAME,
                    DatatypeAccessor::sort(OpaqueLab::get_sort(ctx).clone()),
                )],
            )
            .variant(
                OUT_VARIANT_NAME,
                vec![(
                    OUT_LAB_ACCESSOR_NAME,
                    DatatypeAccessor::sort(OpaqueLab::get_sort(ctx).clone()),
                )],
            )
            .finish();
        ctx.datatypes.insert(Self::CONTEXT_KEY, sort);
    }

    fn new_const(ctx: &Context, name: &str) -> Self {
        Self::from_ast(&Datatype::new_const(name, &Self::get_sort(ctx)))
    }

    fn from_ast(ast: &Self::Z3Ast) -> Self {
        Self(ast.clone())
    }

    fn ast(&self) -> &Self::Z3Ast {
        &self.0
    }

    fn interpret(&self, ctx: &Context, model: &Model) -> Self::Dual {
        let func_name = self.0.decl().name();
        match func_name.as_str() {
            IN_VARIANT_NAME => Self::Dual::r#in(
                OpaqueLab::from_ast(&model.eval(self.in_lab(ctx).ast(), false).unwrap())
                    .interpret(ctx, model),
            ),
            OUT_VARIANT_NAME => Self::Dual::out(
                OpaqueLab::from_ast(&model.eval(self.out_lab(ctx).ast(), false).unwrap())
                    .interpret(ctx, model),
            ),
            _ => panic!(
                "Expected an application of `{}`` or `{}`, but found `{}` instead",
                IN_VARIANT_NAME, OUT_VARIANT_NAME, self.0
            ),
        }
    }
}

impl OpaquePoint {
    /// Produces a Z3 AST which is an `in` variant `Point` with instruction label
    /// `lab`
    pub fn r#in(ctx: &Context, lab: &OpaqueLab) -> Self {
        Self::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[IN_VARIANT_IDX]
                .constructor
                .apply(&[lab.ast()])
                .as_datatype()
                .unwrap(),
        )
    }

    /// Produces a Z3 AST which is an `out` variant `Point` with instruction label
    /// `lab`
    pub fn out(ctx: &Context, lab: &OpaqueLab) -> Self {
        Self::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[OUT_VARIANT_IDX]
                .constructor
                .apply(&[lab.ast()])
                .as_datatype()
                .unwrap(),
        )
    }

    /// Produces a Z3 AST which checks if the `self` is the `in` variant.
    pub fn is_in(&self, ctx: &Context) -> Bool {
        Self::get_datatype_sort(ctx).as_ref().unwrap().variants[IN_VARIANT_IDX]
            .tester
            .apply(&[&self.0])
            .as_bool()
            .unwrap()
    }

    /// Produces a Z3 AST which checks if the `self` is the `out` variant.
    pub fn is_out(&self, ctx: &Context) -> Bool {
        Self::get_datatype_sort(ctx).as_ref().unwrap().variants[OUT_VARIANT_IDX]
            .tester
            .apply(&[&self.0])
            .as_bool()
            .unwrap()
    }

    /// Produces a Z3 AST which gets the `lab` field of `self`, if `self` is an
    /// `in` variant.
    pub fn in_lab(&self, ctx: &Context) -> OpaqueLab {
        OpaqueLab::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[IN_VARIANT_IDX].accessors
                [IN_LAB_ACCESSOR_IDX]
                .apply(&[&self.0])
                .as_datatype()
                .unwrap(),
        )
    }

    /// Produces a Z3 AST which gets the `lab` field of `self`, if `self` is an
    /// `out` variant.
    pub fn out_lab(&self, ctx: &Context) -> OpaqueLab {
        OpaqueLab::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[OUT_VARIANT_IDX].accessors
                [OUT_LAB_ACCESSOR_IDX]
                .apply(&[&self.0])
                .as_datatype()
                .unwrap(),
        )
    }
}

/// Interpretation of a `Point`..
#[derive(Clone, Copy, PartialEq, Eq)]
pub enum InterpPoint {
    In { lab: InterpLab },
    Out { lab: InterpLab },
}

impl InterpDatatype for InterpPoint {
    type Dual = OpaquePoint;

    fn opaquify(&self, ctx: &Context) -> Self::Dual {
        Self::Dual::from_ast(
            &match self {
                Self::In { lab } => Self::Dual::get_datatype_sort(ctx)
                    .as_ref()
                    .unwrap()
                    .variants[IN_VARIANT_IDX]
                    .constructor
                    .apply(&[lab.opaquify(ctx).ast()]),
                Self::Out { lab } => Self::Dual::get_datatype_sort(ctx)
                    .as_ref()
                    .unwrap()
                    .variants[OUT_VARIANT_IDX]
                    .constructor
                    .apply(&[lab.opaquify(ctx).ast()]),
            }
            .as_datatype()
            .unwrap(),
        )
    }
}

impl InterpPoint {
    /// Creates a `Point` of `in` variant with `Lab` `lab`.
    pub fn r#in(lab: InterpLab) -> Self {
        Self::In { lab }
    }

    /// Creates a `Point` of `out` variant with `Lab` `lab`.
    pub fn out(lab: InterpLab) -> Self {
        Self::Out { lab }
    }

    /// Checks if `self` is the `In` variant.
    pub fn is_in(&self) -> bool {
        matches!(self, Self::In { .. })
    }

    /// Checks if `self` is the `Out` variant.
    pub fn is_out(&self) -> bool {
        matches!(self, Self::Out { .. })
    }

    /// Gets the `Lab` of a `List`.
    pub fn head(&self) -> &InterpLab {
        match self {
            Self::In { lab } => lab,
            Self::Out { lab } => lab,
        }
    }
}
