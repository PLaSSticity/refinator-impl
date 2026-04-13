//! # Program Display Formatting
//!
//! This module contains logic to format a program representation (with types)
//! in human (or machine)-readable format.

use std::{
    collections::HashMap,
    io::{Result, Write},
    marker::PhantomData,
};

use crate::{
    format::{
        ConsoleFormat, TexFormat, function::FunctionWithContext, global_var::GlobalVarWithContext,
        r#struct::StructWithContext, types::TypeFrag,
    },
    lang::{
        program::Program,
        r#struct::StructIdent,
        stype::{STypeFrag, TypeLab},
        variable::VarIdent,
    },
    results::{Results, rtype::RTypeFrag},
};

impl Program<'_> {
    /// Pulls a map of `VarID` to variable names from `self`.
    fn get_var_name_map(&self) -> HashMap<VarIdent, &String> {
        let mut result = HashMap::new();
        for var in self.globals() {
            result.insert(var.id, &var.name);
        }
        for var in self.locals() {
            result.insert(var.id, &var.name);
        }
        result
    }

    /// Pulls a map of `VarID` to their source types, with type labels, from
    /// `self`.
    fn get_var_source_type_map(&self) -> HashMap<VarIdent, Vec<(&TypeLab, &STypeFrag)>> {
        let mut result = HashMap::new();
        for var in self.globals() {
            let mut pairs = vec![];
            for typelab in &var.lhs_typelabs {
                pairs.push((typelab, self.lab_stype(typelab)));
            }
            result.insert(var.id, pairs);
        }
        for var in self.locals() {
            let mut pairs = vec![];
            for typelab in &var.typelabs {
                pairs.push((typelab, self.lab_stype(typelab)));
            }
            result.insert(var.id, pairs);
        }
        result
    }

    /// Pulls a map of struct fields `(StructID, usize)` to their source types,
    /// with type labels, from `self`.
    fn get_field_source_type_map(
        &self,
    ) -> HashMap<(StructIdent, usize), Vec<(&TypeLab, &STypeFrag)>> {
        let mut result = HashMap::new();
        for r#struct in self.structs() {
            for (field, typelabs) in r#struct.field_typelabs.iter().enumerate() {
                let mut pairs = vec![];
                for typelab in typelabs {
                    pairs.push((typelab, self.lab_stype(typelab)));
                }
                result.insert((r#struct.id.clone(), field), pairs);
            }
        }

        result
    }
}

/// A `Program` bundled with additional information needed to print it in
/// human-readable format with Rust types.
pub struct ProgramWithRustTypes<'a> {
    pub program: Program<'a>,
    pub results: Results,
}

impl<'a> ProgramWithRustTypes<'a> {
    /// Pulls a map of `VarID` to their Rust types, with type labels, from
    /// `self`.
    fn get_var_rust_type_map(&self) -> HashMap<VarIdent, Vec<(&TypeLab, &RTypeFrag)>> {
        let mut result = HashMap::new();
        for var in self.program.globals() {
            let mut pairs = vec![];
            for typelab in &var.lhs_typelabs {
                pairs.push((typelab, self.results.rust_types.get(typelab).unwrap()));
            }
            result.insert(var.id, pairs);
        }
        for var in self.program.locals() {
            let mut pairs = vec![];
            for typelab in &var.typelabs {
                pairs.push((typelab, self.results.rust_types.get(typelab).unwrap()));
            }
            result.insert(var.id, pairs);
        }
        result
    }

    /// Pulls a map of struct fields `(StructID, usize)` to their Rust types,
    /// with type labels, from `self`.
    fn get_field_rust_type_map(
        &self,
    ) -> HashMap<(StructIdent, usize), Vec<(&TypeLab, &RTypeFrag)>> {
        let mut result = HashMap::new();
        for r#struct in self.program.structs() {
            for (field, typelabs) in r#struct.field_typelabs.iter().enumerate() {
                let mut pairs = vec![];
                for typelab in typelabs {
                    pairs.push((typelab, self.results.rust_types.get(typelab).unwrap()));
                }
                result.insert((r#struct.id.clone(), field), pairs);
            }
        }

        result
    }

