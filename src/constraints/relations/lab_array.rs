//! `LabArray` relation declaration.

use z3::{
    FuncDecl, Sort,
    ast::{Bool, Int},
};

use crate::constraints::{
    Context, ContextKey,
    functions::{DeclaredFunction, Function, SingletonFunction},
};

/// Declaration of `LabArray` relation.
pub struct LabArray;

impl SingletonFunction for LabArray {
    const INSTANCE: Self = LabArray {};
}

impl Function for LabArray {
    const CONTEXT_KEY: ContextKey = ContextKey::RelDeclLabArray;
    const NAME: &str = "LabArray";
    type DomainType = (Int,);
    type CodomainType = Bool;

    /// Generates the Z3 AST that applies the `LabArray` relation to `args`.
    ///
    /// # Panics
    /// - if the context object for `ContextKey::RelDeclLabArray` is not
    ///   initialized.
    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        self.get_decl(ctx)
            .apply(&[&args.0])
            .as_bool()
            .expect("Function signature is Int -> Bool")
    }
}

impl DeclaredFunction for LabArray {
    /// Generates the Z3 function declaration.
    fn declare(&self, ctx: &mut Context) {
        let func = FuncDecl::new(Self::NAME, &[&Sort::int()], &Sort::bool());
        ctx.func_decls.insert(Self::CONTEXT_KEY, func);
    }
}
