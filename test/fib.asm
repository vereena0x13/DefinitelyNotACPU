#include "../arch/isa.asm"
#include "lcd.asm"


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
        add #0x01
        sta {addr}+1
        lda {addr}
        add #0x00
        sta {addr}
    }
}


                    lcd_init
                    lcd_clear
                    lcd_goto 0, 0



loop:               jmp loop