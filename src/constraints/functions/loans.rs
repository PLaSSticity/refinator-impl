//! `Loans` function declaration.

use z3::{FuncDecl, Sort, ast::Set};

use crate::constraints::{
    Context, ContextKey,
    datatypes::{OpaqueDatatype, loan::OpaqueLoan, point::OpaquePoint},
    functions::{DeclaredFunction, Function, SingletonFunction},
};

/// Declaration of `Loans` function.
pub struct Loans;

impl SingletonFunction for Loans {
    const INSTANCE: Self = Loans {};
}

impl Function for Loans {
    const CONTEXT_KEY: ContextKey = ContextKey::FuncDeclLoans;
    const NAME: &str = "Loans";
    type DomainType = (OpaquePoint,);
    type CodomainType = Set;

    /// Generates the Z3 AST that applies the `Loans` function to `args`.
    ///
    /// # Panics
    /// - if the context object for `Self::CONTEXT_KEY` is not initialized
    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        self.get_decl(ctx)
            .apply(&[args.0.ast()])
            .as_set()
            .expect("Function signature is Point -> 𝒫(Loan)")
    }
}

impl DeclaredFunction for Loans {
    /// Generates the Z3 function declaration for `Loans`.
    ///
    /// # Panics
    /// - if the context object for `ContextKey::DatatypePoint` is not
    ///   initialized
    /// - if the context object for `ContextKey::DatatypeLoan` is not
    ///   initialized
    fn declare(&self, ctx: &mut Context) {
        let func = FuncDecl::new(
            Self::NAME,
            &[&OpaquePoint::get_sort(ctx)],
            &Sort::set(&OpaqueLoan::get_sort(ctx)),
        );
        ctx.func_decls.insert(Self::CONTEXT_KEY, func);
    }
}
