//! `LabRType` function declaration.

use z3::{FuncDecl, Sort, ast::Int};

use crate::constraints::{
    Context, ContextKey,
    datatypes::{OpaqueDatatype, basetype::OpaqueBaseType},
    functions::{DeclaredFunction, Function, SingletonFunction},
};

/// Declaration of `LabRType` function.
pub struct LabRType;

impl SingletonFunction for LabRType {
    const INSTANCE: Self = LabRType {};
}

impl Function for LabRType {
    const CONTEXT_KEY: ContextKey = ContextKey::FuncDeclLabRType;
    const NAME: &str = "LabRType";
    type DomainType = (Int,);
    type CodomainType = OpaqueBaseType;

    /// Generates the Z3 AST that applies the `LabRType` function to `args`.
    ///
    /// # Panics
    /// - if the context object for `Self::CONTEXT_KEY` is not initialized
    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        OpaqueBaseType::from_ast(
            &self
                .get_decl(ctx)
                .apply(&[&args.0])
                .as_datatype()
                .expect("Function signature is Int -> BaseType"),
        )
    }
}

impl DeclaredFunction for LabRType {
    /// Generates the Z3 function declaration for `LabRType`.
    ///
    /// # Panics
    /// - if the context object for `ContextKey::DatatypeBaseType` is not
    ///   initialized
    fn declare(&self, ctx: &mut Context) {
        let func = FuncDecl::new(Self::NAME, &[&Sort::int()], &OpaqueBaseType::get_sort(ctx));
        ctx.func_decls.insert(Self::CONTEXT_KEY, func);
    }
}
