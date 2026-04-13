//! # Instruction Display Formatting
//!
//! This module contains logic to format an instruction representation
//! (with types) in human (or machine)-readable format.

use std::io::{Result, Write};

use console::style;

use crate::{
    format::{
        ConsoleFormat, Superscript, TexFormat, const_expr, tex_const_expr, tex_unimplemented,
        types::TypeFrag, unimplemented,
    },
    lang::{instruction::Instruction, stype::TypeLab, variable::VarIdent},
};

/// Display text for `unreachable` instructions.
fn unreachable(out: &mut dyn Write) -> Result<()> {
    write!(
        out,
        "{}{}{}",
        style("(").dim(),
        style("unreachable").italic().dim(),
        style(")").dim()
    )
}

/// An `Instruction` bundled with additional information needed to print it in
/// human-readable format with type labels.
pub struct InstructionWithContext<'a, T: TypeFrag> {
    pub instr: &'a Instruction<'a>,
    pub var_name_map: &'a dyn Fn(VarIdent) -> &'a str,
    pub var_type_map: &'a dyn Fn(VarIdent) -> &'a [(&'a TypeLab, &'a T)],
    pub type_map: &'a dyn Fn(TypeLab) -> &'a T,
}

impl<T: TypeFrag> ConsoleFormat for InstructionWithContext<'_, T> {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        match self.instr {
            Instruction::Alloca { lhs_var, .. } => {
                ConsoleFormat::format((self.var_type_map)(*lhs_var), out)?;
                write!(out, " ")?;
                ConsoleFormat::format((self.var_name_map)(*lhs_var), out)?;
                write!(out, " = {}(⋯);", style("alloca").bold())
            }
            Instruction::Load {
                lhs_var,
                rhs_var,
                rhs_typelab,
                ..
            } => {
                ConsoleFormat::format((self.var_type_map)(*lhs_var), out)?;
                write!(out, " ")?;
                ConsoleFormat::format((self.var_name_map)(*lhs_var), out)?;
                write!(out, " = {}*", style("[").dim())?;
                ConsoleFormat::format((self.var_name_map)(*rhs_var), out)?;
                write!(
                    out,
                    "{}{} {} ",
                    style("]").dim(),
                    style(rhs_typelab.0.superscript()).dim(),
                    style("=>").dim()
                )?;
                ConsoleFormat::format((self.type_map)(*rhs_typelab), out)?;
                write!(out, ";")
            }
            Instruction::Store {
                lhs_var,
                rhs_var,
                rhs_typelab,
                ..
            } => {
                write!(out, "*")?;
                ConsoleFormat::format((self.var_name_map)(*lhs_var), out)?;
                write!(out, " = {}", style("[").dim())?;
                if let Some(rhs_var) = rhs_var {
                    ConsoleFormat::format((self.var_name_map)(*rhs_var), out)?;
                } else {
                    const_expr(out)?;
                }
                write!(
                    out,
                    "{}{} {} ",
                    style("]").dim(),
                    style(rhs_typelab.0.superscript()).dim(),
                    style("=>").dim()
                )?;
                ConsoleFormat::format((self.type_map)(*rhs_typelab), out)?;
                write!(out, ";")
            }
            Instruction::Field {
                lhs_var,
                rhs_var,
                field_idx,
                rhs_typelab,
                ..
            } => {
                ConsoleFormat::format((self.var_type_map)(*lhs_var), out)?;
                write!(out, " ")?;
                ConsoleFormat::format((self.var_name_map)(*lhs_var), out)?;
                write!(out, " = {}&*(*", style("[").dim())?;
                ConsoleFormat::format((self.var_name_map)(*rhs_var), out)?;
                write!(
                    out,
                    ").{}{}{} {} ",
                    field_idx,
                    style("]").dim(),
                    style(rhs_typelab.0.superscript()).dim(),
                    style("=>").dim()
                )?;
                ConsoleFormat::format((self.type_map)(*rhs_typelab), out)?;
                write!(out, ";")
            }
            Instruction::Element {
                lhs_var,
                rhs_var,
                elem_var,
                rhs_typelab,
                ..
            } => {
                ConsoleFormat::format((self.var_type_map)(*lhs_var), out)?;
                write!(out, " ")?;
                ConsoleFormat::format((self.var_name_map)(*lhs_var), out)?;
                write!(out, " = {}&", style("[").dim())?;
                ConsoleFormat::format((self.var_name_map)(*rhs_var), out)?;
                write!(out, "[",)?;
                if let Some(elem_var) = elem_var {
                    ConsoleFormat::format((self.var_name_map)(*elem_var), out)?;
                } else {
                    const_expr(out)?;
                }
                write!(
                    out,
                    "]{}{} {} ",
                    style("]").dim(),
                    style(rhs_typelab.0.superscript()).dim(),
                    style("=>").dim()
                )?;
                ConsoleFormat::format((self.type_map)(*rhs_typelab), out)?;
                write!(out, ";")
            }
            Instruction::Call {
                lhs_var,
                callee,
                arg_vars,
                arg_typelabs,
                ..
            } => {
                if let Some(lhs_var) = lhs_var {
                    ConsoleFormat::format((self.var_type_map)(*lhs_var), out)?;
                    write!(out, " ")?;
                    ConsoleFormat::format((self.var_name_map)(*lhs_var), out)?;
                    write!(out, " = ")?;
                }
                write!(out, "{}(", callee)?;
                for (var, typelab) in arg_vars.iter().zip(arg_typelabs.iter()) {
                    write!(out, "{}", style("[").dim())?;
                    if let Some(var) = var {
                        ConsoleFormat::format((self.var_name_map)(*var), out)?;
                    } else {
                        const_expr(out)?;
                    }
                    write!(
                        out,
                        "{}{} {} ",
                        style("]").dim(),
                        style(typelab.0.superscript()).dim(),
                        style("=>").dim()
                    )?;
                    ConsoleFormat::format((self.type_map)(*typelab), out)?;
                    write!(out, ", ")?;
                }
                write!(out, ");")
            }
            Instruction::Use {
                lhs_var,
                operand_vars,
                operand_typelabs,
                ..
            } => {
                if let Some(lhs_var) = lhs_var {
                    ConsoleFormat::format((self.var_type_map)(*lhs_var), out)?;
                    write!(out, " ")?;
                    ConsoleFormat::format((self.var_name_map)(*lhs_var), out)?;
                    write!(out, " = ")?;
                }
                write!(out, "{}(", style("use").bold())?;
                for (var, typelab) in operand_vars.iter().zip(operand_typelabs.iter()) {
                    write!(out, "{}", style("[").dim())?;
                    if let Some(var) = var {
                        ConsoleFormat::format((self.var_name_map)(*var), out)?;
                    } else {
                        const_expr(out)?;
                    }
                    write!(
                        out,
                        "{}{} {} ",
                        style("]").dim(),
                        style(typelab.0.superscript()).dim(),
                        style("=>").dim()
                    )?;
                    ConsoleFormat::format((self.type_map)(*typelab), out)?;
                    write!(out, ", ")?;
                }
                write!(out, ");")
            }
            Instruction::Phi {
                lhs_var,
                operand_vars,
                operand_typelabs,
                ..
            } => {
                ConsoleFormat::format((self.var_type_map)(*lhs_var), out)?;
                write!(out, " ")?;
                ConsoleFormat::format((self.var_name_map)(*lhs_var), out)?;
                write!(out, " = ")?;
                write!(out, "{}(", style("phi").bold())?;
                for (var, typelab) in operand_vars.iter().zip(operand_typelabs.iter()) {
                    write!(out, "{}", style("[").dim())?;
                    if let Some(var) = var {
                        ConsoleFormat::format((self.var_name_map)(*var), out)?;
                    } else {
                        const_expr(out)?;
                    }
                    write!(
                        out,
                        "{}{} {} ",
                        style("]").dim(),
                        style(typelab.0.superscript()).dim(),
                        style("=>").dim()
                    )?;
                    ConsoleFormat::format((self.type_map)(*typelab), out)?;
                    write!(out, ": ")?;
                    unimplemented(out)?;
                    write!(out, ", ")?;
                }
                write!(out, ");")
            }
            Instruction::CondBr {
                cond_var,
                cond_typelab,
                then_target,
                else_target,
                ..
            } => {
                write!(out, "{} ({}", style("if").bold(), style("[").dim())?;
                if let Some(cond_var) = cond_var {
                    ConsoleFormat::format((self.var_name_map)(*cond_var), out)?;
                } else {
                    const_expr(out)?;
                }
                write!(
                    out,
                    "{}{} {} ",
                    style("]").dim(),
                    style(cond_typelab.0.superscript()).dim(),
                    style("=>").dim()
                )?;
                ConsoleFormat::format((self.type_map)(*cond_typelab), out)?;
                write!(
                    out,
                    ") {} {}; {} {} {};",
                    style("goto").bold(),
                    then_target.0,
                    style("else").bold(),
                    style("goto").bold(),
                    else_target.0,
                )
            }
            Instruction::Br { target, .. } => {
                write!(out, "{} {};", style("goto").bold(), target.0)
            }
            Instruction::Ret {
                rhs_var,
                rhs_typelab,
                ..
            } => {
                write!(out, "{} {}", style("return").bold(), style("[").dim())?;
                if let Some(rhs_var) = rhs_var {
                    ConsoleFormat::format((self.var_name_map)(*rhs_var), out)?;
                } else {
                    const_expr(out)?;
                }
                write!(
                    out,
                    "{}{} {} ",
                    style("]").dim(),
                    style(rhs_typelab.0.superscript()).dim(),
                    style("=>").dim()
                )?;
                ConsoleFormat::format((self.type_map)(*rhs_typelab), out)?;
                write!(out, ";")
            }
            Instruction::Switch {
                cond_var,
                cond_typelab,
                targets,
                ..
            } => {
                write!(out, "{} {}", style("switch").bold(), style("[").dim())?;
                if let Some(cond_var) = cond_var {
                    ConsoleFormat::format((self.var_name_map)(*cond_var), out)?;
                } else {
                    const_expr(out)?;
                }
                write!(
                    out,
                    "{}{} {} ",
                    style("]").dim(),
                    style(cond_typelab.0.superscript()).dim(),
                    style("=>").dim()
                )?;
                ConsoleFormat::format((self.type_map)(*cond_typelab), out)?;
                writeln!(out, " {{")?;
                for target in targets {
                    write!(out, "        {} ", style("case").bold())?;
                    unimplemented(out)?;
                    writeln!(out, ": {} {};", style("goto").bold(), target.0)?;
                }
                write!(out, "    }}")
            }
            Instruction::Unreachable { .. } => unreachable(out),
        }
    }
}

