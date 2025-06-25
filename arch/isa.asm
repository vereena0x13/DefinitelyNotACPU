OPMAX                       = 64
UMAX                        = 16
FMAX                        = 4


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

op_lshi                     = 0x10          ; 0000  xx00  =>  lsh
op_lshm                     = 0x18          ; 1000  xx00  =>  lsh
op_lsh                      = 0x14          ; 0100  xx00  =>  lsh
op_rshi                     = 0x11          ; 0001  xx01  =>  rsh
op_rshm                     = 0x19          ; 1001  xx01  =>  rsh
op_rsh                      = 0x15          ; 0101  xx01  =>  rsh
op_andi                     = 0x12          ; 0010  xx10  =>  bit
op_andm                     = 0x16          ; 0110  xx10  =>  bit
op_ori                      = 0x1A          ; 1010  xx10  =>  bit
op_orm                      = 0x1E          ; 1110  xx10  =>  bit
op_xori                     = 0x13          ; 0011  xx11  =>  bit
op_xorm                     = 0x17          ; 0111  xx11  =>  bit
; op_                         = 0x1B          ; 1011  xx11  =>  bit
; op_                         = 0x1C          ; 1100  xx00  =>  lsh
; op_                         = 0x1D          ; 1101  xx01  => rsh
; op_                         = 0x1F          ; 1111  xx11  =>  bit
;op_lshi                     = 0x10          ; 0000  xx00  =>  lsh
;op_rshi                     = 0x11          ; 0001  xx01  =>  rsh
;op_andi                     = 0x12          ; 0010  xx10  =>  bit
;op_xori                     = 0x13          ; 0011  xx11  =>  bit
;op_lsh                      = 0x14          ; 0100  xx00  =>  lsh
;op_rsh                      = 0x15          ; 0101  xx01  =>  rsh
;op_andm                     = 0x16          ; 0110  xx10  =>  bit
;op_xorm                     = 0x17          ; 0111  xx11  =>  bit
;op_lshm                     = 0x18          ; 1000  xx00  =>  lsh
;op_rshm                     = 0x19          ; 1001  xx01  =>  rsh
;op_ori                      = 0x1A          ; 1010  xx10  =>  bit
;; op_                         = 0x1B          ; 1011  xx11  =>  bit
;; op_                         = 0x1C          ; 1100  xx00  =>  lsh
;; op_                         = 0x1D          ; 1101  xx01  => rsh
;op_orm                      = 0x1E          ; 1110  xx10  =>  bit
;; op_                         = 0x1F          ; 1111  xx11  =>  bit

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
    lsh                     => op_lsh
    rsh #{imm: u8}          => op_rshi @ imm
    rsh {addr: u16}         => op_rshm @ addr
    rsh                     => op_rsh
    and #{imm: u8}          => op_andi @ imm
    and {addr: u16}         => op_andm @ addr
    or #{imm: u8}           => op_ori @ imm
    or {addr: u16}          => op_orm @ addr
    xor #{imm: u8}          => op_xori @ imm
    xor {addr: u16}         => op_xorm @ addr

    jmp {addr: u16}         => op_jmp @ addr

    adc #{imm: u8}          => op_adci @ imm
    adc {addr: u16}         => op_adcm @ addr
    sbc #{imm: u8}          => op_sbci @ imm
    sbc {addr: u16}         => op_sbcm @ addr
    
    jz {addr: u16}          => op_jz @ addr
    jc {addr: u16}          => op_jc @ addr
    jnz {addr: u16}         => op_jnz @ addr
    jnc {addr: u16}         => op_jnc @ addr
}