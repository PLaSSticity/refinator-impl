//! Definition of the `Loan` datatype.
//!
//! Abstractly, a loan is a pair containing a lifetime variable and a borrowed
//! path.
//!
//! At constraint-generation time, the maximum number of unique loans is fixed,
//! so we enumerate all of them.

use std::collections::HashMap;

use const_format::formatcp;
use z3::{
    DatatypeBuilder, Model,
    ast::{Ast, Datatype},
};

use crate::{
    constraints::{
        Context, ContextKey,
        datatypes::{InterpDatatype, OpaqueDatatype},
    },
    lang::stype::TypeLab,
};

/// The prefix for variant names in the `DatatypeSort`.
const VARIANT_PREFIX: &str = formatcp!("{}.", OpaqueLoan::NAME);

/// Opaque Z3 representation of a `Loan`.
#[derive(Clone)]
pub struct OpaqueLoan {
    typelab: TypeLab,
    ast: Datatype,
}

impl OpaqueDatatype for OpaqueLoan {
    const CONTEXT_KEY: ContextKey = ContextKey::DatatypeLoan;
    const NAME: &str = "Loan";
    type Dual = InterpLoan;
    type Options<'a> = ();
    type Z3Ast = Datatype;

    fn define(ctx: &mut Context, _options: &Self::Options<'_>) {
        let mut builder = DatatypeBuilder::new(Self::NAME);
        let mut variants = HashMap::new();

        for (idx, typelab) in ctx.rvals.borrow_typelabs().enumerate() {
            builder = builder.variant(&format!("{}{}", VARIANT_PREFIX, typelab.0), vec![]);
            variants.insert(typelab, idx);
        }

        ctx.datatypes.insert(Self::CONTEXT_KEY, builder.finish());
        ctx.loan_variants.replace(variants);
    }

    /// Operation not supported
    fn new_const(_ctx: &Context, _name: &str) -> Self {
        panic!("Operation not supported")
    }

    /// Operation not supported
    fn from_ast(_ast: &Self::Z3Ast) -> Self {
        panic!("Operation not supported")
    }

    fn ast(&self) -> &Self::Z3Ast {
        &self.ast
    }

    fn interpret(&self, _ctx: &Context, _model: &Model) -> Self::Dual {
        let func_name = self.ast.decl().name();

        assert!(
            &func_name[..VARIANT_PREFIX.len()] == VARIANT_PREFIX,
            "Expected an application of `{}TYPELAB` for some rvalue \
            expression `TYPELAB`, but found `{}` instead",
            VARIANT_PREFIX,
            self.ast
        );

        let typelab = TypeLab(func_name[VARIANT_PREFIX.len()..].parse().unwrap());

        Self::Dual { typelab }
    }
}

impl OpaqueLoan {
    /// Gets the map from `TypeLab`s to `Loan` variant indices for this
    /// datatype.
    ///
    /// # Panics
    /// - If `define` has not been called.
    pub fn get_variants<'a>(ctx: &'a Context<'a>) -> &'a HashMap<TypeLab, usize> {
        ctx.loan_variants.as_ref().unwrap()
    }

    /// Gets the `TypeLab` associated with this loan.
    pub fn get_typelab(&self) -> TypeLab {
        self.typelab
    }
}

/// Interpretation of a `Loan`.
#[derive(Clone, Copy, PartialEq, Eq)]
pub struct InterpLoan {
    pub typelab: TypeLab,
}

impl InterpDatatype for InterpLoan {
    type Dual = OpaqueLoan;

    fn opaquify(&self, ctx: &Context) -> Self::Dual {
        Self::Dual {
            typelab: self.typelab,
            ast: Self::Dual::get_datatype_sort(ctx)
                .as_ref()
                .unwrap()
                .variants[*Self::Dual::get_variants(ctx).get(&self.typelab).unwrap()]
            .constructor
            .apply(&[])
            .as_datatype()
            .unwrap(),
        }
    }
}

impl InterpLoan {
    /// Creates a new `Self` with associated `TypeLab` `typelab`.
    pub fn new(typelab: TypeLab) -> Self {
        Self { typelab }
    }
}
