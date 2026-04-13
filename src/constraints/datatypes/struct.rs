//! Definition of the `Struct` datatype.
//!
//! The `Struct` datatype is an enumeration of struct kinds that appear in the
//! input to &refinator.

use std::collections::HashMap;

use const_format::formatcp;
use z3::{
    DatatypeBuilder, Model,
    ast::{Ast, Bool, Datatype},
};

use crate::{
    constraints::{
        Context, ContextKey,
        datatypes::{InterpDatatype, OpaqueDatatype},
    },
    lang::{program::Program, r#struct::StructIdent},
};

/// The prefix to use on the names of the datatype variants.
const VARIANT_NAME_PREFIX: &str = formatcp!("{}.", OpaqueStruct::NAME);

/// Error message to print when there are no struct definitions.
pub const ERR_NO_STRUCT_DEFS: &str =
    "Attempted to access struct definitions, but the input program has no struct definitions.";

/// Error message to print when attempting to access a non-existent struct definition.
pub const ERR_BAD_STRUCT_KIND: &str =
    "Attempted to access definition of struct that does not exist in the input program.";

/// Opaque Z3 representation of a `Struct`.
#[derive(Clone)]
pub struct OpaqueStruct(Datatype);

impl OpaqueDatatype for OpaqueStruct {
    const CONTEXT_KEY: ContextKey = ContextKey::DatatypeStruct;
    const NAME: &str = "Struct";
    type Dual = InterpStruct;
    type Options<'a> = (&'a Program<'a>,);
    type Z3Ast = Datatype;

    /// Takes a 1-tuple `(&Program, )` as the `options` argument, where
    /// `options.0` is the `Program` to analyze.
    fn define(ctx: &mut Context, options: &Self::Options<'_>) {
        let structs: Vec<_> = options.0.structs();
        if !structs.is_empty() {
            let mut builder = DatatypeBuilder::new(Self::NAME);
            let mut variants = HashMap::new();
            for (idx, name) in structs.into_iter().map(|s| &s.id).enumerate() {
                builder = builder.variant(&format!("{}{}", VARIANT_NAME_PREFIX, name), vec![]);
                variants.insert(name.clone(), idx);
            }
            ctx.datatypes.insert(Self::CONTEXT_KEY, builder.finish());
            ctx.struct_variants.replace(variants);
        }
    }

    fn new_const(ctx: &Context, name: &str) -> Self {
        Self::from_ast(&Datatype::new_const(name, &Self::get_sort(ctx)))
    }

    fn from_ast(ast: &Self::Z3Ast) -> Self {
        Self(ast.clone())
    }

    fn ast(&self) -> &Self::Z3Ast {
        &self.0
    }

    fn interpret(&self, _ctx: &Context, _model: &Model) -> Self::Dual {
        let func_name = self.0.decl().name();
        assert!(
            &func_name[..VARIANT_NAME_PREFIX.len()] == VARIANT_NAME_PREFIX,
            "Expected a Struct constructor `{}STRUCT_NAME`, but found `{}` instead.",
            VARIANT_NAME_PREFIX,
            self.0
        );

        Self::Dual {
            kind: StructIdent(String::from(&func_name[VARIANT_NAME_PREFIX.len()..])),
        }
    }
}

impl OpaqueStruct {
    /// Gets the map from `StructID`s to `DatatypeSort` variant indices for this
    /// datatype.
    ///
    /// # Panics
    /// - If `define` has not been called.
    pub fn get_variants<'a>(ctx: &'a Context<'a>) -> &'a HashMap<StructIdent, usize> {
        ctx.struct_variants.as_ref().expect(ERR_NO_STRUCT_DEFS)
    }

    /// Produces a Z3 AST which checks if the self`` is the `kind` variant.
    ///
    /// # Panics
    /// - If `kind` is not a struct kind that appears in the variant map.
    pub fn is_kind(&self, ctx: &Context, kind: &StructIdent) -> Bool {
        let variant_idx = Self::get_variants(ctx)
            .get(kind)
            .expect(ERR_BAD_STRUCT_KIND);

        Self::get_datatype_sort(ctx).as_ref().unwrap().variants[*variant_idx]
            .tester
            .apply(&[&self.0])
            .as_bool()
            .unwrap()
    }
}

/// Interpretation of a `Struct`.
#[derive(Clone)]
pub struct InterpStruct {
    pub kind: StructIdent,
}

impl InterpDatatype for InterpStruct {
    type Dual = OpaqueStruct;

    fn opaquify(&self, ctx: &Context) -> Self::Dual {
        let variant_idx = Self::Dual::get_variants(ctx)
            .get(&self.kind)
            .expect(ERR_BAD_STRUCT_KIND);

        Self::Dual::from_ast(
            &Self::Dual::get_datatype_sort(ctx)
                .as_ref()
                .unwrap()
                .variants[*variant_idx]
                .constructor
                .apply(&[])
                .as_datatype()
                .unwrap(),
        )
    }
}

impl InterpStruct {
    /// Creates a `Struct` with kind `kind`.
    pub fn new(kind: StructIdent) -> Self {
        Self { kind }
    }
}

impl<T: Into<String>> From<T> for InterpStruct {
    fn from(value: T) -> Self {
        Self {
            kind: StructIdent(value.into()),
        }
    }
}
