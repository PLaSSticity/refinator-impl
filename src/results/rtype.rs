//! # Rust Types
//!
//! &inator infers Rust type fragments for each `TypeLab` in a program. In this
//! module, we define Rust type fragments.

use crate::results::lifetime::Lifetime;

// A fragment of a Rust type.
#[derive(Clone, PartialEq, Eq)]
pub enum RTypeFrag {
    Void,
    Bool,
    Int8,
    Int16,
    Int32,
    Int64,
    Float32,
    Float64,
    Ghost {
        array: bool,
        cell: bool,
    },
    Box {
        array: bool,
        cell: bool,
    },
    Rc {
        array: bool,
        cell: bool,
    },
    Shared {
        array: bool,
        cell: bool,
        lifetime: Lifetime,
    },
    Mut {
        array: bool,
        cell: bool,
        lifetime: Lifetime,
    },
    Unknown,
    Struct {
        kind: String,
        lifetimes: Vec<Lifetime>,
    },
}

impl RTypeFrag {
    /// Checks if `self` is a `own` variant.
    pub fn is_own(&self) -> bool {
        matches!(
            self,
            Self::Ghost { .. } | Self::Box { .. } | Self::Rc { .. }
        )
    }

    /// Checks if `self` is a `ref` variant.
    pub fn is_ref(&self) -> bool {
        matches!(self, Self::Shared { .. } | Self::Mut { .. })
    }

    /// Checks if `self` is a `ptr` variant.
    pub fn is_ptr(&self) -> bool {
        self.is_own() || self.is_ref()
    }

    /// Checks if `self` is a `struct` variant.
    pub fn is_struct(&self) -> bool {
        matches!(self, Self::Struct { .. })
    }

    /// Checks if `self` is a `unknown` variant.
    pub fn is_unknown(&self) -> bool {
        matches!(self, Self::Unknown)
    }

    /// Checks if `self` has an array qualifier.
    pub fn is_array(&self) -> bool {
        match self {
            Self::Void => false,
            Self::Bool => false,
            Self::Int8 => false,
            Self::Int16 => false,
            Self::Int32 => false,
            Self::Int64 => false,
            Self::Float32 => false,
            Self::Float64 => false,
            Self::Ghost { array, cell: _ } => *array,
            Self::Box { array, cell: _ } => *array,
            Self::Rc { array, cell: _ } => *array,
            Self::Shared {
                array,
                cell: _,
                lifetime: _,
            } => *array,
            Self::Mut {
                array,
                cell: _,
                lifetime: _,
            } => *array,
            Self::Unknown => false,
            Self::Struct {
                kind: _,
                lifetimes: _,
            } => false,
        }
    }

    /// Checks if `self` has a `Cell` qualifier.
    pub fn is_cell(&self) -> bool {
        match self {
            Self::Void => false,
            Self::Bool => false,
            Self::Int8 => false,
            Self::Int16 => false,
            Self::Int32 => false,
            Self::Int64 => false,
            Self::Float32 => false,
            Self::Float64 => false,
            Self::Ghost { array: _, cell } => *cell,
            Self::Box { array: _, cell } => *cell,
            Self::Rc { array: _, cell } => *cell,
            Self::Shared {
                array: _,
                cell,
                lifetime: _,
            } => *cell,
            Self::Mut {
                array: _,
                cell,
                lifetime: _,
            } => *cell,
            Self::Unknown => false,
            Self::Struct {
                kind: _,
                lifetimes: _,
            } => false,
        }
    }

    /// Retrieves the lifetime of `self`, if `self` is a `ref` variant.
    pub fn try_lifetime(&self) -> Option<Lifetime> {
        match self {
            Self::Void => None,
            Self::Bool => None,
            Self::Int8 => None,
            Self::Int16 => None,
            Self::Int32 => None,
            Self::Int64 => None,
            Self::Float32 => None,
            Self::Float64 => None,
            Self::Ghost { array: _, cell: _ } => None,
            Self::Box { array: _, cell: _ } => None,
            Self::Rc { array: _, cell: _ } => None,
            Self::Shared {
                array: _,
                cell: _,
                lifetime,
            } => Some(*lifetime),
            Self::Mut {
                array: _,
                cell: _,
                lifetime,
            } => Some(*lifetime),
            Self::Unknown => None,
            Self::Struct {
                kind: _,
                lifetimes: _,
            } => None,
        }
    }

    /// Retrieves the lifetime of `self`, where `self` is a `ref` variant.
    ///
    /// # Panics
    /// - if `self` is not a `ref` variant.
    pub fn get_lifetime(&self) -> Lifetime {
        self.try_lifetime().expect("`self` is a `ref` variant.")
    }

    /// Retrieves the lifetimes of `self`, if `self` is a `struct` variant.
    pub fn try_lifetimes(&self) -> Option<&[Lifetime]> {
        match self {
            Self::Void => None,
            Self::Bool => None,
            Self::Int8 => None,
            Self::Int16 => None,
            Self::Int32 => None,
            Self::Int64 => None,
            Self::Float32 => None,
            Self::Float64 => None,
            Self::Ghost { array: _, cell: _ } => None,
            Self::Box { array: _, cell: _ } => None,
            Self::Rc { array: _, cell: _ } => None,
            Self::Shared {
                array: _,
                cell: _,
                lifetime: _,
            } => None,
            Self::Mut {
                array: _,
                cell: _,
                lifetime: _,
            } => None,
            Self::Unknown => None,
            Self::Struct { kind: _, lifetimes } => Some(lifetimes),
        }
    }

    /// Retrieves the lifetime of `self`, where `self` is a `struct` variant.
    ///
    /// # Panics
    /// - if `self` is not a `struct` variant.
    pub fn get_lifetimes(&self) -> &[Lifetime] {
        self.try_lifetimes().expect("`self` is a `struct` variant.")
    }
}