    /// Constructs a new `ProgramWithRustTypes`.
    pub fn new(program: Program<'a>, results: Results) -> Self {
        Self { program, results }
    }
}

/// Strategy for formatting a program for console viewing.
pub struct ProgramConsoleFormatter<T: TypeFrag> {
    _typefrag_type: PhantomData<T>,
}

impl<T: TypeFrag> ProgramConsoleFormatter<T> {
    fn generic_format<'a>(
        program: &'a Program,
        out: &mut impl Write,
        field_type_map: &'a dyn Fn(StructIdent, usize) -> &'a [(&'a TypeLab, &'a T)],
        var_name_map: &'a dyn Fn(VarIdent) -> &'a str,
        var_type_map: &'a dyn Fn(VarIdent) -> &'a [(&'a TypeLab, &'a T)],
        type_map: &'a dyn Fn(TypeLab) -> &'a T,
        struct_generics_map: &'a dyn Fn(StructIdent) -> u64,
    ) -> Result<()> {
        for r#struct in program.structs() {
            ConsoleFormat::format(
                &StructWithContext {
                    r#struct,
                    field_type_map,
                    struct_generics_map,
                },
                out,
            )?;
            writeln!(out)?;
        }

        for var in program.globals() {
            ConsoleFormat::format(
                &GlobalVarWithContext {
                    var,
                    var_name_map,
                    var_type_map,
                    type_map,
                },
                out,
            )?;
            writeln!(out)?;
        }

        for function in program.functions() {
            ConsoleFormat::format(
                &FunctionWithContext {
                    function,
                    var_name_map,
                    var_type_map,
                    type_map,
                },
                out,
            )?;
            writeln!(out)?;
        }

        Ok(())
    }
}

impl ProgramConsoleFormatter<STypeFrag> {
    pub fn format(program: &Program, out: &mut impl Write) -> Result<()> {
        let field_type_map = program.get_field_source_type_map();
        let field_type_map_fn =
            |r#struct: StructIdent, field: usize| -> &[(&TypeLab, &STypeFrag)] {
                field_type_map.get(&(r#struct, field)).unwrap()
            };

        let var_name_map = program.get_var_name_map();
        let var_name_map_fn = |var: VarIdent| -> &str { var_name_map.get(&var).unwrap() };

        let var_type_map = program.get_var_source_type_map();
        let var_type_map_fn =
            |var: VarIdent| -> &[(&TypeLab, &STypeFrag)] { var_type_map.get(&var).unwrap() };

        let type_map_fn = |typelab: TypeLab| -> &STypeFrag { program.lab_stype(&typelab) };

        Self::generic_format(
            program,
            out,
            &field_type_map_fn,
            &var_name_map_fn,
            &var_type_map_fn,
            &type_map_fn,
            &|_| -> u64 { 0 },
        )
    }
}

impl ProgramConsoleFormatter<RTypeFrag> {
    pub fn format(program: &ProgramWithRustTypes, out: &mut impl Write) -> Result<()> {
        let field_type_map = program.get_field_rust_type_map();
        let field_type_map_fn =
            |r#struct: StructIdent, field: usize| -> &[(&TypeLab, &RTypeFrag)] {
                field_type_map.get(&(r#struct, field)).unwrap()
            };

        let var_name_map = program.program.get_var_name_map();
        let var_name_map_fn = |var: VarIdent| -> &str { var_name_map.get(&var).unwrap() };

        let var_type_map = program.get_var_rust_type_map();
        let var_type_map_fn =
            |var: VarIdent| -> &[(&TypeLab, &RTypeFrag)] { var_type_map.get(&var).unwrap() };

        let type_map_fn =
            |typelab: TypeLab| -> &RTypeFrag { program.results.rust_types.get(&typelab).unwrap() };

        let struct_lifetime_map_fn = |r#struct: StructIdent| -> u64 {
            match program.results.struct_generics.get(&r#struct) {
                Some(res) => *res,
                None => 0,
            }
        };

        Self::generic_format(
            &program.program,
            out,
            &field_type_map_fn,
            &var_name_map_fn,
            &var_type_map_fn,
            &type_map_fn,
            &struct_lifetime_map_fn,
        )
    }
}

/// Strategy for formatting a program for TeX.
pub struct ProgramTexFormatter<T: TypeFrag> {
    _typefrag_type: PhantomData<T>,
}

impl<T: TypeFrag> ProgramTexFormatter<T> {
    fn generic_format<'a>(
        program: &'a Program,
        out: &mut impl Write,
        field_type_map: &'a dyn Fn(StructIdent, usize) -> &'a [(&'a TypeLab, &'a T)],
        var_name_map: &'a dyn Fn(VarIdent) -> &'a str,
        var_type_map: &'a dyn Fn(VarIdent) -> &'a [(&'a TypeLab, &'a T)],
        type_map: &'a dyn Fn(TypeLab) -> &'a T,
        struct_generics_map: &'a dyn Fn(StructIdent) -> u64,
    ) -> Result<()> {
        for r#struct in program.structs() {
            TexFormat::format(
                &StructWithContext {
                    r#struct,
                    field_type_map,
                    struct_generics_map,
                },
                out,
            )?;
            writeln!(out, "\\\\")?;
        }

