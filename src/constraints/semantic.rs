//! # Semantic Preservation Constraints
//!
//! In this module are functions that generate the semantic preservation
//! constraints, as described in the paper.

use z3::ast::Bool;

use crate::{
    analysis::path::Path,
    constraints::{
        Context,
        datatypes::{InterpDatatype, r#struct::InterpStruct},
        functions::{InlineSingletonFunction, SingletonFunction, labrtype::LabRType},
        relations::{pointer_transform::NondestructiveTransform, struct_clonable::StructClonable},
    },
    lang::{
        function::{FuncIdent, Function},
        instruction::Instruction,
        program::Program,
        r#struct::StructIdent,
        stype::{STypeFrag, TypeLab},
    },
};

/// Prefix of functions used for monomorphized `malloc`s in &inator's
/// benchmarks.
pub const PREFIX_MONO_MALLOC: &str = "REFINATOR_MALLOC_";

/// Prefix of functions used for monomorphized `free`s in &inator's benchmarks.
pub const PREFIX_MONO_FREE: &str = "REFINATOR_FREE_";

/// Produces the constraints for required owning pointers.
pub fn gen_owning(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut assertions = vec![];

    // `alloca` instructions should always yield an owning pointer.
    for func in program.functions() {
        for bb in &func.basic_blocks {
            for instr in &bb.instructions {
                if let Instruction::Alloca {
                    id: _,
                    llvm_instr: _,
                    lhs_var,
                } = instr
                {
                    let typelab = *program
                        .var_typelabs(lhs_var)
                        .first()
                        .expect("Every variable should have at least one associated `TypeLab`.");
                    let frag = LabRType::apply(ctx, &(typelab.into(),));
                    assertions.push(frag.is_own(ctx));
                }
            }
        }
    }

    let mut assert_ret_owned = |func: &Function| {
        let typelab = *func
            .ret_typelabs
            .first()
            .expect("Every function return should have at least one associated `TypeLab`.");
        let frag = LabRType::apply(ctx, &(typelab.into(),));
        assertions.push(frag.is_own(ctx));
    };

    // `malloc`, `calloc`, `valloc`, `realloc`, and `aligned_alloc` always yield
    // an owning pointer.
    let libc_allocs = ["malloc", "calloc", "valloc", "realloc", "aligned_alloc"];
    libc_allocs
        .into_iter()
        .filter_map(|name| program.try_get_function(&FuncIdent(String::from(name))))
        .for_each(&mut assert_ret_owned);

    // Support for monomorphized `malloc`-family functions used for the
    // benchmarks.
    program
        .functions()
        .into_iter()
        .filter(|func| func.id.0.find(PREFIX_MONO_MALLOC) == Some(0))
        .for_each(&mut assert_ret_owned);

    assertions
}

/// Produces the live variables-based nondestructive transformation constraints.
pub fn gen_transform(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut assertions = vec![];

    for rval_typelab in ctx.rvals.typelabs() {
        let func = ctx.rvals.get_func(rval_typelab);
        let lv = ctx.live_variables.get(func).expect(
            "Should have performed live-variables analysis on every function \
            in the source program before constraint generation.",
        );
        let instr_lab = ctx.rvals.get_lab(rval_typelab);
        let rval_path = match ctx.rvals.try_get_path(rval_typelab) {
            Some(path) => path,
            None => continue,
        };

        if program.lab_stype(&rval_typelab).is_ptr()
            && lv.live_after(&rval_path.get_var(), &instr_lab)
        {
            let s_typelab = *match rval_path {
                Path::Var { var } => program
                    .var_typelabs(&var)
                    .first()
                    .expect("Every variable should have at least one associated `TypeLab`."),
                Path::Deref { var } => program.var_typelabs(&var).get(1).expect(
                    "Every `ptr`-typed variable should have at least two associated `TypeLab`s.",
                ),
                Path::Elem { var } => program.var_typelabs(&var).first().expect(
                    "Every `ptr`-typed variable should have at least two associated `TypeLab`s.",
                ),
                Path::DDeref { .. } => unreachable!(),
                Path::Field { var, field } => {
                    let r#struct = match program.var_stype(&var).get(1).expect(
                        "Every `ptr`-typed variable should have at least to associated `TypeLab`s.",
                    ) {
                        STypeFrag::Struct(s) => s,
                        _ => fail_debug(&func, &rval_typelab), //unreachable!(),
                    };
                    let r#struct = StructIdent(String::from(r#struct));
                    program.field_typelabs(&r#struct, &field).first().expect(
                    "Every `ptr`-typed variable should have at least two associated `TypeLab`s.",
                    )
                }
            };
            assertions.push(NondestructiveTransform::inline(
                ctx,
                &(s_typelab.into(), rval_typelab.into()),
            ));
        }
    }

    assertions
}

