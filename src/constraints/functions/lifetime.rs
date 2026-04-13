//! `Lifetime` function declaration.

use z3::{FuncDecl, Sort, ast::Set};

use crate::constraints::{
    Context, ContextKey,
    datatypes::{OpaqueDatatype, lifetime::OpaqueLifetime, point::OpaquePoint},
    functions::{DeclaredFunction, Function, SingletonFunction},
};

// Declaration of `Lifetime` function.
pub struct Lifetime;

impl SingletonFunction for Lifetime {
    const INSTANCE: Self = Lifetime {};
}

impl Function for Lifetime {
    const CONTEXT_KEY: ContextKey = ContextKey::FuncDeclLifetime;
    const NAME: &str = "Lifetime";
    type DomainType = (OpaqueLifetime,);
    type CodomainType = Set;

    /// Generates the Z3 AST that applies the `Lifetime` function to `args`.
    ///
    /// # Panics
    /// - if the context object for `Self::CONTEXT_KEY` is not initialized
    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        self.get_decl(ctx)
            .apply(&[args.0.ast()])
            .as_set()
            .expect("Function signature is Lifetime -> 𝒫(Point)")
    }
}

impl DeclaredFunction for Lifetime {
    /// Generates the Z3 function declaration for `Lifetime`.
    ///
    /// # Panics
    /// - if the context object for `ContextKey::DatatypePoint` is not
    ///   initialized
    fn declare(&self, ctx: &mut Context) {
        let func = FuncDecl::new(
            Self::NAME,
            &[&OpaqueLifetime::get_sort(ctx)],
            &Sort::set(&OpaquePoint::get_sort(ctx)),
        );
        ctx.func_decls.insert(Self::CONTEXT_KEY, func);
    }
}
