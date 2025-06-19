d_rd                    = 1 << 8
alu_xorb                = 1 << 9
alu_ci                  = 1 << 10
;2                      = 1 << 11
pc_rd                   = 1 << 12
pc_inc                  = 1 << 13
pc_ld                   = 1 << 14
mar_rd                  = 1 << 15
mar_lo_ld               = 1 << 16
mar_hi_ld               = 1 << 17
a_rd                    = 1 << 18
a_ld                    = 1 << 19
b_ld                    = 1 << 20
flags_ld                = 1 << 21
upc_rst                 = 1 << 22
ram_rd                  = 1 << 23
ram_wr                  = 1 << 24
ir_ld                   = 1 << 25
addr_lo_to_d            = 1 << 26
addr_hi_to_d            = 1 << 27
d_to_mar_lo             = 1 << 29
d_to_mar_hi             = 1 << 28
upc_inc                 = 1 << 30
alu_rd                  = 1 << 31


OPMAX                   = 24
UMAX                    = 16
FMAX                    = 4


#ruledef ucode {
    uinsn {uops: u32}   => (uops | upc_inc)`32
    urst {uops: u32}    => (uops | upc_rst)`32

    fetch => asm {
        uinsn pc_rd | ram_rd | ir_ld
        uinsn pc_inc
    }
}


#bankdef ucode_zc {
    #bits 32
    #size OPMAX*UMAX
    #fill
    #outp 0
}

#bankdef ucode_Zc {
    #bits 32
    #size OPMAX*UMAX
    #fill
    #outp OPMAX*UMAX*1*32
}

#bankdef ucode_zC {
    #bits 32
    #size OPMAX*UMAX
    #fill
    #outp OPMAX*UMAX*2*32
}

#bankdef ucode_ZC {
    #bits 32
    #size OPMAX*UMAX
    #fill
    #outp OPMAX*UMAX*3*32
}


#ruledef {
    i_ld_mar_no_inc => asm {
        uinsn pc_rd | ram_rd | d_to_mar_hi | mar_hi_ld
        uinsn pc_inc
        uinsn pc_rd | ram_rd | d_to_mar_lo | mar_lo_ld
    }


    i_jskip => asm {
        fetch
        i_ld_mar_no_inc
        urst pc_inc
    }
    i_jtake => asm {
        fetch
        i_ld_mar_no_inc
        urst mar_rd | pc_ld
    }


    i_adci 0 => asm {
        fetch
        uinsn pc_rd | ram_rd | b_ld
        urst pc_inc | alu_rd | a_ld | flags_ld
    }
    i_adcm 0 => asm {
        fetch
        i_ld_mar_no_inc
        uinsn pc_inc | mar_rd | ram_rd | b_ld
        urst alu_rd | a_ld | flags_ld
    }
    i_sbci 0 => asm {
        fetch
        uinsn pc_rd | ram_rd | b_ld
        urst pc_inc | alu_xorb | alu_rd | a_ld | flags_ld
    }
    i_sbcm 0 => asm {
        fetch
        i_ld_mar_no_inc
        uinsn pc_inc | mar_rd | ram_rd | b_ld
        urst alu_xorb | alu_rd | a_ld | flags_ld
    }

    i_adci 1 => asm {
        fetch
        uinsn pc_rd | ram_rd | b_ld
        urst pc_inc | alu_ci | alu_rd | a_ld | flags_ld
    }
    i_adcm 1 => asm {
        fetch
        i_ld_mar_no_inc
        uinsn pc_inc | mar_rd | ram_rd | b_ld
        urst alu_ci | alu_rd | a_ld | flags_ld
    }
    i_sbci 1 => asm {
        fetch
        uinsn pc_rd | ram_rd | b_ld
        urst pc_inc | alu_ci | alu_xorb | alu_rd | a_ld | flags_ld
    }
    i_sbcm 1 => asm {
        fetch
        i_ld_mar_no_inc
        uinsn pc_inc | mar_rd | ram_rd | b_ld
        urst alu_ci | alu_xorb | alu_rd | a_ld | flags_ld
    }
}


#bank ucode_zc
zc:
#include "ucode_base.asm"
#include "ucode_zc.asm"

#bank ucode_Zc
Zc:
#include "ucode_base.asm"
#include "ucode_Zc.asm"

#bank ucode_zC
zC:
#include "ucode_base.asm"
#include "ucode_zC.asm"

#bank ucode_ZC
ZC:
#include "ucode_base.asm"
#include "ucode_ZC.asm"