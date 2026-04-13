//! # &inator Pointer Transformation Relations
//!
//! In this module, we define the general and nondestructive pointer
//! transformation relations.
//!
//! All constraints that use pointer transformation relations use SMT
//! constraints of the following form:
//! ```
//! (LabRType(ℓ₁), LabArray(ℓ₁), LabCell(ℓ₁), LabRType(ℓ₂), LabArray(ℓ₂), LabCell(ℓ₂)) ∈ R
//! ```
//! So, in our implementation, we can define the pointer transformation
//! "relations" as formulas with `TypeLab` variables ℓ₁ and ℓ₂.

use phf::{phf_map, phf_set};
use z3::{
    RecFuncDecl, Sort,
    ast::{Bool, Int},
};

use crate::constraints::{
    context::{Context, ContextKey},
    functions::labrtype::LabRType,
    functions::{DefinedFunction, Function, InlineFunction, SingletonFunction},
    relations::{lab_array::LabArray, lab_cell::LabCell},
};

/// Type of the entries in the lookup tables.
type LUTEntry = (&'static str, bool, bool);

/// Generates a Z3 AST for a formula to evaluate whether the type assigned to
/// `typelab` matches the type captured by `entry`.
fn lut_matches(ctx: &Context, typelab: &Int, entry: &LUTEntry) -> Bool {
    let (base, array, cell) = *entry;
    let base_matches = match base {
        "ghost" => <LabRType as SingletonFunction>::apply(ctx, &(typelab.clone(),)).is_ghost(ctx),
        "Box" => <LabRType as SingletonFunction>::apply(ctx, &(typelab.clone(),)).is_box(ctx),
        "Rc" => <LabRType as SingletonFunction>::apply(ctx, &(typelab.clone(),)).is_rc(ctx),
        "shared" => <LabRType as SingletonFunction>::apply(ctx, &(typelab.clone(),)).is_shared(ctx),
        "mut" => <LabRType as SingletonFunction>::apply(ctx, &(typelab.clone(),)).is_mut(ctx),
        _ => unreachable!(),
    };
    let array_matches = if array {
        <LabArray as SingletonFunction>::apply(ctx, &(typelab.clone(),))
    } else {
        <LabArray as SingletonFunction>::apply(ctx, &(typelab.clone(),)).not()
    };
    let cell_matches = if cell {
        <LabCell as SingletonFunction>::apply(ctx, &(typelab.clone(),))
    } else {
        <LabCell as SingletonFunction>::apply(ctx, &(typelab.clone(),)).not()
    };
    Bool::and(&[base_matches, array_matches, cell_matches])
}

/* General transformations -------------------------------------------------- */

/// Lookup table for general pointer transformation relation.
static GENERAL_RELATION: phf::Map<LUTEntry, phf::Set<LUTEntry>> = phf_map! {
    ("ghost", true, true) => phf_set! {
        ("ghost", true, false),
        ("mut", false, false),
        ("ghost", false, true),
        ("Rc", false, false),
        ("shared", false, false),
        ("shared", true, true),
        ("Box", true, false),
        ("mut", true, true),
        ("ghost", false, false),
        ("Rc", true, true),
        ("shared", true, false),
        ("Box", false, true),
        ("mut", true, false),
        ("ghost", true, true),
        ("mut", false, true),
        ("Rc", false, true),
        ("Rc", true, false),
        ("shared", false, true),
        ("Box", false, false),
        ("Box", true, true),
    },
    ("ghost", true, false) => phf_set! {
        ("ghost", true, false),
        ("mut", false, false),
        ("ghost", false, true),
        ("Rc", false, false),
        ("shared", false, false),
        ("shared", true, true),
        ("Box", true, false),
        ("mut", true, true),
        ("ghost", false, false),
        ("Rc", true, true),
        ("shared", true, false),
        ("Box", false, true),
        ("mut", true, false),
        ("ghost", true, true),
        ("mut", false, true),
        ("Rc", false, true),
        ("Rc", true, false),
        ("shared", false, true),
        ("Box", false, false),
        ("Box", true, true),
    },
    ("ghost", false, true) => phf_set! {
        ("Rc", false, false),
        ("mut", false, true),
        ("Box", false, true),
        ("mut", false, false),
        ("ghost", false, true),
        ("Rc", false, true),
        ("shared", false, true),
        ("Box", false, false),
        ("ghost", false, false),
        ("shared", false, false),
    },
    ("ghost", false, false) => phf_set! {
        ("Rc", false, false),
        ("mut", false, true),
        ("Box", false, true),
        ("mut", false, false),
        ("Rc", false, true),
        ("ghost", false, true),
        ("shared", false, true),
        ("Box", false, false),
        ("ghost", false, false),
        ("shared", false, false),
    },
    ("Box", true, true) => phf_set! {
        ("ghost", true, false),
        ("mut", false, false),
        ("ghost", false, true),
        ("Rc", false, false),
        ("shared", false, false),
        ("shared", true, true),
        ("Box", true, false),
        ("mut", true, true),
        ("ghost", false, false),
        ("Rc", true, true),
        ("shared", true, false),
        ("Box", false, true),
        ("mut", true, false),
        ("ghost", true, true),
        ("mut", false, true),
        ("Rc", false, true),
        ("Rc", true, false),
        ("shared", false, true),
        ("Box", false, false),
        ("Box", true, true),
    },
    ("Box", true, false) => phf_set! {
        ("ghost", true, false),
        ("mut", false, false),
        ("ghost", false, true),
        ("Rc", false, false),
        ("shared", false, false),
        ("shared", true, true),
        ("Box", true, false),
        ("mut", true, true),
        ("ghost", false, false),
        ("Rc", true, true),
        ("shared", true, false),
        ("Box", false, true),
        ("mut", true, false),
        ("ghost", true, true),
        ("mut", false, true),
        ("Rc", false, true),
        ("Rc", true, false),
        ("shared", false, true),
        ("Box", false, false),
        ("Box", true, true),
    },
    ("Box", false, true) => phf_set! {
        ("mut", false, true),
        ("Box", false, true),
        ("mut", false, false),
        ("Rc", false, true),
        ("ghost", false, true),
        ("shared", false, true),
        ("Box", false, false),
        ("Rc", false, false),
        ("shared", false, false),
        ("ghost", false, false),
    },
    ("Box", false, false) => phf_set! {
        ("Rc", false, false),
        ("mut", false, true),
        ("Box", false, true),
        ("mut", false, false),
        ("ghost", false, true),
        ("Rc", false, true),
        ("shared", false, true),
        ("Box", false, false),
        ("ghost", false, false),
        ("shared", false, false),
    },
    ("Rc", true, true) => phf_set! {
        ("Rc", true, true),
        ("mut", false, false),
        ("shared", false, true),
        ("shared", false, false),
        ("shared", true, true),
    },
    ("Rc", true, false) => phf_set! {
        ("shared", false, false),
        ("Rc", true, false),
        ("shared", true, false),
    },
    ("Rc", false, true) => phf_set! {
        ("mut", false, false),
        ("Rc", false, true),
        ("shared", false, false),
        ("shared", false, true),
    },
    ("Rc", false, false) => phf_set! {
        ("Rc", false, false),
        ("shared", false, false),
    },
    ("shared", true, true) => phf_set! {
        ("mut", false, false),
        ("shared", false, false),
        ("shared", false, true),
        ("shared", true, true),
    },
    ("shared", true, false) => phf_set! {
        ("shared", false, false),
        ("shared", true, false),
    },
    ("shared", false, true) => phf_set! {
        ("mut", false, false),
        ("shared", false, false),
        ("shared", false, true),
    },
    ("shared", false, false) => phf_set! {
        ("shared", false, false),
    },
    ("mut", true, true) => phf_set! {
        ("mut", false, true),
        ("mut", true, true),
        ("mut", false, false),
        ("shared", false, true),
        ("shared", false, false),
        ("shared", true, true),
    },
    ("mut", true, false) => phf_set! {
        ("shared", false, false),
        ("mut", false, false),
        ("mut", true, false),
        ("shared", true, false),
    },
    ("mut", false, true) => phf_set! {
        ("mut", false, false),
        ("mut", false, true),
        ("shared", false, false),
        ("shared", false, true),
    },
    ("mut", false, false) => phf_set! {
        ("mut", false, false),
        ("shared", false, false),
    },
};

/// Definition of the general pointer transformation relation.
pub struct GeneralTransform;

impl SingletonFunction for GeneralTransform {
    const INSTANCE: Self = GeneralTransform {};
}

impl Function for GeneralTransform {
    const CONTEXT_KEY: ContextKey = ContextKey::RelDefGeneralTransform;
    const NAME: &str = "general-transform";
    type DomainType = (Int, Int);
    type CodomainType = Bool;

    /// Generates the Z3 AST that applies the general pointer transformation to
    /// `args`.
    ///
    /// # Panics
    /// - if the context object for `ContextKey::RelDefGeneralTransform` is not
    ///   initialized.
    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        self.get_def(ctx)
            .apply(&[&args.0, &args.1])
            .as_bool()
            .expect("Function signature is Int × Int -> Bool")
    }
}

