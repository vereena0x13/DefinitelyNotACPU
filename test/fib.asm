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
                        

                        lda #13
                        push
                        call fib
                        pop

                        lcd_write_hex_byte

                        
l00p5ever:              #res 64
                        jmp l00p5ever



fib:                    lda [sp], 3
                        cmp #0
                        jz .end
                        cmp #1
                        jz .end

                        sub #1
                        push
                        call fib
                        
                        lda [sp], 4
                        sub #2
                        push
                        call fib
                        
                        pop
                        sta .t0
                        pop
                        add .t0
                        sta [sp], 3

.end:                   ret
.t0:                    #res 1