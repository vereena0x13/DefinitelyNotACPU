#ruledef arch {
    nop                     => 0x00

    ldz                     => 0x01
    stz #{addr: u16}        => 0x02 @ addr
    stz {addr: u16}         => 0x02 @ addr

    lda #{imm: u8}          => 0x03 @ imm
    lda {addr: u16}         => 0x04 @ addr
    sta #{addr: u16}        => 0x05 @ addr
    sta {addr: u16}         => 0x05 @ addr

    add #{imm: u8}          => 0x06 @ imm
    add {addr: u16}         => 0x07 @ addr
    sub #{imm: u8}          => 0x08 @ imm
    sub {addr: u16}         => 0x09 @ addr

    cmp #{imm: u8}          => 0x0A @ imm
    cmp {addr: u16}         => 0x0B @ addr

    jmp {addr: u16}         => 0x0C @ addr

    adc #{imm: u8}          => 0x0D @ imm
    adc {addr: u16}         => 0x0E @ addr
    sbc #{imm: u8}          => 0x0F @ imm
    sbc {addr: u16}         => 0x10 @ addr
    
    jz {addr: u16}          => 0x11 @ addr
    jc {addr: u16}          => 0x12 @ addr
    jnz {addr: u16}         => 0x13 @ addr
    jnc {addr: u16}         => 0x14 @ addr
}