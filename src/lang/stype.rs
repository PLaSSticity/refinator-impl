//! # Source Type Inference.
//!
//! &inator's source program construction includes _source type inference_, in
//! which the input LLVM IR is analyzed to determine the source types for all of
//! the typed objects in the program. Typed objects are struct fields, function
//! returns, and variables.
//!
//! For source type inference, we first construct a directed rooted forest,
//! where the nodes are occurrences of source types, an edge `u -> v` means
//! that `u`'s inner type is `v` (this implies `u` can have an inner type: it
//! is `ptr` or `array`). The roots of the forest correspond to the outer-most
//! fragment of the source type of a typed object.
//!
//! Then, using the instructions in a program, we determine how to merge parts
//! of the forset. For example, for the instruction `p = *q`, if we have the
//! following forest where `p:1` is the root of `p`'s tree and `q:1` is the
//! root of `q`'s tree, then we know that `p:1` and `q:2` are equal, and we
//! record this equality constraint.
//!
//! ```text
//!                  q:1 (ptr)
//!                   |
//!                   v
//!     p:1 (ptr) == q:2 (ptr)
//!      |            |
//!      v            v
//!     p:2 (i32)    q:3 (i32)
//! ```
//!
//! Once we have generated the forests and the equality constraints, we can
//! inspect the graph and its equalities to determine the complete source type
//! of each typed object.

use std::{collections::HashMap, fmt::Display, ops::Deref, slice::Iter};

use either::Either;
use llvm_ir::{
    Type,
    types::{FPType, Typed},
};
use petgraph::{
    graph::{EdgeIndex, NodeIndex},
    prelude::DiGraph,
    unionfind::UnionFind,
};
use regex::Regex;
use z3::ast::Int;

use crate::lang::{
    function::FuncIdent, instruction::Instruction, r#struct::StructIdent, variable::VarIdent,
};

/// Newtype for type labels.
#[derive(Clone, Copy, PartialOrd, Ord, PartialEq, Eq, Hash, Default)]
pub struct TypeLab(pub u64);

impl From<&TypeLab> for Int {
    fn from(value: &TypeLab) -> Self {
        Self::from_u64(value.0)
    }
}

impl From<TypeLab> for Int {
    fn from(value: TypeLab) -> Self {
        Self::from(&value)
    }
}

/// A fragment of a source type.
#[derive(Clone, PartialEq, Eq)]
pub enum STypeFrag {
    Void,
    Bool,
    Int8,
    Int16,
    Int32,
    Int64,
    Float32,
    Float64,
    Struct(String),
    Pointer,
    Unknown,
}

impl Display for STypeFrag {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Void => write!(f, "void"),
            Self::Bool => write!(f, "bool"),
            Self::Int8 => write!(f, "i8"),
            Self::Int16 => write!(f, "i16"),
            Self::Int32 => write!(f, "i32"),
            Self::Int64 => write!(f, "i64"),
            Self::Float32 => write!(f, "f32"),
            Self::Float64 => write!(f, "f64"),
            Self::Struct(name) => write!(f, "struct({name})"),
            Self::Pointer => write!(f, "ptr"),
            Self::Unknown => write!(f, "unknown"),
        }
    }
}

impl STypeFrag {
    /// Checks if `self` is a `ptr` variant.
    pub fn is_ptr(&self) -> bool {
        matches!(self, Self::Pointer)
    }

    /// Checks if `self` is a `struct` variant.
    pub fn is_struct(&self) -> bool {
        matches!(self, Self::Struct(_))
    }

    /// Checks if `self` is a `unknown` variant.
    pub fn is_unknown(&self) -> bool {
        matches!(self, Self::Unknown)
    }

    /// Gets the kind of `self`, assuming `self` is a `struct` variant.
    ///
    /// # Panics
    /// - if `self` is not a `struct` variant.
    pub fn struct_kind(&self) -> &str {
        match self {
            Self::Struct(s) => s,
            _ => panic!(),
        }
    }
}

/// A `SIInstr` captures the relevant data about an LLVM instruction needed for
/// source type inference.
pub enum SIInstr {
    Alloca {
        lhs: VarIdent,
        llvm_instr: llvm_ir::instruction::Alloca,
    },
    Load {
        lhs: VarIdent,
        rhs: VarIdent,
        rhs_tl: TypeLab,
        llvm_instr: llvm_ir::instruction::Load,
    },
    Store {
        lhs: VarIdent,
        rhs: Option<VarIdent>,
        rhs_tl: TypeLab,
        llvm_instr: llvm_ir::instruction::Store,
    },
    Field {
        lhs: VarIdent,
        rhs: VarIdent,
        rhs_tl: TypeLab,
        struct_id: StructIdent,
        field_idx: usize,
        llvm_instr: llvm_ir::instruction::GetElementPtr,
    },
    Element {
        lhs: VarIdent,
        rhs: VarIdent,
        rhs_tl: TypeLab,
        llvm_instr: llvm_ir::instruction::GetElementPtr,
    },
    Call {
        lhs: Option<VarIdent>,
        args: Vec<Option<VarIdent>>,
        args_tl: Vec<TypeLab>,
        func_id: FuncIdent,
        llvm_instr: llvm_ir::instruction::Call,
    },
    Phi {
        lhs: VarIdent,
        operands: Vec<Option<VarIdent>>,
        operands_tl: Vec<TypeLab>,
        llvm_instr: llvm_ir::instruction::Phi,
    },
    Use {
        lhs: Option<VarIdent>,
        operands: Vec<Option<VarIdent>>,
        operands_tl: Vec<TypeLab>,
        llvm_instr: Either<llvm_ir::Instruction, llvm_ir::Terminator>,
        llvm_operands: Vec<llvm_ir::Operand>,
    },
    Ret {
        rhs: Option<VarIdent>,
        rhs_tl: TypeLab,
        llvm_instr: llvm_ir::terminator::Ret,
    },
}

