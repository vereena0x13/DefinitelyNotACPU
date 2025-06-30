#include "isa.asm"
#include "ctrl.asm"



FLAG_Z                  = 0
FLAG_C                  = 0


#bankdef ucode {
    #bits 8
    #size OPMAX*UMAX*4
    #fill
    #outp 0
}


#fn opaddr(op)          => op*UMAX*4

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
}




#addr opaddr(op_nop)    ; 2 cy
                        uinsn pc_rd | ram_rd | ir_ld
                        urst pc_inc



#addr opaddr(op_ldz)    ; 2 cy
                        uinsn pc_rd | ram_rd | ir_ld
                        urst pc_inc | a_ld

#addr opaddr(op_stz)    ; 6 cy
                        fetch
                        i_ld_mar_no_inc
                        urst pc_inc | mar_rd | ram_wr



#addr opaddr(op_ldai)   ; 4 cy
                        fetch
                        uinsn pc_rd | ram_rd | a_ld
                        urst pc_inc

#addr opaddr(op_ldam)   ; 6 cy
                        fetch
                        i_ld_mar_no_inc
                        urst pc_inc | mar_rd | ram_rd | a_ld

#addr opaddr(op_sta)    ; 6 cy
                        fetch
                        i_ld_mar_no_inc
                        urst pc_inc | mar_rd | a_rd | ram_wr



#addr opaddr(op_addi)   ; 4 cy
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_rd | a_ld | flags_ld

#addr opaddr(op_addm)   ; 7 cy
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_rd | a_ld | flags_ld

#addr opaddr(op_subi)   ; 4 cy
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_ci | alu_xorb | alu_rd | a_ld | flags_ld

#addr opaddr(op_subm)   ; 7 cy
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_ci | alu_xorb | alu_rd | a_ld | flags_ld

#addr opaddr(op_adci)   ; 4 cy
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
#if FLAG_C == 1 {
                        urst pc_inc | alu_ci | alu_rd | a_ld | flags_ld
}
#else {
                        urst pc_inc | alu_rd | a_ld | flags_ld
}

#addr opaddr(op_adcm)   ; 7 cy
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
#if FLAG_C == 1 {
                        urst alu_ci | alu_rd | a_ld | flags_ld
}
#else {
                        urst alu_rd | a_ld | flags_ld
}

#addr opaddr(op_sbci)   ; 4 cy
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
#if FLAG_C == 1 {
                        urst pc_inc | alu_ci | alu_xorb | alu_rd | a_ld | flags_ld
}
#else {
                        urst pc_inc | alu_xorb | alu_rd | a_ld | flags_ld
}

#addr opaddr(op_sbcm)   ; 7 cy
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
#if FLAG_C == 1 {
                        urst alu_ci | alu_xorb | alu_rd | a_ld | flags_ld
}
#else {
                        urst alu_xorb | alu_rd | a_ld | flags_ld
}



#addr opaddr(op_cmpi)   ; 4 cy
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_ci | alu_xorb | alu_rd | flags_ld

#addr opaddr(op_cmpm)   ; 7 cy
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_ci | alu_xorb | alu_rd | flags_ld



#addr opaddr(op_shli)   ; 4 cy
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_bit_rd | a_ld

#addr opaddr(op_shlm)   ; 7 cy
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_bit_rd | a_ld

#addr opaddr(op_shl)    ; 4 cy
                        fetch
                        uinsn a_rd | b_ld
                        urst alu_bit_rd | a_ld

#addr opaddr(op_shri)   ; 4 cy
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_bit_rd | a_ld

#addr opaddr(op_shrm)   ; 7 cy
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_bit_rd | a_ld

#addr opaddr(op_shr)    ; 4 cy
                        fetch
                        uinsn a_rd | b_ld
                        urst alu_bit_rd | a_ld

#addr opaddr(op_andi)   ; 4 cy
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_bit_and | alu_bit_rd | a_ld

#addr opaddr(op_andm)   ; 7 cy
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_bit_and | alu_bit_rd | a_ld

#addr opaddr(op_ori)    ; 4 cy
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_bit_or | alu_bit_rd | a_ld

#addr opaddr(op_orm)    ; 7 cy
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_bit_or | alu_bit_rd | a_ld

#addr opaddr(op_xori)   ; 4 cy
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_bit_xor | alu_bit_rd | a_ld

#addr opaddr(op_xorm)   ; 7 cy
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_bit_xor | alu_bit_rd | a_ld



#addr opaddr(op_jmp)    ; 6 cy
                        fetch
                        i_ld_mar_no_inc
                        urst mar_rd | pc_ld



#addr opaddr(op_jz)    ; 6 cy
                        fetch
                        i_ld_mar_no_inc
#if FLAG_Z == 1 {
                        urst mar_rd | pc_ld
}
#else {
                        urst pc_inc
}

#addr opaddr(op_jc)    ; 6 cy
                        fetch
                        i_ld_mar_no_inc
#if FLAG_C == 1 {
                        urst mar_rd | pc_ld
}
#else {
                        urst pc_inc
}

#addr opaddr(op_jnz)    ; 6 cy
                        fetch
                        i_ld_mar_no_inc
#if FLAG_Z == 1 {
                        urst pc_inc
}
#else {
                        urst mar_rd | pc_ld
}

#addr opaddr(op_jnc)    ; 6 cy
                        fetch
                        i_ld_mar_no_inc
#if FLAG_C == 1 {
                        urst pc_inc
}
#else {
                        urst mar_rd | pc_ld
}



#addr opaddr(op_stpc)   ; 7 cy
                        fetch
                        uinsn pc_rd | addr_hi_to_d | ram_wr
                        uinsn pc_rd | addr_lo_to_d | a_ld
                        uinsn pc_inc
                        uinsn pc_rd | a_rd | ram_wr
                        urst pc_inc


