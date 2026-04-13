fn leftpad(
    st: &Vec<u8>,
    padding: Option<&Vec<u8>>,
    min_len: u64,
    dest: Option<&mut Vec<u8>>,
    dest_sz: Option<u64>,
) -> u64 {
    let str_len: u64 = st.len() as u64;

    let padding = match padding {
        None => &" ".as_bytes().to_vec(),
        Some(p) => {
            if p.len() == 0 {
                &" ".as_bytes().to_vec()
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
            *dest = vec![];
            while (dest.len() as u64) < npad {
                dest.append(&mut padding.clone());
            }
            while (dest.len() as u64) > npad {
                dest.remove(dest.len() - 1);
            }
            dest.append(&mut st.clone());
            if dest_sz < (dest.len() as u64) {
                *dest = dest[..(dest_sz as usize)].to_vec();
            }
            dest.len() as u64
        }
        _ => str_len + npad,
    }
}