        for var in program.globals() {
            TexFormat::format(
                &GlobalVarWithContext {
                    var,
                    var_name_map,
                    var_type_map,
                    type_map,
                },
                out,
            )?;
            writeln!(out, "\\\\")?;
        }

        for function in program.functions() {
            TexFormat::format(
                &FunctionWithContext {
                    function,
                    var_name_map,
                    var_type_map,
                    type_map,
                },
                out,
            )?;
            writeln!(out, "\\\\")?;
        }

        Ok(())
    }
}

impl ProgramTexFormatter<STypeFrag> {
    pub fn format(program: &Program, out: &mut impl Write) -> Result<()> {
        let field_type_map = program.get_field_source_type_map();
        let field_type_map_fn =
            |r#struct: StructIdent, field: usize| -> &[(&TypeLab, &STypeFrag)] {
                field_type_map.get(&(r#struct, field)).unwrap()
            };

        let var_name_map = program.get_var_name_map();
        let var_name_map_fn = |var: VarIdent| -> &str { var_name_map.get(&var).unwrap() };

        let var_type_map = program.get_var_source_type_map();
        let var_type_map_fn =
            |var: VarIdent| -> &[(&TypeLab, &STypeFrag)] { var_type_map.get(&var).unwrap() };

        let type_map_fn = |typelab: TypeLab| -> &STypeFrag { program.lab_stype(&typelab) };

        Self::generic_format(
            program,
            out,
            &field_type_map_fn,
            &var_name_map_fn,
            &var_type_map_fn,
            &type_map_fn,
            &|_| -> u64 { 0 },
        )
    }
}

impl ProgramTexFormatter<RTypeFrag> {
    pub fn format(program: &ProgramWithRustTypes, out: &mut impl Write) -> Result<()> {
        let field_type_map = program.get_field_rust_type_map();
        let field_type_map_fn =
            |r#struct: StructIdent, field: usize| -> &[(&TypeLab, &RTypeFrag)] {
                field_type_map.get(&(r#struct, field)).unwrap()
            };

        let var_name_map = program.program.get_var_name_map();
        let var_name_map_fn = |var: VarIdent| -> &str { var_name_map.get(&var).unwrap() };

        let var_type_map = program.get_var_rust_type_map();
        let var_type_map_fn =
            |var: VarIdent| -> &[(&TypeLab, &RTypeFrag)] { var_type_map.get(&var).unwrap() };

        let type_map_fn =
            |typelab: TypeLab| -> &RTypeFrag { program.results.rust_types.get(&typelab).unwrap() };

        let struct_lifetime_map_fn = |r#struct: StructIdent| -> u64 {
            match program.results.struct_generics.get(&r#struct) {
                Some(res) => *res,
                None => 0,
            }
        };

        Self::generic_format(
            &program.program,
            out,
            &field_type_map_fn,
            &var_name_map_fn,
            &var_type_map_fn,
            &type_map_fn,
            &struct_lifetime_map_fn,
        )
    }
}
