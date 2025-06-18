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
    ;adc {imm: u8}           => 0x?? @ imm
    ;adc [{addr: u16}]       => 0x?? @ addr
    ;sbc {imm: u8}           => 0x?? @ imm
    ;sbc [{addr: u16}]       => 0x?? @ addr

    cmp #{imm: u8}          => 0x08 @ imm
    cmp {addr: u16}         => 0x09 @ addr

    jmp {addr: u16}         => 0x0A @ addr
    jz {addr: u16}          => 0x0B @ addr
    jc {addr: u16}          => 0x0C @ addr
    jnz {addr: u16}         => 0x0D @ addr
    jnc {addr: u16}         => 0x0E @ addr
}