impl DefinedFunction for GeneralTransform {
    /// Generates the Z3 function definition for the general pointer
    /// transformation predicate.
    fn define(&self, ctx: &mut Context) {
        let func = RecFuncDecl::new(Self::NAME, &[&Sort::int(), &Sort::int()], &Sort::bool());
        let args = (Int::new_const("typelab!0"), Int::new_const("typelab!1"));
        let body = self.inline(ctx, &args);
        func.add_def(&[&args.0, &args.1], &body);
        ctx.func_defs.insert((Self::CONTEXT_KEY, None), func);
    }
}

impl InlineFunction for GeneralTransform {
    /// Generates the Z3 AST that applies the general pointer transformation to
    /// `args` by inlining its definition.
    fn inline(&self, ctx: &Context, args: &Self::DomainType) -> Bool {
        let (from, to) = args;
        let mut clauses = vec![];
        for (lut_from, lut_to_set) in &GENERAL_RELATION {
            for lut_to in lut_to_set {
                clauses.push(Bool::and(&[
                    lut_matches(ctx, from, lut_from),
                    lut_matches(ctx, to, lut_to),
                ]));
            }
        }
        Bool::or(&clauses)
    }
}

/* Nondestructive transformations ------------------------------------------- */

/// Lookup table for nondestructive pointer transformation relation.
static NONDESTRUCTIVE_RELATION: phf::Map<LUTEntry, phf::Set<LUTEntry>> = phf_map! {
    ("ghost", true, true) => phf_set! {
        ("shared", false, true),
        ("mut", true, true),
        ("shared", false, false),
        ("mut", false, true),
        ("mut", false, false),
        ("shared", true, true),
    },
    ("ghost", true, false) => phf_set! {
        ("shared", false, false),
        ("mut", true, false),
        ("shared", true, false),
        ("mut", false, false),
    },
    ("ghost", false, true) => phf_set! {
        ("mut", false, false),
        ("mut", false, true),
        ("shared", false, true),
        ("shared", false, false),
    },
    ("ghost", false, false) => phf_set! {
        ("mut", false, false),
        ("shared", false, false),
    },
    ("Box", true, true) => phf_set! {
        ("shared", false, true),
        ("mut", true, true),
        ("shared", false, false),
        ("mut", false, true),
        ("mut", false, false),
        ("shared", true, true),
    },
    ("Box", true, false) => phf_set! {
        ("shared", false, false),
        ("mut", true, false),
        ("shared", true, false),
        ("mut", false, false),
    },
    ("Box", false, true) => phf_set! {
        ("mut", false, false),
        ("mut", false, true),
        ("shared", false, true),
        ("shared", false, false),
    },
    ("Box", false, false) => phf_set! {
        ("mut", false, false),
        ("shared", false, false),
    },
    ("Rc", true, true) => phf_set! {
        ("shared", false, true),
        ("Rc", true, true),
        ("shared", false, false),
        ("mut", false, false),
        ("shared", true, true),
    },
    ("Rc", true, false) => phf_set! {
        ("shared", false, false),
        ("Rc", true, false),
        ("shared", true, false),
    },
    ("Rc", false, true) => phf_set! {
        ("mut", false, false),
        ("shared", false, true),
        ("shared", false, false),
        ("Rc", false, true),
    },
    ("Rc", false, false) => phf_set! {
        ("shared", false, false),
        ("Rc", false, false),
    },
    ("shared", true, true) => phf_set! {
        ("mut", false, false),
        ("shared", false, true),
        ("shared", true, true),
        ("shared", false, false),
    },
    ("shared", true, false) => phf_set! {
        ("shared", false, false),
        ("shared", true, false),
    },
    ("shared", false, true) => phf_set! {
        ("mut", false, false),
        ("shared", false, true),
        ("shared", false, false),
    },
    ("shared", false, false) => phf_set! {
        ("shared", false, false),
    },
    ("mut", true, true) => phf_set! {
        ("shared", false, true),
        ("mut", true, true),
        ("shared", false, false),
        ("mut", false, true),
        ("mut", false, false),
        ("shared", true, true),
    },
    ("mut", true, false) => phf_set! {
        ("shared", false, false),
        ("mut", true, false),
        ("shared", true, false),
        ("mut", false, false),
    },
    ("mut", false, true) => phf_set! {
        ("mut", false, false),
        ("shared", false, true),
        ("mut", false, true),
        ("shared", false, false),
    },
    ("mut", false, false) => phf_set! {
        ("shared", false, false),
        ("mut", false, false),
    },
};

