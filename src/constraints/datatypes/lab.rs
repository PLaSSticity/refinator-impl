//! Definition of the `Lab` datatype.
//!
//! The `Lab` datatype is an enumeration of `Lab`s that appear in the input to
//! &refinator.

use std::collections::HashMap;

use const_format::formatcp;
use z3::{
    DatatypeBuilder, Model,
    ast::{Ast, Datatype},
};

use crate::{
    constraints::{
        Context, ContextKey,
        datatypes::{InterpDatatype, OpaqueDatatype},
    },
    lang::{instruction::InstrLab, program::Program},
};

/// The prefix to use on the names of the datatype variants.
const VARIANT_NAME_PREFIX: &str = formatcp!("{}.", OpaqueLab::NAME);

/// The error message to print when trying to look up a `Lab` ID that isn't in
/// the variant map.
pub const ERR_BAD_LAB_ID: &str =
    "Attempted to access instruction label that does not exist in the input program.";

/// Opaque Z3 representation of a `Lab`.
#[derive(Clone)]
pub struct OpaqueLab(Datatype);

impl OpaqueDatatype for OpaqueLab {
    const CONTEXT_KEY: ContextKey = ContextKey::DatatypeLab;
    const NAME: &str = "Lab";
    type Dual = InterpLab;
    type Options<'a> = (&'a Program<'a>,);
    type Z3Ast = Datatype;

    /// Takes a 1-tuple `(&Program, )` as the `options` argument, where
    /// `options.0` is the `Program` to analyze.
    fn define(ctx: &mut Context, options: &Self::Options<'_>) {
        let mut variants = HashMap::new();
        let mut builder = DatatypeBuilder::new(Self::NAME);
        let mut variant_idx = 0;
        for function in options.0.functions() {
            for basic_block in &function.basic_blocks {
                for instr in &basic_block.instructions {
                    variants.insert(*instr.id(), variant_idx);
                    builder = builder
                        .variant(&format!("{}{}", VARIANT_NAME_PREFIX, instr.id().0), vec![]);
                    variant_idx += 1;
                }
            }
        }
        ctx.datatypes.insert(Self::CONTEXT_KEY, builder.finish());
        ctx.lab_variants.replace(variants);
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
        assert!(&func_name[..VARIANT_NAME_PREFIX.len()] == VARIANT_NAME_PREFIX);

        let id = InstrLab(func_name[VARIANT_NAME_PREFIX.len()..].parse().unwrap());
        Self::Dual { id }
    }
}

impl OpaqueLab {
    /// Gets the variant map.
    pub fn get_variants<'a>(ctx: &'a Context<'a>) -> &'a HashMap<InstrLab, usize> {
        ctx.lab_variants.as_ref().unwrap()
    }
}

/// Interpretation of a `Lab`.
#[derive(Clone, Copy, PartialEq, Eq)]
pub struct InterpLab {
    pub id: InstrLab,
}

impl InterpDatatype for InterpLab {
    type Dual = OpaqueLab;

    fn opaquify(&self, ctx: &Context) -> Self::Dual {
        Self::Dual::from_ast(
            &Self::Dual::get_datatype_sort(ctx)
                .as_ref()
                .unwrap()
                .variants[*Self::Dual::get_variants(ctx)
                .get(&self.id)
                .expect(ERR_BAD_LAB_ID)]
            .constructor
            .apply(&[])
            .as_datatype()
            .unwrap(),
        )
    }
}

impl InterpLab {
    /// Creates a `InterpLab` with id `id`.
    pub fn new(id: InstrLab) -> Self {
        Self { id }
    }
}
