//! # &inator SMT Constraint Functions
//!
//! In this module, we declare or define the SMT functions used in &inator's SMT
//! constraints.

use z3::{FuncDecl, RecFuncDecl, ast::Bool};

use crate::{
    constraints::{Context, ContextKey},
    lang::program::Program,
};

pub mod cost;
pub mod labrtype;
pub mod lifetime;
pub mod lifetime_end;
pub mod loans;
pub mod ref_bind;
pub mod ref_lifetime;
pub mod ref_param;
pub mod struct_bind;
pub mod struct_generics;
pub mod struct_lifetime;
pub mod struct_param;
pub mod struct_rank;

pub trait Function: Sized {
    /// The context key for this function definition.
    const CONTEXT_KEY: ContextKey;

    /// The name to use for this function in Z3.
    const NAME: &str;

    /// The type of the domain.
    type DomainType;

    /// The type of the codomain.
    type CodomainType;

    /// Generates the Z3 AST that applies this function to `args`.
    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType;
}

pub trait DefinedFunction: Function {
    /// Generates the Z3 function definition.
    fn define(&self, ctx: &mut Context);

    /// Pulls the Z3 `RecFuncDecl` for this function.
    ///
    /// # Panics
    /// - if the context object for `Self::CONTEXT_KEY` is not initialized
    fn get_def<'a>(&self, ctx: &'a Context<'a>) -> &'a RecFuncDecl {
        ctx.func_defs
            .get(&(Self::CONTEXT_KEY, None))
            .as_ref()
            .unwrap()
    }
}

pub trait InlineFunction: DefinedFunction {
    /// Generates the Z3 AST that applies this function to `args` by inlining
    /// its definition.
    fn inline(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType;
}

pub trait DeclaredFunction: Function {
    /// Generates the Z3 function declaration.
    fn declare(&self, ctx: &mut Context);

    /// Pulls the Z3 `FuncDecl` for this function.
    ///
    /// # Panics
    /// - if the context object for `Self::CONTEXT_KEY` is not initialized
    fn get_decl<'a>(&self, ctx: &'a Context<'a>) -> &'a FuncDecl {
        ctx.func_decls.get(&Self::CONTEXT_KEY).unwrap()
    }
}

pub trait SingletonFunction: Function {
    /// The singleton instance for this function.
    const INSTANCE: Self;

    /// Generates the Z3 AST that applies this function to `args`.
    fn apply(ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        Self::INSTANCE.apply(ctx, args)
    }
}

pub trait AxiomatizedFunction: DeclaredFunction {
    /// Generates the axioms for this function.
    fn constrain(&self, ctx: &Context, program: &Program) -> Vec<Bool>;
}

pub trait DefinedSingletonFunction: DefinedFunction + SingletonFunction {
    /// Generates the Z3 function definition.
    fn define(ctx: &mut Context) {
        Self::INSTANCE.define(ctx);
    }

    /// Pulls the Z3 `RecFuncDecl` for this function.
    ///
    /// # Panics
    /// - if the context object for `Self::CONTEXT_KEY` is not initialized
    fn get_def<'a>(ctx: &'a Context<'a>) -> &'a RecFuncDecl {
        Self::INSTANCE.get_def(ctx)
    }
}

pub trait InlineSingletonFunction: InlineFunction + SingletonFunction {
    /// Generates the Z3 AST that applies this function to `args` by inlining
    /// its definition.
    fn inline(ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        Self::INSTANCE.inline(ctx, args)
    }
}

pub trait DeclaredSingletonFunction: DeclaredFunction + SingletonFunction {
    /// Generates the Z3 function declaration.
    fn declare(ctx: &mut Context) {
        Self::INSTANCE.declare(ctx);
    }

    /// Pulls the Z3 `FuncDecl` for this function.
    ///
    /// # Panics
    /// - if the context object for `Self::CONTEXT_KEY` is not initialized
    fn get_decl<'a>(ctx: &'a Context<'a>) -> &'a FuncDecl {
        Self::INSTANCE.get_decl(ctx)
    }
}

pub trait AxiomatizedSingletonFunction: AxiomatizedFunction + DeclaredSingletonFunction {
    /// Generates the axioms for this function.
    fn constrain(ctx: &Context, program: &Program) -> Vec<Bool> {
        Self::INSTANCE.constrain(ctx, program)
    }
}

impl<T: DefinedFunction + SingletonFunction> DefinedSingletonFunction for T {}
impl<T: InlineFunction + SingletonFunction> InlineSingletonFunction for T {}
impl<T: DeclaredFunction + SingletonFunction> DeclaredSingletonFunction for T {}
impl<T: AxiomatizedFunction + SingletonFunction> AxiomatizedSingletonFunction for T {}
