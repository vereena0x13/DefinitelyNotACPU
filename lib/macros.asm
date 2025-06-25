#once


#ruledef {
    lda [{addr: u16}] => asm {
        lda {addr}
        sta a+2
        lda {addr}+1
        sta a+1
a:      lda 0x0000
    }

    sta [{addr: u16}] => asm {
        sta a-1
        lda {addr}
        sta a+2
        lda {addr}+1
        sta a+1
        lda #0x00
a:      sta 0x0000
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