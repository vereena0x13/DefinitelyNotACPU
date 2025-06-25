#once

LCDCMD                  = 0x7F00
LCDDAT                  = 0x7F01

#ruledef {
    lcd_init => asm {
        lda #0x38   ; 2 lines, 5x8 matrix, 8-bit mode
        sta LCDCMD
        lda #0x06   ; shift cursor right on data
        sta LCDCMD
        lda #0x0C   ; display on
        sta LCDCMD
    }

    lcd_goto {col: u4}, 0 => asm {
        lda #(0x80 + {col})
        sta LCDCMD
    }

    lcd_goto {col: u4}, 1 => asm {
        lda #(0xC0 + {col})
        sta LCDCMD
    }

    lcd_clear => asm {
        lda #0x01
        sta LCDCMD
    }
}