#once


lcd_hex_t0:         #res 1
lcd_hex_tptr0:      #d16 HEX_DIGITS

#align 16*32
#assert (HEX_DIGITS & 0x000F) == 0
HEX_DIGITS:         #d "0123456789ABCDEF"


#ruledef {
    lcd_write_hex_digit => asm {
        add #(HEX_DIGITS & 0x00FF)
        sta lcd_hex_tptr0 + 1
        lda [lcd_hex_tptr0]
        sta LCDDAT
    }

    lcd_write_hex_byte => asm {
        sta lcd_hex_t0
        and #0xF0
        rsh
        rsh
        rsh
        rsh
        lcd_write_hex_digit
        lda lcd_hex_t0
        and #0x0F
        lcd_write_hex_digit
        lda lcd_hex_t0
    }
}