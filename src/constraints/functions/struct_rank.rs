//! `StructRank` function declaration.

use z3::{FuncDecl, Sort, ast::Int};

use crate::constraints::{
    Context, ContextKey,
    datatypes::{OpaqueDatatype, r#struct::OpaqueStruct},
    functions::{DeclaredFunction, Function, SingletonFunction},
};

/// Declaration of `StructRank` function.
pub struct StructRank;

impl SingletonFunction for StructRank {
    const INSTANCE: Self = StructRank {};
}

impl Function for StructRank {
    const CONTEXT_KEY: ContextKey = ContextKey::FuncDeclStructRank;
    const NAME: &str = "StructRank";
    type DomainType = (OpaqueStruct,);
    type CodomainType = Int;

    /// Generates the Z3 AST that applies the `StructRank` function to `args`.
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

impl DeclaredFunction for StructRank {
    /// Generates the Z3 function declaration for `StructRank`.
    ///
    /// # Panics
    /// - if the context object for `ContextKey::DatatypeStruct` is not
    ///   initialized
    fn declare(&self, ctx: &mut Context) {
        let func = FuncDecl::new(Self::NAME, &[&OpaqueStruct::get_sort(ctx)], &Sort::int());
        ctx.func_decls.insert(Self::CONTEXT_KEY, func);
    }
}
