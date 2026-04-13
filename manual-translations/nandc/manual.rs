fn bool_to_bit(x: bool) -> i8 {
    if x { 1 } else { 0 }
}

fn bit_to_bool(x: i8) -> bool {
    x == 1
}

fn sub_bit(a: bool, b: bool, carry: bool, carry_result: &mut bool) -> bool {
    let mut b2: bool = false;
    let mut b1: bool = false;
    let result = half_sub(half_sub(a, b, &mut b1), carry, &mut b2);
    *carry_result = or(b1, b2);
    result
}
fn or(a: bool, b: bool) -> bool {
    nand(not(a), not(b))
}
fn not(a: bool) -> bool {
    nand(a, true)
}
fn check_sub() -> bool {
    for a in 0..0b1111 {
        for b in 0..0b1111 {
            let my = sub_u4(a, b);
            let h = (a - b) & 0b1111;
            if my != h {
                println!("ERROR: Sub failed with {}+{}:", a, b);
                println!("  My  : {}", my);
                println!("  Real: {}", h);
                return false;
            }
        }
    }
    println!("Sub works correctly");
    return true;
}
fn half_sub(a: bool, b: bool, carry_result: &mut bool) -> bool {
    *carry_result = and(not(a), b);
    xor(a, b)
}
fn print_add_bit(a: bool, b: bool, carry: bool) {
    println!("a      : {}", bll(a));
    println!("b      : {}", bll(b));
    println!("carry  : {}", bll(carry));
    let mut res_carry: bool = false;
    println!("result :");
    println!("  bit  : {}", bll(add_bit(a, b, carry, &mut res_carry)));
    println!("  carry: {}", bll(res_carry));
}
fn sub_u4(a: i8, b: i8) -> i8 {
    let mut carry: bool = false;
    let mut result = 0;
    result |= bool_to_bit(sub_bit(
        bit_to_bool((a >> 0) & 0b1),
        bit_to_bool((b >> 0) & 0b1),
        carry,
        &mut carry,
    )) << 0;
    result |= bool_to_bit(sub_bit(
        bit_to_bool((a >> 1) & 0b1),
        bit_to_bool((b >> 1) & 0b1),
        carry,
        &mut carry,
    )) << 1;
    result |= bool_to_bit(sub_bit(
        bit_to_bool((a >> 2) & 0b1),
        bit_to_bool((b >> 2) & 0b1),
        carry,
        &mut carry,
    )) << 2;
    result |= bool_to_bit(sub_bit(
        bit_to_bool((a >> 3) & 0b1),
        bit_to_bool((b >> 3) & 0b1),
        carry,
        &mut carry,
    )) << 3;
    result
}
fn add_u4(a: i8, b: i8) -> i8 {
    let mut carry: bool = false;
    let mut result = 0;
    result |= bool_to_bit(add_bit(
        bit_to_bool((a >> 0) & 0b1),
        bit_to_bool((b >> 0) & 0b1),
        carry,
        &mut carry,
    )) << 0;
    result |= bool_to_bit(add_bit(
        bit_to_bool((a >> 1) & 0b1),
        bit_to_bool((b >> 1) & 0b1),
        carry,
        &mut carry,
    )) << 1;
    result |= bool_to_bit(add_bit(
        bit_to_bool((a >> 2) & 0b1),
        bit_to_bool((b >> 2) & 0b1),
        carry,
        &mut carry,
    )) << 2;
    result |= bool_to_bit(add_bit(
        bit_to_bool((a >> 3) & 0b1),
        bit_to_bool((b >> 3) & 0b1),
        carry,
        &mut carry,
    )) << 3;
    result
}
fn xor(a: bool, b: bool) -> bool {
    or(and(a, not(b)), and(not(a), b))
}
fn and(a: bool, b: bool) -> bool {
    not(nand(a, b))
}
fn add_bit(a: bool, b: bool, carry: bool, carry_result: &mut bool) -> bool {
    *carry_result = and(or(a, b), or(and(a, b), carry));
    xor(xor(a, b), carry)
}
fn bll(x: bool) -> String {
    if x {
        "true".to_string()
    } else {
        "false".to_string()
    }
}
fn check_add() -> bool {
    for a in 0..0b1111 {
        for b in 0..0b1111 {
            let my = add_u4(a, b);
            let h = (a + b) & 0b1111;
            if my != h {
                println!("ERROR: Add failed with {}+{}:", a, b);
                println!("  My  : {}", my);
                // probably should print `h`, but this
                // is what the original C program does.
                println!("  Real: {}", my);
                return false;
            }
        }
    }
    println!("Add works correctly");
    return true;
}
fn nand(a: bool, b: bool) -> bool {
    !(a && b)
}

fn main() {
    check_add();
    check_sub();
}
