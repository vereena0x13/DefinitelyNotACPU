#include "../arch/isa.asm"

                        jmp start

#include "../lib/macros.asm"
#include "../lib/stack.asm"

#include "../lib/extra/lcd.asm"
#include "../lib/extra/lcd_hex.asm"




start:                  lcd_init
                        lcd_clear
                        lcd_goto 0, 0


                        lda #7
                        push
                        call fib
                        pop

                        ;lcd_write_hex_byte

                        #res 1024*4
                        jmp start


l00p5ever:              #res 64
                        jmp l00p5ever



;   NOTE TODO: why did i make this table? by hand? ...
;              i had no need for a table, it kinda just happened?
;              this is why we need Roe v. Wade smh
;
;   +----------------------+--------+-------+-------+
;   | (pseudo-)instruction | cycles | count |   cum |
;   +----------------------+--------+-------+-------+
;   |                 call |    145 |     2 |   290 |
;   |                  ret |    106 |     1 |   106 |
;   |                 push |     60 |     2 |   120 |
;   |                  pop |     50 |     2 |   100 |
;   |         sta [??], ?? |     48 |     1 |    48 |
;   |         lda [??], ?? |     38 |     2 |    76 |
;   +----------------------+--------+-------+-------+

fib:                    lda [sp], 3                 ; 38
                        cmp #0                      ; 4
                        jz .end                     ; 6
                        cmp #1                      ; 4
                        jz .end                     ; 6

                        sub #1                      ; 4
                        push                        ; 60
                        call fib                    ; 145

                        lda [sp], 4                 ; 38
                        sub #2                      ; 4
                        push                        ; 60
                        call fib                    ; 145

                        pop                         ; 50
                        sta .t0                     ; 6
                        pop                         ; 50
                        add .t0                     ; 7
                        sta [sp], 3                 ; 48

.end:                   ret                         ; 106
.t0:                    #res 1