impl<'a> From<&Instruction<'a>> for SIInstr {
    fn from(value: &Instruction<'a>) -> Self {
        match value {
            Instruction::Alloca {
                id: _,
                llvm_instr,
                lhs_var,
            } => SIInstr::Alloca {
                lhs: *lhs_var,
                llvm_instr: (*llvm_instr).clone(),
            },
            Instruction::Load {
                id: _,
                llvm_instr,
                lhs_var,
                rhs_var,
                rhs_typelab,
            } => SIInstr::Load {
                lhs: *lhs_var,
                rhs: *rhs_var,
                rhs_tl: *rhs_typelab,
                llvm_instr: (*llvm_instr).clone(),
            },
            Instruction::Store {
                id: _,
                llvm_instr,
                lhs_var,
                rhs_var,
                rhs_typelab,
            } => SIInstr::Store {
                lhs: *lhs_var,
                rhs: *rhs_var,
                rhs_tl: *rhs_typelab,
                llvm_instr: (*llvm_instr).clone(),
            },
            Instruction::Field {
                id: _,
                llvm_instr,
                lhs_var,
                struct_id,
                rhs_var,
                field_idx,
                rhs_typelab,
            } => SIInstr::Field {
                lhs: *lhs_var,
                rhs: *rhs_var,
                rhs_tl: *rhs_typelab,
                struct_id: struct_id.clone(),
                field_idx: *field_idx,
                llvm_instr: (*llvm_instr).clone(),
            },
            Instruction::Element {
                id: _,
                llvm_instr,
                lhs_var,
                rhs_var,
                elem_var: _,
                rhs_typelab,
            } => SIInstr::Element {
                lhs: *lhs_var,
                rhs: *rhs_var,
                rhs_tl: *rhs_typelab,
                llvm_instr: (*llvm_instr).clone(),
            },
            Instruction::Call {
                id: _,
                llvm_instr,
                lhs_var,
                callee,
                arg_vars,
                arg_typelabs,
            } => SIInstr::Call {
                lhs: *lhs_var,
                args: arg_vars.clone(),
                args_tl: arg_typelabs.clone(),
                func_id: callee.clone(),
                llvm_instr: (*llvm_instr).clone(),
            },
            Instruction::Phi {
                id: _,
                llvm_instr,
                lhs_var,
                operand_vars,
                operand_typelabs,
            } => SIInstr::Phi {
                lhs: *lhs_var,
                operands: operand_vars.clone(),
                operands_tl: operand_typelabs.clone(),
                llvm_instr: (*llvm_instr).clone(),
            },
            Instruction::Use {
                id: _,
                llvm_instr,
                llvm_operands,
                lhs_var,
                operand_vars,
                operand_typelabs,
                successors: _,
            } => SIInstr::Use {
                lhs: *lhs_var,
                operands: operand_vars.clone(),
                operands_tl: operand_typelabs.clone(),
                llvm_instr: llvm_instr.cloned(),
                llvm_operands: llvm_operands.clone(),
            },
            Instruction::Ret {
                id: _,
                llvm_instr,
                rhs_var,
                rhs_typelab,
            } => SIInstr::Ret {
                rhs: *rhs_var,
                rhs_tl: *rhs_typelab,
                llvm_instr: (*llvm_instr).clone(),
            },
            Instruction::Br {
                id: _,
                llvm_instr,
                target: _,
            } => SIInstr::Use {
                lhs: None,
                operands: vec![],
                operands_tl: vec![],
                llvm_instr: Either::Right(llvm_ir::Terminator::from((*llvm_instr).clone())),
                llvm_operands: vec![],
            },
            Instruction::CondBr {
                id: _,
                llvm_instr,
                cond_var,
                cond_typelab,
                then_target: _,
                else_target: _,
            } => SIInstr::Use {
                lhs: None,
                operands: vec![*cond_var],
                operands_tl: vec![*cond_typelab],
                llvm_instr: Either::Right(llvm_ir::Terminator::from((*llvm_instr).clone())),
                llvm_operands: vec![llvm_instr.condition.clone()],
            },
            Instruction::Switch {
                id: _,
                llvm_instr,
                cond_var,
                cond_typelab,
                targets: _,
            } => SIInstr::Use {
                lhs: None,
                operands: vec![*cond_var],
                operands_tl: vec![*cond_typelab],
                llvm_instr: Either::Right(llvm_ir::Terminator::from((*llvm_instr).clone())),
                llvm_operands: vec![llvm_instr.operand.clone()],
            },
            Instruction::Unreachable { id: _, llvm_instr } => SIInstr::Use {
                lhs: None,
                operands: vec![],
                operands_tl: vec![],
                llvm_instr: Either::Right(llvm_ir::Terminator::from((*llvm_instr).clone())),
                llvm_operands: vec![],
            },
        }
    }
}

/// A `SIFunction` captures the relevant data about an LLVM function needed for
/// source type inference.
pub struct SIFunction<'a> {
    pub llvm_func: Either<&'a llvm_ir::Function, &'a llvm_ir::function::FunctionDeclaration>,
    pub param_vars: Vec<VarIdent>,
    pub instrs: Vec<SIInstr>,
}

/// A `SITypeFrag` is a source type fragment, plus some extra variants, used as
/// labels for nodes in source type inference.
///
/// This is the same as `STypeFrag`, except for:
/// 1. The `Infer` variant, which is used by the inference to mark a node with
///    unknown type, and it should take the type from elsewhere in its
///    equivalence class,
/// 2. The `Restrict*` variants, which the inference uses to mark nodes that
///    should not be unioned with other nodes.
#[derive(Clone, PartialEq, Eq)]
enum SITypeFrag {
    Void,
    Bool,
    Int8,
    Int16,
    Int32,
    Int64,
    Float32,
    Float64,
    Struct(String),
    Pointer,
    Unknown,
    Infer,
    RestrictPointer,
    RestrictUnknown,
}

impl Display for SITypeFrag {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Void => write!(f, "void"),
            Self::Bool => write!(f, "bool"),
            Self::Int8 => write!(f, "i8"),
            Self::Int16 => write!(f, "i16"),
            Self::Int32 => write!(f, "i32"),
            Self::Int64 => write!(f, "i64"),
            Self::Float32 => write!(f, "f32"),
            Self::Float64 => write!(f, "f64"),
            Self::Struct(name) => write!(f, "struct({name})"),
            Self::Pointer => write!(f, "ptr"),
            Self::Unknown => write!(f, "unknown"),
            Self::Infer => write!(f, "infer"),
            Self::RestrictPointer => write!(f, "restrict+ptr"),
            Self::RestrictUnknown => write!(f, "restrict+unknown"),
        }
    }
}

