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


#fn lo(imm) => imm[7:0]
#fn hi(imm) => imm[15:8]


#ruledef arch {
    nop                     => op_nop

    ldz                     => op_ldz
    stz {addr: u16}         => op_stz @ lo(addr) @ hi(addr)

    lda #{imm: u8}          => op_ldai @ imm
    lda {addr: u16}         => op_ldam @ lo(addr) @ hi(addr)
    sta {addr: u16}         => op_sta @ lo(addr) @ hi(addr)

    add #{imm: u8}          => op_addi @ imm
    add {addr: u16}         => op_addm @ lo(addr) @ hi(addr)
    sub #{imm: u8}          => op_subi @ imm
    sub {addr: u16}         => op_subm @ lo(addr) @ hi(addr)
    adc #{imm: u8}          => op_adci @ imm
    adc {addr: u16}         => op_adcm @ lo(addr) @ hi(addr)
    sbc #{imm: u8}          => op_sbci @ imm
    sbc {addr: u16}         => op_sbcm @ lo(addr) @ hi(addr)

    cmp #{imm: u8}          => op_cmpi @ imm
    cmp {addr: u16}         => op_cmpm @ lo(addr) @ hi(addr)

    shl #{imm: u8}          => op_shli @ imm
    shl {addr: u16}         => op_shlm @ lo(addr) @ hi(addr)
    shl                     => op_shl
    shr #{imm: u8}          => op_shri @ imm
    shr {addr: u16}         => op_shrm @ lo(addr) @ hi(addr)
    shr                     => op_shr
    and #{imm: u8}          => op_andi @ imm
    and {addr: u16}         => op_andm @ lo(addr) @ hi(addr)
    or #{imm: u8}           => op_ori @ imm
    or {addr: u16}          => op_orm @ lo(addr) @ hi(addr)
    xor #{imm: u8}          => op_xori @ imm
    xor {addr: u16}         => op_xorm @ lo(addr) @ hi(addr)

    jmp {addr: u16}         => op_jmp @ lo(addr) @ hi(addr)

    jz {addr: u16}          => op_jz @ lo(addr) @ hi(addr)
    jc {addr: u16}          => op_jc @ lo(addr) @ hi(addr)
    jnz {addr: u16}         => op_jnz @ lo(addr) @ hi(addr)
    jnc {addr: u16}         => op_jnc @ lo(addr) @ hi(addr)

    stpc                    => op_stpc @ 0x00 @ 0x00

    inc                     => op_inc
    dec                     => op_dec
    inc {addr: u16}         => op_incm @ lo(addr) @ hi(addr)
    dec {addr: u16}         => op_decm @ lo(addr) @ hi(addr)
}