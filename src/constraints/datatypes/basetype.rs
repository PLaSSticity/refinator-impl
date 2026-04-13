//! Definition of the `BaseType` datatype.
//!
//! The `BaseType` datatype is an enumeration of the base Rust type fragments
//! that may appear in the Rust types inferred by &inator.

use const_format::formatcp;
use z3::{
    DatatypeAccessor, DatatypeBuilder, Model,
    ast::{Ast, Bool, Datatype, Dynamic},
};

use crate::constraints::{
    Context, ContextKey,
    datatypes::{
        InterpDatatype, OpaqueDatatype,
        r#struct::{InterpStruct, OpaqueStruct},
    },
};

/* Constants ================================================================ */

/// The name of the `void` variant in Z3.
const VOID_VARIANT_NAME: &str = formatcp!("{}.void", OpaqueBaseType::NAME);

/// The index of the `void` variant in the `DatatypeSort`.
const VOID_VARIANT_IDX: usize = 0;

/// The name of the `bool` variant in Z3.
const BOOL_VARIANT_NAME: &str = formatcp!("{}.bool", OpaqueBaseType::NAME);

/// The index of the `bool` variant in the `DatatypeSort`.
const BOOL_VARIANT_IDX: usize = 1;

/// The name of the `i8` variant in Z3.
const I8_VARIANT_NAME: &str = formatcp!("{}.i8", OpaqueBaseType::NAME);

/// The index of the `i8` variant in the `DatatypeSort`.
const I8_VARIANT_IDX: usize = 2;

/// The name of the `i16` variant in Z3.
const I16_VARIANT_NAME: &str = formatcp!("{}.i16", OpaqueBaseType::NAME);

/// The index of the `i16` variant in the `DatatypeSort`.
const I16_VARIANT_IDX: usize = 3;

/// The name of the `i32` variant in Z3.
const I32_VARIANT_NAME: &str = formatcp!("{}.i32", OpaqueBaseType::NAME);

/// The index of the `i32` variant in the `DatatypeSort`.
const I32_VARIANT_IDX: usize = 4;

/// The name of the `i64` variant in Z3.
const I64_VARIANT_NAME: &str = formatcp!("{}.i64", OpaqueBaseType::NAME);

/// The index of the `i64` variant in the `DatatypeSort`.
const I64_VARIANT_IDX: usize = 5;

/// The name of the `f32` variant in Z3.
const F32_VARIANT_NAME: &str = formatcp!("{}.f32", OpaqueBaseType::NAME);

/// The index of the `f32` variant in the `DatatypeSort`.
const F32_VARIANT_IDX: usize = 6;

/// The name of the `f64` variant in Z3.
const F64_VARIANT_NAME: &str = formatcp!("{}.f64", OpaqueBaseType::NAME);

/// The index of the `f64` variant in the `DatatypeSort`.
const F64_VARIANT_IDX: usize = 7;

/// The name of the `ghost` variant in Z3.
const GHOST_VARIANT_NAME: &str = formatcp!("{}.ghost", OpaqueBaseType::NAME);

/// The index of the `ghost` variant in the `DatatypeSort`.
const GHOST_VARIANT_IDX: usize = 8;

/// The name of the `Box` variant in Z3.
const BOX_VARIANT_NAME: &str = formatcp!("{}.Box", OpaqueBaseType::NAME);

/// The index of the `Box` variant in the `DatatypeSort`.
const BOX_VARIANT_IDX: usize = 9;

/// The name of the `Rc` variant in Z3.
const RC_VARIANT_NAME: &str = formatcp!("{}.Rc", OpaqueBaseType::NAME);

/// The index of the `Rc` variant in the `DatatypeSort`.
const RC_VARIANT_IDX: usize = 10;

/// The name of the `shared` variant in Z3.
const SHARED_VARIANT_NAME: &str = formatcp!("{}.shared", OpaqueBaseType::NAME);

/// The index of the `shared` variant in the `DatatypeSort`.
const SHARED_VARIANT_IDX: usize = 11;

/// The name of the `mut` variant in Z3.
const MUT_VARIANT_NAME: &str = formatcp!("{}.mut", OpaqueBaseType::NAME);

/// The index of the `mut` variant in the `DatatypeSort`.
const MUT_VARIANT_IDX: usize = 12;

/// The name of the `unknown` variant in Z3.
const UNKNOWN_VARIANT_NAME: &str = formatcp!("{}.unknown", OpaqueBaseType::NAME);