impl TryInto<STypeFrag> for SITypeFrag {
    type Error = &'static str;
    fn try_into(self) -> Result<STypeFrag, Self::Error> {
        match self {
            Self::Void => Ok(STypeFrag::Void),
            Self::Bool => Ok(STypeFrag::Bool),
            Self::Int8 => Ok(STypeFrag::Int8),
            Self::Int16 => Ok(STypeFrag::Int16),
            Self::Int32 => Ok(STypeFrag::Int32),
            Self::Int64 => Ok(STypeFrag::Int64),
            Self::Float32 => Ok(STypeFrag::Float32),
            Self::Float64 => Ok(STypeFrag::Float64),
            Self::Struct(s) => Ok(STypeFrag::Struct(s)),
            Self::Pointer => Ok(STypeFrag::Pointer),
            Self::Unknown => Ok(STypeFrag::Unknown),
            Self::Infer => Err("Tried to convert a `SITypeFrag::Infer` into a `STypeFrag`."),
            Self::RestrictPointer => Ok(STypeFrag::Pointer),
            Self::RestrictUnknown => Ok(STypeFrag::Unknown),
        }
    }
}

impl SITypeFrag {
    /// Checks if `self` is an `infer` variant.
    pub fn is_infer(&self) -> bool {
        matches!(self, Self::Infer)
    }

    /// Checks if `self` is a `restrict` variant.
    pub fn is_restrict(&self) -> bool {
        matches!(self, Self::RestrictPointer | Self::RestrictUnknown)
    }
}

/// A (incomplete) source type used in source type inference. This is a wrapper
/// around a vector of `SITypeFrag`s.
#[derive(Clone, PartialEq, Eq)]
struct SIType(Vec<SITypeFrag>);

impl SIType {
    fn unsupported(ty: &Type) -> Self {
        eprintln!(
            "WARN: Encountered unsupported type during source type inference. \
            Treating as an unknown type...",
        );
        eprintln!("      Encountered LLVM type {}.", ty);
        Self(vec![SITypeFrag::Unknown])
    }

    fn as_slice(&self) -> &[SITypeFrag] {
        self.0.as_slice()
    }
}

impl<T: Deref<Target = Type>> From<T> for SIType {
    /// Conversion from an LLVM type inserts an `SITypeFrag::Infer` as the last
    /// `SITypeFrag` for pointer types.
    fn from(value: T) -> Self {
        match &*value {
            Type::VoidType => Self(vec![SITypeFrag::Void]),
            Type::IntegerType { bits } => match bits {
                1 => Self(vec![SITypeFrag::Bool]),
                8 => Self(vec![SITypeFrag::Int8]),
                16 => Self(vec![SITypeFrag::Int16]),
                32 => Self(vec![SITypeFrag::Int32]),
                64 => Self(vec![SITypeFrag::Int64]),
                _ => Self::unsupported(&value),
            },
            Type::FPType(llvm_fp_ty) => match llvm_fp_ty {
                FPType::Single => Self(vec![SITypeFrag::Float32]),
                FPType::Double => Self(vec![SITypeFrag::Float64]),
                _ => Self::unsupported(&value),
            },
            Type::ArrayType {
                element_type,
                num_elements: _,
            }
            | Type::VectorType {
                element_type,
                num_elements: _,
                scalable: _,
            } => Self::from(element_type.clone()),
            Type::PointerType { addr_space: _ } => {
                Self(vec![SITypeFrag::Pointer, SITypeFrag::Infer])
            }
            Type::NamedStructType { name } => Self(vec![SITypeFrag::Struct(name.clone())]),
            _ => Self::unsupported(&value),
        }
    }
}

impl<'a> IntoIterator for &'a SIType {
    type Item = &'a SITypeFrag;
    type IntoIter = Iter<'a, SITypeFrag>;
    fn into_iter(self) -> Self::IntoIter {
        self.0.iter()
    }
}

/// A `SIRoots` contains maps from typed object identifiers to their indices of
/// their associated root nodes in a `SIContext::forest`.
struct SIRoots {
    fields: HashMap<(StructIdent, usize), NodeIndex>,
    rets: HashMap<FuncIdent, NodeIndex>,
    vars: HashMap<VarIdent, NodeIndex>,
    rvals: HashMap<TypeLab, NodeIndex>,
}

impl SIRoots {
    fn new() -> Self {
        Self {
            fields: HashMap::new(),
            rets: HashMap::new(),
            vars: HashMap::new(),
            rvals: HashMap::new(),
        }
    }
}

/// A `SIForest` contains the data structures used in the forest constructed
/// during source type inference.
struct SIForest {
    forest: DiGraph<SITypeFrag, ()>,
    equal: UnionFind<u32>,
    equal_reindex: HashMap<NodeIndex, u32>,
    forest_reindex: HashMap<u32, NodeIndex>,
    roots: SIRoots,
}

impl SIForest {
    fn new() -> Self {
        Self {
            forest: DiGraph::new(),
            equal: UnionFind::new_empty(),
            equal_reindex: HashMap::new(),
            forest_reindex: HashMap::new(),
            roots: SIRoots::new(),
        }
    }

    /// Inserts a node into `self`.
    fn add_node(&mut self, label: SITypeFrag) -> NodeIndex {
        let idx = self.forest.add_node(label);
        let equal_idx = self.equal.new_set();
        self.equal_reindex.insert(idx, equal_idx);
        self.forest_reindex.insert(equal_idx, idx);
        idx
    }

    /// Inserts an edge into `self`.
    fn add_edge(&mut self, src: NodeIndex, dst: NodeIndex) -> EdgeIndex {
        self.forest.add_edge(src, dst, ())
    }

    /// Unions `a` and `b` in `equal`.
    fn union(&mut self, a: NodeIndex, b: NodeIndex) -> bool {
        self.equal.union(
            *self.equal_reindex.get(&a).unwrap(),
            *self.equal_reindex.get(&b).unwrap(),
        )
    }

    /// Unions `a` and `b` in `equal`, except if the `SITypeFrag` for `a` or
    /// `b` is a `restrict` variant, then this is a no-op.
    fn safe_union(&mut self, a: NodeIndex, b: NodeIndex) -> bool {
        let a_ty = self.ty(a).expect("`a` should be a valid node index");
        let b_ty = self.ty(b).expect("`b` should be a valid node index");
        if !a_ty.is_restrict() && !b_ty.is_restrict() {
            self.equal.union(
                *self.equal_reindex.get(&a).unwrap(),
                *self.equal_reindex.get(&b).unwrap(),
            )
        } else {
            false
        }
    }

    /// Finds a representative for `x` in `equal`.
    fn find(&mut self, x: NodeIndex) -> NodeIndex {
        *self
            .forest_reindex
            .get(&self.equal.find_mut(*self.equal_reindex.get(&x).unwrap()))
            .unwrap()
    }

    /// Gets a vector of the outgoing neighbors of of `x`.
    fn out(&self, x: NodeIndex) -> Vec<NodeIndex> {
        self.forest.neighbors(x).collect()
    }