/** debug.py expects this format for output */
fn fail_debug(func: &FuncIdent, typelab: &TypeLab) -> ! {
    panic!("Unexpected error at function {}, typelab {}", func, typelab.0);
}

/// Generates a Z3 AST which checks if the Rust type formed by composing the
/// `TypeLab`s in `typelabs` is shallowly clonable.
///
/// # Panics
/// - if `typelabs` is not well-formed, in the sense that the list of
///   `STypeFrag`s obtained from mapping each `TypeLab` to its `STypeFrag` is
///   is well-formed.
pub fn ast_is_clonable(ctx: &Context, program: &Program, typelabs: &[TypeLab]) -> Bool {
    let (first, rest) = typelabs
        .split_first()
        .expect("Panic in `ast_is_clonable`: `typelabs` is not well-formed.");
    let first_frag = LabRType::apply(ctx, &(first.into(),));
    match program.lab_stype(first) {
        STypeFrag::Pointer => Bool::and(&[
            first_frag.is_box(ctx).not(),
            first_frag.is_mut(ctx).not(),
            first_frag
                .is_ghost(ctx)
                .implies(ast_is_clonable(ctx, program, rest)),
        ]),
        STypeFrag::Struct(s) => StructClonable::apply(ctx, &(InterpStruct::from(s).opaquify(ctx),)),
        STypeFrag::Unknown => Bool::from_bool(false),
        _ => Bool::from_bool(true),
    }
}

/// Generates the struct clonability constraints.
pub fn gen_struct_clonable(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut assertions = vec![];
    for r#struct in program.structs() {
        for typelabs in &r#struct.field_typelabs {
            assertions.push(
                StructClonable::apply(
                    ctx,
                    &(InterpStruct::new(r#struct.id.clone()).opaquify(ctx),),
                )
                .implies(ast_is_clonable(ctx, program, typelabs)),
            )
        }
    }
    assertions
}

/// Generates the referent preservation constraints.
pub fn gen_referent(ctx: &Context, program: &Program) -> Vec<Bool> {
    let mut assertions = vec![];

    for rval_typelab in ctx.rvals.typelabs() {
        let rval_path = ctx.rvals.get_path(rval_typelab);

        // We only need to emit these constraints for pointer-typed `load` and
        // `field` rvalue expressions.
        let outer_typelab = *match rval_path {
            Path::Var { .. } => continue,
            Path::Deref { var } if program.lab_stype(&rval_typelab).is_ptr() => program
                .var_typelabs(&var)
                .first()
                .expect("Every variable should have at least one associated `TypeLab`."),
            Path::Deref { .. } => continue,
            Path::DDeref { .. } => unreachable!(),
            Path::Elem { .. } => continue,
            Path::Field { var, field: _ } => program
                .var_typelabs(&var)
                .first()
                .expect("Every variable should have at least one associated `TypeLab`."),
        };
        let outer_frag = LabRType::apply(ctx, &(outer_typelab.into(),));

        let outer_not_uniq_owning = Bool::or(&[
            outer_frag.is_shared(ctx),
            outer_frag.is_mut(ctx),
            outer_frag.is_rc(ctx),
        ]);

        let src_typelab = *match rval_path {
            Path::Var { .. } => unreachable!(),
            Path::Deref { var } => program.var_typelabs(&var).get(1).expect(
                "Every `ptr`-typed variable should have at least two associated `TypeLab`s.",
            ),
            Path::DDeref { .. } => unreachable!(),
            Path::Elem { .. } => unreachable!(),
            Path::Field { var, field } => {
                let r#struct = match program.var_stype(&var).get(1).expect(
                    "Every `ptr`-typed variable should have at least two associated `TypeLab`s.",
                ) {
                    STypeFrag::Struct(s) => s,
                    _ => unreachable!(),
                };
                let r#struct = StructIdent(String::from(r#struct));
                program.field_typelabs(&r#struct, &field).first().expect(
                    "Every `ptr`-typed variable should have at least two associated `TypeLab`s.",
                )
            }
        };

        assertions.push(
            outer_not_uniq_owning.implies(NondestructiveTransform::inline(
                ctx,
                &(src_typelab.into(), rval_typelab.into()),
            )),
        );
    }

    assertions
}
