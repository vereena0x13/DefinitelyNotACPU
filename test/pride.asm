#include "../arch/isa.asm"
#include "../lib/macros.asm"
#include "../lib/lcd.asm"



                    lcd_init
                    lcd_clear

                    lcd_goto 1, 0

                    stz i
l0:                 lda [ptr]
                    sta LCDDAT
                    lcd_delay
                    inc16 ptr
                    lda i
                    add #1
                    sta i
                    cmp #14
                    jnz l0

                    lcd_goto 1, 1
                    stz i
l1:                 lda [ptr]
                    sta LCDDAT
                    lcd_delay
                    inc16 ptr
                    lda i
                    add #1
                    sta i
                    cmp #14
                    jnz l1


                    N = 4096
loop:               #res N
                    lda #0x08
                    sta LCDCMD
                    lcd_delay
                    #res N
                    lda #0x0C
                    sta LCDCMD
                    lcd_delay
                    jmp loop


i:                  #d8 0
ptr:                #d16 line1
line1:              #d "HAPPY PRIDE MY"
line2:              #d "FELLOW FAGGOTS"