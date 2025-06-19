#include "../arch/isa.asm"


LCDCMD              = 0x7F00
LCDDAT              = 0x7F01


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
}

#ruledef {
    inc16 {addr: u16} => asm {
        lda {addr}+1
        add #0x01
        sta {addr}+1
        lda {addr}
        add #0x00
        sta {addr}
    }
}


                    lda #0x38
                    sta LCDCMD
                    lda #0x06
                    sta LCDCMD
                    lda #0x0C
                    sta LCDCMD

                    lda #0x01
                    sta LCDCMD

                    lda #0x81
                    sta LCDCMD


                    stz i
l0:                 lda [ptr]
                    sta LCDDAT
                    inc16 ptr
                    lda i
                    add #1
                    sta i
                    cmp #14
                    jnz l0


                    lda #0xC1
                    sta LCDCMD


                    stz i
l1:                 lda [ptr]
                    sta LCDDAT
                    inc16 ptr
                    lda i
                    add #1
                    sta i
                    cmp #14
                    jnz l1


loop:               #res 512
                    lda #0x08
                    sta LCDCMD
                    #res 512
                    lda #0x0C
                    sta LCDCMD
                    jmp loop


i:                  #d8 0
ptr:                #d16 line1
line1:              #d "HAPPY PRIDE MY"
line2:              #d "FELLOW FAGGOTS"