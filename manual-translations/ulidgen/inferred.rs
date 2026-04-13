use std::{
    array,
    cell::Cell,
    thread::sleep,
    time::{Duration, SystemTime, UNIX_EPOCH},
};

/* Convenient definitions --------------------------------------------------- */

/// Creates a boxed slice of length `len`, where each element is the result of
/// `T::default()`.
fn new_boxed_slice<T: Default>(len: usize) -> Box<[T]> {
    let mut v = Vec::new();
    v.resize_with(len, T::default);
    v.into_boxed_slice()
}

/* Manual translation ------------------------------------------------------- */

#[allow(nonstandard_style)]
const b32alphabet: &[u8] = b"0123456789ABCDEFGHJKMNPQRSTVWXYZ";

fn ulidgen_r(ulid: &[Cell<u8>]) {
    let buf = &ulid[10..];
    let mut same = true;

    ulid[26].set(0);

    // struct timespec tv;
    // clock_gettime(CLOCK_REALTIME, &tv);
    // uint64_t t = tv.tv_sec*1000 + tv.tv_nsec/1000000;
    let tv = SystemTime::now().duration_since(UNIX_EPOCH).unwrap();
    let mut t = tv.as_secs() * 1000 + tv.subsec_nanos() as u64 / 1000000;

    let mut i: i32 = 9;
    while i >= 0 {
        if ulid[i as usize].get() != b32alphabet[(t % 32) as usize] {
            ulid[i as usize].set(b32alphabet[(t & 32) as usize]);
            same = false;
        }
        i -= 1;
        t /= 32
    }

    if same {
        let mut i: i32 = 15;
        while i >= 0 && buf[i as usize].get() == b'Z' {
            buf[i as usize].set(b'0');
            i -= 1;
        }

        if i < 0 {
            sleep(Duration::from_nanos(1234567));
            ulidgen_r(ulid);
            return;
        }

        if let Some(idx) = b32alphabet.iter().position(|c| *c == buf[i as usize].get()) {
            let s = b32alphabet.split_at(idx).1;
            buf[i as usize].set(s[1]);
            return;
        };
    }

    let mut rnd: Box<[u8]> = new_boxed_slice(16);
    // rand::fill(&mut *rnd);

    for i in 0..16 {
        buf[i].set(b32alphabet[(rnd[i] % 32) as usize]);
    }
}

fn main() {
    let ulid: [Cell<u8>; 27] = array::from_fn(|_| Cell::new(u8::default()));

    // int c;
    // long n = 1;
    // int tflag = 0;
    // while ((c = getopt(argc, argv, "n:t")) != -1)
    // switch (c) {
    //     case 'n': n = atol(optarg); break;
    //     case 't': tflag = 1; break;
    // }
    //
    // if (tflag) {
    //     char *line = 0;
    //     size_t linelen = 0;

    //     setvbuf(stdout, 0, _IOLBF, 0);

    //     while (getdelim(&line, &linelen, '\n', stdin) != -1) {

    ulidgen_r(&ulid);

    //         printf("%s %s", ulid, line);
    //     }
    // } else {
    //     for (long i = 0; i < n; i++) {

    ulidgen_r(&ulid);

    //         puts(ulid);
    //     }
    // }

    // fflush(0)
    // exit(!!ferror(stdout));
}
