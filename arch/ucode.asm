#include "isa.asm"


FLAG_Z                  = 0
FLAG_C                  = 0


OPMAX                   = 64
UMAX                    = 16
FMAX                    = 4


#bankdef ucode_zc {
    #bits 32
    #size OPMAX*UMAX
    #fill
    #outp 0
}


#fn opaddr(op)          => op*UMAX*4


d0                      = 1 << 0
d1                      = 1 << 1
d2                      = 1 << 2
d3                      = 1 << 3
d4                      = 1 << 4
d5                      = 1 << 5
d6                      = 1 << 6
d7                      = 1 << 7
d_rd                    = 1 << 8
alu_xorb                = 1 << 9
alu_ci                  = 1 << 10
alu_bit_rd              = 1 << 11
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

alu_bit_and             = 0
alu_bit_or              = alu_xorb
alu_bit_xor             = alu_ci
alu_bit_not             = alu_xorb | alu_ci


#ruledef ucode {
    uinsn {uops: u32}   => (uops | upc_inc)`32
    urst {uops: u32}    => (uops | upc_rst)`32

    fetch => asm {
        uinsn pc_rd | ram_rd | ir_ld
        uinsn pc_inc
    }


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
}



#align UMAX*32
;#addr opaddr(op_nop)
.nop:                   uinsn pc_rd | ram_rd | ir_ld
                        urst pc_inc



#align UMAX*32          
;#addr opaddr(op_ldz)
.ldz:                   fetch
                        urst a_ld

#align UMAX*32
;#addr opaddr(op_stz)
.stz:                   fetch
                        i_ld_mar_no_inc
                        urst pc_inc | mar_rd | ram_wr



#align UMAX*32
;#addr opaddr(op_ldai)
.ldai:                  fetch
                        uinsn pc_rd | ram_rd | a_ld
                        urst pc_inc

#align UMAX*32
;#addr opaddr(op_ldam)
.ldam:                  fetch
                        i_ld_mar_no_inc
                        urst pc_inc | mar_rd | ram_rd | a_ld

#align UMAX*32
;#addr opaddr(op_sta)
.sta:                   fetch
                        i_ld_mar_no_inc
                        urst pc_inc | mar_rd | a_rd | ram_wr



#align UMAX*32
;#addr opaddr(op_addi)
.addi:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_rd | a_ld | flags_ld

#align UMAX*32
;#addr opaddr(op_addm)
.addm:                  fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_rd | a_ld | flags_ld

#align UMAX*32
;#addr opaddr(op_subi)
.subi:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_ci | alu_xorb | alu_rd | a_ld | flags_ld

#align UMAX*32
;#addr opaddr(op_subm)
.subm:                  fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_ci | alu_xorb | alu_rd | a_ld | flags_ld



#align UMAX*32
;#addr opaddr(op_cmpi)
.cmpi:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_ci | alu_xorb | alu_rd | flags_ld

#align UMAX*32
;#addr opaddr(op_cmpm)
.cmpm:                  fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_ci | alu_xorb | alu_rd | flags_ld



#align UMAX*32
                        fetch
#align UMAX*32
                        fetch
#align UMAX*32
                        fetch
#align UMAX*32
                        fetch



#align UMAX*32
;#addr opaddr(op_lshi)
.lshi:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_bit_rd | a_ld

#align UMAX*32
;#addr opaddr(op_rshi)
.rshi:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_bit_rd | a_ld

#align UMAX*32
;#addr opaddr(op_andi)
.andi:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_bit_and | alu_bit_rd | a_ld

#align UMAX*32
;#addr opaddr(op_xori)
.xori:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_bit_xor | alu_bit_rd | a_ld

#align UMAX*32
;#addr opaddr(op_rsh)
.lsh:                   fetch
                        uinsn a_rd | b_ld
                        urst alu_bit_rd | a_ld

#align UMAX*32
;#addr opaddr(op_rsh)
.rsh:                   fetch
                        uinsn a_rd | b_ld
                        urst alu_bit_rd | a_ld

#align UMAX*32
;#addr opaddr(op_andm)
.andm:                  fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_bit_and | alu_bit_rd | a_ld

#align UMAX*32
;#addr opaddr(op_xorm)
.xorm:                  fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_bit_xor | alu_bit_rd | a_ld

#align UMAX*32
;#addr opaddr(op_lshm)
.lshm:                  fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_bit_rd | a_ld

#align UMAX*32
;#addr opaddr(op_rshm)
.rshm:                  fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_bit_rd | a_ld

#align UMAX*32
;#addr opaddr(op_ori)
.ori:                   fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_bit_or | alu_bit_rd | a_ld

#align UMAX*32
                        fetch
#align UMAX*32
                        fetch
#align UMAX*32
                        fetch

#align UMAX*32
;#addr opaddr(op_orm)
.orm:                   fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_bit_or | alu_bit_rd | a_ld

#align UMAX*32
                        fetch



#align UMAX*32
;#addr opaddr(op_jmp)
.jmp:                   fetch
                        i_ld_mar_no_inc
                        urst mar_rd | pc_ld


#align UMAX*32
#if FLAG_C == 1 {
.adci:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_ci | alu_rd | a_ld | flags_ld
}
#else {
.adci:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_rd | a_ld | flags_ld
}

#align UMAX*32
#if FLAG_C == 1 {
.adcm:                  fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_ci | alu_rd | a_ld | flags_ld
}
#else {
.adcm:                  fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_rd | a_ld | flags_ld
}

#align UMAX*32
#if FLAG_C == 1 {
.sbci:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_ci | alu_xorb | alu_rd | a_ld | flags_ld
}
#else {
.sbci:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_xorb | alu_rd | a_ld | flags_ld
}

#align UMAX*32
#if FLAG_C == 1 {
.sbcm:                  fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_ci | alu_xorb | alu_rd | a_ld | flags_ld
}
#else {
.sbcm:                  fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_xorb | alu_rd | a_ld | flags_ld
}


#align UMAX*32
#if FLAG_Z == 1 {
.jz:                    i_jtake
}
#else {
.jz:                    i_jskip
}

#align UMAX*32
#if FLAG_C == 1 {
.jc:                    i_jtake
}
#else {
.jc:                    i_jskip
}

#align UMAX*32
#if FLAG_Z == 1 {
.jnz:                   i_jskip
}
#else {
.jnz:                   i_jtake
}

#align UMAX*32
#if FLAG_C == 1 {
.jnc:                   i_jskip
}
#else {
.jnc:                   i_jtake
}