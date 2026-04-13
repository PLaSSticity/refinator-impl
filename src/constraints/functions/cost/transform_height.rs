//! Transformation height-based `cost` function definition.

use z3::{
    RecFuncDecl, Sort,
    ast::{Bool, Int},
};

use crate::constraints::{
    Context, ContextKey,
    datatypes::{OpaqueDatatype, basetype::OpaqueBaseType},
    functions::{DefinedFunction, Function, InlineFunction, SingletonFunction},
};

/// Definition of the tansformation height-based `cost` function.
pub struct TransformHeightCost;

impl SingletonFunction for TransformHeightCost {
    const INSTANCE: Self = TransformHeightCost {};
}

impl Function for TransformHeightCost {
    const CONTEXT_KEY: ContextKey = ContextKey::FuncDefCost;
    const NAME: &str = "cost";
    type DomainType = (OpaqueBaseType,);
    type CodomainType = Int;

    fn apply(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        self.get_def(ctx)
            .apply(&[args.0.ast()])
            .as_int()
            .expect("Function signature is BaseType  -> Int")
    }
}

impl DefinedFunction for TransformHeightCost {
    fn define(&self, ctx: &mut Context) {
        let func = RecFuncDecl::new(Self::NAME, &[&OpaqueBaseType::get_sort(ctx)], &Sort::int());
        let args = (OpaqueBaseType::new_const(ctx, "ty!0"),);
        let body = self.inline(ctx, &args);
        func.add_def(&[args.0.ast()], &body);
        ctx.func_defs.insert((Self::CONTEXT_KEY, None), func);
    }
}

impl InlineFunction for TransformHeightCost {
    fn inline(&self, ctx: &Context, args: &Self::DomainType) -> Self::CodomainType {
        #[allow(clippy::type_complexity)]
        let cases: Vec<(&dyn Fn(&OpaqueBaseType, &Context) -> Bool, u64)> = vec![
            (&OpaqueBaseType::is_ghost, 1),
            (&OpaqueBaseType::is_box, 1),
            (&OpaqueBaseType::is_rc, 1),
            (&OpaqueBaseType::is_mut, 2),
            (&OpaqueBaseType::is_shared, 3),
        ];

        let mut body = Int::from_u64(0);
        for (tester, cost) in cases {
            body = tester(&args.0, ctx).ite(&Int::from_u64(cost), &body);
        }

        body
    }
}
