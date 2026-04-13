//! # Global Variable Display Formatting
//!
//! This module contains logic to format a global variable representation (with
//! types) in human (or machine)-readable format.

use std::io::{Result, Write};

use crate::{
    format::{ConsoleFormat, Superscript, TexFormat, const_expr, tex_const_expr, types::TypeFrag},
    lang::{
        stype::TypeLab,
        variable::{VarIdent, global::GlobalVar},
    },
};

/// A `GlobalVar` bundled with additional information needed to print it in
/// human-readable format with type labels.
pub struct GlobalVarWithContext<'a, T: TypeFrag> {
    pub var: &'a GlobalVar<'a>,
    pub var_name_map: &'a dyn Fn(VarIdent) -> &'a str,
    pub var_type_map: &'a dyn Fn(VarIdent) -> &'a [(&'a TypeLab, &'a T)],
    pub type_map: &'a dyn Fn(TypeLab) -> &'a T,
}

impl<T: TypeFrag> ConsoleFormat for GlobalVarWithContext<'_, T> {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        ConsoleFormat::format((self.var_type_map)(self.var.id), out)?;
        write!(out, " ")?;
        ConsoleFormat::format((self.var_name_map)(self.var.id), out)?;
        if let Some(typelab) = &self.var.rhs_typelab {
            write!(out, " = [")?;
            const_expr(out)?;
            write!(out, "]{} => ", typelab.0.superscript())?;
            ConsoleFormat::format((self.type_map)(*typelab), out)?;
            write!(out, ";")
        } else {
            write!(out, ";")
        }
    }
}

impl<T: TypeFrag> TexFormat for GlobalVarWithContext<'_, T> {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        TexFormat::format((self.var_type_map)(self.var.id), out)?;
        write!(out, " ")?;
        TexFormat::format((self.var_name_map)(self.var.id), out)?;
        if let Some(typelab) = &self.var.rhs_typelab {
            write!(out, " = \\labeled{{{}}}{{", typelab.0)?;
            tex_const_expr(out)?;
            write!(out, "}}{{\\color{{gray}}: ")?;
            TexFormat::format((self.type_map)(*typelab), out)?;
            write!(out, "}};")
        } else {
            write!(out, ";")
        }
    }
}
