//! `LifetimeEnd` function definition.

use z3::{FuncDecl, Sort, ast::Set};

use crate::constraints::{
    Context,
    context::ContextKey,
    datatypes::{OpaqueDatatype, lifetime::OpaqueLifetime},
    functions::{DeclaredFunction, Function, SingletonFunction},
};

/// Definition of the `LifetimeEnd` relation.
pub struct LifetimeEnd;

impl SingletonFunction for LifetimeEnd {
    const INSTANCE: Self = LifetimeEnd {};
}

impl Function for LifetimeEnd {
    const CONTEXT_KEY: ContextKey = ContextKey::FuncDeclLifetimeEnd;
    const NAME: &'static str = "LifetimeEnd";
    type DomainType = (OpaqueLifetime,);
    type CodomainType = Set;

    /// Generates the Z3 AST that applies the `LiftimeEnd` function to `args`.
    ///
    /// # Panics
    /// - if the context object for `(Self::CONTEXT_KEY, self.function)` is not
    ///   initialized
    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        self.get_decl(ctx)
            .apply(&[args.0.ast()])
            .as_set()
            .expect("Function signature is Lifetime -> Set<Int>")
    }
}

impl DeclaredFunction for LifetimeEnd {
    /// Generates the Z3 function declaration.
    fn declare(&self, ctx: &mut Context) {
        let func = FuncDecl::new(
            Self::NAME,
            &[&OpaqueLifetime::get_sort(ctx)],
            &Sort::set(&Sort::int()),
        );
        ctx.func_decls.insert(Self::CONTEXT_KEY, func);
    }
}
