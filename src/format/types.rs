//! # Type Display Formatting
//!
//! This module contains logic to format a source or Rust type in human
//! (or machine)-readable format.

use std::io::{Result, Write};

use console::style;

use crate::{
    constraints::datatypes::r#struct::InterpStruct,
    format::{ConsoleFormat, Superscript, TexFormat},
    lang::stype::{STypeFrag, TypeLab},
    results::{lifetime::Lifetime, rtype::RTypeFrag},
};

/// Marker trait for bare type fragments.
pub trait TypeFrag: ConsoleFormatType + TexFormatType {}

impl TypeFrag for STypeFrag {}
impl TypeFrag for RTypeFrag {}

/// Types that implement `ConsoleFormatType` can be used as the types that
/// appear in program fragments that are `ConsoleFormat`.
pub trait ConsoleFormatType: ConsoleFormat {
    /// Returns `true` if `self` is not a base type, i.e. this type is contains
    /// another type.
    fn is_base(&self) -> bool;

    /// Writes `self` to `out` in a suitable format, using `inner` to write the
    /// inner type to `out`.
    ///
    /// # Panics
    /// - If this operation is unsupported for this the type of `self`.
    /// - If `is_base(&self)`.
    fn format_with_inner(
        &self,
        out: &mut dyn Write,
        inner: &dyn Fn(&mut dyn Write) -> Result<()>,
    ) -> Result<()>;
}

impl ConsoleFormat for STypeFrag {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        match self {
            Self::Void => write!(out, "{}", style("void").red()),
            Self::Bool => write!(out, "{}", style("bool").red()),
            Self::Int8 => write!(out, "{}", style("i8").red()),
            Self::Int16 => write!(out, "{}", style("i16").red()),
            Self::Int32 => write!(out, "{}", style("i32").red()),
            Self::Int64 => write!(out, "{}", style("i64").red()),
            Self::Float32 => write!(out, "{}", style("f32").red()),
            Self::Float64 => write!(out, "{}", style("f64").red()),
            Self::Pointer => write!(out, "{}", style("ptr").red()),
            Self::Struct(s) => write!(out, "{}({})", style("struct").red(), s),
            Self::Unknown => write!(out, "{}", style("unknown").red()),
        }
    }
}

impl ConsoleFormatType for STypeFrag {
    fn is_base(&self) -> bool {
        !matches!(self, Self::Pointer)
    }

    fn format_with_inner(
        &self,
        out: &mut dyn Write,
        inner: &dyn Fn(&mut dyn Write) -> Result<()>,
    ) -> Result<()> {
        assert!(!ConsoleFormatType::is_base(self));
        ConsoleFormat::format(self, out)?;
        write!(out, "(")?;
        inner(out)?;
        write!(out, ")")
    }
}

impl ConsoleFormat for InterpStruct {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        write!(out, "{}", self.kind)
    }
}

impl ConsoleFormat for Lifetime {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        match self {
            Lifetime::Variable(n) | Lifetime::Parameter(n) => write!(out, "'{}", n),
        }
    }
}

impl ConsoleFormat for [Lifetime] {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        write!(out, "<")?;
        for lifetime in self {
            ConsoleFormat::format(lifetime, out)?;
            write!(out, ", ")?;
        }
        write!(out, ">")
    }
}

impl ConsoleFormat for RTypeFrag {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        match self {
            Self::Void => write!(out, "{}", style("void").green()),
            Self::Bool => write!(out, "{}", style("bool").green()),
            Self::Int8 => write!(out, "{}", style("i8").green()),
            Self::Int16 => write!(out, "{}", style("i16").green()),
            Self::Int32 => write!(out, "{}", style("i32").green()),
            Self::Int64 => write!(out, "{}", style("i64").green()),
            Self::Float32 => write!(out, "{}", style("f32").green()),
            Self::Float64 => write!(out, "{}", style("f64").green()),
            Self::Ghost { array: _, cell: _ }
            | Self::Box { array: _, cell: _ }
            | Self::Rc { array: _, cell: _ }
            | Self::Shared {
                array: _,
                cell: _,
                lifetime: _,
            }
            | Self::Mut {
                array: _,
                cell: _,
                lifetime: _,
            } => {
                match self {
                    Self::Ghost { array: _, cell: _ } => write!(out, "{}", style("ghost").green())?,
                    Self::Box { array: _, cell: _ } => write!(out, "{}", style("Box").green())?,
                    Self::Rc { array: _, cell: _ } => write!(out, "{}", style("Rc").green())?,
                    Self::Shared {
                        array: _,
                        cell: _,
                        lifetime,
                    } => {
                        write!(out, "{}", style("&").green())?;
                        ConsoleFormat::format(lifetime, out)?;
                    }
                    Self::Mut {
                        array: _,
                        cell: _,
                        lifetime,
                    } => {
                        write!(out, "{}", style("&").green())?;
                        ConsoleFormat::format(lifetime, out)?;
                        write!(out, " {}", style("mut").green())?
                    }
                    _ => unreachable!(),
                };

                if self.is_array() || self.is_cell() {
                    if self.is_own() {
                        write!(out, "<")?;
                    } else {
                        write!(out, " ")?;
                    }
                }

                if self.is_array() {
                    write!(out, "[")?;
                }

                if self.is_cell() {
                    write!(out, "{}", style("Cell").green())?;
                }

                if self.is_array() {
                    write!(out, "]")?;
                }

                if self.is_own() && (self.is_array() || self.is_cell()) {
                    write!(out, ">")?;
                }

                Ok(())
            }
            Self::Unknown => write!(out, "{}", style("unknown").green()),
            Self::Struct { kind, lifetimes } => {
                write!(out, "{}(", style("struct").green())?;
                ConsoleFormat::format(kind.as_str(), out)?;
                write!(out, ")")?;
                if !lifetimes.is_empty() {
                    ConsoleFormat::format(lifetimes.as_slice(), out)?;
                }
                Ok(())
            }
        }
    }
}

