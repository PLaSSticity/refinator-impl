fn leftpad(
    st: &String,
    padding: Option<&String>,
    min_len: u64,
    dest: Option<&mut String>,
    dest_sz: Option<u64>,
) -> u64 {
    let str_len: u64 = st.len() as u64;

    let padding = match padding {
        None => " ",
        Some(p) => {
            if p == "" {
                " "
            } else {
                p
            }
        }
    };

    let npad = if str_len < min_len {
        min_len - str_len
    } else {
        0
    };

    match (dest, dest_sz) {
        (Some(dest), Some(dest_sz)) => {
            *dest = String::new();
            while (dest.len() as u64) < npad {
                dest.push_str(padding);
            }
            while (dest.len() as u64) > npad {
                dest.remove(dest.len() - 1);
            }
            dest.push_str(st);
            if dest_sz < (dest.len() as u64) {
                *dest = dest[..(dest_sz as usize)].to_string();
            }
            dest.len() as u64
        }
        _ => str_len + npad,
    }
}
