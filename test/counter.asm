#include "../arch/isa.asm"

                    jmp start

#include "../lib/macros.asm"
#include "../lib/lcd.asm"
#include "../lib/lcd_hex.asm"



start:              lcd_init
                    lcd_clear
                    lcd_goto 0, 0



loop:               #res 512
                    
                    lcd_goto 0, 0

                    lda counter
                    lcd_write_hex_byte

                    add #1
                    sta counter

                    jmp loop



counter:            #d8 0