impl ConsoleFormatType for RTypeFrag {
    fn is_base(&self) -> bool {
        !self.is_ptr()
    }

    fn format_with_inner(
        &self,
        out: &mut dyn Write,
        inner: &dyn Fn(&mut dyn Write) -> Result<()>,
    ) -> Result<()> {
        assert!(!ConsoleFormatType::is_base(self));
        match self {
            Self::Ghost { array: _, cell: _ } => {
                write!(out, "{}<", style("ghost").green())?;
            }
            Self::Box { array: _, cell: _ } => {
                write!(out, "{}<", style("Box").green())?;
            }
            Self::Rc { array: _, cell: _ } => {
                write!(out, "{}<", style("Rc").green())?;
            }
            Self::Shared {
                array: _,
                cell: _,
                lifetime,
            } => {
                write!(out, "{}", style("&").green())?;
                ConsoleFormat::format(lifetime, out)?;
                write!(out, " ")?;
            }
            Self::Mut {
                array: _,
                cell: _,
                lifetime,
            } => {
                write!(out, "{}", style("&").green())?;
                ConsoleFormat::format(lifetime, out)?;
                write!(out, " {} ", style("mut").green())?;
            }
            _ => unreachable!(),
        }

        if self.is_array() {
            write!(out, "[")?;
        }

        if self.is_cell() {
            write!(out, "{}<", style("Cell").green())?;
        }

        inner(out)?;

        if self.is_cell() {
            write!(out, ">")?;
        }

        if self.is_array() {
            write!(out, "]")?;
        }

        match self {
            Self::Ghost { array: _, cell: _ }
            | Self::Box { array: _, cell: _ }
            | Self::Rc { array: _, cell: _ } => {
                write!(out, ">")?;
            }
            Self::Shared { .. } => (),
            Self::Mut { .. } => (),
            _ => unreachable!(),
        }

        Ok(())
    }
}

impl<T: TypeFrag> ConsoleFormat for [&T] {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        assert!(!self.is_empty());
        if ConsoleFormatType::is_base(self) {
            ConsoleFormat::format(self[0], out)
        } else {
            ConsoleFormatType::format_with_inner(self, out, &|out| {
                ConsoleFormat::format(&self[1..], out)
            })
        }
    }
}

impl<T: TypeFrag> ConsoleFormatType for [&T] {
    fn is_base(&self) -> bool {
        assert!(!self.is_empty());
        ConsoleFormatType::is_base(self[0])
    }

    fn format_with_inner(
        &self,
        out: &mut dyn Write,
        inner: &dyn Fn(&mut dyn Write) -> Result<()>,
    ) -> Result<()> {
        assert!(!self.is_empty());
        assert!(!ConsoleFormatType::is_base(self));
        ConsoleFormatType::format_with_inner(self[0], out, inner)
    }
}

impl<T: TypeFrag> ConsoleFormat for [(&TypeLab, &T)] {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        assert!(!self.is_empty());
        write!(out, "{}", style("[").dim())?;
        if ConsoleFormatType::is_base(self) {
            ConsoleFormat::format(self[0].1, out)?;
        } else {
            ConsoleFormatType::format_with_inner(self, out, &|out| {
                ConsoleFormat::format(&self[1..], out)
            })?;
        }
        write!(
            out,
            "{}{}",
            style("]").dim(),
            style(self[0].0.0.superscript()).dim()
        )
    }
}

