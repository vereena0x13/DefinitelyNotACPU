#define OPMAX   64
#define UMAX    16
#define FMAX    4


const u8 ucode[FMAX*OPMAX*UMAX*4] = {
#include "ucode_zc.h"
,
#include "ucode_Zc.h"
,
#include "ucode_zC.h"
,
#include "ucode_ZC.h"
};

#define get_uinsn_b(op, upc, flags, b) ucode[flags*OPMAX*UMAX*4 + op*UMAX*4 + upc*4 + b]
#define get_uinsn(op, upc, flags) (get_uinsn_b(op, upc, flags, 3) | \
                                    (get_uinsn_b(op, upc, flags, 2) << 8) | \
                                    (get_uinsn_b(op, upc, flags, 1) << 16) | \
                                    (get_uinsn_b(op, upc, flags, 0) << 24))


void dump_ucode_info() {
    for(u32 op = 0; op < OP_COUNT; op++) {
        if(INSN_CYCLES[op] == 0) continue;

        auto n = printf("%s:", INSN_NAME[op]);
        nputchar(' ', 8 - n);

        u32 count = 0;
        while(!(get_uinsn(op, count, 0) & SR_UPC_RST)) {
            count++;
        }
        count++;

        printf("%d\n", count);
    }
}