#include <stdint.h>

#include "codegen.h"

#include <testing/tassert.h> // tassert

// struct RGenState {
//     // Each bit corresponds with a registers 0-31 where the LSB is 0
//     uint32_t registers_in_use;

//     unsigned int sp_offset;
// } RGEN_STATE;

uint32_t registers_in_use;
unsigned int sp_offset;

void r_code_gen_init() {
    registers_in_use = 0;
    sp_offset = 0;
}

char *r_start_main() {
    static char start[256] = "\
.global _start\n\
_start:\n";

    return start;
}