/// Definition of the nondestructive pointer transformation relation.
pub struct NondestructiveTransform;

impl SingletonFunction for NondestructiveTransform {
    const INSTANCE: Self = NondestructiveTransform {};
}

impl Function for NondestructiveTransform {
    const CONTEXT_KEY: ContextKey = ContextKey::RelDefNondestructiveTransform;
    const NAME: &str = "nondestructive-transform";
    type DomainType = (Int, Int);
    type CodomainType = Bool;

    /// Generates the Z3 AST that applies the nondestructive pointer
    /// transformation to `args`.
    ///
    /// # Panics
    /// - if the context object for `ContextKey::RelDefNondestructiveTransform`
    ///   is not initialized.
    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        self.get_def(ctx)
            .apply(&[&args.0, &args.1])
            .as_bool()
            .expect("Function signature is Int × Int -> Bool")
    }
}

impl DefinedFunction for NondestructiveTransform {
    /// Generates the Z3 function definition for the nondestructive pointer
    /// transformation predicate.
    fn define(&self, ctx: &mut Context) {
        let func = RecFuncDecl::new(Self::NAME, &[&Sort::int(), &Sort::int()], &Sort::bool());
        let args = (Int::new_const("typelab!0"), Int::new_const("typelab!1"));
        let body = self.inline(ctx, &args);
        func.add_def(&[&args.0, &args.1], &body);
        ctx.func_defs.insert((Self::CONTEXT_KEY, None), func);
    }
}

impl InlineFunction for NondestructiveTransform {
    /// Generates the Z3 AST that applies the nondestructive pointer
    /// transformation to `args` by inlining its definition.
    fn inline(&self, ctx: &Context, args: &Self::DomainType) -> Bool {
        let (from, to) = args;
        let mut clauses = vec![];
        for (lut_from, lut_to_set) in &NONDESTRUCTIVE_RELATION {
            for lut_to in lut_to_set {
                clauses.push(Bool::and(&[
                    lut_matches(ctx, from, lut_from),
                    lut_matches(ctx, to, lut_to),
                ]));
            }
        }
        Bool::or(&clauses)
    }
}
