op_nop                      = 0x00

op_ldz                      = 0x01
op_stz                      = 0x02

op_ldai                     = 0x03
op_ldam                     = 0x04
op_sta                      = 0x05

op_addi                     = 0x06
op_addm                     = 0x07
op_subi                     = 0x08
op_subm                     = 0x09

op_cmpi                     = 0x0A
op_cmpm                     = 0x0B

; op_                         = 0x0C
; op_                         = 0x0D
; op_                         = 0x0E
; op_                         = 0x0F

; xx00  =>  lsh                         
; xx01  =>  rsh               
; xx10  =>  bit    
; xx10  =>  bit            
op_lshi                     = 0x10          ; 0000 
op_lshm                     = 0x18          ; 1000
op_rshi                     = 0x11          ; 0001
op_rshm                     = 0x19          ; 1001
op_andi                     = 0x12          ; 0010
op_andm                     = 0x16          ; 0110
op_ori                      = 0x1A          ; 1010 
op_orm                      = 0x1E          ; 1110 
op_xori                     = 0x13          ; 0011
op_xorm                     = 0x17          ; 0111
op_not                      = 0x1B          ; 1011 
; op_                         = 0x14
; op_                         = 0x15
; op_                         = 0x1C
; op_                         = 0x1D
; op_                         = 0x1F

op_jmp                      = 0x20

op_adci                     = 0x21
op_adcm                     = 0x22
op_sbci                     = 0x23
op_sbcm                     = 0x24

op_jz                       = 0x25
op_jc                       = 0x26
op_jnz                      = 0x27
op_jnc                      = 0x28


#ruledef arch {
    nop                     => op_nop

    ldz                     => op_ldz
    stz {addr: u16}         => op_stz @ addr

    lda #{imm: u8}          => op_ldai @ imm
    lda {addr: u16}         => op_ldam @ addr
    sta {addr: u16}         => op_sta @ addr

    add #{imm: u8}          => op_addi @ imm
    add {addr: u16}         => op_addm @ addr
    sub #{imm: u8}          => op_subi @ imm
    sub {addr: u16}         => op_subm @ addr

    cmp #{imm: u8}          => op_cmpi @ imm
    cmp {addr: u16}         => op_cmpm @ addr

    lsh #{imm: u8}          => op_lshi @ imm
    lsh {addr: u16}         => op_lshm @ addr
    rsh #{imm: u8}          => op_rshi @ imm
    rsh {addr: u16}         => op_rshm @ addr
    and #{imm: u8}          => op_andi @ imm
    and {addr: u16}         => op_andm @ addr
    or #{imm: u8}           => op_ori @ imm
    or {addr: u16}          => op_orm @ addr
    xor #{imm: u8}          => op_xori @ imm
    xor {addr: u16}         => op_xorm @ addr
    not                     => op_not

    jmp {addr: u16}         => op_jmp @ addr

    adc #{imm: u8}          => op_adc @ imm
    adc {addr: u16}         => op_adc @ addr
    sbc #{imm: u8}          => op_sbc @ imm
    sbc {addr: u16}         => op_sbc @ addr
    
    jz {addr: u16}          => op_jz @ addr
    jc {addr: u16}          => op_jc @ addr
    jnz {addr: u16}         => op_jnz @ addr
    jnc {addr: u16}         => op_jnc @ addr
}