    /// Gets an outgoing neighbor of `x`.
    fn next(&self, x: NodeIndex) -> Option<NodeIndex> {
        self.out(x).first().copied()
    }

    /// Inserts `idx` as the index of the root node for the `field` field of
    /// `struct`.
    fn insert_field(&mut self, r#struct: StructIdent, field: usize, idx: NodeIndex) {
        self.roots.fields.insert((r#struct, field), idx);
    }

    /// Inserts `idx` as the index of the root node for the return of `func`.
    fn insert_ret(&mut self, func: FuncIdent, idx: NodeIndex) {
        self.roots.rets.insert(func, idx);
    }

    /// Inserts `idx` as the index of the root node for `var`.
    fn insert_var(&mut self, var: VarIdent, idx: NodeIndex) {
        self.roots.vars.insert(var, idx);
    }

    /// Inserts `idx` as the index of the root node for the rvalue expression
    /// identified by `typelab`.
    fn insert_rval(&mut self, typelab: TypeLab, idx: NodeIndex) {
        self.roots.rvals.insert(typelab, idx);
    }

    /// Gets the root `NodeIndex` for field `field` on struct `struct`.
    fn field_idx(&self, r#struct: &StructIdent, field: usize) -> NodeIndex {
        *self.roots.fields.get(&(r#struct.clone(), field)).expect(
            "All struct fields should have a corresponding root node in \
                `forest` that is recorded in `roots.fields`.",
        )
    }

    /// Gets the root `NodeIndex` for the return value of `func`.
    fn ret_idx(&self, func: &FuncIdent) -> NodeIndex {
        *self.roots.rets.get(func).expect(
            "All function returns should have a corresponding root node in \
                `forest` that is recorded in `roots.rets`.",
        )
    }

    /// Gets the root `NodeIndex` for the type of `var`.
    fn var_idx(&self, var: &VarIdent) -> NodeIndex {
        *self.roots.vars.get(var).expect(
            "All variables should have a corresponding root node in \
            `forest` that is recorded in `roots.vars`.",
        )
    }

    /// Gets the `NodeIndex` for the inner type of `var`.
    fn deref_idx(&self, var: &VarIdent) -> NodeIndex {
        self.next(self.var_idx(var))
            .expect("`Pointer`-typed variables always have an outgoing neighbor.")
    }

    // Gets the `NodeIndex` for the type of the rvalue expression identified by
    // `typelab`.
    fn rval_idx(&self, typelab: &TypeLab) -> NodeIndex {
        *self.roots.rvals.get(typelab).expect(
            "All rval expressions should have a corresponding root node in \
            `forest` that is recorded in `roots.rvals`.",
        )
    }

    /// Pulls the equivalence classes in `self.equal`.
    fn pull_classes(&mut self) -> HashMap<NodeIndex, Vec<NodeIndex>> {
        let mut classes: HashMap<NodeIndex, Vec<NodeIndex>> = HashMap::new();
        let indices: Vec<NodeIndex> = self.forest.node_indices().collect();
        for idx in indices {
            classes.entry(self.find(idx)).or_default().push(idx);
        }
        classes
    }

    /// Gets the `SITypeFrag` for the node with index `idx`.
    fn ty(&self, idx: NodeIndex) -> Option<SITypeFrag> {
        self.forest.node_weight(idx).cloned()
    }

    // /// For debugging, dumps the forest in dot format to stderr.
    // fn dump(&mut self) {
    //     let classes = self.pull_classes();
    //     eprintln!("digraph {{");
    //     for (canon, elts) in classes {
    //         eprintln!("subgraph cluster_{} {{", canon.index());
    //         for elt in elts {
    //             eprintln!("{} [label=\"{}\"]", elt.index(), self.ty(elt).unwrap());
    //         }
    //         eprintln!("}}")
    //     }
    //     for (i, ((r#struct, fld), elt)) in self.roots.fields.iter().enumerate() {
    //         eprintln!("f{} [shape=box, label=\"{}::{}\"]", i, r#struct, fld);
    //         eprintln!("f{} -> {}", i, elt.index());
    //     }
    //     for (i, (func, elt)) in self.roots.rets.iter().enumerate() {
    //         eprintln!("r{} [shape=box, label=\"ret {}\"]", i, func);
    //         eprintln!("r{} -> {}", i, elt.index());
    //     }
    //     for var in self.roots.vars.keys() {
    //         eprintln!("v{} [shape=box, label=\"var {}\"]", var, var);
    //     }
    //     for (var, elt) in self.roots.vars.iter() {
    //         eprintln!("v{} -> {}", var, elt.index());
    //     }
    //     for rval in self.roots.rvals.keys() {
    //         eprintln!("rv{} [shape=box, label=\"rval {}\"]", rval.0, rval.0);
    //     }
    //     for (rval, elt) in self.roots.rvals.iter() {
    //         eprintln!("rv{} -> {}", rval.0, elt.index());
    //     }
    //     for (s, d) in self
    //         .forest
    //         .edge_indices()
    //         .flat_map(|e| self.forest.edge_endpoints(e))
    //     {
    //         eprintln!("{} -> {}", s.index(), d.index());
    //     }
    //     eprintln!("}}");
    // }
}

/// A `SIContext` contains the data structures used for source type inference.
struct SIContext<'a> {
    module: &'a llvm_ir::Module,
    structs: HashMap<StructIdent, &'a llvm_ir::Type>,
    globals: HashMap<VarIdent, &'a llvm_ir::module::GlobalVariable>,
    funcs: HashMap<FuncIdent, SIFunction<'a>>,
    forest: SIForest,
}

impl<'a> SIContext<'a> {
    fn new(
        module: &'a llvm_ir::Module,
        structs: HashMap<StructIdent, &'a llvm_ir::Type>,
        globals: HashMap<VarIdent, &'a llvm_ir::module::GlobalVariable>,
        funcs: HashMap<FuncIdent, SIFunction<'a>>,
    ) -> Self {
        Self {
            module,
            structs,
            globals,
            funcs,
            forest: SIForest::new(),
        }
    }
}

///  A set of tuples `(regex, ty)` which specifies that for a function
///  whose name matches `regex`, the `SIType` of its return value is `ty`.
const RET_OVERRIDES: &[(&str, &[SITypeFrag])] = &[
    (
        r"^malloc$",
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
    (
        r"^memmap$",
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
    (
        r"^llvm\.stacksave$",
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
];

///  A set of tuples `(regex, n, ty)` which specifies that for a
///  function whose name matches `regex`, the `SIType` its `n`th parameter
///  should be `ty`.
///
///  The `llvm.memcpy.*`, `llvm.memmove.*`, and `llvm.memset.*` intrinsics
///  are problematic.
const PARAM_OVERRIDES: &[(&str, usize, &[SITypeFrag])] = &[
    (
        r"^llvm\.stacksave$",
        0,
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
    (
        r"^llvm\.memcpy\..*$",
        0,
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
    (
        r"^llvm\.memcpy\..*$",
        1,
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
    (
        r"^llvm\.memmove\..*$",
        0,
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
    (
        r"^llvm\.memmove\..*$",
        1,
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
    (
        r"^llvm\.memset\..*$",
        0,
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
    // `instruction::Instruction::from_instr` throws out calls to this
    // intrinsic.
    (
        r"^llvm\.lifetime\..*$",
        1, /* In LLVM 17, the pointer is the second argument of llvm.lifetime.* */
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
    (
        r"^llvm\.objectsize\..*$",
        0,
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
    (
        r"^__memcpy_chk$",
        0,
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
    (
        r"^__memcpy_chk$",
        1,
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
    (
        r"^__memset_chk$",
        0,
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
    (
        r"^memmap$",
        0,
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
    (
        r"^munmap$",
        0,
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
    (
        r"^free$",
        0,
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
    (
        r"^memcmp$",
        0,
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
    (
        r"^memcmp$",
        1,
        &[SITypeFrag::RestrictPointer, SITypeFrag::RestrictUnknown],
    ),
    (
        r"^strcmp$",
        0,
        &[SITypeFrag::RestrictPointer, SITypeFrag::Int8],
    ),
    (
        r"^strcmp$",
        1,
        &[SITypeFrag::RestrictPointer, SITypeFrag::Int8],
    ),
    (
        r"^strlen$",
        0,
        &[SITypeFrag::RestrictPointer, SITypeFrag::Int8],
    ),
    (
        r"^printf$",
        0,
        &[SITypeFrag::RestrictPointer, SITypeFrag::Int8],
    ),
    (
        r"^fprintf$",
        1,
        &[SITypeFrag::RestrictPointer, SITypeFrag::Int8],
    ),
    (r"^puts$", 0, &[SITypeFrag::Pointer, SITypeFrag::Int8]),
    (r"^fputs$", 0, &[SITypeFrag::Pointer, SITypeFrag::Int8]),
];

/// The source types for the typed objects in a program.
pub struct SourceTypes {
    pub fields: HashMap<StructIdent, Vec<Vec<STypeFrag>>>,
    pub rets: HashMap<FuncIdent, Vec<STypeFrag>>,
    pub vars: HashMap<VarIdent, Vec<STypeFrag>>,
    pub rvals: HashMap<TypeLab, Vec<STypeFrag>>,
}

impl SourceTypes {
    fn insert_si_ty(forest: &mut SIForest, ty: SIType) -> NodeIndex {
        assert!(!ty.as_slice().is_empty());
        let (si_frag, rest) = ty.as_slice().split_first().expect("Checked by assertion.");
        let root_idx = forest.add_node(si_frag.clone());
        let mut pred_idx = root_idx;
        for si_frag in rest {
            let idx = forest.add_node(si_frag.clone());
            forest.add_edge(pred_idx, idx);
            pred_idx = idx;
        }
        root_idx
    }

    fn insert_ty(forest: &mut SIForest, ty: &Type) -> NodeIndex {
        Self::insert_si_ty(forest, ty.into())
    }

    fn try_known_ret(func: &FuncIdent) -> Option<SIType> {
        for (regex, ty) in RET_OVERRIDES {
            let regex = Regex::new(regex).unwrap();
            if regex.is_match(&func.to_string()) {
                return Some(SIType(Vec::from(*ty)));
            }
        }
        None
    }

    fn try_known_param(func: &FuncIdent, n: usize) -> Option<SIType> {
        for (regex, param, ty) in PARAM_OVERRIDES {
            if *param == n {
                let regex = Regex::new(regex).unwrap();
                if regex.is_match(&func.to_string()) {
                    return Some(SIType(Vec::from(*ty)));
                }
            }
        }
        None
    }

    fn gen_known_roots(mut ctx: SIContext) -> SIContext {
        let mut forest = ctx.forest;

        for (func_id, func) in &ctx.funcs {
            // Return value
            if let Some(ret_ty) = Self::try_known_ret(func_id) {
                let ret_idx = Self::insert_si_ty(&mut forest, ret_ty);
                forest.insert_ret(func_id.clone(), ret_idx);
            }

            // Parameters
            for (n, var) in func.param_vars.iter().enumerate() {
                if let Some(param_ty) = Self::try_known_param(func_id, n) {
                    let var_idx = Self::insert_si_ty(&mut forest, param_ty);
                    forest.insert_var(*var, var_idx);
                }
            }
        }

        ctx.forest = forest;
        ctx
    }

    fn gen_roots(mut ctx: SIContext) -> SIContext {
        let mut forest = ctx.forest;

        // Struct type definitions
        for (r#struct, ty) in &ctx.structs {
            match ty {
                Type::StructType {
                    element_types,
                    is_packed: _,
                } => {
                    for (field, ty) in element_types.iter().enumerate() {
                        let idx = Self::insert_ty(&mut forest, ty);
                        forest.insert_field(r#struct.clone(), field, idx);
                    }
                }
                _ => unreachable!(),
            }
        }

        // Global variables
        for (id, var) in &ctx.globals {
            let idx = Self::insert_ty(&mut forest, &var.ty);
            forest.insert_var(*id, idx);
        }

        // Functions
        for (func_id, func) in &ctx.funcs {
            // Return value
            if !forest.roots.rets.contains_key(func_id) {
                let ret_ty = match func.llvm_func {
                    Either::Left(func) => func.return_type.clone(),
                    Either::Right(func) => func.return_type.clone(),
                };
                let ret_idx = Self::insert_ty(&mut forest, &ret_ty);
                forest.insert_ret(func_id.clone(), ret_idx);
            }

            // Parameters
            let llvm_params = match func.llvm_func {
                Either::Left(func) => &func.parameters,
                Either::Right(func) => &func.parameters,
            };
            for (param, var) in llvm_params.iter().zip(func.param_vars.iter()) {
                if !forest.roots.vars.contains_key(var) {
                    let var_idx = Self::insert_ty(&mut forest, &param.get_type(&ctx.module.types));
                    forest.insert_var(*var, var_idx);
                }
            }

            // Non-parameter local variables.
            for instr in &func.instrs {
                let (var, ty) = match instr {
                    SIInstr::Alloca { lhs, llvm_instr } => {
                        (*lhs, llvm_instr.get_type(&ctx.module.types))
                    }
                    SIInstr::Load {
                        lhs, llvm_instr, ..
                    } => (*lhs, llvm_instr.get_type(&ctx.module.types)),
                    SIInstr::Store { .. } => continue,
                    SIInstr::Field {
                        lhs, llvm_instr, ..
                    } => (*lhs, llvm_instr.get_type(&ctx.module.types)),
                    SIInstr::Element {
                        lhs, llvm_instr, ..
                    } => (*lhs, llvm_instr.get_type(&ctx.module.types)),
                    SIInstr::Call {
                        lhs: Some(lhs),
                        llvm_instr,
                        ..
                    } => (*lhs, llvm_instr.get_type(&ctx.module.types)),
                    SIInstr::Call { .. } => continue,
                    SIInstr::Phi {
                        lhs, llvm_instr, ..
                    } => (*lhs, llvm_instr.get_type(&ctx.module.types)),
                    SIInstr::Use {
                        lhs: Some(lhs),
                        operands: _,
                        operands_tl: _,
                        llvm_instr,
                        llvm_operands: _,
                    } => {
                        let ty = match llvm_instr {
                            Either::Left(instr) => instr.get_type(&ctx.module.types),
                            Either::Right(instr) => instr.get_type(&ctx.module.types),
                        };
                        (*lhs, ty)
                    }
                    SIInstr::Use { .. } => continue,
                    SIInstr::Ret { .. } => continue,
                };
                let var_idx = Self::insert_ty(&mut forest, &ty);
                forest.insert_var(var, var_idx);
            }

            // Rvalue expressions.
            for instr in &func.instrs {
                match instr {
                    SIInstr::Alloca { .. } => continue,
                    SIInstr::Load {
                        lhs: _,
                        rhs: _,
                        rhs_tl,
                        llvm_instr,
                    } => {
                        let rval_idx = Self::insert_ty(&mut forest, &llvm_instr.loaded_ty);
                        forest.insert_rval(*rhs_tl, rval_idx);
                    }
                    SIInstr::Store {
                        lhs: _,
                        rhs: _,
                        rhs_tl,
                        llvm_instr,
                    } => {
                        let ty = llvm_instr.value.get_type(&ctx.module.types);
                        let rval_idx = Self::insert_ty(&mut forest, &ty);
                        forest.insert_rval(*rhs_tl, rval_idx);
                    }
                    SIInstr::Field {
                        lhs: _,
                        rhs: _,
                        rhs_tl,
                        struct_id: _,
                        field_idx: _,
                        llvm_instr: _,
                    }
                    | SIInstr::Element {
                        lhs: _,
                        rhs: _,
                        rhs_tl,
                        llvm_instr: _,
                    } => {
                        let si_ty = SIType(vec![SITypeFrag::Pointer, SITypeFrag::Infer]);
                        let rval_idx = Self::insert_si_ty(&mut forest, si_ty);
                        forest.insert_rval(*rhs_tl, rval_idx);
                    }
                    SIInstr::Call {
                        lhs: _,
                        args: _,
                        args_tl,
                        func_id: _,
                        llvm_instr,
                    } => {
                        for (operand, tl) in
                            llvm_instr.arguments.iter().map(|(o, _)| o).zip(args_tl)
                        {
                            let ty = operand.get_type(&ctx.module.types);
                            let rval_idx = Self::insert_ty(&mut forest, &ty);
                            forest.insert_rval(*tl, rval_idx);
                        }
                    }
                    SIInstr::Phi {
                        lhs: _,
                        operands: _,
                        operands_tl,
                        llvm_instr,
                    } => {
                        for tl in operands_tl {
                            let rval_idx = Self::insert_ty(&mut forest, &llvm_instr.to_type);
                            forest.insert_rval(*tl, rval_idx);
                        }
                    }
                    SIInstr::Use {
                        lhs: _,
                        operands: _,
                        operands_tl,
                        llvm_instr: _,
                        llvm_operands,
                    } => {
                        for (operand, tl) in llvm_operands.iter().zip(operands_tl) {
                            let ty = operand.get_type(&ctx.module.types);
                            let rval_idx = Self::insert_ty(&mut forest, &ty);
                            forest.insert_rval(*tl, rval_idx);
                        }
                    }
                    SIInstr::Ret {
                        rhs: _,
                        rhs_tl,
                        llvm_instr,
                    } => {
                        let si_ty = match &llvm_instr.return_operand {
                            Some(ty) => ty.get_type(&ctx.module.types).into(),
                            None => SIType(vec![SITypeFrag::Void]),
                        };
                        let rval_idx = Self::insert_si_ty(&mut forest, si_ty);
                        forest.insert_rval(*rhs_tl, rval_idx);
                    }
                }
            }
        }

        ctx.forest = forest;
        ctx
    }

    fn process_instrs(mut ctx: SIContext) -> SIContext {
        let mut forest = ctx.forest;

        for (func_id, func) in &ctx.funcs {
            for instr in &func.instrs {
                match instr {
                    SIInstr::Alloca { lhs, llvm_instr } => {
                        let new_idx = Self::insert_ty(&mut forest, &llvm_instr.allocated_type);
                        let lhs_idx = forest.deref_idx(lhs);
                        forest.union(new_idx, lhs_idx);
                    }
                    SIInstr::Load {
                        lhs,
                        rhs,
                        rhs_tl,
                        llvm_instr: _,
                    } => {
                        let rval_idx = forest.rval_idx(rhs_tl);

                        let lhs_idx = forest.var_idx(lhs);
                        let rhs_idx = forest.deref_idx(rhs);

                        forest.union(rval_idx, lhs_idx);
                        forest.union(rval_idx, rhs_idx);
                    }
                    SIInstr::Store {
                        lhs,
                        rhs,
                        rhs_tl,
                        llvm_instr: _,
                    } => {
                        let rval_idx = forest.rval_idx(rhs_tl);

                        let lhs_idx = forest.deref_idx(lhs);

                        forest.union(rval_idx, lhs_idx);
                        if let Some(rhs) = rhs {
                            let rhs_idx = forest.var_idx(rhs);
                            forest.union(rval_idx, rhs_idx);
                        }
                    }
                    SIInstr::Field {
                        lhs,
                        rhs,
                        rhs_tl,
                        struct_id,
                        field_idx: f,
                        llvm_instr,
                    } => {
                        // TODO: Handling of `gep` instructions is generally brittle.
                        // We expect `gep`s that index into a struct field to
                        // have exactly two indices: one to index into the
                        // implied array of structs pointed to by `rhs`, and one
                        // to pick a field.
                        assert!(llvm_instr.indices.len() == 2);

                        let lhs_idx = forest.var_idx(lhs);
                        let rval_idx = forest.rval_idx(rhs_tl);
                        forest.union(lhs_idx, rval_idx);

                        let deref_lhs_idx = forest.deref_idx(lhs);
                        let field_idx = forest.field_idx(struct_id, *f);
                        forest.union(deref_lhs_idx, field_idx);

                        let struct_idx = Self::insert_si_ty(
                            &mut forest,
                            SIType(vec![SITypeFrag::Struct(struct_id.to_string())]),
                        );
                        let rhs_idx = forest.deref_idx(rhs);
                        forest.union(struct_idx, rhs_idx);
                    }
                    SIInstr::Element {
                        lhs,
                        rhs,
                        rhs_tl,
                        llvm_instr,
                    } => {
                        // The type of `rhs` is always a pointer to (potentially
                        // an array of) the source type.
                        let source_idx =
                            Self::insert_ty(&mut forest, &llvm_instr.source_element_type);
                        let deref_rhs_idx = forest.deref_idx(rhs);
                        forest.union(deref_rhs_idx, source_idx);

                        let rhs_idx = forest.var_idx(rhs);
                        let rval_idx = forest.rval_idx(rhs_tl);
                        let lhs_idx = forest.var_idx(lhs);
                        forest.union(rhs_idx, rval_idx);
                        forest.union(rval_idx, lhs_idx);
                    }
                    SIInstr::Call {
                        lhs,
                        args,
                        args_tl,
                        func_id,
                        llvm_instr,
                    } => {
                        // Match return type.
                        if let Some(lhs) = lhs {
                            let new_idx = Self::insert_ty(
                                &mut forest,
                                &llvm_instr.get_type(&ctx.module.types),
                            );
                            let lhs_idx = forest.var_idx(lhs);
                            forest.union(new_idx, lhs_idx);

                            // This could be suspect if the function is polymorphic.
                            let ret_idx = forest.ret_idx(func_id);
                            forest.safe_union(new_idx, ret_idx);
                        }

                        // Match argument and parameter types.
                        let params = &ctx
                            .funcs
                            .get(func_id)
                            .expect(
                                "All called functions should have been \
                                declared, and thus appear in `forest.funcs`.",
                            )
                            .param_vars;
                        for ((param, arg_var), arg_tl) in
                            params.iter().zip(args.iter()).zip(args_tl)
                        {
                            let rval_idx = forest.rval_idx(arg_tl);

                            if let Some(arg_var) = arg_var {
                                let arg_idx = forest.var_idx(arg_var);
                                forest.union(rval_idx, arg_idx);
                            }

                            // This could be suspect if the function is polymorphic.
                            let param_idx = forest.var_idx(param);
                            forest.safe_union(rval_idx, param_idx);
                        }
                    }
                    SIInstr::Phi {
                        lhs,
                        operands,
                        operands_tl,
                        llvm_instr: _,
                    } => {
                        let lhs_idx = forest.var_idx(lhs);
                        for (var, tl) in operands.iter().zip(operands_tl) {
                            let rval_idx = forest.rval_idx(tl);
                            forest.union(lhs_idx, rval_idx);

                            if let Some(var) = var {
                                let var_idx = forest.var_idx(var);
                                forest.union(var_idx, rval_idx);
                            }
                        }
                    }
                    SIInstr::Use {
                        lhs: _,
                        operands,
                        operands_tl,
                        llvm_instr: _,
                        llvm_operands: _,
                    } => {
                        for (operand, tl) in operands.iter().zip(operands_tl.iter()) {
                            if let Some(var) = operand {
                                let var_idx = forest.var_idx(var);
                                let rval_idx = forest.rval_idx(tl);
                                forest.union(var_idx, rval_idx);
                            }
                        }
                    }
                    SIInstr::Ret {
                        rhs,
                        rhs_tl,
                        llvm_instr: _,
                    } => {
                        let rval_idx = forest.rval_idx(rhs_tl);
                        let ret_idx = forest.ret_idx(func_id);
                        forest.union(rval_idx, ret_idx);
                        if let Some(rhs) = rhs {
                            let rhs_idx = forest.var_idx(rhs);
                            forest.union(rval_idx, rhs_idx);
                        }
                    }
                }
            }
        }

        ctx.forest = forest;
        ctx
    }

    /// For each node `u`, `u'`, `v`, `v'`, if `u ~ v`, `u -> u'` and `v -> v'`,
    /// then expand the equivalence classes such that `u' ~ v'` also.
    fn expand_classes(mut ctx: SIContext) -> SIContext {
        let mut forest = ctx.forest;

        let mut changed = true;
        while changed {
            changed = false;
            let classes = forest.pull_classes();
            for class in classes.values() {
                for src1_idx in class.iter().copied() {
                    let targets1 = forest.out(src1_idx);
                    for src2_idx in class.iter().copied() {
                        let targets2 = forest.out(src2_idx);
                        for tgt1_idx in targets1.iter().cloned() {
                            for tgt2_idx in targets2.iter().cloned() {
                                changed |= forest.union(tgt1_idx, tgt2_idx);
                            }
                        }
                    }
                }
            }
        }

        ctx.forest = forest;
        ctx
    }

    /// Computes the `SITypeFrag` for each equivalence class in `classes`.
    fn find_frags(
        ctx: &SIContext,
        classes: &HashMap<NodeIndex, Vec<NodeIndex>>,
    ) -> HashMap<NodeIndex, SITypeFrag> {
        let mut result = HashMap::new();

        for (canon, elts) in classes {
            let mut frag = SITypeFrag::Infer;
            'elts: for idx in elts {
                let new_frag = ctx
                    .forest
                    .ty(*idx)
                    .expect("`idx` should be a valid node index.");
                if frag.is_infer() && !new_frag.is_infer() {
                    frag = new_frag;
                } else if !new_frag.is_infer() && frag != new_frag {
                    eprintln!(
                        "WARN: Encountered mismatched types during source type \
                        inference, choosing `unknown`..."
                    );
                    eprintln!("      {} != {}", frag, new_frag,);
                    frag = SITypeFrag::Unknown;
                    break 'elts;
                }
            }
            result.insert(*canon, frag);
        }

        result
    }

    /// Merges all the equivalence classes.
    fn merge_classes(mut ctx: SIContext) -> SIContext {
        let classes = ctx.forest.pull_classes();
        let frags = Self::find_frags(&ctx, &classes);

        let mut forest = ctx.forest;
        let mut n_forest = DiGraph::<SITypeFrag, ()>::new();

        // A map of indices in `forest` to indices in `n_forest`.
        let mut n_reindex = HashMap::<NodeIndex, NodeIndex>::new();

        // Add the nodes of `n_forest` and compute the re-indexing map.
        for (canon, elts) in classes {
            let new_idx = n_forest.add_node(
                frags
                    .get(&canon)
                    .expect(
                        "The representative of each equivalence class should \
                        be a key in `frags`",
                    )
                    .clone(),
            );
            for idx in elts {
                n_reindex.insert(idx, new_idx);
            }
        }

        // Add the edges of `n_forest`.
        for src_idx in forest.forest.node_indices() {
            let canon_src_idx = *n_reindex
                .get(&forest.find(src_idx))
                .expect("All old node indices should be keys in `n_reindex`.");
            for dst_idx in forest.out(src_idx) {
                let canon_dst_idx = *n_reindex
                    .get(&forest.find(dst_idx))
                    .expect("All old node indices should be keys in `n_reindex`.");
                if !n_forest.contains_edge(canon_src_idx, canon_dst_idx) {
                    n_forest.add_edge(canon_src_idx, canon_dst_idx, ());
                }
            }
        }

        // Remap roots in the original forest's indices to the new forest's
        // indices.
        let SIRoots {
            fields,
            rets,
            vars,
            rvals,
        } = forest.roots;

        let mut n_fields = HashMap::new();
        for (id, idx) in fields {
            n_fields.insert(
                id,
                *n_reindex
                    .get(&idx)
                    .expect("All old node indices should be keys in `n_reindex`."),
            );
        }

        let mut n_rets = HashMap::new();
        for (id, idx) in rets {
            n_rets.insert(
                id,
                *n_reindex
                    .get(&idx)
                    .expect("All old node indices should be keys in `n_reindex`."),
            );
        }

        let mut n_vars = HashMap::new();
        for (id, idx) in vars {
            n_vars.insert(
                id,
                *n_reindex
                    .get(&idx)
                    .expect("All old node indices should be keys in `n_reindex`."),
            );
        }

        let mut n_rvals = HashMap::new();
        for (id, idx) in rvals {
            n_rvals.insert(
                id,
                *n_reindex
                    .get(&idx)
                    .expect("All old node indices should be keys in `n_reindex`."),
            );
        }

        ctx.forest = SIForest::new();
        ctx.forest.forest = n_forest;
        ctx.forest.roots.fields = n_fields;
        ctx.forest.roots.rets = n_rets;
        ctx.forest.roots.vars = n_vars;
        ctx.forest.roots.rvals = n_rvals;
        ctx
    }

    fn to_sfrags(ty: SITypeFrag) -> Vec<STypeFrag> {
        match ty {
            SITypeFrag::Void => vec![STypeFrag::Void],
            SITypeFrag::Bool => vec![STypeFrag::Bool],
            SITypeFrag::Int8 => vec![STypeFrag::Int8],
            SITypeFrag::Int16 => vec![STypeFrag::Int16],
            SITypeFrag::Int32 => vec![STypeFrag::Int32],
            SITypeFrag::Int64 => vec![STypeFrag::Int64],
            SITypeFrag::Float32 => vec![STypeFrag::Float32],
            SITypeFrag::Float64 => vec![STypeFrag::Float64],
            SITypeFrag::Struct(s) => vec![STypeFrag::Struct(s)],
            SITypeFrag::Pointer | SITypeFrag::RestrictPointer => vec![STypeFrag::Pointer],
            SITypeFrag::Unknown | SITypeFrag::Infer | SITypeFrag::RestrictUnknown => {
                vec![STypeFrag::Unknown]
            }
        }
    }

    /// Find source types.
    fn find_types(ctx: SIContext) -> Self {
        let forest = ctx.forest;

        let sfrags_from_root = |root: NodeIndex| -> Vec<STypeFrag> {
            let mut result = vec![];
            let mut prev_idx = root;
            'nodes: loop {
                result.append(&mut Self::to_sfrags(
                    forest
                        .ty(prev_idx)
                        .expect("`prev_idx` should be obtained from `forest`"),
                ));
                match forest.next(prev_idx) {
                    Some(idx) => prev_idx = idx,
                    None => break 'nodes,
                }
            }
            result
        };

        let mut tmp_fields = HashMap::<StructIdent, HashMap<usize, NodeIndex>>::new();
        for ((r#struct, field), idx) in &forest.roots.fields {
            tmp_fields
                .entry(r#struct.clone())
                .or_default()
                .insert(*field, *idx);
        }

        let mut fields = HashMap::new();
        for (r#struct, flds) in tmp_fields {
            let mut result = vec![];
            let mut flds: Vec<(usize, NodeIndex)> = flds.into_iter().collect();
            flds.sort_by_key(|(field, _)| *field);
            for (_, root) in flds {
                result.push(sfrags_from_root(root));
            }
            fields.insert(r#struct, result);
        }

        let mut rets = HashMap::new();
        for (func, root) in &forest.roots.rets {
            rets.insert(func.clone(), sfrags_from_root(*root));
        }

        let mut vars = HashMap::new();
        for (var, root) in &forest.roots.vars {
            vars.insert(*var, sfrags_from_root(*root));
        }

        let mut rvals = HashMap::new();
        for (tl, root) in &forest.roots.rvals {
            rvals.insert(*tl, sfrags_from_root(*root));
        }

        Self {
            fields,
            rets,
            vars,
            rvals,
        }
    }

    /// Infer the source types for the typed objects in `module`.
    pub fn analyze(
        module: &llvm_ir::Module,
        structs: HashMap<StructIdent, &llvm_ir::Type>,
        globals: HashMap<VarIdent, &llvm_ir::module::GlobalVariable>,
        funcs: HashMap<FuncIdent, SIFunction>,
    ) -> Self {
        let ctx = SIContext::new(module, structs, globals, funcs);
        let ctx = Self::gen_known_roots(ctx);
        let ctx = Self::gen_roots(ctx);
        let ctx = Self::process_instrs(ctx);
        let ctx = Self::expand_classes(ctx);
        let ctx = Self::merge_classes(ctx);
        Self::find_types(ctx)
    }
}
