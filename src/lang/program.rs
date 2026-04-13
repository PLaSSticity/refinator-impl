//! # Source Language Program Representation
//!
//! This module implements the source language representation of an LLVM
//! program. The source language representation of an LLVM module is captured
//! by the `Program` struct. A `Program` is generated from an `llvm_ir::Module`
//! using `Program::construct`.
//!
//! ## Implementation Details
//!
//! To generate a source language representation of an LLVM IR module, we need
//! to do the following.
//!
//! 1. Assign identifiers to each struct declaration, global variable,
//!    local variable, basic block, and instruction, in that order.
//!    We need to be able to look up these home-grown identifiers using the
//!    identifiers that are present in the LLVM IR.
//! 2. Build data structures that incompletely represent each struct type,
//!    function, and instruction in the source language. This captures the
//!    structure of the module, but is missing type information.
//! 3. Infer the source types for each typed object, except for rvalue
//!    expressions; that is, each struct field, function return, and variable.
//! 4. Assign type labels to each typed object, and build the `lab_stype` and
//!    `*_typelabs` functions.
//! 5. Add type information to the source language representation.

use either::Either;
use llvm_ir::Name;
use std::collections::HashMap;

use crate::lang::{
    basic_block::{BasicBlock, BasicBlockIdent},
    function::{FuncIdent, Function},
    instruction::{InstrLab, Instruction},
    r#struct::{Struct, StructIdent},
    stype::{SIFunction, SIInstr, STypeFrag, SourceTypes, TypeLab},
    variable::{VarIdent, global::GlobalVar, local::LocalVar},
};

/// Used to pass around mappings of LLVM identifiers to our home-grown
/// identifiers.
pub struct Labels<'a> {
    llvm_mod: &'a llvm_ir::Module,
    structs: HashMap<StructIdent, Option<llvm_ir::TypeRef>>,
    globals: HashMap<Name, VarIdent>,
    locals: HashMap<FuncIdent, HashMap<Name, VarIdent>>,
    basic_blocks: HashMap<FuncIdent, HashMap<Name, BasicBlockIdent>>,
    instrs: HashMap<FuncIdent, HashMap<BasicBlockIdent, Vec<InstrLab>>>,
}

impl Labels<'_> {
    /// Finds the variable identifier for the variable in the operand, if there
    /// is one.
    ///
    /// Searches the global variables and the local variables in `func`.
    ///
    /// # Panics
    /// - if `operand` is a metadata operand, or
    /// - if `func` is not the identifier of a function analyzed in `self`
    pub fn extract_var(&self, func: &FuncIdent, operand: &llvm_ir::Operand) -> Option<VarIdent> {
        match operand {
            llvm_ir::Operand::LocalOperand { name, ty: _ } => Some(
                *self
                    .locals
                    .get(func)
                    .expect("`func` should have been analyzed in `self`")
                    .get(name)
                    .expect("`name` is a local variable in `func`"),
            ),
            llvm_ir::Operand::ConstantOperand(c) => match &**c {
                llvm_ir::Constant::GlobalReference { name, ty: _ } => {
                    Some(*self.globals.get(name).expect("`name` is a global variable"))
                }
                _ => None,
            },
            _ => None,
        }
    }

    /// Finds the variable identifier for the variable in `func` named `name`.
    ///
    /// # Panics
    /// - if no variable named `name` is declared in `func` and no global
    ///   variable is called `name`
    pub fn find_var(&self, func: &FuncIdent, name: &Name) -> VarIdent {
        self.locals
            .get(func)
            .expect("`func` should have been analyzed in `self`")
            .get(name)
            .cloned()
            .unwrap_or_else(|| {
                *self.globals.get(name).expect(
                    "`name` should be the name of a global variable if it \
                        was not one of the local variables in `func`",
                )
            })
    }

    /// Finds the basic block identifier identifier for the basic block in
    /// `func` named `name`.
    ///
    /// # Panics
    /// - if no basic block labeled `name` appears in `func`.
    pub fn find_bb(&self, func: &FuncIdent, name: &Name) -> BasicBlockIdent {
        *self
            .basic_blocks
            .get(func)
            .expect("`func` should have been analyzed in `self`")
            .get(name)
            .expect("`name` should be the name of a basic block in `func`")
    }
}

pub struct Program<'a> {
    pub llvm_mod: &'a llvm_ir::Module,
    structs: HashMap<StructIdent, Struct>,
    functions: HashMap<FuncIdent, Function<'a>>,
    globals: HashMap<VarIdent, GlobalVar<'a>>,
    locals: HashMap<VarIdent, LocalVar>,
    stypes: HashMap<TypeLab, STypeFrag>,
    rval_typelabs: HashMap<TypeLab, Vec<TypeLab>>,
}

impl<'a> Program<'a> {
    /// Labels all of the struct declarations and definitions in `src`.
    ///
    /// Returns a mapping of struct identifiers to the LLVM type for the struct
    /// definition. If the value for a struct identifier is `None`, then the
    /// struct type was declared but not defined.
    fn label_structs(src: &llvm_ir::Module) -> HashMap<StructIdent, Option<llvm_ir::TypeRef>> {
        let mut result = HashMap::new();

        for name in src.types.all_struct_names() {
            let id = StructIdent(name.to_string());
            let ty = match src
                .types
                .named_struct_def(name)
                .expect("Got the name from `llvm-ir`")
            {
                llvm_ir::types::NamedStructDef::Defined(ty) => Some(ty.clone()),
                llvm_ir::types::NamedStructDef::Opaque => None,
            };
            result.insert(id, ty);
        }

        result
    }

