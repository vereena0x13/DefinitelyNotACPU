#align UMAX*32
.nop:                   uinsn pc_rd | ram_rd | ir_ld
                        urst pc_inc

                        
#align UMAX*32
.ldai:                  fetch
                        uinsn pc_rd | ram_rd | a_ld
                        urst pc_inc

#align UMAX*32
.ldam:                  fetch
                        uinsn pc_rd | ram_rd | d_to_mar_hi | mar_hi_ld
                        uinsn pc_inc
                        uinsn pc_rd | ram_rd | d_to_mar_lo | mar_lo_ld
                        urst pc_inc | mar_rd | ram_rd | a_ld

#align UMAX*32
.sta:                   fetch
                        uinsn pc_rd | ram_rd | d_to_mar_hi | mar_hi_ld
                        uinsn pc_inc
                        uinsn pc_rd | ram_rd | d_to_mar_lo | mar_lo_ld
                        urst pc_inc | mar_rd | a_rd | ram_wr


#align UMAX*32
.addi:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_rd | a_ld | flags_ld

#align UMAX*32
.addm:                  fetch
                        uinsn pc_rd | ram_rd | d_to_mar_hi | mar_hi_ld
                        uinsn pc_inc
                        uinsn pc_rd | ram_rd | d_to_mar_lo | mar_lo_ld
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_rd | a_ld | flags_ld

#align UMAX*32
.subi:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_ci | alu_xorb | alu_rd | a_ld | flags_ld

#align UMAX*32
.subm:                  fetch
                        uinsn pc_rd | ram_rd | d_to_mar_hi | mar_hi_ld
                        uinsn pc_inc
                        uinsn pc_rd | ram_rd | d_to_mar_lo | mar_lo_ld
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_ci | alu_xorb | alu_rd | a_ld | flags_ld


#align UMAX*32
.cmpi:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_ci | alu_xorb | alu_rd | flags_ld

#align UMAX*32
.cmpm:                  fetch
                        uinsn pc_rd | ram_rd | d_to_mar_hi | mar_hi_ld
                        uinsn pc_inc
                        uinsn pc_rd | ram_rd | d_to_mar_lo | mar_lo_ld
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_ci | alu_xorb | alu_rd | flags_ld


#align UMAX*32
.jmp:                   fetch
                        uinsn pc_rd | ram_rd | d_to_mar_hi | mar_hi_ld
                        uinsn pc_inc
                        uinsn pc_rd | ram_rd | d_to_mar_lo | mar_lo_ld
                        urst mar_rd | pc_ld