impl<T: TypeFrag> ConsoleFormatType for [(&TypeLab, &T)] {
    fn is_base(&self) -> bool {
        assert!(!self.is_empty());
        ConsoleFormatType::is_base(self[0].1)
    }

    fn format_with_inner(
        &self,
        out: &mut dyn Write,
        inner: &dyn Fn(&mut dyn Write) -> Result<()>,
    ) -> Result<()> {
        assert!(!self.is_empty());
        assert!(!ConsoleFormatType::is_base(self));
        ConsoleFormatType::format_with_inner(self[0].1, out, inner)
    }
}

/// Types that implement `TexFormatType` can be used as the types that appear in
/// program fragments that are `TexFormat`.
pub trait TexFormatType: TexFormat {
    /// Returns `true` if `self` is not a base type, i.e. this type is contains
    /// another type.
    fn is_base(&self) -> bool;

    /// Writes `self` to `out` in a suitable format, using `inner` to write the
    /// inner type to `out`.
    ///
    /// # Panics
    /// - If this operation is unsupported for this the type of `self`.
    /// - If `is_base(&self)`.
    fn format_with_inner(
        &self,
        out: &mut dyn Write,
        inner: &dyn Fn(&mut dyn Write) -> Result<()>,
    ) -> Result<()>;
}

impl TexFormat for STypeFrag {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        match self {
            Self::Void => write!(out, "\\sty{{void}}"),
            Self::Bool => write!(out, "\\sty{{bool}}"),
            Self::Int8 => write!(out, "\\sty{{i8}}"),
            Self::Int16 => write!(out, "\\sty{{i16}}"),
            Self::Int32 => write!(out, "\\sty{{i32}}"),
            Self::Int64 => write!(out, "\\sty{{i64}}"),
            Self::Float32 => write!(out, "\\sty{{f32}}"),
            Self::Float64 => write!(out, "\\sty{{f64}}"),
            Self::Pointer => write!(out, "\\sty{{ptr}}"),
            Self::Struct(s) => {
                write!(out, "\\sty{{struct}}(")?;
                TexFormat::format(s.as_str(), out)?;
                write!(out, ")")
            }
            Self::Unknown => write!(out, "\\sty{{unknown}}"),
        }
    }
}

impl TexFormatType for STypeFrag {
    fn is_base(&self) -> bool {
        ConsoleFormatType::is_base(self)
    }

    fn format_with_inner(
        &self,
        out: &mut dyn Write,
        inner: &dyn Fn(&mut dyn Write) -> Result<()>,
    ) -> Result<()> {
        assert!(!TexFormatType::is_base(self));
        TexFormat::format(self, out)?;
        write!(out, "(")?;
        inner(out)?;
        write!(out, ")")
    }
}

impl TexFormat for InterpStruct {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        TexFormat::format(self.kind.0.as_str(), out)
    }
}

impl TexFormat for Lifetime {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        match self {
            Lifetime::Variable(n) | Lifetime::Parameter(n) => write!(out, "\\lifetime{{{}}}", n),
        }
    }
}

impl TexFormat for [Lifetime] {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        let mut result = String::from("\\kw{nil}");

        let mut lifetimes = Vec::from_iter(self.iter());
        lifetimes.reverse();

        while let Some(lifetime) = lifetimes.pop() {
            let mut inner = vec![];
            TexFormat::format(lifetime, &mut inner)?;
            result = String::from("\\kw{cons}(")
                + &String::from_utf8(inner).unwrap()
                + ", "
                + &result
                + ")";
        }

        write!(out, "{}", result)
    }
}

