#ruledef arch {
    nop                     => 0x00

    lda #{imm: u8}          => 0x01 @ imm
    lda {addr: u16}         => 0x02 @ addr
    sta #{addr: u16}        => 0x03 @ addr
    sta {addr: u16}         => 0x03 @ addr

    add #{imm: u8}          => 0x04 @ imm
    add {addr: u16}         => 0x05 @ addr
    sub #{imm: u8}          => 0x06 @ imm
    sub {addr: u16}         => 0x07 @ addr

    cmp #{imm: u8}          => 0x08 @ imm
    cmp {addr: u16}         => 0x09 @ addr

    jmp {addr: u16}         => 0x0A @ addr

    adc #{imm: u8}          => 0x0B @ imm
    adc [{addr: u16}]       => 0x0C @ addr
    sbc #{imm: u8}          => 0x0D @ imm
    sbc [{addr: u16}]       => 0x0E @ addr
    
    jz {addr: u16}          => 0x0F @ addr
    jc {addr: u16}          => 0x10 @ addr
    jnz {addr: u16}         => 0x11 @ addr
    jnc {addr: u16}         => 0x12 @ addr
}