/// The index of the `unknown` variant in the `DatatypeSort`.
const UNKNOWN_VARIANT_IDX: usize = 13;

// Struct has to be the last variant, since we may omit it for programs that
// don't use any structs.

/// The name of the `struct` variant in Z3.
const STRUCT_VARIANT_NAME: &str = formatcp!("{}.struct", OpaqueBaseType::NAME);

/// The index of the `struct` variant in the `DatatypeSort`.
const STRUCT_VARIANT_IDX: usize = 14;

/// The name of the `kind` accessor for the `struct` variant in Z3.
const STRUCT_KIND_ACCESSOR_NAME: &str = formatcp!("{STRUCT_VARIANT_NAME}.kind");

/// The index of the `kind` accessor for the `struct` variant in Z3.
const STRUCT_KIND_ACCESSOR_IDX: usize = 0;

/* End of constants ========================================================= */

/// Opaque Z3 representation of an `BaseType`.
#[derive(Clone)]
pub struct OpaqueBaseType(Datatype);

impl OpaqueDatatype for OpaqueBaseType {
    const CONTEXT_KEY: ContextKey = ContextKey::DatatypeBaseType;
    const NAME: &str = "BaseType";
    type Dual = InterpBaseType;
    type Options<'a> = ();
    type Z3Ast = Datatype;

    /// Generates the Z3 datatype definition.
    ///
    /// If `ContextKey::DatatypeStruct` or `ContextKey::VariantsStruct` is `None` in
    /// `ctx`, then the Z3 datatype is not defined with a struct variant.
    fn define(ctx: &mut Context, _options: &Self::Options<'_>) {
        let mut builder = DatatypeBuilder::new(Self::NAME)
            .variant(VOID_VARIANT_NAME, vec![])
            .variant(BOOL_VARIANT_NAME, vec![])
            .variant(I8_VARIANT_NAME, vec![])
            .variant(I16_VARIANT_NAME, vec![])
            .variant(I32_VARIANT_NAME, vec![])
            .variant(I64_VARIANT_NAME, vec![])
            .variant(F32_VARIANT_NAME, vec![])
            .variant(F64_VARIANT_NAME, vec![])
            .variant(GHOST_VARIANT_NAME, vec![])
            .variant(BOX_VARIANT_NAME, vec![])
            .variant(RC_VARIANT_NAME, vec![])
            .variant(SHARED_VARIANT_NAME, vec![])
            .variant(MUT_VARIANT_NAME, vec![])
            .variant(UNKNOWN_VARIANT_NAME, vec![]);
        if ctx.datatypes.contains_key(&ContextKey::DatatypeStruct) {
            builder = builder.variant(
                STRUCT_VARIANT_NAME,
                vec![(
                    STRUCT_KIND_ACCESSOR_NAME,
                    DatatypeAccessor::sort(OpaqueStruct::get_sort(ctx).clone()),
                )],
            );
        }
        ctx.datatypes.insert(Self::CONTEXT_KEY, builder.finish());
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

    fn interpret(&self, ctx: &Context, model: &Model) -> Self::Dual {
        let func_name = self.0.decl().name();
        match func_name.as_str() {
            VOID_VARIANT_NAME => Self::Dual::Void,
            BOOL_VARIANT_NAME => Self::Dual::Bool,
            I8_VARIANT_NAME => Self::Dual::Int8,
            I16_VARIANT_NAME => Self::Dual::Int16,
            I32_VARIANT_NAME => Self::Dual::Int32,
            I64_VARIANT_NAME => Self::Dual::Int64,
            F32_VARIANT_NAME => Self::Dual::Float32,
            F64_VARIANT_NAME => Self::Dual::Float64,
            GHOST_VARIANT_NAME => Self::Dual::Ghost,
            BOX_VARIANT_NAME => Self::Dual::Box,
            RC_VARIANT_NAME => Self::Dual::Rc,
            SHARED_VARIANT_NAME => Self::Dual::Shared,
            MUT_VARIANT_NAME => Self::Dual::Mut,
            UNKNOWN_VARIANT_NAME => Self::Dual::Unknown,
            STRUCT_VARIANT_NAME => Self::Dual::Struct {
                kind: OpaqueStruct::from_ast(
                    &model.eval(self.struct_kind(ctx).ast(), false).unwrap(),
                )
                .interpret(ctx, model),
            },
            _ => panic!(
                "Expected an application of `{}.VARIANT_NAME` for some valid `VARIANT_NAME` for `BaseType`, but found `{}` instead",
                Self::NAME,
                self.0
            ),
        }
    }
}

impl OpaqueBaseType {
    /* Constructors --------------------------------------------------------- */

