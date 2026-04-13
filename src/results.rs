//! &inator inference results
//!
//! Data structures to hold &inator's inference results.

use std::{
    collections::{HashMap, HashSet},
    hash::Hash,
};

use z3::{
    FuncInterp, Model,
    ast::{Dynamic, Int},
};

use crate::{
    constraints::{
        ConstraintSystem,
        context::ContextKey,
        datatypes::{
            InterpDatatype, OpaqueDatatype,
            basetype::{InterpBaseType, OpaqueBaseType},
            lab::InterpLab,
            lifetime::InterpLifetime,
            point::InterpPoint,
            r#struct::OpaqueStruct,
        },
        functions::{
            DeclaredSingletonFunction, SingletonFunction, labrtype::LabRType,
            lifetime::Lifetime as CLifetime, lifetime_end::LifetimeEnd, ref_lifetime::RefLifetime,
            ref_param::RefParam,
        },
        relations::{lab_array::LabArray, lab_cell::LabCell},
    },
    lang::{instruction::InstrLab, r#struct::StructIdent, stype::TypeLab},
    results::{
        lifetime::{Lifetime, Region},
        rtype::RTypeFrag,
    },
};

pub mod lifetime;
pub mod rtype;

/// &inator inference results.
pub struct Results {
    pub struct_generics: HashMap<StructIdent, u64>,
    pub rust_types: HashMap<TypeLab, RTypeFrag>,
    pub regions: HashMap<Lifetime, Region>,
}

impl Results {
    /// Pulls the interpretation of a function from `model`.
    fn pull_interp_func<K: Eq + Hash, V>(
        func: &FuncInterp,
        transform_args: impl Fn(Vec<Dynamic>) -> K,
        transform_value: impl Fn(Dynamic) -> V,
    ) -> (HashMap<K, V>, V) {
        let map = HashMap::from_iter(func.get_entries().iter().map(|entry| {
            let args = transform_args(entry.get_args());
            let value = transform_value(entry.get_value());
            (args, value)
        }));
        let default = transform_value(func.get_else());
        (map, default)
    }

    /// Makes `map` totally defined on `domain` using default value `default`.
    fn make_total<K: Eq + Hash, V: Clone>(
        map: HashMap<K, V>,
        domain: impl Iterator<Item = K>,
        default: V,
    ) -> HashMap<K, V> {
        let mut map = map;
        for x in domain {
            map.entry(x).or_insert_with(|| default.clone());
        }
        map
    }

    /// Pulls the number of lifetime parameters for each struct type from `model`.
    fn pull_struct_generics(
        constraints: &ConstraintSystem,
        model: &Model,
    ) -> HashMap<StructIdent, u64> {
        let transform_args = |args: Vec<Dynamic>| -> StructIdent {
            OpaqueStruct::from_ast(
                &args
                    .first()
                    .expect("Signature of `StructGenerics` is StructIdent -> Int")
                    .as_datatype()
                    .expect("Signature of `StructGenerics` is StructIdent -> Int"),
            )
            .interpret(&constraints.ctx, model)
            .kind
        };
        let transform_value = |value: Dynamic| -> u64 {
            value
                .as_int()
                .expect("Signature of `StructGenerics` is StructIdent -> Int")
                .as_u64()
                .expect("This should not fail...")
        };

        let (map, default) = if let Some(struct_generics) = constraints
            .ctx
            .func_decls
            .get(&ContextKey::FuncDeclStructGenerics)
            && let Some(struct_generics) = model.get_func_interp(struct_generics)
        {
            Self::pull_interp_func(&struct_generics, transform_args, transform_value)
        } else {
            (HashMap::new(), 0)
        };

        Self::make_total(
            map,
            constraints.program.structs().iter().map(|s| s.id.clone()),
            default,
        )
    }

    /// Pulls the Rust type fragments for each type label from `model`.
    fn pull_rust_types(
        constraints: &ConstraintSystem,
        model: &Model,
        struct_generics: &HashMap<StructIdent, u64>,
    ) -> HashMap<TypeLab, RTypeFrag> {
        // To get the complete Rust type fragments, we need:
        //   1. Base types (from `LabRType`)
        //   2. Arrays qualifiers (from `LabArray`)
        //   3. Cell qualfiers (from `LabCell`)
        //   4. Reference lifetime variables (from `RefLifetime`)
        //   5. Struct lifetime variables (from `StructLifetime`)
        //   6. Reference lifetime parameters in struct definitions (from
        //      `RefParam`)
        //   7. Struct lifetime parameters in struct definitions (from
        //      `StructParam`)

        // 1. Base types
        let (map, default) = Self::pull_interp_func(
            &model
                .get_func_interp(LabRType::get_decl(&constraints.ctx))
                .expect("LabRType has an interpretation in `model`"),
            |args| {
                TypeLab(
                    args.first()
                        .expect("Signature of LabRType is Int -> BaseType")
                        .as_int()
                        .expect("Signature of LabRType is Int -> BaseType")
                        .as_u64()
                        .expect("Obtained from model"),
                )
            },
            |value| {
                OpaqueBaseType::from_ast(
                    &value
                        .as_datatype()
                        .expect("Signature of LabRType is Int -> BaseType"),
                )
                .interpret(&constraints.ctx, model)
            },
        );
        let base_types = Self::make_total(map, constraints.program.typelabs().into_iter(), default);

        // 2. Array qualifiers
        let (map, default) = Self::pull_interp_func(
            &model
                .get_func_interp(LabArray::get_decl(&constraints.ctx))
                .expect("LabArray has an interpretation in `model`"),
            |args| {
                TypeLab(
                    args.first()
                        .expect("Signature of LabArray is Int -> Bool")
                        .as_int()
                        .expect("Signature of LabArray is Int -> Bool")
                        .as_u64()
                        .expect("Obtained from model"),
                )
            },
            |value| {
                value
                    .as_bool()
                    .expect("Signature of LabArray is Int -> Bool")
                    .as_bool()
                    .expect("Obtained  from model")
            },
        );
        let arrays = Self::make_total(map, constraints.program.typelabs().into_iter(), default);

        // 3. Cell qualifiers
        let (map, default) = Self::pull_interp_func(
            &model
                .get_func_interp(LabCell::get_decl(&constraints.ctx))
                .expect("LabCell has an interpretation in `model`"),
            |args| {
                TypeLab(
                    args.first()
                        .expect("Signature of LabCell is Int -> Bool")
                        .as_int()
                        .expect("Signature of LabCell is Int -> Bool")
                        .as_u64()
                        .expect("Obtained from model"),
                )
            },
            |value| {
                value
                    .as_bool()
                    .expect("Signature of LabCell is Int -> Bool")
                    .as_bool()
                    .expect("Obtained  from model")
            },
        );
        let cells = Self::make_total(map, constraints.program.typelabs().into_iter(), default);

        // 4. Reference lifetime variables
        let (map, default) = Self::pull_interp_func(
            &model
                .get_func_interp(RefLifetime::get_decl(&constraints.ctx))
                .expect("RefLifetime has an interpretation in `model`"),
            |args| {
                TypeLab(
                    args.first()
                        .expect("Signature of RefLifetime is Int -> Int")
                        .as_int()
                        .expect("Signature of RefLifetime is Int -> Int")
                        .as_u64()
                        .expect("Obtained from model"),
                )
            },
            |value| {
                value
                    .as_int()
                    .expect("Signature of RefLifetime is Int -> Int")
                    .as_u64()
                    .expect("obtained from model")
            },
        );
        let ref_lifetimes =
            Self::make_total(map, constraints.program.typelabs().into_iter(), default);

        // 5. Struct lifetime variables
        let (map, default) = if let Some(struct_lifetimes_decl) = constraints
            .ctx
            .func_decls
            .get(&ContextKey::FuncDeclStructLifetime)
            && let Some(interp_struct_lifetimes) = model.get_func_interp(struct_lifetimes_decl)
        {
            Self::pull_interp_func(
                &interp_struct_lifetimes,
                |args| {
                    let typelab = TypeLab(
                        args.first()
                            .expect("Signature of StructLifetimes is Int × Int -> Int")
                            .as_int()
                            .expect("Signature of StructLifetimes is Int × Int -> Int")
                            .as_u64()
                            .expect("Obtained from model"),
                    );
                    let j = args
                        .get(1)
                        .expect("Signature of StructLifetimes is Int × Int -> Int")
                        .as_int()
                        .expect("Signature of StructLifetimes is Int × Int -> Int")
                        .as_u64()
                        .expect("Obtained from model");
                    (typelab, j)
                },
                |value| {
                    value
                        .as_int()
                        .expect("Signature of StructLifetimes is Int × Int -> Int")
                        .as_u64()
                        .expect("Obtained from model")
                },
            )
        } else {
            (HashMap::new(), u64::default())
        };
        let struct_lifetimes = Self::make_total(
            map,
            constraints
                .program
                .typelabs()
                .into_iter()
                .flat_map(|typelab| (0..constraints.ctx.list_capacity).map(move |i| (typelab, i))),
            default,
        );

        // 6. Reference lifetime parameters
        let (map, default) = if let Some(interp_ref_param) =
            model.get_func_interp(RefParam::get_decl(&constraints.ctx))
        {
            Self::pull_interp_func(
                &interp_ref_param,
                |args| {
                    TypeLab(
                        args.first()
                            .expect("Signature of RefParam is Int -> Int")
                            .as_int()
                            .expect("Signature of RefParam is Int -> Int")
                            .as_u64()
                            .expect("Obtained from model"),
                    )
                },
                |value| {
                    value
                        .as_int()
                        .expect("Signature of RefParam is Int -> Int")
                        .as_u64()
                        .expect("obtained from model")
                },
            )
        } else {
            (HashMap::new(), u64::default())
        };
        let ref_params = Self::make_total(map, constraints.program.typelabs().into_iter(), default);

        // 7. Struct lifetime parameters
        let (map, default) = if let Some(struct_params_decl) = constraints
            .ctx
            .func_decls
            .get(&ContextKey::FuncDeclStructParam)
            && let Some(interp_struct_params) = model.get_func_interp(struct_params_decl)
        {
            Self::pull_interp_func(
                &interp_struct_params,
                |args| {
                    let typelab = TypeLab(
                        args.first()
                            .expect("Signature of StructParam is Int × Int -> Int")
                            .as_int()
                            .expect("Signature of StructParam is Int × Int -> Int")
                            .as_u64()
                            .expect("Obtained from model"),
                    );
                    let j = args
                        .get(1)
                        .expect("Signature of StructParam is Int × Int -> Int")
                        .as_int()
                        .expect("Signature of StructParam is Int × Int -> Int")
                        .as_u64()
                        .expect("Obtained from model");
                    (typelab, j)
                },
                |value| {
                    value
                        .as_int()
                        .expect("Signature of StructParam is Int × Int -> Int")
                        .as_u64()
                        .expect("Obtained from model")
                },
            )
        } else {
            (HashMap::new(), u64::default())
        };
        let struct_params = Self::make_total(
            map,
            constraints
                .program
                .typelabs()
                .into_iter()
                .flat_map(|typelab| (0..constraints.ctx.list_capacity).map(move |i| (typelab, i))),
            default,
        );

        let pull_base = |typelab: TypeLab| -> InterpBaseType {
            base_types
                .get(&typelab)
                .expect("`base_types` is totally defined over `TypeLab`s in `constraints.program`")
                .clone()
        };
        let pull_array = |typelab: TypeLab| -> bool {
            *arrays
                .get(&typelab)
                .expect("`arrays` is totally defined over `TypeLab`s in `constraints.program`")
        };
        let pull_cell = |typelab: TypeLab| -> bool {
            *cells
                .get(&typelab)
                .expect("`cells` is totally defined over `TypeLab`s in `constraints.program`")
        };
        let pull_ref_lifetime = |typelab: TypeLab| -> Lifetime {
            let lifetime = *ref_lifetimes.get(&typelab).expect(
                "`ref_lifetimes` is totally defined over `TypeLab`s in `constraints.program`",
            );
            Lifetime::Variable(lifetime)
        };
        let pull_struct_lifetimes = |typelab: TypeLab, n: u64| -> Vec<Lifetime> {
            Vec::from_iter((0..n).map(|i| {
                let lifetime = *struct_lifetimes.get(&(typelab, i)).expect(
                    "`struct_lifetimes` is totally defined over the \
                        `TypeLab`s in `constraints.program` × \
                        [0, `constraints.ctx.list_capacity`]",
                );
                Lifetime::Variable(lifetime)
            }))
        };
        let pull_ref_param = |typelab: TypeLab| -> Lifetime {
            let param = *ref_params
                .get(&typelab)
                .expect("`ref_params` is totally defined over `TypeLab`s in `constraints.program`");
            Lifetime::Parameter(param)
        };
        let pull_struct_params = |typelab: TypeLab, n: u64| -> Vec<Lifetime> {
            Vec::from_iter((0..n).map(|i| {
                let param = *struct_params.get(&(typelab, i)).expect(
                    "`struct_params` is totally defined over the \
                        `TypeLab`s in `constraints.program` × \
                        [0, `constraints.ctx.list_capacity`]",
                );
                Lifetime::Parameter(param)
            }))
        };

        let assemble_rust_type = |typelab: TypeLab, in_struct: bool| -> RTypeFrag {
            match pull_base(typelab) {
                InterpBaseType::Void => RTypeFrag::Void,
                InterpBaseType::Bool => RTypeFrag::Bool,
                InterpBaseType::Int8 => RTypeFrag::Int8,
                InterpBaseType::Int16 => RTypeFrag::Int16,
                InterpBaseType::Int32 => RTypeFrag::Int32,
                InterpBaseType::Int64 => RTypeFrag::Int64,
                InterpBaseType::Float32 => RTypeFrag::Float32,
                InterpBaseType::Float64 => RTypeFrag::Float64,
                InterpBaseType::Ghost => RTypeFrag::Ghost {
                    array: pull_array(typelab),
                    cell: pull_cell(typelab),
                },
                InterpBaseType::Box => RTypeFrag::Box {
                    array: pull_array(typelab),
                    cell: pull_cell(typelab),
                },
                InterpBaseType::Rc => RTypeFrag::Rc {
                    array: pull_array(typelab),
                    cell: pull_cell(typelab),
                },
                InterpBaseType::Shared => RTypeFrag::Shared {
                    array: pull_array(typelab),
                    cell: pull_cell(typelab),
                    lifetime: if in_struct {
                        pull_ref_param(typelab)
                    } else {
                        pull_ref_lifetime(typelab)
                    },
                },
                InterpBaseType::Mut => RTypeFrag::Mut {
                    array: pull_array(typelab),
                    cell: pull_cell(typelab),
                    lifetime: if in_struct {
                        pull_ref_param(typelab)
                    } else {
                        pull_ref_lifetime(typelab)
                    },
                },
                InterpBaseType::Unknown => RTypeFrag::Unknown,
                InterpBaseType::Struct { kind } => {
                    let n = *struct_generics.get(&kind.kind).expect(
                        "`struct_generics` is totally defined over `StructIdent`s \
                        in `constraints.program`",
                    );
                    RTypeFrag::Struct {
                        kind: kind.kind.0.clone(),
                        lifetimes: if in_struct {
                            pull_struct_params(typelab, n)
                        } else {
                            pull_struct_lifetimes(typelab, n)
                        },
                    }
                }
            }
        };

        // Finally, construct the mapping of `TypeLab`s to Rust types.
        HashMap::from_iter(
            constraints
                .program
                .struct_typelabs()
                .iter()
                .map(|&typelab| (typelab, assemble_rust_type(typelab, true)))
                .chain(
                    constraints
                        .program
                        .non_struct_typelabs()
                        .iter()
                        .map(|&typelab| (typelab, assemble_rust_type(typelab, false))),
                ),
        )
    }

    fn pull_regions(
        constraints: &ConstraintSystem,
        model: &Model,
        rust_types: &HashMap<TypeLab, RTypeFrag>,
    ) -> HashMap<Lifetime, Region> {
        // To get complete region information, we need:
        //   1. All lifetime variables used by references and structs
        //   2. The program points for each lifetime variable's region (from
        //      `Lifetime`)
        //   3. The universal regions in each lifetime variable's region (from
        //      `LifetimeEnd`)

        // 1. All lifetime variables that appear in `constraints.program`
        let lifetime_vars: HashSet<u64> =
            HashSet::from_iter(rust_types.values().flat_map(|frag| match frag {
                RTypeFrag::Void => vec![],
                RTypeFrag::Bool => vec![],
                RTypeFrag::Int8 => vec![],
                RTypeFrag::Int16 => vec![],
                RTypeFrag::Int32 => vec![],
                RTypeFrag::Int64 => vec![],
                RTypeFrag::Float32 => vec![],
                RTypeFrag::Float64 => vec![],
                RTypeFrag::Ghost { .. } => vec![],
                RTypeFrag::Box { .. } => vec![],
                RTypeFrag::Rc { .. } => vec![],
                RTypeFrag::Shared {
                    array: _,
                    cell: _,
                    lifetime,
                }
                | RTypeFrag::Mut {
                    array: _,
                    cell: _,
                    lifetime,
                } => match lifetime {
                    Lifetime::Variable(i) => vec![*i],
                    Lifetime::Parameter(_) => vec![],
                },
                RTypeFrag::Unknown => vec![],
                RTypeFrag::Struct { kind: _, lifetimes } => {
                    Vec::from_iter(lifetimes.iter().filter_map(|lifetime| match lifetime {
                        Lifetime::Variable(i) => Some(*i),
                        Lifetime::Parameter(_) => None,
                    }))
                }
            }));

        // 2. Interpretation of `Lifetime`
        let mut concrete_regions: HashMap<u64, HashSet<InstrLab>> =
            HashMap::from_iter(lifetime_vars.iter().map(|&var| {
                let region = HashSet::from_iter(
                    constraints
                        .program
                        .functions()
                        .iter()
                        .flat_map(|func| {
                            func.basic_blocks
                                .iter()
                                .flat_map(|bb| bb.instructions.iter().map(|instr| *instr.id()))
                        })
                        .filter(|instr| {
                            let lab = InterpLab::new(*instr);
                            let point = InterpPoint::r#in(lab);
                            let point = point.opaquify(&constraints.ctx);
                            model
                                .eval(
                                    &CLifetime::apply(
                                        &constraints.ctx,
                                        &(InterpLifetime::new(var).opaquify(&constraints.ctx),),
                                    )
                                    .member(point.ast()),
                                    true,
                                )
                                .expect("Model exists")
                                .as_bool()
                                .expect("Obtained from `eval`")
                        }),
                );
                (var, region)
            }));

        // 3. Interpretation of `LifetimeEnd`
        let mut universal_regions: HashMap<u64, HashSet<u64>> =
            HashMap::from_iter(lifetime_vars.iter().map(|&var| {
                let region = HashSet::from_iter(lifetime_vars.iter().cloned().filter(|u_var| {
                    model
                        .eval(
                            &LifetimeEnd::apply(
                                &constraints.ctx,
                                &(InterpLifetime::new(var).opaquify(&constraints.ctx),),
                            )
                            .member(&Int::from_u64(*u_var)),
                            true,
                        )
                        .expect("Model exists")
                        .as_bool()
                        .expect("Obtained from `eval`")
                }));
                (var, region)
            }));

        HashMap::from_iter(lifetime_vars.into_iter().map(|var| {
            let points = concrete_regions
                .remove(&var)
                .expect("`concrete_regions` is totally defined on `lifetime_vars`");
            let u_regions = HashSet::from_iter(
                universal_regions
                    .remove(&var)
                    .expect("`universal_regions` is totally defined on `lifetime_vars`")
                    .into_iter()
                    .map(Lifetime::Variable),
            );
            (Lifetime::Variable(var), Region { points, u_regions })
        }))
    }

    pub fn pull(constraints: &ConstraintSystem, model: &Model) -> Self {
        let struct_generics = Self::pull_struct_generics(constraints, model);
        let rust_types = Self::pull_rust_types(constraints, model, &struct_generics);
        let regions = Self::pull_regions(constraints, model, &rust_types);
        Self {
            struct_generics,
            rust_types,
            regions,
        }
    }
}
