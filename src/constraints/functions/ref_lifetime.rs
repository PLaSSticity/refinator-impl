//! `RefLifetime` function declaration.

use z3::{FuncDecl, Sort, ast::Int};

use crate::constraints::{
    Context, ContextKey,
    datatypes::{OpaqueDatatype, lifetime::OpaqueLifetime},
    functions::{DeclaredFunction, Function, SingletonFunction},
};

/// Declaration of `RefLifetime` function.
pub struct RefLifetime;

impl SingletonFunction for RefLifetime {
    const INSTANCE: Self = RefLifetime {};
}

impl Function for RefLifetime {
    const CONTEXT_KEY: ContextKey = ContextKey::FuncDeclRefLifetime;
    const NAME: &str = "RefLifetime";
    type DomainType = (Int,);
    type CodomainType = OpaqueLifetime;

    /// Generates the Z3 AST that applies the `RefLifetime` function to
    /// `args`.
    ///
    /// # Panics
    /// - if the context object for `Self::CONTEXT_KEY` is not initialized
    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        OpaqueLifetime::from_ast(
            &self
                .get_decl(ctx)
                .apply(&[&args.0])
                .as_int()
                .expect("Function signature is Int -> Int"),
        )
    }
}

impl DeclaredFunction for RefLifetime {
    /// Generates the Z3 function declaration for `RefLifetime`.
    fn declare(&self, ctx: &mut Context) {
        let func = FuncDecl::new(Self::NAME, &[&Sort::int()], &Sort::int());
        ctx.func_decls.insert(Self::CONTEXT_KEY, func);
    }
}