    /// Labels all of the global variable declarations and definitions in `src`.
    ///
    /// Returns a mapping of global variable names to variable identifiers.
    /// The underlying index of each variable identifier is unique, but may need
    /// to be offset to be distinct from the indices for the identifiers of
    /// local variables.
    fn label_globals(src: &llvm_ir::Module) -> HashMap<Name, VarIdent> {
        let mut result = HashMap::new();

        for (i, var) in src.global_vars.iter().enumerate() {
            result.insert(var.name.clone(), VarIdent(i));
        }

        result
    }

    /// Labels all of the local variable declarations and definitions in `src`.
    ///
    /// Returns a mapping of function identifiers to a mapping from variable
    /// names to variable identifiers.
    /// The underlying index of each variable identifier is unique, but may need
    /// to be offset to be distinct from the indices for the identifiers of
    /// global variables.
    fn label_locals(src: &llvm_ir::Module) -> HashMap<FuncIdent, HashMap<Name, VarIdent>> {
        let mut result = HashMap::new();

        let mut i = 0;

        for func in &src.func_declarations {
            let mut local_result = HashMap::new();
            for param in &func.parameters {
                local_result.insert(param.name.clone(), VarIdent(i));
                i += 1;
            }
            result.insert(FuncIdent(func.name.to_string()), local_result);
        }

        for func in &src.functions {
            let mut local_result = HashMap::new();
            for param in &func.parameters {
                local_result.insert(param.name.clone(), VarIdent(i));
                i += 1;
            }
            for bb in &func.basic_blocks {
                for instr in &bb.instrs {
                    if let Some(name) = instr.try_get_result() {
                        local_result.insert(name.clone(), VarIdent(i));
                        i += 1;
                    }
                }
                if let Some(name) = bb.term.try_get_result() {
                    local_result.insert(name.clone(), VarIdent(i));
                    i += 1;
                }
            }
            result.insert(FuncIdent(func.name.to_string()), local_result);
        }

        result
    }

    /// Labels all basic blocks in `src`.
    ///
    /// Returns a mapping of function identifiers to a mapping from basic block
    /// names to basic block identifiers.
    /// The underlying index of each basic block identifier is unique.
    fn label_bbs(src: &llvm_ir::Module) -> HashMap<FuncIdent, HashMap<Name, BasicBlockIdent>> {
        let mut result = HashMap::new();

        let mut i = 0;
        for func in &src.functions {
            let mut inner_result = HashMap::new();
            for bb in &func.basic_blocks {
                inner_result.insert(bb.name.clone(), BasicBlockIdent(i));
                i += 1;
            }
            result.insert(FuncIdent(func.name.to_string()), inner_result);
        }

        result
    }

    /// Labels all of the instructions in `src`.
    ///
    /// Returns a mapping of function identifiers to a mapping of basic block
    /// identifiers to a vector of instruction labels for the instructions that
    /// appear within that basic block, in order.
    ///
    /// The underlying index of each instruction identifier is unique.
    fn label_instrs(
        src: &llvm_ir::Module,
        bb_labels: &HashMap<FuncIdent, HashMap<Name, BasicBlockIdent>>,
    ) -> HashMap<FuncIdent, HashMap<BasicBlockIdent, Vec<InstrLab>>> {
        let mut result = HashMap::new();

        let mut i = 0;
        for func in &src.functions {
            let mut inner_result = HashMap::new();
            let local_bb_labels = bb_labels
                .get(&FuncIdent(func.name.to_string()))
                .expect("`bb_labels` should have an entry for each function definition.");
            for bb in &func.basic_blocks {
                let mut vec_result = vec![];

                for _ in &bb.instrs {
                    vec_result.push(InstrLab(i));
                    i += 1;
                }
                vec_result.push(InstrLab(i));
                i += 1;

                let bb_ident = local_bb_labels.get(&bb.name).expect(
                    "`local_bb_labels` should have an entry for each basic block in `func`.",
                );
                inner_result.insert(*bb_ident, vec_result);
            }
            result.insert(FuncIdent(func.name.to_string()), inner_result);
        }

        result
    }

