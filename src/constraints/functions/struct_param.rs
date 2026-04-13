//! `StructParam` function declaration.

use z3::{FuncDecl, Sort, ast::Int};

use crate::constraints::{
    Context, ContextKey,
    functions::{DeclaredFunction, Function, SingletonFunction},
};

/// Declaration of `StructParam` function.
pub struct StructParam;

impl SingletonFunction for StructParam {
    const INSTANCE: Self = StructParam {};
}

impl Function for StructParam {
    const CONTEXT_KEY: ContextKey = ContextKey::FuncDeclStructParam;
    const NAME: &str = "StructParam";
    type DomainType = (Int, Int);
    type CodomainType = Int;

    /// Generates the Z3 AST that applies the `StructParam` function to
    /// `args`.
    ///
    /// # Panics
    /// - if the context object for `Self::CONTEXT_KEY` is not initialized
    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        self.get_decl(ctx)
            .apply(&[&args.0, &args.1])
            .as_int()
            .expect("Function signature is Int × Int -> Int")
    }
}

impl DeclaredFunction for StructParam {
    /// Generates the Z3 function declaration for `StructParam`.
    fn declare(&self, ctx: &mut Context) {
        let func = FuncDecl::new(Self::NAME, &[&Sort::int(), &Sort::int()], &Sort::int());
        ctx.func_decls.insert(Self::CONTEXT_KEY, func);
    }
}
