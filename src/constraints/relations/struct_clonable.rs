//! `StructClonable` relation declaration.

use z3::{FuncDecl, Sort, ast::Bool};

use crate::constraints::{
    Context, ContextKey,
    datatypes::{OpaqueDatatype, r#struct::OpaqueStruct},
    functions::{DeclaredFunction, Function, SingletonFunction},
};

/// Declaration of `StructClonable` function.
pub struct StructClonable;

impl SingletonFunction for StructClonable {
    const INSTANCE: Self = StructClonable {};
}

impl Function for StructClonable {
    const CONTEXT_KEY: ContextKey = ContextKey::RelDeclStructClonable;
    const NAME: &str = "StructClonable";
    type DomainType = (OpaqueStruct,);
    type CodomainType = Bool;

    /// Generates the Z3 AST that applies the `StructClonable` relation to
    /// `args`.
    ///
    /// # Panics
    /// - if the context object for `Self::CONTEXT_KEY` is not initialized.
    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        self.get_decl(ctx)
            .apply(&[args.0.ast()])
            .as_bool()
            .expect("Function signature is Struct -> Bool")
    }
}

impl DeclaredFunction for StructClonable {
    fn declare(&self, ctx: &mut Context) {
        let func = FuncDecl::new(Self::NAME, &[&OpaqueStruct::get_sort(ctx)], &Sort::bool());
        ctx.func_decls.insert(Self::CONTEXT_KEY, func);
    }
}
