//! # &inator Constraint Generation Context
//!
//! &inator generates constraints in the context of a set of Z3 definitions and
//! declarations and an input program. This includes things such as:
//! - Z3 Datatype definitions
//! - Z3 Function declarations
//! - Program analysis results

use std::collections::{HashMap, HashSet};

use z3::{DatatypeSort, FuncDecl, RecFuncDecl, ast::Bool};

use crate::{
    analysis::{
        control_flow::ControlFlowGraph, drop::DropAnalysis, live_variables::LiveVariables,
        rvals::Rvalues, typelab_pairs::AssignTypeLabPairs,
    },
    constraints::{
        datatypes::{
            OpaqueDatatype, basetype::OpaqueBaseType, lab::OpaqueLab, loan::OpaqueLoan,
            point::OpaquePoint, r#struct::OpaqueStruct,
        },
        functions::{
            AxiomatizedSingletonFunction, DeclaredSingletonFunction, labrtype::LabRType,
            lifetime::Lifetime, lifetime_end::LifetimeEnd, loans::Loans, ref_bind::RefBind,
            ref_lifetime::RefLifetime, ref_param::RefParam, struct_bind::StructBind,
            struct_generics::StructGenerics, struct_lifetime::StructLifetime,
            struct_param::StructParam, struct_rank::StructRank,
        },
        relations::{lab_array::LabArray, lab_cell::LabCell, struct_clonable::StructClonable},
    },
    lang::{
        function::FuncIdent, instruction::InstrLab, program::Program, r#struct::StructIdent,
        stype::TypeLab, variable::VarIdent,
    },
};

/// The keys for objects that appear in a `Context`.
#[derive(PartialEq, Eq, PartialOrd, Ord, Hash)]
pub enum ContextKey {
    DatatypeStruct,
    DatatypeBaseType,
    DatatypeLab,
    DatatypePoint,
    DatatypeLoan,
    VariantsStruct,
    VariantsLab,
    VariantsEnumeratedLoan,
    FuncDeclLabRType,
    FuncDeclRefLifetime,
    FuncDeclRefParam,
    FuncDeclStructGenerics,
    FuncDeclStructLifetime,
    FuncDeclStructParam,
    FuncDeclStructRank,
    FuncDeclLifetime,
    FuncDeclLifetimeEnd,
    FuncDeclLoans,
    FuncDefCost,
    FuncDefRefBind,
    FuncDefStructBind,
    RelDeclLabArray,
    RelDeclLabCell,
    RelDeclStructClonable,
    RelDefGeneralTransform,
    RelDefNondestructiveTransform,
    RelDefLifetimeOutlives,
    None,
}

#[derive(Default)]
pub struct Context<'a> {
    pub datatypes: HashMap<ContextKey, DatatypeSort>,
    pub struct_variants: Option<HashMap<StructIdent, usize>>,
    pub lab_variants: Option<HashMap<InstrLab, usize>>,
    pub loan_variants: Option<HashMap<TypeLab, usize>>,
    pub func_decls: HashMap<ContextKey, FuncDecl>,
    pub func_defs: HashMap<(ContextKey, Option<FuncIdent>), RecFuncDecl>,
    pub list_capacity: u64,
    pub control_flow: HashMap<FuncIdent, ControlFlowGraph<'a>>,
    pub live_variables: HashMap<FuncIdent, LiveVariables>,
    pub drops: HashMap<FuncIdent, DropAnalysis>,
    pub typelab_pairs: HashMap<FuncIdent, AssignTypeLabPairs>,
    pub borrow_conflicts: HashMap<TypeLab, HashSet<TypeLab>>,
    pub assign_conflicts: Vec<(InstrLab, VarIdent, HashSet<TypeLab>)>,
    pub rvals: Rvalues,
    pub axioms: Vec<Bool>,
}

impl<'a> Context<'a> {
    pub fn new(program: &'a Program<'a>) -> Self {
        let mut ctx = Context {
            list_capacity: 1,
            rvals: Rvalues::new(program),
            ..Default::default()
        };

        OpaqueStruct::define(&mut ctx, &(program,));
        OpaqueBaseType::define(&mut ctx, &());
        OpaqueLab::define(&mut ctx, &(program,));
        OpaquePoint::define(&mut ctx, &());
        OpaqueLoan::define(&mut ctx, &());

        <LabRType as DeclaredSingletonFunction>::declare(&mut ctx);
        <LabArray as DeclaredSingletonFunction>::declare(&mut ctx);
        <LabCell as DeclaredSingletonFunction>::declare(&mut ctx);
        <RefLifetime as DeclaredSingletonFunction>::declare(&mut ctx);
        <RefParam as DeclaredSingletonFunction>::declare(&mut ctx);
        <RefBind as DeclaredSingletonFunction>::declare(&mut ctx);

        if ctx.datatypes.contains_key(&ContextKey::DatatypeStruct) {
            <StructClonable as DeclaredSingletonFunction>::declare(&mut ctx);
            <StructGenerics as DeclaredSingletonFunction>::declare(&mut ctx);
            <StructRank as DeclaredSingletonFunction>::declare(&mut ctx);
            <StructLifetime as DeclaredSingletonFunction>::declare(&mut ctx);
            <StructParam as DeclaredSingletonFunction>::declare(&mut ctx);
            <StructBind as DeclaredSingletonFunction>::declare(&mut ctx);
        }

        <Lifetime as DeclaredSingletonFunction>::declare(&mut ctx);
        <LifetimeEnd as DeclaredSingletonFunction>::declare(&mut ctx);
        <Loans as DeclaredSingletonFunction>::declare(&mut ctx);

        for function in program
            .functions()
            .into_iter()
            .filter(|f| !f.basic_blocks.is_empty())
        {
            ctx.control_flow
                .insert(function.id.clone(), ControlFlowGraph::construct(function));
        }

        for function in program
            .functions()
            .into_iter()
            .filter(|f| !f.basic_blocks.is_empty())
        {
            ctx.live_variables.insert(
                function.id.clone(),
                LiveVariables::analyze(ctx.control_flow.get(&function.id).unwrap()),
            );
        }

        for function in program
            .functions()
            .into_iter()
            .filter(|f| !f.basic_blocks.is_empty())
        {
            ctx.drops.insert(
                function.id.clone(),
                DropAnalysis::analyze(
                    function,
                    ctx.control_flow.get(&function.id).unwrap(),
                    ctx.live_variables.get(&function.id).unwrap(),
                ),
            );
        }

        for function in program.functions() {
            ctx.typelab_pairs.insert(
                function.id.clone(),
                AssignTypeLabPairs::analyze(program, function),
            );
        }

        ctx.axioms.extend(RefBind::constrain(&ctx, program));
        ctx.axioms.extend(StructBind::constrain(&ctx, program));

        ctx
    }
}
