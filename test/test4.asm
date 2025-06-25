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
                        

                        lda #0b01001011
                        push
                        call foo
                        pop

                        
l00p5ever:              #res 64
                        jmp l00p5ever




foo:                    lda [sp], 3
                        lsh
                        sta [sp], 3
                        ret