#include "../arch/isa.asm"
#include "macros.asm"
#include "lcd.asm"



                        jmp start



#include "lcd_hex.asm"
#include "stack.asm"



start:                  lcd_init
                        lcd_clear
                        lcd_goto 0, 0
                        
                        
                        lda #"H"
                        push
                        lda #"e"
                        push
                        lda #"l"
                        push
                        lda #"l"
                        push
                        lda #"o"
                        push

                        #res 64

                        pop
                        sta LCDDAT
                        pop
                        sta LCDDAT
                        pop
                        sta LCDDAT
                        pop
                        sta LCDDAT
                        pop
                        sta LCDDAT
                        
                        
                        
                        
                        
l00p5ever:              #res 64
                        jmp l00p5ever