use std::{
    cell::Cell,
    cmp::Ordering,
    ffi::{CStr, CString},
    ops::{Add, AddAssign, Deref, Index, Sub, SubAssign},
    rc::Rc,
};

/* Convenient definitions --------------------------------------------------- */

/// Creates a boxed slice of length `len`, where each element is the result of
/// `T::default()`.
fn new_boxed_slice<T: Default>(len: usize) -> Box<[T]> {
    let mut v = Vec::new();
    v.resize_with(len, T::default);
    v.into_boxed_slice()
}

/// Unified interface to copy out of both `T` and `Cell<T>`.
trait InnerCopy<T: Copy> {
    /// Copies the `T` in `self`.
    fn copy(&self) -> T;
}

impl<T: Copy> InnerCopy<T> for Cell<T> {
    fn copy(&self) -> T {
        self.get()
    }
}

impl<T: Copy> InnerCopy<T> for T {
    fn copy(&self) -> T {
        *self
    }
}

/// Copies `n` `u8`s from `src` into `dst`.
fn cell_slice_memcpy<T: InnerCopy<u8>>(dst: &[Cell<u8>], src: &[T], n: usize) {
    for i in 0..n {
        dst[i].set(src[i].copy());
    }
}

/// Converts a `&[Cell<u8>]` into a `CString`.
fn cell_slice_as_cstring(s: &[Cell<u8>]) -> CString {
    CString::new(Vec::from_iter(s.iter().map(|c| c.get()))).unwrap()
}

/// An `Rc<[T]>` bundled with an offset into the contained slice.
///
/// Problem: we can't have `Rc`s that point into different indices of the same
/// slice. My solution is to treat `Rc<[T]>` pointers specially by bundling
/// together an index, not unlike what we did to manually remove partial
/// aliasing.
#[derive(Default, Clone)]
pub struct RcSlice<T: Default> {
    ptr: Rc<[T]>,
    offset: usize,
}

impl<T: Default> RcSlice<T> {
    pub fn new(len: usize) -> Self {
        Self {
            ptr: Rc::from(new_boxed_slice(len)),
            offset: 0,
        }
    }
}

impl<T: Default> Add<usize> for &RcSlice<T> {
    type Output = RcSlice<T>;

    fn add(self, rhs: usize) -> Self::Output {
        Self::Output {
            ptr: Rc::clone(&self.ptr),
            offset: self.offset + rhs,
        }
    }
}

impl<T: Default> Add<usize> for RcSlice<T> {
    type Output = Self;

    fn add(self, rhs: usize) -> Self::Output {
        &self + rhs
    }
}

impl<T: Default> AddAssign<usize> for RcSlice<T> {
    fn add_assign(&mut self, rhs: usize) {
        *self = &*self + rhs;
    }
}

impl<T: Default> Sub<usize> for &RcSlice<T> {
    type Output = RcSlice<T>;

    fn sub(self, rhs: usize) -> Self::Output {
        Self::Output {
            ptr: Rc::clone(&self.ptr),
            offset: self.offset - rhs,
        }
    }
}

impl<T: Default> Sub<usize> for RcSlice<T> {
    type Output = Self;

    fn sub(self, rhs: usize) -> Self::Output {
        &self - rhs
    }
}

impl<T: Default> SubAssign<usize> for RcSlice<T> {
    fn sub_assign(&mut self, rhs: usize) {
        *self = &*self - rhs;
    }
}

impl<T: Default> Deref for RcSlice<T> {
    type Target = [T];

    fn deref(&self) -> &Self::Target {
        &self.ptr[self.offset..]
    }
}

impl<T: Default> Index<usize> for RcSlice<T> {
    type Output = T;

    fn index(&self, index: usize) -> &Self::Output {
        &self.ptr[self.offset + index]
    }
}

/* Manual translation ------------------------------------------------------- */

const AMP_VERSION: u8 = 1;

#[allow(nonstandard_style)]
#[derive(Default)]
struct amp_t {
    version: i16,
    argc: i16,
    buf: RcSlice<Cell<u8>>,
}

fn read_u32_be(buf: &[Cell<u8>]) -> u32 {
    let mut n = 0;
    n |= (buf[0].get() as u32) << 24;
    n |= (buf[1].get() as u32) << 16;
    n |= (buf[2].get() as u32) << 8;
    n |= buf[3].get() as u32;
    n
}

fn write_u32_be(buf: &[Cell<u8>], n: u32) {
    buf[0].set((n >> 24 & 0xff) as u8);
    buf[1].set((n >> 16 & 0xff) as u8);
    buf[2].set((n >> 8 & 0xff) as u8);
    buf[3].set((n & 0xff) as u8);
}

fn amp_decode(msg: &mut amp_t, buf: RcSlice<Cell<u8>>) {
    msg.version = (buf[0].get() >> 4) as i16;
    msg.argc = (buf[0].get() & 0xf) as i16;
    msg.buf = buf + 1;
}

fn amp_decode_arg(msg: &mut amp_t) -> RcSlice<Cell<u8>> {
    let len = read_u32_be(&msg.buf);
    msg.buf += 4;

    let buf = RcSlice::new(len as usize);

    cell_slice_memcpy(&buf, &msg.buf, len as usize);
    msg.buf += len as usize;

    buf
}

fn amp_encode(argv: &[&[u8]], argc: u32) -> RcSlice<Cell<u8>> {
    let mut len = 1;
    let mut lens = new_boxed_slice(argc as usize);

    for i in 0..argc {
        len += 4;
        lens[i as usize] = CStr::from_bytes_with_nul(argv[i as usize])
            .unwrap()
            .count_bytes() as u32;
        len += lens[i as usize];
    }

    let mut buf: RcSlice<Cell<u8>> = RcSlice::new(len as usize);
    let ret = RcSlice::clone(&buf);

    buf[0].set((AMP_VERSION << 4) | (argc as u8));
    buf += 1;

    for i in 0..argc {
        let len = lens[i as usize];

        write_u32_be(&buf, len);
        buf += 4;

        cell_slice_memcpy(&buf, argv[i as usize], len as usize);
        buf += len as usize;
    }

    ret
}

fn main() {
    let args = [c"some", c"stuff", c"here"];
    let args = Vec::from_iter(args.iter().map(|s| s.to_bytes_with_nul()));

    let buf = amp_encode(&args, 3);

    let mut msg = amp_t::default();
    amp_decode(&mut msg, buf);
    assert!(1 == msg.version);
    assert!(3 == msg.argc);

    for i in 0..msg.argc {
        let arg = amp_decode_arg(&mut msg);
        match i {
            0 => assert!(c"some".cmp(cell_slice_as_cstring(&arg).as_c_str()) == Ordering::Equal),
            1 => assert!(c"stuff".cmp(cell_slice_as_cstring(&arg).as_c_str()) == Ordering::Equal),
            2 => assert!(c"here".cmp(cell_slice_as_cstring(&arg).as_c_str()) == Ordering::Equal),
            _ => (),
        };
    }

    println!("ok");
}
