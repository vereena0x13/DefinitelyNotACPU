#once


#ruledef {
    lda [{addr: u16}] => asm {
        lda {addr}
        sta $+10
        lda {addr}+1
        sta $+5
        lda 0x0000
    }

    sta [{addr: u16}] => asm {
        sta $+16
        lda {addr}
        sta $+12
        lda {addr}+1
        sta $+7
        lda #0x00
        sta 0x0000
    }

    inc16 {addr: u16} => asm {
        lda {addr}+1
        add #1
        sta {addr}+1
        lda {addr}
        adc #0
        sta {addr}
    }

    dec16 {addr: u16} => asm {
        lda {addr}+1
        sub #1
        sta {addr}+1
        lda {addr}
        sbc #0
        sta {addr}
    }
}