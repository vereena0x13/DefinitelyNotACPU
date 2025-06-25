#include "../arch/isa.asm"

                        jmp start


#include "../lib/macros.asm"
#include "../lib/lcd.asm"
#include "../lib/lcd_hex.asm"
#include "../lib/stack.asm"
#include "../lib/callret.asm"



start:                  lcd_init
                        lcd_clear
                        lcd_goto 0, 0
                        

                        lda #1
                        call foo
                        lda #2

                        
l00p5ever:              #res 64
                        jmp l00p5ever




foo:                    lda #0x33
                        ret
                        