    /// Produces a Z3 `BaseType` AST of `void` variant.
    pub fn void(ctx: &Context) -> Self {
        Self::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[VOID_VARIANT_IDX]
                .constructor
                .apply(&[])
                .as_datatype()
                .unwrap(),
        )
    }

    /// Produces a Z3 `BaseType` AST of `bool` variant.
    pub fn bool(ctx: &Context) -> Self {
        Self::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[BOOL_VARIANT_IDX]
                .constructor
                .apply(&[])
                .as_datatype()
                .unwrap(),
        )
    }

    /// Produces a Z3 `BaseType` AST of `i8` variant.
    pub fn i8(ctx: &Context) -> Self {
        Self::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[I8_VARIANT_IDX]
                .constructor
                .apply(&[])
                .as_datatype()
                .unwrap(),
        )
    }

    /// Produces a Z3 `BaseType` AST of `i16` variant.
    pub fn i16(ctx: &Context) -> Self {
        Self::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[I16_VARIANT_IDX]
                .constructor
                .apply(&[])
                .as_datatype()
                .unwrap(),
        )
    }

    /// Produces a Z3 `BaseType` AST of `i32` variant.
    pub fn i32(ctx: &Context) -> Self {
        Self::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[I32_VARIANT_IDX]
                .constructor
                .apply(&[])
                .as_datatype()
                .unwrap(),
        )
    }

    /// Produces a Z3 `BaseType` AST of `i64` variant.
    pub fn i64(ctx: &Context) -> Self {
        Self::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[I64_VARIANT_IDX]
                .constructor
                .apply(&[])
                .as_datatype()
                .unwrap(),
        )
    }

    /// Produces a Z3 `BaseType` AST of `f32` variant.
    pub fn f32(ctx: &Context) -> Self {
        Self::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[F32_VARIANT_IDX]
                .constructor
                .apply(&[])
                .as_datatype()
                .unwrap(),
        )
    }

    /// Produces a Z3 `BaseType` AST of `f64` variant.
    pub fn f64(ctx: &Context) -> Self {
        Self::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[F64_VARIANT_IDX]
                .constructor
                .apply(&[])
                .as_datatype()
                .unwrap(),
        )
    }

    /// Produces a Z3 `BaseType` AST of `ghost` variant.
    pub fn ghost(ctx: &Context) -> Self {
        Self::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[GHOST_VARIANT_IDX]
                .constructor
                .apply(&[])
                .as_datatype()
                .unwrap(),
        )
    }

    /// Produces a Z3 `BaseType` AST of `Box` variant.
    pub fn r#box(ctx: &Context) -> Self {
        Self::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[BOX_VARIANT_IDX]
                .constructor
                .apply(&[])
                .as_datatype()
                .unwrap(),
        )
    }

    /// Produces a Z3 `BaseType` AST of `Rc` variant.
    pub fn rc(ctx: &Context) -> Self {
        Self::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[RC_VARIANT_IDX]
                .constructor
                .apply(&[])
                .as_datatype()
                .unwrap(),
        )
    }

    /// Produces a Z3 `BaseType` AST of `shared` variant with `lifetime`.
    pub fn shared(ctx: &Context) -> Self {
        Self::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[SHARED_VARIANT_IDX]
                .constructor
                .apply(&[])
                .as_datatype()
                .unwrap(),
        )
    }

    /// Produces a Z3 `BaseType` AST of `mut` variant with `lifetime`.
    pub fn r#mut(ctx: &Context) -> Self {
        Self::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[MUT_VARIANT_IDX]
                .constructor
                .apply(&[])
                .as_datatype()
                .unwrap(),
        )
    }

    /// Produces a Z3 `BaseType` AST of `unknown` variant.
    pub fn unknown(ctx: &Context) -> Self {
        Self::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[UNKNOWN_VARIANT_IDX]
                .constructor
                .apply(&[])
                .as_datatype()
                .unwrap(),
        )
    }

    /// Produces a Z3 `BaseType` AST of `struct` variant with `kind` and
    /// `lifetimes`.
    pub fn r#struct(ctx: &Context, kind: &OpaqueStruct) -> Self {
        Self::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[STRUCT_VARIANT_IDX]
                .constructor
                .apply(&[kind.ast()])
                .as_datatype()
                .unwrap(),
        )
    }

    /* Testers -------------------------------------------------------------- */

    /// Produces a Z3 AST which checks if `self` is a `void` variant.
    pub fn is_void(&self, ctx: &Context) -> Bool {
        Self::get_datatype_sort(ctx).as_ref().unwrap().variants[VOID_VARIANT_IDX]
            .tester
            .apply(&[&self.0])
            .as_bool()
            .unwrap()
    }

    /// Produces a Z3 AST which checks if `self` is a `bool` variant.
    pub fn is_bool(&self, ctx: &Context) -> Bool {
        Self::get_datatype_sort(ctx).as_ref().unwrap().variants[BOOL_VARIANT_IDX]
            .tester
            .apply(&[&self.0])
            .as_bool()
            .unwrap()
    }

    /// Produces a Z3 AST which checks if `self` is a `i8` variant.
    pub fn is_i8(&self, ctx: &Context) -> Bool {
        Self::get_datatype_sort(ctx).as_ref().unwrap().variants[I8_VARIANT_IDX]
            .tester
            .apply(&[&self.0])
            .as_bool()
            .unwrap()
    }

    /// Produces a Z3 AST which checks if `self` is a `i16` variant.
    pub fn is_i16(&self, ctx: &Context) -> Bool {
        Self::get_datatype_sort(ctx).as_ref().unwrap().variants[I16_VARIANT_IDX]
            .tester
            .apply(&[&self.0])
            .as_bool()
            .unwrap()
    }

    /// Produces a Z3 AST which checks if `self` is a `i32` variant.
    pub fn is_i32(&self, ctx: &Context) -> Bool {
        Self::get_datatype_sort(ctx).as_ref().unwrap().variants[I32_VARIANT_IDX]
            .tester
            .apply(&[&self.0])
            .as_bool()
            .unwrap()
    }

    /// Produces a Z3 AST which checks if `self` is a `i64` variant.
    pub fn is_i64(&self, ctx: &Context) -> Bool {
        Self::get_datatype_sort(ctx).as_ref().unwrap().variants[I64_VARIANT_IDX]
            .tester
            .apply(&[&self.0])
            .as_bool()
            .unwrap()
    }

    /// Produces a Z3 AST which checks if `self` is a `f32` variant.
    pub fn is_f32(&self, ctx: &Context) -> Bool {
        Self::get_datatype_sort(ctx).as_ref().unwrap().variants[F32_VARIANT_IDX]
            .tester
            .apply(&[&self.0])
            .as_bool()
            .unwrap()
    }

    /// Produces a Z3 AST which checks if `self` is a `f64` variant.
    pub fn is_f64(&self, ctx: &Context) -> Bool {
        Self::get_datatype_sort(ctx).as_ref().unwrap().variants[F64_VARIANT_IDX]
            .tester
            .apply(&[&self.0])
            .as_bool()
            .unwrap()
    }

    /// Produces a Z3 AST which checks if `self` is a `ghost` variant.
    pub fn is_ghost(&self, ctx: &Context) -> Bool {
        Self::get_datatype_sort(ctx).as_ref().unwrap().variants[GHOST_VARIANT_IDX]
            .tester
            .apply(&[&self.0])
            .as_bool()
            .unwrap()
    }

    /// Produces a Z3 AST which checks if `self` is a `Box` variant.
    pub fn is_box(&self, ctx: &Context) -> Bool {
        Self::get_datatype_sort(ctx).as_ref().unwrap().variants[BOX_VARIANT_IDX]
            .tester
            .apply(&[&self.0])
            .as_bool()
            .unwrap()
    }

    /// Produces a Z3 AST which checks if `self` is a `Rc` variant.
    pub fn is_rc(&self, ctx: &Context) -> Bool {
        Self::get_datatype_sort(ctx).as_ref().unwrap().variants[RC_VARIANT_IDX]
            .tester
            .apply(&[&self.0])
            .as_bool()
            .unwrap()
    }

    /// Produces a Z3 AST which checks if `self` is a `shared` variant.
    pub fn is_shared(&self, ctx: &Context) -> Bool {
        Self::get_datatype_sort(ctx).as_ref().unwrap().variants[SHARED_VARIANT_IDX]
            .tester
            .apply(&[&self.0])
            .as_bool()
            .unwrap()
    }

    /// Produces a Z3 AST which checks if `self` is a `mut` variant.
    pub fn is_mut(&self, ctx: &Context) -> Bool {
        Self::get_datatype_sort(ctx).as_ref().unwrap().variants[MUT_VARIANT_IDX]
            .tester
            .apply(&[&self.0])
            .as_bool()
            .unwrap()
    }

    /// Produces a Z3 AST which checks if `self` is an `unknown` variant.
    pub fn is_unknown(&self, ctx: &Context) -> Bool {
        Self::get_datatype_sort(ctx).as_ref().unwrap().variants[UNKNOWN_VARIANT_IDX]
            .tester
            .apply(&[&self.0])
            .as_bool()
            .unwrap()
    }

    /// Produces a Z3 AST which checks if `self` is a `struct` variant.
    pub fn is_struct(&self, ctx: &Context) -> Bool {
        Self::get_datatype_sort(ctx).as_ref().unwrap().variants[STRUCT_VARIANT_IDX]
            .tester
            .apply(&[&self.0])
            .as_bool()
            .unwrap()
    }

    /* Accessors ------------------------------------------------------------ */

    /// Produces a Z3 AST which gets the `kind` field of `self`, if `self`
    /// is a `struct` variant.
    pub fn struct_kind(&self, ctx: &Context) -> OpaqueStruct {
        OpaqueStruct::from_ast(
            &Self::get_datatype_sort(ctx).as_ref().unwrap().variants[STRUCT_VARIANT_IDX].accessors
                [STRUCT_KIND_ACCESSOR_IDX]
                .apply(&[&self.0])
                .as_datatype()
                .unwrap(),
        )
    }

    /* Convenience testers -------------------------------------------------- */

    /// Produces a Z3 AST which checks if `self` is some ptr variant.
    pub fn is_ptr(&self, ctx: &Context) -> Bool {
        Bool::or(&[
            self.is_ghost(ctx),
            self.is_box(ctx),
            self.is_rc(ctx),
            self.is_mut(ctx),
            self.is_shared(ctx),
        ])
    }

    /// Produces a Z3 AST which checks if `self` is some owned pointer variant.
    pub fn is_own(&self, ctx: &Context) -> Bool {
        Bool::or(&[self.is_ghost(ctx), self.is_box(ctx), self.is_rc(ctx)])
    }

    /// Produces a Z3 AST which checks if `self` is some borrowed reference
    /// variant.
    pub fn is_ref(&self, ctx: &Context) -> Bool {
        Bool::or(&[self.is_shared(ctx), self.is_mut(ctx)])
    }

    /// Produces a Z3 AST which checks if `self` is a `struct` variant of kind
    /// `kind`.
    pub fn is_struct_kind(&self, ctx: &Context, kind: &OpaqueStruct) -> Bool {
        Bool::and(&[
            self.is_struct(ctx),
            Dynamic::from_ast(self.struct_kind(ctx).ast()).eq(Dynamic::from_ast(kind.ast())),
        ])
    }
}

