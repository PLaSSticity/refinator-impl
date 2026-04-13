//! `RefParam` function declaration.

use z3::{FuncDecl, Sort, ast::Int};

use crate::constraints::{
    Context, ContextKey,
    functions::{DeclaredFunction, Function, SingletonFunction},
};

/// Declaration of `RefParam` function.
pub struct RefParam;

impl SingletonFunction for RefParam {
    const INSTANCE: Self = RefParam {};
}

impl Function for RefParam {
    const CONTEXT_KEY: ContextKey = ContextKey::FuncDeclRefParam;
    const NAME: &str = "RefParam";
    type DomainType = (Int,);
    type CodomainType = Int;

    /// Generates the Z3 AST that applies the `RefParam` function to
    /// `args`.
    ///
    /// # Panics
    /// - if the context object for `Self::CONTEXT_KEY` is not initialized
    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        self.get_decl(ctx)
            .apply(&[&args.0])
            .as_int()
            .expect("Function signature is Int -> Int")
    }
}

impl DeclaredFunction for RefParam {
    /// Generates the Z3 function declaration for `RefParam`.
    fn declare(&self, ctx: &mut Context) {
        let func = FuncDecl::new(Self::NAME, &[&Sort::int()], &Sort::int());
        ctx.func_decls.insert(Self::CONTEXT_KEY, func);
    }
}
