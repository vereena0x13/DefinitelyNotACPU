#include "isa.asm"
#include "ctrl.asm"



FLAG_Z                  = 0
FLAG_C                  = 0


#bankdef ucode {
    #bits 32
    #size OPMAX*UMAX
    #fill
    #outp 0
}


#fn opaddr(op)          => op*UMAX

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




#addr opaddr(op_nop)    
                        uinsn pc_rd | ram_rd | ir_ld
                        urst pc_inc



#addr opaddr(op_ldz)    
                        fetch
                        urst a_ld

#addr opaddr(op_stz)    
                        fetch
                        i_ld_mar_no_inc
                        urst pc_inc | mar_rd | ram_wr



#addr opaddr(op_ldai)   
                        fetch
                        uinsn pc_rd | ram_rd | a_ld
                        urst pc_inc

#addr opaddr(op_ldam)   
                        fetch
                        i_ld_mar_no_inc
                        urst pc_inc | mar_rd | ram_rd | a_ld

#addr opaddr(op_sta)    
                        fetch
                        i_ld_mar_no_inc
                        urst pc_inc | mar_rd | a_rd | ram_wr



#addr opaddr(op_addi)   
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_rd | a_ld | flags_ld

#addr opaddr(op_addm)   
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_rd | a_ld | flags_ld

#addr opaddr(op_subi)   
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_ci | alu_xorb | alu_rd | a_ld | flags_ld

#addr opaddr(op_subm)   
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_ci | alu_xorb | alu_rd | a_ld | flags_ld

#addr opaddr(op_adci)   
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
#if FLAG_C == 1 {
                        urst pc_inc | alu_ci | alu_rd | a_ld | flags_ld
}
#else {
                        urst pc_inc | alu_rd | a_ld | flags_ld
}

#addr opaddr(op_adcm)   
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
#if FLAG_C == 1 {
                        urst alu_ci | alu_rd | a_ld | flags_ld
}
#else {
                        urst alu_rd | a_ld | flags_ld
}

#addr opaddr(op_sbci)   
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
#if FLAG_C == 1 {
                        urst pc_inc | alu_ci | alu_xorb | alu_rd | a_ld | flags_ld
}
#else {
                        urst pc_inc | alu_xorb | alu_rd | a_ld | flags_ld
}

#addr opaddr(op_sbcm)   
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
#if FLAG_C == 1 {
                        urst alu_ci | alu_xorb | alu_rd | a_ld | flags_ld
}
#else {
                        urst alu_xorb | alu_rd | a_ld | flags_ld
}



#addr opaddr(op_cmpi)   
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_ci | alu_xorb | alu_rd | flags_ld

#addr opaddr(op_cmpm)   
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_ci | alu_xorb | alu_rd | flags_ld



#addr opaddr(op_lshi)   
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_bit_rd | a_ld

#addr opaddr(op_lshm)   
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_bit_rd | a_ld

#addr opaddr(op_lsh)    
                        fetch
                        uinsn a_rd | b_ld
                        urst alu_bit_rd | a_ld

#addr opaddr(op_rshi)   
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_bit_rd | a_ld

#addr opaddr(op_rshm)   
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_bit_rd | a_ld

#addr opaddr(op_rsh)    
                        fetch
                        uinsn a_rd | b_ld
                        urst alu_bit_rd | a_ld

#addr opaddr(op_andi)   
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_bit_and | alu_bit_rd | a_ld

#addr opaddr(op_andm)   
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_bit_and | alu_bit_rd | a_ld

#addr opaddr(op_ori)    
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_bit_or | alu_bit_rd | a_ld

#addr opaddr(op_orm)    
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_bit_or | alu_bit_rd | a_ld

#addr opaddr(op_xori)   
                        fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_bit_xor | alu_bit_rd | a_ld

#addr opaddr(op_xorm)   
                        fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_bit_xor | alu_bit_rd | a_ld



#addr opaddr(op_jmp)    
                        fetch
                        i_ld_mar_no_inc
                        urst mar_rd | pc_ld



#addr opaddr(op_jz)
#if FLAG_Z == 1 {
                        i_jtake
}
#else {
                        i_jskip
}

#addr opaddr(op_jc)
#if FLAG_C == 1 {
                        i_jtake
}
#else {
                        i_jskip
}

#addr opaddr(op_jnz)
#if FLAG_Z == 1 {
                        i_jskip
}
#else {
                        i_jtake
}

#addr opaddr(op_jnc)
#if FLAG_C == 1 {
                        i_jskip
}
#else {
                        i_jtake
}