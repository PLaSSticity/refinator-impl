//! `StructLifetime` function declaration.

use z3::{FuncDecl, Sort, ast::Int};

use crate::constraints::{
    Context, ContextKey,
    datatypes::{OpaqueDatatype, lifetime::OpaqueLifetime},
    functions::{DeclaredFunction, Function, SingletonFunction},
};

/// Declaration of `StructLifetime` function.
pub struct StructLifetime;

impl SingletonFunction for StructLifetime {
    const INSTANCE: Self = StructLifetime {};
}

impl Function for StructLifetime {
    const CONTEXT_KEY: ContextKey = ContextKey::FuncDeclStructLifetime;
    const NAME: &str = "StructLifetime";
    type DomainType = (Int, Int);
    type CodomainType = OpaqueLifetime;

    /// Generates the Z3 AST that applies the `StructLifetime` function to
    /// `args`.
    ///
    /// # Panics
    /// - if the context object for `Self::CONTEXT_KEY` is not initialized
    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        OpaqueLifetime::from_ast(
            &self
                .get_decl(ctx)
                .apply(&[&args.0, &args.1])
                .as_int()
                .expect("Function signature is Int × Int -> Int"),
        )
    }
}

impl DeclaredFunction for StructLifetime {
    /// Generates the Z3 function declaration for `StructLifetime`.
    ///
    /// # Panics
    /// - if the context object for `ContextKey::DatatypeList` is not
    ///   initialized
    fn declare(&self, ctx: &mut Context) {
        let func = FuncDecl::new(Self::NAME, &[&Sort::int(), &Sort::int()], &Sort::int());
        ctx.func_decls.insert(Self::CONTEXT_KEY, func);
    }
}
