//! # Function Display Formatting
//!
//! This module contains logic to format a function representation (with types)
//! in human (or machine)-readable format.

use std::io::{Result, Write};

use console::style;

use crate::{
    analysis::{control_flow::ControlFlowGraph, drop::DropAnalysis, live_variables::LiveVariables},
    format::{ConsoleFormat, TexFormat, instruction::InstructionWithContext, types::TypeFrag},
    lang::{function::Function, stype::TypeLab, variable::VarIdent},
};

/// A `Function` bundled with additional information needed to print it in
/// human-readable format with type labels.
pub struct FunctionWithContext<'a, T: TypeFrag> {
    pub function: &'a Function<'a>,
    pub var_name_map: &'a dyn Fn(VarIdent) -> &'a str,
    pub var_type_map: &'a dyn Fn(VarIdent) -> &'a [(&'a TypeLab, &'a T)],
    pub type_map: &'a dyn Fn(TypeLab) -> &'a T,
}

impl<T: TypeFrag> ConsoleFormat for FunctionWithContext<'_, T> {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        // Return value
        let mut pairs = vec![];
        for typelab in &self.function.ret_typelabs {
            pairs.push((typelab, (self.type_map)(*typelab)));
        }
        ConsoleFormat::format(pairs.as_slice(), out)?;

        write!(out, " {}(", self.function.id)?;
        if !self.function.param_vars.is_empty() {
            writeln!(out)?;
        }
        for param in &self.function.param_vars {
            write!(out, "    ")?;
            ConsoleFormat::format((self.var_type_map)(*param), out)?;
            writeln!(out, " {}, ", (self.var_name_map)(*param))?;
        }
        write!(out, ")")?;

        if self.function.basic_blocks.is_empty() {
            write!(out, ";")
        } else {
            // TODO: Put this (inferred drop printing) in a proper location.
            let cfg = ControlFlowGraph::construct(self.function);
            let lv = LiveVariables::analyze(&cfg);
            let drops = DropAnalysis::analyze(self.function, &cfg, &lv);

            writeln!(out, " {{")?;
            for basic_block in &self.function.basic_blocks {
                // TODO: Put this (inferred drop printing) in a proper location.
                writeln!(out, "    {}:", basic_block.id.0)?;
                if !drops.interior_drops(basic_block.id).is_empty() {
                    write!(out, "    {}{}", style("DROP").bold(), style("("))?;
                    for var in drops.interior_drops(basic_block.id) {
                        ConsoleFormat::format((self.var_name_map)(*var), out)?;
                        write!(out, ", ")?;
                    }
                    writeln!(out, "{}", style(");"))?;
                }

                for instr in &basic_block.instructions {
                    write!(out, "    ")?;
                    ConsoleFormat::format(
                        &InstructionWithContext {
                            instr,
                            var_name_map: self.var_name_map,
                            var_type_map: self.var_type_map,
                            type_map: self.type_map,
                        },
                        out,
                    )?;
                    writeln!(out)?;
                }
            }

            // TODO: Put this (inferred drop printing) in a proper location.
            if !drops.exit_drops().is_empty() {
                write!(out, "    {}{}", style("DROP").bold(), style("("))?;
                for var in drops.exit_drops() {
                    ConsoleFormat::format((self.var_name_map)(*var), out)?;
                    write!(out, ", ")?;
                }
                writeln!(out, "{}", style(");"))?;
            }

            write!(out, "}}")
        }
    }
}

impl<T: TypeFrag> TexFormat for FunctionWithContext<'_, T> {
    fn format(&self, out: &mut dyn Write) -> Result<()> {
        // Return value
        let mut pairs = vec![];
        for typelab in &self.function.ret_typelabs {
            pairs.push((typelab, (self.type_map)(*typelab)));
        }
        TexFormat::format(pairs.as_slice(), out)?;
        write!(out, " ")?;

        TexFormat::format(self.function.id.0.as_str(), out)?;
        write!(out, "(")?;
        for param in &self.function.param_vars {
            TexFormat::format((self.var_type_map)(*param), out)?;
            write!(out, " ")?;
            TexFormat::format((self.var_name_map)(*param), out)?;
            write!(out, ", ")?;
        }
        write!(out, ")")?;

        if self.function.basic_blocks.is_empty() {
            write!(out, ";")
        } else {
            // TODO: Put this (inferred drop printing) in a proper location.
            let cfg = ControlFlowGraph::construct(self.function);
            let lv = LiveVariables::analyze(&cfg);
            let drops = DropAnalysis::analyze(self.function, &cfg, &lv);

            writeln!(out, " \\{{\\\\")?;
            for basic_block in &self.function.basic_blocks {
                // TODO: Put this (inferred drop printing) in a proper location.
                writeln!(
                    out,
                    "\\hspace*{{1em}}{}:\\\\",
                    basic_block.instructions[0].id().0
                )?;
                if !drops.interior_drops(basic_block.id).is_empty() {
                    write!(out, "\\hspace*{{1em}}\\kw{{DROP}}(",)?;
                    for var in drops.interior_drops(basic_block.id) {
                        TexFormat::format((self.var_name_map)(*var), out)?;
                        write!(out, ", ")?;
                    }
                    writeln!(out, ")\\\\")?;
                }

                for instr in &basic_block.instructions {
                    write!(out, "\\hspace*{{1em}}")?;
                    TexFormat::format(
                        &InstructionWithContext {
                            instr,
                            var_name_map: self.var_name_map,
                            var_type_map: self.var_type_map,
                            type_map: self.type_map,
                        },
                        out,
                    )?;
                    writeln!(out, "\\\\")?;
                }
            }

            // TODO: Put this (inferred drop printing) in a proper location.
            if !drops.exit_drops().is_empty() {
                write!(out, "\\hspace*{{1em}}\\kw{{DROP}}(",)?;
                for var in drops.exit_drops() {
                    TexFormat::format((self.var_name_map)(*var), out)?;
                    write!(out, ", ")?;
                }
                writeln!(out, ")\\\\")?;
            }

            write!(out, "\\}}")
        }
    }
}
