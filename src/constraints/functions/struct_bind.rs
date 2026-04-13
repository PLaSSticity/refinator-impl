//! `struct-bind` function definition.

use z3::{
    FuncDecl, Sort,
    ast::{Bool, Int},
};

use crate::{
    analysis::path::Path,
    constraints::{
        context::{Context, ContextKey},
        datatypes::{OpaqueDatatype, lifetime::OpaqueLifetime},
        functions::{
            AxiomatizedFunction, DeclaredFunction, Function, SingletonFunction,
            struct_lifetime::StructLifetime, struct_param::StructParam,
        },
    },
    lang::program::Program,
};

/// Definition of `struct-bind` function.
pub struct StructBind;

impl SingletonFunction for StructBind {
    const INSTANCE: Self = StructBind {};
}

impl Function for StructBind {
    const CONTEXT_KEY: ContextKey = ContextKey::FuncDefStructBind;
    const NAME: &str = "struct-bind";
    type DomainType = (Int, Int, Int);
    type CodomainType = OpaqueLifetime;

    /// Generates the Z3 AST that applies the `struct-bind` function to `args`.
    ///
    /// # Panics
    /// - if the context object for `Self::CONTEXT_KEY` is not initialized
    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        OpaqueLifetime::from_ast(
            &self
                .get_decl(ctx)
                .apply(&[&args.0, &args.1, &args.2])
                .as_int()
                .expect("Function signature is Int × Int × Int -> Int"),
        )
    }
}

impl DeclaredFunction for StructBind {
    ///Generates the Z3 function declaration for `struct-bind`.
    fn declare(&self, ctx: &mut Context) {
        let func = FuncDecl::new(
            Self::NAME,
            &[&Sort::int(), &Sort::int(), &Sort::int()],
            &Sort::int(),
        );
        ctx.func_decls.insert(Self::CONTEXT_KEY, func);
    }
}

impl AxiomatizedFunction for StructBind {
    /// Generates the axioms that define `struct-bind`.
    ///
    /// # Panics
    /// - if the context object for `Self::CONTEXT_KEY` is not initialized.
    fn constrain(&self, ctx: &Context, program: &Program) -> Vec<Bool> {
        let mut result = vec![];

        for rval_typelab in ctx.rvals.typelabs() {
            for (i, inner_typelab) in program
                .rval_typelabs(&rval_typelab)
                .iter()
                .enumerate()
                .filter_map(|(i, typelab)| {
                    program
                        .lab_stype(typelab)
                        .is_struct()
                        .then_some((Int::from_u64(i as u64), typelab))
                })
            {
                for j in (0..ctx.list_capacity).map(Int::from_u64) {
                    let lhs = self.apply(ctx, &(rval_typelab.into(), i.clone(), j.clone()));
                    let rhs = match ctx.rvals.get_path(rval_typelab) {
                        Path::Var { .. } | Path::Deref { .. } | Path::Elem { .. } => {
                            <StructLifetime as SingletonFunction>::apply(
                                ctx,
                                &(inner_typelab.into(), j.clone()),
                            )
                        }
                        Path::DDeref { .. } => unreachable!(),
                        Path::Field { var, field: _ } => {
                            let struct_typelab = program
                                .var_typelabs(&var)
                                .get(1)
                                .expect("Type of `var` is `ptr(struct(_))`");
                            <StructLifetime as SingletonFunction>::apply(
                                ctx,
                                &(
                                    struct_typelab.into(),
                                    <StructParam as SingletonFunction>::apply(
                                        ctx,
                                        &(inner_typelab.into(), j.clone()),
                                    ),
                                ),
                            )
                        }
                    };
                    result.push(lhs.ast().eq(rhs.ast()));
                }
            }
        }

        result
    }
}
