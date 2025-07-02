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
op_adci                     = 0x0A
op_adcm                     = 0x0B
op_sbci                     = 0x0C
op_sbcm                     = 0x0D

op_cmpi                     = 0x0E
op_cmpm                     = 0x0F

op_shli                     = 0x10
op_shri                     = 0x11
op_andi                     = 0x12
op_xori                     = 0x13
op_shl                      = 0x14
op_shr                      = 0x15
op_andm                     = 0x16
op_xorm                     = 0x17
op_shlm                     = 0x18
op_shrm                     = 0x19
op_ori                      = 0x1A
op_orm                      = 0x1E

op_jmp                      = 0x20

op_jz                       = 0x21
op_jc                       = 0x22
op_jnz                      = 0x23
op_jnc                      = 0x24

op_stpc                     = 0x25

op_inc                      = 0x26
op_dec                      = 0x27
op_incm                     = 0x28
op_decm                     = 0x29


#ruledef arch {
    nop                     => op_nop

    ldz                     => op_ldz
    stz {addr: u16}         => op_stz @ addr[7:0] @ addr[15:8]

    lda #{imm: u8}          => op_ldai @ imm
    lda {addr: u16}         => op_ldam @ addr[7:0] @ addr[15:8]
    sta {addr: u16}         => op_sta @ addr[7:0] @ addr[15:8]

    add #{imm: u8}          => op_addi @ imm
    add {addr: u16}         => op_addm @ addr[7:0] @ addr[15:8]
    sub #{imm: u8}          => op_subi @ imm
    sub {addr: u16}         => op_subm @ addr[7:0] @ addr[15:8]
    adc #{imm: u8}          => op_adci @ imm
    adc {addr: u16}         => op_adcm @ addr[7:0] @ addr[15:8]
    sbc #{imm: u8}          => op_sbci @ imm
    sbc {addr: u16}         => op_sbcm @ addr[7:0] @ addr[15:8]

    cmp #{imm: u8}          => op_cmpi @ imm
    cmp {addr: u16}         => op_cmpm @ addr[7:0] @ addr[15:8]

    shl #{imm: u8}          => op_shli @ imm
    shl {addr: u16}         => op_shlm @ addr[7:0] @ addr[15:8]
    shl                     => op_shl
    shr #{imm: u8}          => op_shri @ imm
    shr {addr: u16}         => op_shrm @ addr[7:0] @ addr[15:8]
    shr                     => op_shr
    and #{imm: u8}          => op_andi @ imm
    and {addr: u16}         => op_andm @ addr[7:0] @ addr[15:8]
    or #{imm: u8}           => op_ori @ imm
    or {addr: u16}          => op_orm @ addr[7:0] @ addr[15:8]
    xor #{imm: u8}          => op_xori @ imm
    xor {addr: u16}         => op_xorm @ addr[7:0] @ addr[15:8]

    jmp {addr: u16}         => op_jmp @ addr[7:0] @ addr[15:8]

    jz {addr: u16}          => op_jz @ addr[7:0] @ addr[15:8]
    jc {addr: u16}          => op_jc @ addr[7:0] @ addr[15:8]
    jnz {addr: u16}         => op_jnz @ addr[7:0] @ addr[15:8]
    jnc {addr: u16}         => op_jnc @ addr[7:0] @ addr[15:8]

    stpc                    => op_stpc @ 0x00 @ 0x00

    inc                     => op_inc
    dec                     => op_dec
    inc {addr: u16}         => op_incm @ addr[7:0] @ addr[15:8]
    dec {addr: u16}         => op_decm @ addr[7:0] @ addr[15:8]
}