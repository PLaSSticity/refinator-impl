//! `StructGenerics` function declaration.

use z3::{FuncDecl, Sort, ast::Int};

use crate::constraints::{
    Context, ContextKey,
    datatypes::{OpaqueDatatype, r#struct::OpaqueStruct},
    functions::{DeclaredFunction, Function, SingletonFunction},
};

/// Declaration of `StructGenerics` function.
pub struct StructGenerics;

impl SingletonFunction for StructGenerics {
    const INSTANCE: Self = StructGenerics {};
}

impl Function for StructGenerics {
    const CONTEXT_KEY: ContextKey = ContextKey::FuncDeclStructGenerics;
    const NAME: &str = "StructGenerics";
    type DomainType = (OpaqueStruct,);
    type CodomainType = Int;

    /// Generates the Z3 AST that applies the `StructGenerics` function to
    /// `args`.
    ///
    /// # Panics
    /// - if the context object for `Self::CONTEXT_KEY` is not initialized
    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        self.get_decl(ctx)
            .apply(&[args.0.ast()])
            .as_int()
            .expect("Function signature is Struct -> Int")
    }
}

impl DeclaredFunction for StructGenerics {
    /// Generates the Z3 function declaration for `StructGenerics`.
    ///
    /// # Panics
    /// - if the context object for `ContextKey::DatatypeStruct` is not
    ///   initialized
    /// - if the context object for `ContextKey::DatatypeList` is not
    ///   initialized
    fn declare(&self, ctx: &mut Context) {
        let func = FuncDecl::new(Self::NAME, &[&OpaqueStruct::get_sort(ctx)], &Sort::int());
        ctx.func_decls.insert(Self::CONTEXT_KEY, func);
    }
}