/// Interpretation of an `BaseType`.
#[derive(Clone)]
pub enum InterpBaseType {
    Void,
    Bool,
    Int8,
    Int16,
    Int32,
    Int64,
    Float32,
    Float64,
    Ghost,
    Box,
    Rc,
    Shared,
    Mut,
    Unknown,
    Struct { kind: InterpStruct },
}

impl InterpDatatype for InterpBaseType {
    type Dual = OpaqueBaseType;

    fn opaquify(&self, ctx: &Context) -> Self::Dual {
        match self {
            Self::Void => Self::Dual::void(ctx),
            Self::Bool => Self::Dual::bool(ctx),
            Self::Int8 => Self::Dual::i8(ctx),
            Self::Int16 => Self::Dual::i16(ctx),
            Self::Int32 => Self::Dual::i32(ctx),
            Self::Int64 => Self::Dual::i64(ctx),
            Self::Float32 => Self::Dual::f32(ctx),
            Self::Float64 => Self::Dual::f64(ctx),
            Self::Ghost => Self::Dual::ghost(ctx),
            Self::Box => Self::Dual::r#box(ctx),
            Self::Rc => Self::Dual::rc(ctx),
            Self::Shared => Self::Dual::shared(ctx),
            Self::Mut => Self::Dual::r#mut(ctx),
            Self::Unknown => Self::Dual::unknown(ctx),
            Self::Struct { kind } => Self::Dual::r#struct(ctx, &kind.opaquify(ctx)),
        }
    }
}
