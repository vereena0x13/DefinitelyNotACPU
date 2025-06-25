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