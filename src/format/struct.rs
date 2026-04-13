//! # Struct Display Formatting
//!
//! This module contains logic to format a struct representation (with types)
//! in human (or machine)-readable format.

use std::io::{Result, Write};

use console::style;

use crate::{
    format::{ConsoleFormat, TexFormat, types::TypeFrag},
    lang::{
        r#struct::{Struct, StructIdent},
        stype::TypeLab,
    },
    results::lifetime::Lifetime,
};

/// A `Struct` bundled with additional information needed to print it in
/// human-readable format with type labels.
pub struct StructWithContext<'a, T: TypeFrag> {
    pub r#struct: &'a Struct,
    pub field_type_map: &'a dyn Fn(StructIdent, usize) -> &'a [(&'a TypeLab, &'a T)],
    pub struct_generics_map: &'a dyn Fn(StructIdent) -> u64,
}

impl<T: TypeFrag> ConsoleFormat for StructWithContext<'_, T> {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        write!(out, "{} {}", style("struct").bold(), self.r#struct.id)?;
        if (self.struct_generics_map)(self.r#struct.id.clone()) > 0 {
            write!(out, "<")?;
            for i in 0..(self.struct_generics_map)(self.r#struct.id.clone()) {
                ConsoleFormat::format(&Lifetime::Parameter(i), out)?;
                write!(out, ", ")?;
            }
            write!(out, "> ")?;
        }
        writeln!(out, " {{")?;
        for field in 0..self.r#struct.field_typelabs.len() {
            write!(out, "    ")?;
            ConsoleFormat::format((self.field_type_map)(self.r#struct.id.clone(), field), out)?;
            write!(out, " ")?;
            writeln!(out, " {};", field)?;
        }
        write!(out, "}};")
    }
}

impl<T: TypeFrag> TexFormat for StructWithContext<'_, T> {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        write!(out, "\\kw{{struct}} ")?;
        TexFormat::format(self.r#struct.id.0.as_str(), out)?;
        if (self.struct_generics_map)(self.r#struct.id.clone()) > 0 {
            write!(out, "$\\langle$")?;
            for i in 0..(self.struct_generics_map)(self.r#struct.id.clone()) {
                TexFormat::format(&Lifetime::Parameter(i), out)?;
                write!(out, ", ")?;
            }
            write!(out, "$\\rangle$ ")?;
        }
        writeln!(out, " \\{{\\\\")?;
        for field in 0..self.r#struct.field_typelabs.len() {
            write!(out, "\\hspace*{{1em}}")?;
            TexFormat::format((self.field_type_map)(self.r#struct.id.clone(), field), out)?;
            writeln!(out, " {};\\\\", field)?;
        }
        write!(out, "\\}};")
    }
}