    /// Assigns identifiers to struct declarations, global variables,
    /// local variables, basic blocks, and instructions.
    fn label(src: &llvm_ir::Module) -> Labels<'_> {
        let structs = Self::label_structs(src);
        let mut globals = Self::label_globals(src);
        let locals = Self::label_locals(src);
        for v in globals.values_mut() {
            v.offset(locals.values().map(|v| v.len()).sum());
        }
        let basic_blocks = Self::label_bbs(src);
        let instrs = Self::label_instrs(src, &basic_blocks);
        Labels {
            llvm_mod: src,
            structs,
            globals,
            locals,
            basic_blocks,
            instrs,
        }
    }

    /// Populates a map of struct identifiers to `Struct`s without any type
    /// information.
    fn init_structs(labels: &Labels) -> HashMap<StructIdent, Struct> {
        let mut result = HashMap::new();

        for id in labels.structs.keys() {
            result.insert(
                id.clone(),
                Struct {
                    id: id.clone(),
                    field_typelabs: Vec::new(),
                },
            );
        }

        result
    }

    /// Populates a map of variable identifiers to `GlobalVar`s without any type
    /// information.
    fn init_globals(labels: &Labels<'a>) -> HashMap<VarIdent, GlobalVar<'a>> {
        let mut result = HashMap::new();

        for (name, id) in &labels.globals {
            let llvm_glob = labels.llvm_mod.get_global_var_by_name(name).expect(
                "`name` was obtained by iterating through the global variables \
                in labels.llvm_mod",
            );
            let name = match name {
                llvm_ir::Name::Name(s) => s.to_string(),
                llvm_ir::Name::Number(n) => format!("_{}", n),
            };
            result.insert(
                *id,
                GlobalVar {
                    id: *id,
                    llvm_glob,
                    name,
                    lhs_typelabs: Vec::default(),
                    rhs_typelab: None,
                },
            );
        }

        result
    }

    /// Populates a map of function identifiers to `Function`s without any
    /// type information.
    fn init_functions(labels: &Labels<'a>) -> HashMap<FuncIdent, Function<'a>> {
        let mut result = HashMap::new();

        for func in &labels.llvm_mod.func_declarations {
            let id = FuncIdent(func.name.to_string());
            let llvm_func = Either::Right(func);
            let param_vars: Vec<VarIdent> = func
                .parameters
                .iter()
                .map(|param| labels.find_var(&id, &param.name))
                .collect();
            result.insert(
                id.clone(),
                Function {
                    id,
                    llvm_func,
                    ret_typelabs: Vec::default(),
                    param_vars,
                    basic_blocks: vec![],
                },
            );
        }

        for func in &labels.llvm_mod.functions {
            let func_id = FuncIdent(func.name.to_string());
            let llvm_func = Either::Left(func);
            let param_vars: Vec<VarIdent> = func
                .parameters
                .iter()
                .map(|param| labels.find_var(&func_id, &param.name))
                .collect();

            let mut basic_blocks = Vec::new();

            for bb in &func.basic_blocks {
                let bb_id = labels
                    .basic_blocks
                    .get(&func_id)
                    .expect("`func` should have been analyzed by now")
                    .get(&bb.name)
                    .expect("`bb` should be the name of a basic block in `func`");
                let instr_labs = labels
                    .instrs
                    .get(&func_id)
                    .expect("`func` should have been analyzed by now")
                    .get(bb_id)
                    .expect("`bb` should be the name of a basic block in `func`");
                let mut instructions = Vec::new();
                for (id, instr) in instr_labs.iter().zip(bb.instrs.iter()) {
                    let mut instr = match Instruction::from_instr(labels, &func_id, instr) {
                        Some(instr) => instr,
                        None => continue,
                    };
                    instr.set_id(*id);
                    instructions.push(instr);
                }
                let mut term = Instruction::from_term(labels, &func_id, &bb.term);
                term.set_id(
                    *instr_labs
                        .last()
                        .expect("There should be at least one instruction in each basic block"),
                );
                instructions.push(term);
                basic_blocks.push(BasicBlock {
                    id: *bb_id,
                    llvm_bb: bb,
                    instructions,
                });
            }

            result.insert(
                func_id.clone(),
                Function {
                    id: func_id,
                    llvm_func,
                    ret_typelabs: Vec::default(),
                    param_vars,
                    basic_blocks,
                },
            );
        }

        result
    }

    /// Populates a map of variable identifiers to `LocalVar`s without any type
    /// information.
    fn init_locals(
        labels: &Labels,
        functions: &HashMap<FuncIdent, Function>,
    ) -> HashMap<VarIdent, LocalVar> {
        let mut result = HashMap::new();

        for (func_id, func) in functions {
            for param in match func.llvm_func {
                Either::Left(func) => func.parameters.iter(),
                Either::Right(func) => func.parameters.iter(),
            } {
                let var_id = labels
                    .locals
                    .get(func_id)
                    .expect("`func` should have been analyzed by now")
                    .get(&param.name)
                    .expect("`param.name` should be the name of a a local variable in `func`");
                let name = match &param.name {
                    llvm_ir::Name::Name(s) => s.to_string(),
                    llvm_ir::Name::Number(n) => format!("_{}", n),
                };

                result.insert(
                    *var_id,
                    LocalVar {
                        id: *var_id,
                        name,
                        func: func_id.clone(),
                        instr: None,
                        typelabs: Vec::default(),
                    },
                );
            }

            for bb in &func.basic_blocks {
                for instr in &bb.instructions {
                    if let Some(var_id) = instr.try_decl() {
                        let name = instr.try_result().expect(
                            "LLVM instructions that declare a variable should have a \"result\"",
                        );
                        let name = match name {
                            llvm_ir::Name::Name(s) => s.to_string(),
                            llvm_ir::Name::Number(n) => format!("_{}", n),
                        };
                        result.insert(
                            var_id,
                            LocalVar {
                                id: var_id,
                                name,
                                func: func_id.clone(),
                                instr: Some(*instr.id()),
                                typelabs: Vec::default(),
                            },
                        );
                    }
                }
            }
        }

        result
    }

    /// Assigns a unique `TypeLab` to each rvalue expression, and returns a map
    /// of `TypeLab`s to `STypeFrag`s, where each key is a `TypeLab` used by an
    /// rvalue expression, and every value is `STypeFrag::Unknown`.
    fn init_rvals(functions: &mut HashMap<FuncIdent, Function>) -> HashMap<TypeLab, STypeFrag> {
        let mut res = HashMap::new();

        for func in functions.values_mut() {
            for bb in &mut func.basic_blocks {
                for instr in &mut bb.instructions {
                    match instr {
                        Instruction::Alloca {
                            id: _,
                            llvm_instr: _,
                            lhs_var: _,
                        } => continue,
                        Instruction::Load {
                            id: _,
                            llvm_instr: _,
                            lhs_var: _,
                            rhs_var: _,
                            rhs_typelab: tl,
                        }
                        | Instruction::Store {
                            id: _,
                            llvm_instr: _,
                            lhs_var: _,
                            rhs_var: _,
                            rhs_typelab: tl,
                        }
                        | Instruction::Field {
                            id: _,
                            llvm_instr: _,
                            lhs_var: _,
                            struct_id: _,
                            rhs_var: _,
                            field_idx: _,
                            rhs_typelab: tl,
                        }
                        | Instruction::Element {
                            id: _,
                            llvm_instr: _,
                            lhs_var: _,
                            rhs_var: _,
                            elem_var: _,
                            rhs_typelab: tl,
                        }
                        | Instruction::CondBr {
                            id: _,
                            llvm_instr: _,
                            cond_var: _,
                            cond_typelab: tl,
                            then_target: _,
                            else_target: _,
                        }
                        | Instruction::Ret {
                            id: _,
                            llvm_instr: _,
                            rhs_var: _,
                            rhs_typelab: tl,
                        }
                        | Instruction::Switch {
                            id: _,
                            llvm_instr: _,
                            cond_var: _,
                            cond_typelab: tl,
                            targets: _,
                        } => {
                            tl.0 = res.len() as u64;
                            res.insert(*tl, STypeFrag::Unknown);
                        }
                        Instruction::Call {
                            id: _,
                            llvm_instr: _,
                            lhs_var: _,
                            callee: _,
                            arg_vars: operand_vars,
                            arg_typelabs: tls,
                        }
                        | Instruction::Phi {
                            id: _,
                            llvm_instr: _,
                            lhs_var: _,
                            operand_vars,
                            operand_typelabs: tls,
                        }
                        | Instruction::Use {
                            id: _,
                            llvm_instr: _,
                            llvm_operands: _,
                            lhs_var: _,
                            operand_vars,
                            operand_typelabs: tls,
                            successors: _,
                        } => {
                            for _ in operand_vars {
                                let tl = TypeLab(res.len() as u64);
                                res.insert(tl, STypeFrag::Unknown);
                                tls.push(tl);
                            }
                        }
                        Instruction::Br {
                            id: _,
                            llvm_instr: _,
                            target: _,
                        } => continue,
                        Instruction::Unreachable {
                            id: _,
                            llvm_instr: _,
                        } => continue,
                    }
                }
            }
        }

        res
    }

    /// Perform source type inference using the partially constructed functions
    /// in `functions`.
    fn infer_types(labels: &Labels, functions: &HashMap<FuncIdent, Function>) -> SourceTypes {
        let module = labels.llvm_mod;
        let structs = HashMap::from_iter(
            labels
                .structs
                .iter()
                .filter_map(|(k, v)| v.as_ref().map(|v| (k.clone(), &**v))),
        );
        let globals = HashMap::from_iter(module.global_vars.iter().map(|var| {
            let id = labels
                .globals
                .get(&var.name)
                .expect("`var` should have been analyzed by now");
            (*id, var)
        }));

        let mut funcs = HashMap::new();

        for (id, func) in functions {
            let llvm_func = func.llvm_func;
            let param_vars = func.param_vars.clone();
            let mut instrs = Vec::new();

            for bb in &func.basic_blocks {
                for instr in &bb.instructions {
                    instrs.push(SIInstr::from(instr));
                }
            }

            funcs.insert(
                id.clone(),
                SIFunction {
                    llvm_func,
                    param_vars,
                    instrs,
                },
            );
        }

        SourceTypes::analyze(module, structs, globals, funcs)
    }

    /// Attach source type information to struct definitions.
    fn attach_struct_types(
        types: &SourceTypes,
        structs: &mut HashMap<StructIdent, Struct>,
        lab_stype: HashMap<TypeLab, STypeFrag>,
    ) -> HashMap<TypeLab, STypeFrag> {
        let mut lab_stype = lab_stype;

        for (struct_id, fields) in &types.fields {
            let mut struct_typelabs = Vec::new();
            for frags in fields {
                let mut typelabs = Vec::new();

                // Extra wrapping pointer type fragment
                let typelab = TypeLab(lab_stype.len() as u64);
                typelabs.push(typelab);
                lab_stype.insert(typelab, STypeFrag::Pointer);

                // Remaining type fragments
                for frag in frags {
                    let typelab = TypeLab(lab_stype.len() as u64);
                    typelabs.push(typelab);
                    lab_stype.insert(typelab, frag.clone());
                }
                struct_typelabs.push(typelabs);
            }
            structs
                .get_mut(struct_id)
                .expect("`struct_id` was obtained from `structs`")
                .field_typelabs = struct_typelabs;
        }

        lab_stype
    }

    /// Attach source type information to global variables and their
    /// initializers.
    fn attach_global_types(
        types: &SourceTypes,
        globals: &mut HashMap<VarIdent, GlobalVar>,
        lab_stype: HashMap<TypeLab, STypeFrag>,
    ) -> HashMap<TypeLab, STypeFrag> {
        let mut lab_stype = lab_stype;

        for (var_id, var) in globals.iter_mut() {
            let mut lhs_typelabs = Vec::new();
            for frag in types
                .vars
                .get(var_id)
                .expect("`types.vars` was constructed using the identifiers in `globals`")
            {
                let typelab = TypeLab(lab_stype.len() as u64);
                lhs_typelabs.push(typelab);
                lab_stype.insert(typelab, frag.clone());
            }
            var.lhs_typelabs = lhs_typelabs;

            let frag = types
                .vars
                .get(var_id)
                .expect("`types.vars` was constructed using using the identifiers in `globals`")
                .first()
                .expect("Inferred source types contain at least one fragment");
            let typelab = TypeLab(lab_stype.len() as u64);
            lab_stype.insert(typelab, frag.clone());
            var.rhs_typelab = Some(typelab);
        }

        lab_stype
    }

    /// Attach source type information to everything in `functions` and
    /// `locals`, namely return values and local variables, and excluding
    /// rvalue expressions.
    fn attach_func_types(
        types: &SourceTypes,
        functions: &mut HashMap<FuncIdent, Function>,
        locals: &mut HashMap<VarIdent, LocalVar>,
        lab_stype: HashMap<TypeLab, STypeFrag>,
    ) -> HashMap<TypeLab, STypeFrag> {
        let mut lab_stype = lab_stype;

        for (func_id, func) in functions.iter_mut() {
            /* Return type */
            let mut ret_typelabs = Vec::new();
            for frag in types
                .rets
                .get(func_id)
                .expect("`types.rets` was constructed using the identifiers in `functions`")
            {
                let typelab = TypeLab(lab_stype.len() as u64);
                ret_typelabs.push(typelab);
                lab_stype.insert(typelab, frag.clone());
            }
            func.ret_typelabs = ret_typelabs;

            for param_id in &func.param_vars {
                let mut typelabs = Vec::new();
                for frag in types
                    .vars
                    .get(param_id)
                    .expect("`types.vars` was constructed using the identifiers in `functions`")
                {
                    let typelab = TypeLab(lab_stype.len() as u64);
                    typelabs.push(typelab);
                    lab_stype.insert(typelab, frag.clone());
                }
                locals
                    .get_mut(param_id)
                    .expect("`param_id` is the identifier of a local variable")
                    .typelabs = typelabs;
            }

            for bb in &func.basic_blocks {
                for instr in &bb.instructions {
                    /* Local variable */
                    if let Some(var_id) = instr.try_decl() {
                        let mut typelabs = Vec::new();
                        for frag in types.vars.get(&var_id).expect(
                            "`types.vars` was constructed using the identifiers in `functions`",
                        ) {
                            let typelab = TypeLab(lab_stype.len() as u64);
                            typelabs.push(typelab);
                            lab_stype.insert(typelab, frag.clone());
                        }
                        locals
                            .get_mut(&var_id)
                            .expect("`var_id` is the identifier of a local variable")
                            .typelabs = typelabs;
                    }
                }
            }
        }

        lab_stype
    }

    /// Gets the type labels of the local variable in `locals` with variable
    /// identifier `id`, or the global variable in `globals` if no such local
    /// variable exists.
    ///
    /// # Panics
    /// - If `id` isn't the variable identifier for any variable in `locals`
    ///   or `globals`.
    fn find_var_typelabs<'b>(
        locals: &'b HashMap<VarIdent, LocalVar>,
        globals: &'b HashMap<VarIdent, GlobalVar>,
        id: &VarIdent,
    ) -> &'b [TypeLab] {
        if let Some(var) = locals.get(id) {
            &var.typelabs
        } else {
            let var = globals.get(id).expect(
                "If `id` isn't a key in `locals`, it should be a key in \
                `globals`.",
            );
            &var.lhs_typelabs
        }
    }

    /// Attach source type information to rvalue expressions in `functions`.
    /// Returns a tuple containing the updated `lab_stype` as its first element,
    /// and the map `rval_typelabs` as its second element.
    fn attach_rvalue_types(
        types: &SourceTypes,
        structs: &HashMap<StructIdent, Struct>,
        globals: &HashMap<VarIdent, GlobalVar>,
        functions: &mut HashMap<FuncIdent, Function>,
        locals: &HashMap<VarIdent, LocalVar>,
        lab_stype: HashMap<TypeLab, STypeFrag>,
    ) -> (HashMap<TypeLab, STypeFrag>, HashMap<TypeLab, Vec<TypeLab>>) {
        let mut lab_stype = lab_stype;
        let mut rval_typelabs = HashMap::new();

        for func in functions.values() {
            for bb in &func.basic_blocks {
                for instr in &bb.instructions {
                    match instr {
                        Instruction::Alloca { .. } => (),
                        Instruction::Load {
                            id: _,
                            llvm_instr: _,
                            lhs_var: _,
                            rhs_var,
                            rhs_typelab,
                        } => {
                            let mut typelabs = vec![*rhs_typelab];

                            let (_, rest_typelabs) =
                                Self::find_var_typelabs(locals, globals, rhs_var)
                                    .split_first()
                                    .expect(
                                        "Each variable should have a non-empty list of `TypeLab`s.",
                                    );
                            let (first_typelab, rest_typelabs) =
                                rest_typelabs.split_first().expect(
                                    "The rhs variable in a load instruction has \
                                    at least two `TypeLab`s.",
                                );

                            let first_frag = lab_stype.get(first_typelab).expect(
                                "`lab_stype` should have an entry for each variable `TypeLab`",
                            );
                            lab_stype.insert(*rhs_typelab, first_frag.clone());

                            typelabs.extend(rest_typelabs);

                            rval_typelabs.insert(*rhs_typelab, typelabs);
                        }
                        Instruction::Store {
                            id: _,
                            llvm_instr: _,
                            lhs_var: _,
                            rhs_var,
                            rhs_typelab,
                        }
                        | Instruction::Ret {
                            id: _,
                            llvm_instr: _,
                            rhs_var,
                            rhs_typelab,
                        }
                        | Instruction::Switch {
                            id: _,
                            llvm_instr: _,
                            cond_var: rhs_var,
                            cond_typelab: rhs_typelab,
                            targets: _,
                        } => {
                            let mut typelabs = vec![*rhs_typelab];

                            if let Some(rhs_var) = rhs_var {
                                // In this case, the rvalue expression is a variable.
                                let (first_typelab, rest_typelabs) = Self::find_var_typelabs(
                                    locals, globals, rhs_var,
                                )
                                .split_first()
                                .expect(
                                    "Each variable should have a non-empty list of `TypeLab`s.",
                                );
                                let first_frag = lab_stype.get(first_typelab).expect(
                                    "`lab_stype` should have an entry for each variable `TypeLab`",
                                );
                                lab_stype.insert(*rhs_typelab, first_frag.clone());
                                typelabs.extend(rest_typelabs);
                            } else {
                                // In this case, the rvalue expression is a constant.
                                let (first, rest) = types.rvals.get(rhs_typelab)
                                    .expect("Each rvalue expression should have a non-empty list of `TypeLab`s.")
                                    .split_first()
                                    .expect("The list is non-empty");

                                lab_stype.insert(*rhs_typelab, first.clone());
                                for frag in rest {
                                    let typelab = TypeLab(lab_stype.len() as u64);
                                    typelabs.push(typelab);
                                    lab_stype.insert(typelab, frag.clone());
                                }
                            }

                            rval_typelabs.insert(*rhs_typelab, typelabs);
                        }
                        Instruction::Field {
                            id: _,
                            llvm_instr: _,
                            lhs_var: _,
                            struct_id,
                            rhs_var: _,
                            field_idx,
                            rhs_typelab,
                        } => {
                            let mut typelabs = vec![*rhs_typelab];
                            lab_stype.insert(*rhs_typelab, STypeFrag::Pointer);

                            let (_, rest_typelabs) = structs
                                .get(struct_id)
                                .expect("All `Struct`s have been initialized")
                                .field_typelabs
                                .get(*field_idx)
                                .expect("`field_idx` is a valid field index for struct type `struct_id`")
                                .split_first()
                                .expect("All fields have an outer `TypeLab` with `ptr` type.");

                            typelabs.extend(rest_typelabs);
                            rval_typelabs.insert(*rhs_typelab, typelabs);
                        }
                        Instruction::Element {
                            id: _,
                            llvm_instr: _,
                            lhs_var: _,
                            rhs_var,
                            elem_var: _,
                            rhs_typelab,
                        } => {
                            let mut typelabs = vec![*rhs_typelab];
                            lab_stype.insert(*rhs_typelab, STypeFrag::Pointer);

                            let rest_typelabs = Self::find_var_typelabs(locals, globals, rhs_var)
                                .split_first()
                                .expect("Each variable should have a non-empty list of `TypeLab`s.")
                                .1;
                            typelabs.extend(rest_typelabs);

                            rval_typelabs.insert(*rhs_typelab, typelabs);
                        }
                        Instruction::Call {
                            id: _,
                            llvm_instr: _,
                            lhs_var: _,
                            callee: _,
                            arg_vars: operand_vars,
                            arg_typelabs: operand_typelabs,
                        }
                        | Instruction::Use {
                            id: _,
                            llvm_instr: _,
                            llvm_operands: _,
                            lhs_var: _,
                            operand_vars,
                            operand_typelabs,
                            successors: _,
                        }
                        | Instruction::Phi {
                            id: _,
                            llvm_instr: _,
                            lhs_var: _,
                            operand_vars,
                            operand_typelabs,
                        } => {
                            for (typelab, var) in operand_typelabs.iter().zip(operand_vars.iter()) {
                                let mut typelabs = vec![*typelab];

                                if let Some(var) = var {
                                    // In this case, the rvalue expression is a variable.
                                    let (first_typelab, rest_typelabs) = Self::find_var_typelabs(
                                        locals, globals, var,
                                    )
                                    .split_first()
                                    .expect(
                                        "Each variable should have a non-empty list of `TypeLab`s.",
                                    );
                                    let first_frag = lab_stype.get(first_typelab).expect(
                                        "`lab_stype` should have an entry for each variable `TypeLab`",
                                    );
                                    lab_stype.insert(*typelab, first_frag.clone());
                                    typelabs.extend(rest_typelabs);
                                } else {
                                    // In this case, the rvalue expression is a constant.
                                    let (first, rest) = types.rvals.get(typelab)
                                        .expect("Each rvalue expression should have a non-empty list of `TypeLab`s.")
                                        .split_first()
                                        .expect("The list is non-empty");

                                    lab_stype.insert(*typelab, first.clone());
                                    for frag in rest {
                                        let typelab = TypeLab(lab_stype.len() as u64);
                                        typelabs.push(typelab);
                                        lab_stype.insert(typelab, frag.clone());
                                    }
                                }

                                rval_typelabs.insert(*typelab, typelabs);
                            }
                        }
                        Instruction::Br { .. } => continue,
                        Instruction::CondBr {
                            id: _,
                            llvm_instr: _,
                            cond_var: _,
                            cond_typelab,
                            then_target: _,
                            else_target: _,
                        } => {
                            lab_stype.insert(*cond_typelab, STypeFrag::Bool);
                            rval_typelabs.insert(*cond_typelab, vec![*cond_typelab]);
                        }
                        Instruction::Unreachable {
                            id: _,
                            llvm_instr: _,
                        } => continue,
                    }
                }
            }
        }

        (lab_stype, rval_typelabs)
    }

    pub fn construct(src: &'a llvm_ir::Module) -> Self {
        let labels = Self::label(src);
        let mut structs = Self::init_structs(&labels);
        let mut globals = Self::init_globals(&labels);
        let mut functions = Self::init_functions(&labels);
        let mut locals = Self::init_locals(&labels, &functions);
        let lab_stype = Self::init_rvals(&mut functions);
        let types = Self::infer_types(&labels, &functions);
        let lab_stype = Self::attach_struct_types(&types, &mut structs, lab_stype);
        let lab_stype = Self::attach_global_types(&types, &mut globals, lab_stype);
        let lab_stype = Self::attach_func_types(&types, &mut functions, &mut locals, lab_stype);
        let (lab_stype, rval_typelabs) = Self::attach_rvalue_types(
            &types,
            &structs,
            &globals,
            &mut functions,
            &locals,
            lab_stype,
        );

        Self {
            llvm_mod: src,
            structs,
            functions,
            globals,
            locals,
            stypes: lab_stype,
            rval_typelabs,
        }
    }

    /// Gets a vector of all the `Struct`s in this program.
    pub fn structs(&self) -> Vec<&Struct> {
        self.structs.values().collect()
    }

    /// Gets the `Struct` with name `id`.
    ///
    /// # Panics
    /// If `id` is not the name of a struct in this program
    pub fn get_struct(&self, id: &StructIdent) -> &Struct {
        self.structs.get(id).unwrap()
    }

    /// Gets a vector of all the functions in this program.
    pub fn functions(&'a self) -> Vec<&'a Function<'a>> {
        self.functions.values().collect()
    }

    /// Gets the `Function` with name `id`.
    pub fn try_get_function(&'a self, id: &FuncIdent) -> Option<&'a Function<'a>> {
        self.functions.get(id)
    }

    /// Gets the `Function` with name `id`.
    ///
    /// # Panics
    /// If `id` is not the name of a function in this program.
    pub fn get_function(&'a self, id: &FuncIdent) -> &'a Function<'a> {
        self.try_get_function(id).unwrap()
    }

    /// Gets a vector of all the global variables in this program.
    pub fn globals(&'a self) -> Vec<&'a GlobalVar<'a>> {
        self.globals.values().collect()
    }

    /// Gets the `GlobalVar` with `VarID` `id`.
    ///
    /// # Panics
    /// If `id` is not the `VarID` of a global variable in this program.
    pub fn get_global(&self, id: &VarIdent) -> &GlobalVar<'_> {
        self.globals.get(id).unwrap()
    }

    /// Gets a vector of all the local variables in this program.
    pub fn locals(&self) -> Vec<&LocalVar> {
        self.locals.values().collect()
    }

    /// Gets the `LocalVar` with `VarID` `id`.
    ///
    /// # Panics
    /// If `id` is not the `VarID` of a local variable in this program.
    pub fn get_local(&self, id: &VarIdent) -> &LocalVar {
        self.locals.get(id).unwrap()
    }

    /// Gets the `GlobalVar` or `LocalVar` with `VarID` `id`.
    ///
    /// # Panics
    /// If `id` is not the `VarID` of any variable in this program.
    pub fn get_var(&self, id: &VarIdent) -> Either<&GlobalVar<'_>, &LocalVar> {
        self.globals
            .get(id)
            .map(Either::Left)
            .or(self.locals.get(id).map(Either::Right))
            .unwrap()
    }

    /// Gets a vector of all the `TypeLab`s which appear in this program.
    pub fn typelabs(&self) -> Vec<TypeLab> {
        self.stypes.keys().cloned().collect()
    }

    /// Gets the outer `STypeFrag` of the SType of a `TypeLab`.
    ///
    /// # Panics
    /// If `typelab` is not a `TypeLab` which appears in this program.
    pub fn lab_stype(&self, typelab: &TypeLab) -> &STypeFrag {
        self.stypes.get(typelab).unwrap()
    }

    /// Gets the `TypeLab`s of a variable.
    ///
    /// # Panics
    /// If `id` is not the identifier of any variable in this program.
    pub fn var_typelabs(&self, id: &VarIdent) -> &[TypeLab] {
        Self::find_var_typelabs(&self.locals, &self.globals, id)
    }

    pub fn signature_outer_typelabs(&self) -> Vec<TypeLab> {
        let mut result = vec![];
        for global in self.globals.values() {
            let first = global
                .lhs_typelabs
                .first()
                .expect("Every global variable has an outer `ptr` type fragment.");
            result.push(*first);
        }
        for struc in self.structs.values() {
            for field_typelabs in &struc.field_typelabs {
                let first = field_typelabs
                    .first()
                    .expect("Every struct field has an outer `ptr` type fragment.");
                result.push(*first);
            }
        }
        for function in self.functions.values() {
          let first = function.ret_typelabs
              .first()
              .expect("Every function return value has an outer `ptr` type fragment.");
          result.push(*first);
          for param_var in &function.param_vars {
              let first = self.var_typelabs(param_var)
                  .first()
                  .expect("Every function parameter has an outer `ptr` type fragment.");
              result.push(*first);
          }
        }
        result
    }

    /// Gets the `TypeLab`s of all global variables, return values,
    /// function parameters, and struct fields.
    pub fn signature_typelabs(&self) -> Vec<TypeLab> {
        let mut result = vec![];
        for global in self.globals.values() {
            result.extend(&global.lhs_typelabs);
        }
        for function in self.functions.values() {
            result.append(&mut function.ret_typelabs.clone());
            for param_var in &function.param_vars {
                result.extend(self.var_typelabs(param_var));
            }
        }
        for struc in self.structs.values() {
            for field_typelabs in &struc.field_typelabs {
                result.extend(field_typelabs);
            }
        }
        result
    }

    /// Gets only the outermost `TypeLab`s of all global variables and struct
    /// fields.
    pub fn outer_typelabs(&self) -> Vec<TypeLab> {
        let mut result = vec![];
        for r#struct in self.structs.values() {
            for field_typelabs in &r#struct.field_typelabs {
                let first = field_typelabs
                    .first()
                    .expect("Every struct field has an outer `ptr` type fragment.");
                result.push(*first);
            }
        }
        for global in self.globals.values() {
            let first = global
                .lhs_typelabs
                .first()
                .expect("Every global variable has an outer `ptr` type fragment.");
            result.push(*first);
        }
        result
    }

    /// Gets only the inner `TypeLab`s of all global variables and struct
    /// fields, and all `TypeLab`s of return values and parameters.
    pub fn inner_typelabs(&self) -> Vec<TypeLab> {
        let mut result = vec![];
        for r#struct in self.structs.values() {
            for field_typelabs in &r#struct.field_typelabs {
                let (_, rest) = field_typelabs
                    .split_first()
                    .expect("Every struct field has an outer `ptr` type fragment.");
                result.extend(rest);
            }
        }
        for global in self.globals.values() {
            let (_, rest) = global
                .lhs_typelabs
                .split_first()
                .expect("Every global variable has an outer `ptr` type fragment.");
            result.extend(rest);
        }
        for function in self.functions.values() {
            result.append(&mut function.ret_typelabs.clone());
            for param_var in &function.param_vars {
                result.extend(self.var_typelabs(param_var));
            }
        }
        result
    }

    /// Gets all `TypeLab`s that appear in struct definitions.
    pub fn struct_typelabs(&self) -> Vec<TypeLab> {
        Vec::from_iter(
            self.structs
                .values()
                .flat_map(|r#struct| r#struct.field_typelabs.iter().flatten())
                .cloned(),
        )
    }

    /// Gets all `TypeLab`s excluding those that appear in struct definitions.
    pub fn non_struct_typelabs(&self) -> Vec<TypeLab> {
        Vec::from_iter(
            self.globals
                .values()
                .flat_map(|global| global.lhs_typelabs.iter().chain(global.rhs_typelab.iter()))
                .chain(self.locals.values().flat_map(|local| local.typelabs.iter()))
                .chain(
                    self.functions
                        .values()
                        .flat_map(|func| func.ret_typelabs.iter()),
                )
                .chain(self.rval_typelabs.keys())
                .cloned(),
        )
    }

    /// Gets the `TypeLab`s of a rvalue expression.
    pub fn try_rval_typelabs(&self, rval: &TypeLab) -> Option<&[TypeLab]> {
        self.rval_typelabs.get(rval).map(|v| &**v)
    }

    /// Gets the `TypeLab`s of a rvalue expression.
    ///
    /// # Panics
    /// If `rval` is not the `TypeLab` of any rvalue expression in this program.
    pub fn rval_typelabs(&self, rval: &TypeLab) -> &[TypeLab] {
        self.try_rval_typelabs(rval).unwrap()
    }

    /// Gets the `STypeFrag`s of a variable.
    ///
    /// # Panics
    /// If `var` is not the `VarID` of any variable in this program.
    pub fn var_stype(&self, var: &VarIdent) -> Vec<&STypeFrag> {
        match self.get_var(var) {
            Either::Left(glob_var) => &glob_var.lhs_typelabs,
            Either::Right(loc_var) => &loc_var.typelabs,
        }
        .iter()
        .map(|typelab| self.lab_stype(typelab))
        .collect()
    }

    /// Gets the `TypeLab`s of a struct field.
    ///
    /// # Panics
    /// If `id` is not the identifier of any struct in this program or field_idx
    /// is not a valid field index for the struct `id`.
    pub fn field_typelabs(&self, id: &StructIdent, field_idx: &usize) -> &[TypeLab] {
        self.get_struct(id)
            .field_typelabs
            .get(*field_idx)
            .expect("`field_idx` should have been a valid field index for struct `id`")
    }

    /// Gets the `STypeFrag`s of a struct field.
    ///
    /// # Panics
    /// If `id` is not the identifier of any struct in this program or field_idx
    /// is not a valid field index for the struct `id`.
    pub fn field_stype(&self, id: &StructIdent, field_idx: &usize) -> Vec<&STypeFrag> {
        self.get_struct(id)
            .field_typelabs
            .get(*field_idx)
            .expect("`field_idx` should have been a valid field index for struct `id`")
            .iter()
            .map(|typelab| self.lab_stype(typelab))
            .collect()
    }

    /// Gets the number of instructions in `self`.
    pub fn num_instrs(&self) -> usize {
        self.functions.values().map(|func| func.num_instrs()).sum()
    }
}
