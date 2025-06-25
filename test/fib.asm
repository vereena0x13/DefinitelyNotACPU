#include "../arch/isa.asm"

                        jmp start


#include "../lib/macros.asm"
#include "../lib/lcd.asm"
#include "../lib/lcd_hex.asm"
#include "../lib/stack.asm"



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



;   NOTE TODO: why did i make this table? by hand? ...
;              i had no need for a table, it kinda just happened?
;              this is why we need Roe v. Wade smh
;
;   +----------------------+--------+-------+-------+
;   | (pseudo-)instruction | cycles | count |   cum |
;   +----------------------+--------+-------+-------+
;   |                 call |    173 |     2 |   346 |
;   |                  ret |    126 |     1 |   126 |
;   |                 push |     72 |     2 |   144 |
;   |                  pop |     62 |     2 |   124 |
;   |         sta [??], ?? |     48 |     1 |    48 |
;   |         lda [??], ?? |     38 |     2 |    76 |
;   +----------------------+--------+-------+-------+

fib:                    lda [sp], 3                 ; 38
                        cmp #0                      ; 4
                        jz .end                     ; 6
                        cmp #1                      ; 4
                        jz .end                     ; 6

                        sub #1                      ; 4
                        push                        ; 72
                        call fib                    ; 173

                        lda [sp], 4                 ; 38
                        sub #2                      ; 4
                        push                        ; 72
                        call fib                    ; 173

                        pop                         ; 62
                        sta .t0                     ; 6
                        pop                         ; 62
                        add .t0                     ; 7
                        sta [sp], 3                 ; 48

.end:                   ret                         ; 126
.t0:                    #res 1