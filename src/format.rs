//! # LabLLVM Display Formatting
//!
//! This module contains logic to format a LabLLVM program representation in
//! human (or machine)-readable format.

pub mod function;
pub mod global_var;
pub mod instruction;
pub mod program;
pub mod r#struct;
pub mod types;

use std::io::{Result, Write};

use console::style;

/// Types that implement `ConsoleFormat` can be formatted in a human-readable
/// format intended for viewing in a console.
pub trait ConsoleFormat {
    /// Writes `self` to `out` in a suitable format.
    fn format(&self, out: &mut dyn Write) -> Result<()>;
}

impl ConsoleFormat for str {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        write!(out, "{}", self)
    }
}

/// Types that implement `TexFormat` can be formatted in TeX.
pub trait TexFormat {
    /// Writes `self` to `out` in a suitable format.
    fn format(&self, out: &mut dyn Write) -> Result<()>;
}

impl TexFormat for str {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        write!(out, "\\detokenize{{{}}}", self)
    }
}

/// Types that implement `Superscript` can be formatted as a string of
/// superscript numerals.
trait Superscript {
    /// Converts `self` into its numeric representation using superscript
    /// numerals.
    fn superscript(&self) -> String;
}

impl Superscript for str {
    /// Converts a base-10 numeric string into a string where all characters are
    /// replaced with their superscript version.
    ///
    /// # Panics
    /// - If `self` is not a base-10 numeric string.
    fn superscript(&self) -> String {
        let mut result = String::with_capacity(self.len());
        for c in self.chars() {
            assert!(c.is_ascii_digit());
            result.push(match c {
                '0' => '⁰',
                '1' => '¹',
                '2' => '²',
                '3' => '³',
                '4' => '⁴',
                '5' => '⁵',
                '6' => '⁶',
                '7' => '⁷',
                '8' => '⁸',
                '9' => '⁹',
                _ => unreachable!(),
            });
        }
        result
    }
}

impl Superscript for usize {
    fn superscript(&self) -> String {
        self.to_string().superscript()
    }
}

impl Superscript for u64 {
    fn superscript(&self) -> String {
        self.to_string().superscript()
    }
}

/// Display text for a generic constant expression.
fn const_expr(out: &mut dyn Write) -> Result<()> {
    write!(
        out,
        "{}{}{}",
        style("(").dim(),
        style("const expr").italic().dim(),
        style(")").dim()
    )
}

/// Display text for a placeholder.
fn unimplemented(out: &mut dyn Write) -> Result<()> {
    write!(
        out,
        "{}{}{}",
        style("(").dim(),
        style("unimplemented").italic().dim(),
        style(")").dim()
    )
}

/// Display text for a generic constant expression.
fn tex_const_expr(out: &mut dyn Write) -> Result<()> {
    write!(out, "(const expr)")
}

/// Display text for a placeholder.
fn tex_unimplemented(out: &mut dyn Write) -> Result<()> {
    write!(out, "(unimplemented)")
}
