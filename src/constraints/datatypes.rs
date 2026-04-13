//! # &inator SMT Constraint Datatypes
//!
//! In this module, we define the datatypes used in &inator's SMT constraints.

use z3::{DatatypeSort, Model, Sort, ast::Ast};

use crate::constraints::{Context, ContextKey};

pub mod basetype;
pub mod lab;
pub mod lifetime;
pub mod loan;
pub mod point;
pub mod r#struct;

/// Structs that implement `OpaqueDatatype` are opaque (uninterpreted) Z3 ASTs
/// of a datatype type.
pub trait OpaqueDatatype: Clone {
    /// The context key for this datatype.
    const CONTEXT_KEY: ContextKey;

    /// The name of this datatype in Z3.
    const NAME: &'static str;

    /// The interpreted version of this datatype.
    type Dual: InterpDatatype;

    /// The options used in the definition.
    type Options<'a>;

    /// The Z3 AST type.
    type Z3Ast: Ast;

    /// Defines this datatype in Z3.
    fn define(ctx: &mut Context, options: &Self::Options<'_>);

    /// Gets the Z3 `DatatypeSort` for this datatype from `ctx`.
    fn get_datatype_sort<'a>(ctx: &'a Context<'a>) -> Option<&'a DatatypeSort> {
        ctx.datatypes.get(&Self::CONTEXT_KEY)
    }

    /// Gets the Z3 `Sort` for this datatype from `ctx`.
    fn get_sort(ctx: &Context) -> Sort {
        Self::get_datatype_sort(ctx).unwrap().sort.clone()
    }

    /// Creates a Z3 constant of this datatype with name `name`.
    fn new_const(ctx: &Context, name: &str) -> Self;

    /// Constructs a `Self` from a Z3 AST `ast`.
    fn from_ast(ast: &Self::Z3Ast) -> Self;

    /// Gets the Z3 AST for `self`.
    fn ast(&self) -> &Self::Z3Ast;

    /// Converts `Self` to `Self::Dual`.
    ///
    /// # Panics
    /// - If `self.ast()` is not an application of a constructor for `Self`, or
    ///   any argument of the constructor is not a constant or an application of
    ///   another datatype constructor.
    fn interpret(&self, ctx: &Context, model: &Model) -> Self::Dual;
}

/// Structs that implement `IntrpDatatype` are interpreted values of a datatype
/// typed term.
pub trait InterpDatatype: Clone {
    /// The Z3 AST type for this datatype.
    type Dual: OpaqueDatatype;

    /// Converts `Self` to `Self::Dual`.
    fn opaquify(&self, ctx: &Context) -> Self::Dual;
}
