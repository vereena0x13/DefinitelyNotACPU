#align UMAX*32
.adci:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_rd | a_ld | flags_ld

#align UMAX*32
.adcm:                  fetch
                        uinsn pc_rd | ram_rd | d_to_mar_hi | mar_hi_ld
                        uinsn pc_inc
                        uinsn pc_rd | ram_rd | d_to_mar_lo | mar_lo_ld
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_rd | a_ld | flags_ld

#align UMAX*32
.sbci:                  fetch
                        uinsn pc_rd | ram_rd | b_ld
                        urst pc_inc | alu_xorb | alu_rd | a_ld | flags_ld

#align UMAX*32
.sbcm:                  fetch
                        uinsn pc_rd | ram_rd | d_to_mar_hi | mar_hi_ld
                        uinsn pc_inc
                        uinsn pc_rd | ram_rd | d_to_mar_lo | mar_lo_ld
                        uinsn pc_inc | mar_rd | ram_rd | b_ld
                        urst alu_xorb | alu_rd | a_ld | flags_ld
                        

#align UMAX*32
.jz:                    fetch
                        uinsn pc_rd | ram_rd | d_to_mar_hi | mar_hi_ld
                        uinsn pc_inc
                        uinsn pc_rd | ram_rd | d_to_mar_lo | mar_lo_ld
                        urst mar_rd | pc_ld

#align UMAX*32
.jc:                    fetch
                        uinsn pc_rd | ram_rd | d_to_mar_hi | mar_hi_ld
                        uinsn pc_inc
                        uinsn pc_rd | ram_rd | d_to_mar_lo | mar_lo_ld
                        urst pc_inc

#align UMAX*32
.jnz:                   fetch
                        uinsn pc_rd | ram_rd | d_to_mar_hi | mar_hi_ld
                        uinsn pc_inc
                        uinsn pc_rd | ram_rd | d_to_mar_lo | mar_lo_ld
                        urst pc_inc

#align UMAX*32
.jnc:                   fetch
                        uinsn pc_rd | ram_rd | d_to_mar_hi | mar_hi_ld
                        uinsn pc_inc
                        uinsn pc_rd | ram_rd | d_to_mar_lo | mar_lo_ld
                        urst mar_rd | pc_ld