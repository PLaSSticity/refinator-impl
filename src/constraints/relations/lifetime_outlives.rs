//! `lifetime-outlives` relation definition.
//!
//! We define a different variant of `lifetime-outlives` for each function that
//! appears in the input program since lifetime inference (used for borrow
//! checking, at least) is intraprocedural. For a function identifier `F`, we'll
//! denote the variant of `lifetime-outlives` for `F` by `lifetime-outlives(F)`.
//!
//! For a function identifier `F` and lifetime variables `super`, `sub`,
//! `super, sub ∈ lifetime-outlives(F)` means that for all program points `p`
//! in `F`, we have `p ∈ Lifetime(super) -> p ∈ Lifetime(sub)`.

use z3::{
    RecFuncDecl, Sort,
    ast::{Bool, Int},
};

use crate::{
    constraints::{
        Context,
        context::ContextKey,
        datatypes::{
            InterpDatatype, OpaqueDatatype, lab::InterpLab, lifetime::OpaqueLifetime,
            point::InterpPoint,
        },
        functions::{
            DefinedFunction, Function, InlineFunction, SingletonFunction, lifetime::Lifetime,
            lifetime_end::LifetimeEnd, ref_lifetime::RefLifetime, struct_lifetime::StructLifetime,
        },
    },
    lang::{function::FuncIdent, program::Program, stype::STypeFrag},
};

/// Definition of the `lifetime-outlives` relation for the function with
/// identifer `function` appearing in program `program`.
pub struct LifetimeOutlives<'a> {
    program: &'a Program<'a>,
    function: FuncIdent,
}

impl<'a> LifetimeOutlives<'a> {
    /// Constructs a `LifetimeOutlives` strategy for function `func` in program
    /// `program`.
    pub fn new(program: &'a Program<'a>, function: FuncIdent) -> Self {
        Self { program, function }
    }
}

impl Function for LifetimeOutlives<'_> {
    const CONTEXT_KEY: ContextKey = ContextKey::RelDefLifetimeOutlives;
    const NAME: &'static str = "lifetime-outlives";
    type DomainType = (OpaqueLifetime, OpaqueLifetime);
    type CodomainType = Bool;

    /// Generates the Z3 AST that applies the `lifetime-outlives` relation to
    /// `args`.
    ///
    /// # Panics
    /// - if the context object for `(Self::CONTEXT_KEY, self.function)` is not
    ///   initialized
    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        self.get_def(ctx)
            .apply(&[args.0.ast(), args.1.ast()])
            .as_bool()
            .expect("Function signature is Lifetime × Lifetime -> Bool")
    }
}

impl DefinedFunction for LifetimeOutlives<'_> {
    /// Generates the Z3 function definition for the `lifetime-outlives`
    /// predicate.
    ///
    /// # Panics
    /// - if the context object for `ContextKey::DatatypeLab` is not initialized
    /// - if the context object for `ContextKey::VariantsLab` is not initialized
    fn define(&self, ctx: &mut Context) {
        let func = RecFuncDecl::new(
            format!("{}!{}", Self::NAME, self.function.0),
            &[
                &OpaqueLifetime::get_sort(ctx),
                &OpaqueLifetime::get_sort(ctx),
            ],
            &Sort::bool(),
        );
        let args = (
            OpaqueLifetime::new_const(ctx, "lifetime!0"),
            OpaqueLifetime::new_const(ctx, "lifetime!1"),
        );
        let body = self.inline(ctx, &args);
        func.add_def(&[args.0.ast(), args.1.ast()], &body);
        ctx.func_defs
            .insert((Self::CONTEXT_KEY, Some(self.function.clone())), func);
    }

    /// Pulls the Z3 `RecFuncDecl` for the `lifetime-outlives` predicate.
    ///
    /// # Panics
    /// - if the context object for `(Self::CONTEXT_KEY, self.function)` is not
    ///   initialized
    fn get_def<'a>(&self, ctx: &'a Context<'a>) -> &'a RecFuncDecl {
        ctx.func_defs
            .get(&(Self::CONTEXT_KEY, Some(self.function.clone())))
            .as_ref()
            .unwrap()
    }
}

impl InlineFunction for LifetimeOutlives<'_> {
    /// Generates the Z3 AST that applies this lifetime outlives predicate to
    /// `args` by inlining its definition.
    ///
    /// # Panics
    /// - if the context object for `ContextKey::DatatypeLab` is not initialized
    /// - if the context object for `ContextKey::VariantsLab` is not initialized
    fn inline(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        let (sup, sub) = args;
        let func = self.program.get_function(&self.function);

        // Clauses that propagate program points from `sub` to `sup`.
        let p_clauses = func
            .basic_blocks
            .iter()
            .flat_map(|bb| bb.instructions.iter())
            .flat_map(|instr| {
                let lab = InterpLab::new(*instr.id());
                let in_point = InterpPoint::r#in(lab).opaquify(ctx);
                let out_point = InterpPoint::out(lab).opaquify(ctx);
                vec![
                    <Lifetime as SingletonFunction>::apply(ctx, &(sub.clone(),))
                        .member(in_point.ast())
                        .implies(
                            <Lifetime as SingletonFunction>::apply(ctx, &(sup.clone(),))
                                .member(in_point.ast()),
                        ),
                    <Lifetime as SingletonFunction>::apply(ctx, &(sub.clone(),))
                        .member(out_point.ast())
                        .implies(
                            <Lifetime as SingletonFunction>::apply(ctx, &(sup.clone(),))
                                .member(out_point.ast()),
                        ),
                ]
            });

        // Clauses that propagate end regions from `sub` to `sup`.
        let u_typelabs = func.ret_typelabs.iter().chain(
            func.param_vars
                .iter()
                .flat_map(|v| self.program.var_typelabs(v)),
        );
        let u_clauses = u_typelabs.flat_map(|typelab| match self.program.lab_stype(typelab) {
            STypeFrag::Pointer => {
                vec![
                    <LifetimeEnd as SingletonFunction>::apply(ctx, &(sub.clone(),))
                        .member(
                            <RefLifetime as SingletonFunction>::apply(ctx, &(typelab.into(),))
                                .ast(),
                        )
                        .implies(
                            <LifetimeEnd as SingletonFunction>::apply(ctx, &(sup.clone(),)).member(
                                <RefLifetime as SingletonFunction>::apply(ctx, &(typelab.into(),))
                                    .ast(),
                            ),
                        ),
                ]
            }
            STypeFrag::Struct(_) => Vec::from_iter((0..ctx.list_capacity).map(|i| {
                <LifetimeEnd as SingletonFunction>::apply(ctx, &(sub.clone(),))
                    .member(
                        <StructLifetime as SingletonFunction>::apply(
                            ctx,
                            &(typelab.into(), Int::from_u64(i)),
                        )
                        .ast(),
                    )
                    .implies(
                        <LifetimeEnd as SingletonFunction>::apply(ctx, &(sup.clone(),)).member(
                            <StructLifetime as SingletonFunction>::apply(
                                ctx,
                                &(typelab.into(), Int::from_u64(i)),
                            )
                            .ast(),
                        ),
                    )
            })),
            _ => vec![],
        });

        let clauses = Vec::from_iter(p_clauses.chain(u_clauses));
        Bool::and(&clauses)
    }
}
