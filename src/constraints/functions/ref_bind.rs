//! `ref-bind` function definition.

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
            ref_lifetime::RefLifetime, ref_param::RefParam, struct_lifetime::StructLifetime,
        },
    },
    lang::program::Program,
};

/// Definition of `ref-bind` function.
pub struct RefBind;

impl SingletonFunction for RefBind {
    const INSTANCE: Self = RefBind {};
}

impl Function for RefBind {
    const CONTEXT_KEY: ContextKey = ContextKey::FuncDefRefBind;
    const NAME: &str = "ref-bind";
    type DomainType = (Int, Int);
    type CodomainType = OpaqueLifetime;

    /// Generates the Z3 AST that applies the `ref-bind` function to `args`.
    ///
    /// # Panics
    /// - if the context object for `Self::CONTEXT_KEY` is not initialized
    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        OpaqueLifetime::from_ast(
            &self
                .get_decl(ctx)
                .apply(&[&args.0, &args.1])
                .as_int()
                .expect("Function signature is Int × Int -> Int"),
        )
    }
}

impl DeclaredFunction for RefBind {
    ///Generates the Z3 function declaration for `ref-bind`.
    fn declare(&self, ctx: &mut Context) {
        let func = FuncDecl::new(Self::NAME, &[&Sort::int(), &Sort::int()], &Sort::int());
        ctx.func_decls.insert(Self::CONTEXT_KEY, func);
    }
}

impl AxiomatizedFunction for RefBind {
    /// Generates the axioms that define `ref-bind`.
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
                .filter(|(_, typelab)| program.lab_stype(typelab).is_ptr())
            {
                let lhs = self.apply(ctx, &(rval_typelab.into(), Int::from_u64(i as u64)));
                let rhs = match ctx.rvals.get_path(rval_typelab) {
                    Path::Var { .. } | Path::Deref { .. } | Path::Elem { .. } => {
                        <RefLifetime as SingletonFunction>::apply(ctx, &(inner_typelab.into(),))
                    }
                    Path::DDeref { .. } => unreachable!(),
                    Path::Field { var, field: _ } => {
                        if i == 0 {
                            <RefLifetime as SingletonFunction>::apply(ctx, &(inner_typelab.into(),))
                        } else {
                            let struct_typelab = program
                                .var_typelabs(&var)
                                .get(1)
                                .expect("Type of `var` is `ptr(struct(_))`");
                            <StructLifetime as SingletonFunction>::apply(
                                ctx,
                                &(
                                    struct_typelab.into(),
                                    <RefParam as SingletonFunction>::apply(
                                        ctx,
                                        &(inner_typelab.into(),),
                                    ),
                                ),
                            )
                        }
                    }
                };
                result.push(lhs.ast().eq(rhs.ast()));
            }
        }

        result
    }
}
