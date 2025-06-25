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




                    jmp start



t0:                 #res 1
tptr0:              #d16 HEX_DIGITS

#align 16*32
#assert (HEX_DIGITS & 0x000F) == 0
HEX_DIGITS:         #d "0123456789ABCDEF"


#ruledef {
    lcd_write_hex_digit => asm {
        add #(HEX_DIGITS & 0x00FF)
        sta tptr0 + 1
        lda [tptr0]
        sta LCDDAT
    }

    lcd_write_hex_byte => asm {
        sta t0
        and #0xF0
        rsh
        rsh
        rsh
        rsh
        lcd_write_hex_digit
        lda t0
        and #0x0F
        lcd_write_hex_digit
        lda t0
    }
}



start:              lcd_init
                    lcd_clear
                    lcd_goto 0, 0


                    ldz

l00p:               #res 64
                    
                    sta t0
                    lcd_goto 0, 0
                    lda t0
                    lcd_write_hex_byte
                    
                    add #1
                    jmp l00p


loop:               #res 64
                    jmp loop



