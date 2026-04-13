//! `base-equiv` relation definition.

use z3::{
    RecFuncDecl, Sort,
    ast::{Bool, Dynamic},
};

use crate::constraints::{
    Context, ContextKey,
    datatypes::{OpaqueDatatype, basetype::OpaqueBaseType},
    functions::{DefinedFunction, Function, InlineFunction, SingletonFunction},
};

/// Definition of `base-equiv` relation.
pub struct BaseEquiv;

impl SingletonFunction for BaseEquiv {
    const INSTANCE: Self = BaseEquiv {};
}

impl Function for BaseEquiv {
    const CONTEXT_KEY: ContextKey = ContextKey::RelDefBaseEquiv;
    const NAME: &str = "base-equiv";
    type DomainType = (OpaqueBaseType, OpaqueBaseType);
    type CodomainType = Bool;

    /// Generates the Z3 AST that applies the base type equivalence relation to
    /// `args`.
    ///
    /// # Panics
    /// - if the context object for `ContextKey::RelDefBaseEquiv` is not
    ///   initialized.
    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Bool {
        self.get_def(ctx)
            .apply(&[args.0.ast(), args.1.ast()])
            .as_bool()
            .expect("Function signature is BaseType × BaseType -> Bool")
    }
}

impl DefinedFunction for BaseEquiv {
    /// Generates the Z3 function definition for the base type equivalence
    /// predcicate.
    ///
    /// # Panics
    /// - if the context object for `ContextKey::DatatypeBaseType` is not
    ///   initialized
    fn define(&self, ctx: &mut Context) {
        let func = RecFuncDecl::new(
            Self::NAME,
            &[
                &OpaqueBaseType::get_sort(ctx),
                &OpaqueBaseType::get_sort(ctx),
            ],
            &Sort::bool(),
        );

        let args = (
            OpaqueBaseType::new_const(ctx, "ty!0"),
            OpaqueBaseType::new_const(ctx, "ty!1"),
        );

        let body = self.inline(ctx, &args);

        func.add_def(&[args.0.ast(), args.1.ast()], &body);

        ctx.func_defs.insert((Self::CONTEXT_KEY, None), func);
    }
}

impl InlineFunction for BaseEquiv {
    /// Generates the Z3 AST that applies the base type equivalence relation to
    /// `args` by inlining its definition.
    fn inline(&self, ctx: &Context, args: &Self::DomainType) -> Bool {
        let (lhs, rhs) = args;
        let lhs_has_no_lifetimes = if ctx.datatypes.contains_key(&ContextKey::DatatypeStruct) {
            Bool::and(&[&lhs.is_struct(ctx).not(), &lhs.is_ref(ctx).not()])
        } else {
            lhs.is_ref(ctx).not()
        };

        let mut clauses = vec![
            lhs_has_no_lifetimes
                .implies(Dynamic::from_ast(lhs.ast()).eq(Dynamic::from_ast(rhs.ast()))),
            lhs.is_shared(ctx).iff(rhs.is_shared(ctx)),
            lhs.is_mut(ctx).iff(rhs.is_mut(ctx)),
        ];

        if ctx.datatypes.contains_key(&ContextKey::DatatypeStruct) {
            clauses.push(lhs.is_struct(ctx).iff(rhs.is_struct(ctx)));
            clauses.push(
                lhs.is_struct(ctx).implies(
                    Dynamic::from_ast(lhs.struct_kind(ctx).ast())
                        .eq(Dynamic::from_ast(rhs.struct_kind(ctx).ast())),
                ),
            );
        }

        Bool::and(&clauses)
    }
}
