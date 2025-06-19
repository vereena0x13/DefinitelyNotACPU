#align UMAX*32
.nop:                   uinsn pc_rd | ram_rd | ir_ld
                        urst pc_inc

                        
#align UMAX*32
.ldai:                  fetch
                        uinsn pc_rd | ram_rd | a_ld
                        urst pc_inc

#align UMAX*32
.ldam:                  fetch
                        i_ld_mar_no_inc
                        urst pc_inc | mar_rd | ram_rd | a_ld

#align UMAX*32
.sta:                   fetch
                        i_ld_mar_no_inc
                        urst pc_inc | mar_rd | a_rd | ram_wr


#align UMAX*32
.addi:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_rd | a_ld | flags_ld

#align UMAX*32
.addm:                  fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_rd | a_ld | flags_ld

#align UMAX*32
.subi:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_ci | alu_xorb | alu_rd | a_ld | flags_ld

#align UMAX*32
.subm:                  fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_ci | alu_xorb | alu_rd | a_ld | flags_ld


#align UMAX*32
.cmpi:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_ci | alu_xorb | alu_rd | flags_ld

#align UMAX*32
.cmpm:                  fetch
                        i_ld_mar_no_inc
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_ci | alu_xorb | alu_rd | flags_ld


#align UMAX*32
.jmp:                   fetch
                        i_ld_mar_no_inc
                        urst mar_rd | pc_ld