impl TexFormat for RTypeFrag {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        match self {
            Self::Void => write!(out, "\\rty{{void}}"),
            Self::Bool => write!(out, "\\rty{{bool}}"),
            Self::Int8 => write!(out, "\\rty{{i8}}"),
            Self::Int16 => write!(out, "\\rty{{i16}}"),
            Self::Int32 => write!(out, "\\rty{{i32}}"),
            Self::Int64 => write!(out, "\\rty{{i64}}"),
            Self::Float32 => write!(out, "\\rty{{f32}}"),
            Self::Float64 => write!(out, "\\rty{{f64}}"),
            Self::Ghost { array: _, cell: _ }
            | Self::Box { array: _, cell: _ }
            | Self::Rc { array: _, cell: _ }
            | Self::Shared {
                array: _,
                cell: _,
                lifetime: _,
            }
            | Self::Mut {
                array: _,
                cell: _,
                lifetime: _,
            } => {
                match self {
                    Self::Ghost { array: _, cell: _ } => write!(out, "\\rty{{ghost}}")?,
                    Self::Box { array: _, cell: _ } => write!(out, "\\rty{{Box}}")?,
                    Self::Rc { array: _, cell: _ } => write!(out, "\\rty{{Rc}}")?,
                    Self::Shared {
                        array: _,
                        cell: _,
                        lifetime: _,
                    } => write!(out, "\\rty{{shared}}")?,
                    Self::Mut {
                        array: _,
                        cell: _,
                        lifetime: _,
                    } => write!(out, "\\rty{{mut}}")?,
                    _ => unreachable!(),
                }

                if self.is_cell() || self.is_array() {
                    write!(out, "^\\texttt{{")?;
                    if self.is_array() {
                        write!(out, "[")?;
                    }
                    if self.is_cell() {
                        write!(out, "{}", style("Cell").green())?;
                    }
                    if self.is_array() {
                        write!(out, "]")?;
                    }
                    write!(out, "}}")?;
                }

                Ok(())
            }
            Self::Unknown => write!(out, "\\rty{{unknown}}"),
            Self::Struct { kind, lifetimes } => {
                write!(out, "\\rty{{struct}}(")?;
                TexFormat::format(kind.as_str(), out)?;
                write!(out, ", ")?;
                TexFormat::format(lifetimes.as_slice(), out)?;
                write!(out, ")")
            }
        }
    }
}

impl TexFormatType for RTypeFrag {
    fn is_base(&self) -> bool {
        !self.is_ptr()
    }

    fn format_with_inner(
        &self,
        out: &mut dyn Write,
        inner: &dyn Fn(&mut dyn Write) -> Result<()>,
    ) -> Result<()> {
        assert!(!TexFormatType::is_base(self));
        match self {
            Self::Ghost { array: _, cell: _ } => {
                write!(out, "\\rty{{ghost}}")?;
            }
            Self::Box { array: _, cell: _ } => {
                write!(out, "\\rty{{Box}}")?;
            }
            Self::Rc { array: _, cell: _ } => {
                write!(out, "\\rty{{Rc}}")?;
            }
            Self::Shared {
                array: _,
                cell: _,
                lifetime: _,
            } => {
                write!(out, "\\rty{{shared}}")?;
            }
            Self::Mut {
                array: _,
                cell: _,
                lifetime: _,
            } => {
                write!(out, "\\rty{{mut}}")?;
            }
            _ => unreachable!(),
        }

        if self.is_cell() || self.is_array() {
            write!(out, "^\\texttt{{")?;
            if self.is_array() {
                write!(out, "[")?;
            }
            if self.is_cell() {
                write!(out, "{}", style("Cell").green())?;
            }
            if self.is_array() {
                write!(out, "]")?;
            }
            write!(out, "}}")?;
        }

        write!(out, "(")?;

        if self.is_ref() {
            TexFormat::format(&self.get_lifetime(), out)?;
            write!(out, ", ")?;
        }

        inner(out)?;

        write!(out, ")")
    }
}

impl<T: TypeFrag> TexFormat for [&T] {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        assert!(!self.is_empty());
        if TexFormatType::is_base(self) {
            TexFormat::format(self[0], out)
        } else {
            TexFormatType::format_with_inner(self, out, &|out| TexFormat::format(&self[1..], out))
        }
    }
}

impl<T: TypeFrag> TexFormatType for [&T] {
    fn is_base(&self) -> bool {
        ConsoleFormatType::is_base(self)
    }

    fn format_with_inner(
        &self,
        out: &mut dyn Write,
        inner: &dyn Fn(&mut dyn Write) -> Result<()>,
    ) -> Result<()> {
        assert!(!self.is_empty());
        assert!(!TexFormatType::is_base(self));
        TexFormatType::format_with_inner(self[0], out, inner)
    }
}

impl<T: TypeFrag> TexFormat for [(&TypeLab, &T)] {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        assert!(!self.is_empty());
        write!(out, "\\labeled{{{}}}{{", self[0].0.0)?;
        if TexFormatType::is_base(self) {
            TexFormat::format(self[0].1, out)?;
        } else {
            TexFormatType::format_with_inner(self, out, &|out| TexFormat::format(&self[1..], out))?;
        }
        write!(out, "}}")
    }
}

impl<T: TypeFrag> TexFormatType for [(&TypeLab, &T)] {
    fn is_base(&self) -> bool {
        ConsoleFormatType::is_base(self)
    }

    fn format_with_inner(
        &self,
        out: &mut dyn Write,
        inner: &dyn Fn(&mut dyn Write) -> Result<()>,
    ) -> Result<()> {
        assert!(!self.is_empty());
        assert!(!TexFormatType::is_base(self));
        TexFormatType::format_with_inner(self[0].1, out, inner)
    }
}