impl<T: TypeFrag> TexFormat for InstructionWithContext<'_, T> {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        match self.instr {
            Instruction::Alloca { lhs_var, .. } => {
                TexFormat::format((self.var_type_map)(*lhs_var), out)?;
                write!(out, " ")?;
                TexFormat::format((self.var_name_map)(*lhs_var), out)?;
                write!(out, " = \\kw{{alloca}}($\\cdots$);")
            }
            Instruction::Load {
                lhs_var,
                rhs_var,
                rhs_typelab,
                ..
            } => {
                TexFormat::format((self.var_type_map)(*lhs_var), out)?;
                write!(out, " ")?;
                TexFormat::format((self.var_name_map)(*lhs_var), out)?;
                write!(out, " = \\labeled{{{}}}{{*", rhs_typelab.0)?;
                TexFormat::format((self.var_name_map)(*rhs_var), out)?;
                write!(out, "}}{{\\color{{gray}}: ")?;
                TexFormat::format((self.type_map)(*rhs_typelab), out)?;
                write!(out, "}};")
            }
            Instruction::Store {
                lhs_var,
                rhs_var,
                rhs_typelab,
                ..
            } => {
                write!(out, "*")?;
                TexFormat::format((self.var_name_map)(*lhs_var), out)?;
                write!(out, " = \\labeled{{{}}}{{", rhs_typelab.0)?;
                if let Some(rhs_var) = rhs_var {
                    TexFormat::format((self.var_name_map)(*rhs_var), out)?;
                } else {
                    tex_const_expr(out)?;
                }
                write!(out, "}}{{\\color{{gray}}: ")?;
                TexFormat::format((self.type_map)(*rhs_typelab), out)?;
                write!(out, "}};")
            }
            Instruction::Field {
                lhs_var,
                rhs_var,
                field_idx,
                rhs_typelab,
                ..
            } => {
                TexFormat::format((self.var_type_map)(*lhs_var), out)?;
                write!(out, " ")?;
                TexFormat::format((self.var_name_map)(*lhs_var), out)?;
                write!(out, " = \\labeled{{{}}}{{\\&(*", rhs_typelab.0)?;
                TexFormat::format((self.var_name_map)(*rhs_var), out)?;
                write!(out, ").{}}}{{\\color{{gray}}: ", field_idx)?;
                TexFormat::format((self.type_map)(*rhs_typelab), out)?;
                write!(out, "}};")
            }
            Instruction::Element {
                lhs_var,
                rhs_var,
                elem_var,
                rhs_typelab,
                ..
            } => {
                TexFormat::format((self.var_type_map)(*lhs_var), out)?;
                write!(out, " ")?;
                TexFormat::format((self.var_name_map)(*lhs_var), out)?;
                write!(out, " = \\labeled{{{}}}{{\\&", rhs_typelab.0)?;
                TexFormat::format((self.var_name_map)(*rhs_var), out)?;
                write!(out, "[",)?;
                if let Some(elem_var) = elem_var {
                    TexFormat::format((self.var_name_map)(*elem_var), out)?;
                } else {
                    tex_const_expr(out)?;
                }
                write!(out, "]}}{{\\color{{gray}}: ")?;
                TexFormat::format((self.type_map)(*rhs_typelab), out)?;
                write!(out, "}};")
            }
            Instruction::Call {
                lhs_var,
                callee,
                arg_vars,
                arg_typelabs,
                ..
            } => {
                if let Some(lhs_var) = lhs_var {
                    TexFormat::format((self.var_type_map)(*lhs_var), out)?;
                    write!(out, " ")?;
                    TexFormat::format((self.var_name_map)(*lhs_var), out)?;
                    write!(out, " = ")?;
                }
                write!(out, "\\detokenize{{{}}}(", callee)?;
                for (var, typelab) in arg_vars.iter().zip(arg_typelabs.iter()) {
                    write!(out, "\\labeled{{{}}}{{", typelab.0)?;
                    if let Some(var) = var {
                        TexFormat::format((self.var_name_map)(*var), out)?;
                    } else {
                        tex_const_expr(out)?;
                    }
                    write!(out, "}}{{\\color{{gray}}: ")?;
                    TexFormat::format((self.type_map)(*typelab), out)?;
                    write!(out, "}}, ")?;
                }
                write!(out, ");")
            }
            Instruction::Use {
                lhs_var,
                operand_vars,
                operand_typelabs,
                ..
            } => {
                if let Some(lhs_var) = lhs_var {
                    TexFormat::format((self.var_type_map)(*lhs_var), out)?;
                    write!(out, " ")?;
                    TexFormat::format((self.var_name_map)(*lhs_var), out)?;
                    write!(out, " = ")?;
                }
                write!(out, "\\kw{{use}}(")?;
                for (var, typelab) in operand_vars.iter().zip(operand_typelabs.iter()) {
                    write!(out, "\\labeled{{{}}}{{", typelab.0)?;
                    if let Some(var) = var {
                        TexFormat::format((self.var_name_map)(*var), out)?;
                    } else {
                        tex_const_expr(out)?;
                    }
                    write!(out, "}}{{\\color{{gray}}: ")?;
                    TexFormat::format((self.type_map)(*typelab), out)?;
                    write!(out, "}}, ")?;
                }
                write!(out, ");")
            }
            Instruction::Phi {
                lhs_var,
                operand_vars,
                operand_typelabs,
                ..
            } => {
                TexFormat::format((self.var_type_map)(*lhs_var), out)?;
                write!(out, " ")?;
                TexFormat::format((self.var_name_map)(*lhs_var), out)?;
                write!(out, " = ")?;
                write!(out, "\\kw{{phi}}(")?;
                for (var, typelab) in operand_vars.iter().zip(operand_typelabs.iter()) {
                    write!(out, "\\labeled{{{}}}{{", typelab.0)?;
                    if let Some(var) = var {
                        TexFormat::format((self.var_name_map)(*var), out)?;
                    } else {
                        tex_const_expr(out)?;
                    }
                    write!(out, "}}{{\\color{{gray}}: ")?;
                    TexFormat::format((self.type_map)(*typelab), out)?;
                    write!(out, "}}: ")?;
                    tex_unimplemented(out)?;
                    write!(out, ", ")?;
                }
                write!(out, ");")
            }
            Instruction::CondBr {
                cond_var,
                cond_typelab,
                then_target,
                else_target,
                ..
            } => {
                write!(out, "\\kw{{if}} (\\labeled{{{}}}{{", cond_typelab.0)?;
                if let Some(cond_var) = cond_var {
                    TexFormat::format((self.var_name_map)(*cond_var), out)?;
                } else {
                    tex_const_expr(out)?;
                }
                write!(out, "}}{{\\color{{gray}}: ")?;
                TexFormat::format((self.type_map)(*cond_typelab), out)?;
                write!(
                    out,
                    "}}) \\kw{{goto}} {}; \\kw{{else}} \\kw{{goto}} {};",
                    then_target.0, else_target.0,
                )
            }
            Instruction::Br { target, .. } => {
                write!(out, "\\kw{{goto}} {};", target.0)
            }
            Instruction::Ret {
                rhs_var,
                rhs_typelab,
                ..
            } => {
                write!(out, "\\kw{{return}} \\labeled{{{}}}{{", rhs_typelab.0)?;
                if let Some(rhs_var) = rhs_var {
                    TexFormat::format((self.var_name_map)(*rhs_var), out)?;
                } else {
                    tex_const_expr(out)?;
                }
                write!(out, "}}{{\\color{{gray}}: ")?;
                TexFormat::format((self.type_map)(*rhs_typelab), out)?;
                write!(out, "}};")
            }
            Instruction::Switch {
                cond_var,
                cond_typelab,
                targets,
                ..
            } => {
                write!(out, "\\kw{{switch}} \\labeled{{{}}}{{", cond_typelab.0)?;
                if let Some(cond_var) = cond_var {
                    TexFormat::format((self.var_name_map)(*cond_var), out)?;
                } else {
                    tex_const_expr(out)?;
                }
                write!(out, "}}{{\\color{{gray}}: ")?;
                TexFormat::format((self.type_map)(*cond_typelab), out)?;
                writeln!(out, "}} \\{{\\\\")?;
                for target in targets {
                    write!(out, "\\hspace*{{2em}}\\kw{{case}} ")?;
                    tex_unimplemented(out)?;
                    writeln!(out, ": \\kw{{goto}} {};", target.0)?;
                }
                write!(out, "\\hspace*{{1em}}\\}}")
            }
            Instruction::Unreachable { .. } => write!(out, "\\kw{{unreachable}}"),
        }
    }
}
