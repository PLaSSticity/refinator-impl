//! Definition of the `Lifetime` datatype.
//!
//! A `Lifetime` is a thin wrapper around an `Int`.

use z3::{Sort, ast::Int};

use crate::constraints::{
    Context, ContextKey,
    datatypes::{InterpDatatype, OpaqueDatatype},
};

/// Z3 representation of an `Lifetime`.
#[derive(Clone)]
pub struct OpaqueLifetime(Int);

impl OpaqueDatatype for OpaqueLifetime {
    const CONTEXT_KEY: ContextKey = ContextKey::None;
    const NAME: &str = "Lifetime";
    type Dual = InterpLifetime;
    type Options<'a> = ();
    type Z3Ast = Int;

    fn define(_ctx: &mut Context, _options: &Self::Options<'_>) {}

    fn get_sort(_ctx: &Context) -> Sort {
        Sort::int()
    }

    fn new_const(_ctx: &Context, name: &str) -> Self {
        Self(Int::new_const(name))
    }

    fn from_ast(ast: &Self::Z3Ast) -> Self {
        Self(ast.clone())
    }

    fn ast(&self) -> &Self::Z3Ast {
        &self.0
    }

    fn interpret(&self, _ctx: &Context, model: &z3::Model) -> Self::Dual {
        Self::Dual::new(model.eval(&self.0, false).unwrap().as_u64().unwrap())
    }
}

/// Interpreted `Lifetime`.
#[derive(Clone, Copy, PartialEq, Eq, Debug)]
pub struct InterpLifetime(pub u64);

impl InterpDatatype for InterpLifetime {
    type Dual = OpaqueLifetime;

    fn opaquify(&self, _ctx: &Context) -> Self::Dual {
        Self::Dual::from_ast(&Int::from_u64(self.0))
    }
}

impl InterpLifetime {
    /// Creates a `Self` with underlying lifetime variable identifier `id`.
    pub fn new(id: u64) -> Self {
        Self(id)
    }
}
