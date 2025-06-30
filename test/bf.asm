#include "../arch/isa.asm"

                        jmp start

#include "../lib/macros.asm"
#include "../lib/stack.asm"

#include "../lib/extra/lcd.asm"
#include "../lib/extra/lcd_hex.asm"



;CODE: #d "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+." ;>++."
CODE: #d "+++++++++++[>++++++>+++++++++>++++++++>++++>+++>+<<<<<<-]>++++++.>++.+++++++..+++.>>.>-.<<-.<.+++.------.--------.>>>+."
CODELEN = $ - CODE



start:                  lcd_init
                        lcd_clear
                        lcd_goto 0, 0

                        call brainfuck

                        lcd_goto 0, 1
                        lda #"B"
                        sta LCDDAT
                        lda #"O"
                        sta LCDDAT
                        sta LCDDAT
                        lda #"B"
                        sta LCDDAT
                        lda #"I"
                        sta LCDDAT
                        lda #"E"
                        sta LCDDAT
                        lda #"S"
                        sta LCDDAT

                        spin



brainfuck:              st16 bf_ip, #CODE
                        st16 bf_dp, #(tape + 0x100)
.clear_loop:            dec16 bf_dp
                        stz [bf_dp]
                        lda #tape[15:8]
                        cmp bf_dp+1
                        jnz .clear_loop
                        lda #tape[7:0]
                        cmp bf_dp
                        jnz .clear_loop
.bfloop:
                        lda bf_ip+1
                        cmp #(CODE + CODELEN)[15:8]
                        jnz .bfloop1
                        lda bf_ip
                        cmp #(CODE + CODELEN)[7:0]
                        jz .bfdone
.bfloop1:
                        lda [bf_ip]

                        cmp #">"
                        jz .bf_right
                        cmp #"<"
                        jz .bf_left
                        cmp #"+"
                        jz .bf_inc
                        cmp #"-"
                        jz .bf_dec
                        cmp #"."
                        jz .bf_putc
                        cmp #"["
                        jz .bf_open
                        cmp #"]"
                        jz .bf_close
                        jmp .bfloop

.bf_right:              inc16 bf_dp
                        jmp .bfincip
.bf_left:               dec16 bf_dp
                        jmp .bfincip
.bf_inc:                lda [bf_dp]
                        inc
                        sta [bf_dp]
                        jmp .bfincip
.bf_dec:                lda [bf_dp]
                        dec
                        sta [bf_dp]
                        jmp .bfincip
.bf_putc:               lda [bf_dp]
                        sta LCDDAT
                        jmp .bfincip
.bf_open:               lda [bf_dp]
                        cmp #0
                        jnz .bfincip
                            lda #1
                            sta .t0
..loop:                     lda .t0
                            cmp #0
                            jz ..done
                            inc16 bf_ip
                            lda [bf_ip]
                            cmp #"["
                            jz ..open
                            cmp #"]"
                            jz ..close
                            jmp ..loop
..open:                     inc .t0
                            jmp ..loop
..close:                    dec .t0
                            jmp ..loop
..done:                 jmp .bfloop
.bf_close:              lda [bf_dp]
                        cmp #0
                        jz .bfincip
                            lda #1
                            sta .t0
..loop:                     lda .t0
                            cmp #0
                            jz ..done
                            dec16 bf_ip
                            lda [bf_ip]
                            cmp #"["
                            jz ..open
                            cmp #"]"
                            jz ..close
                            jmp ..loop
..open:                     dec .t0
                            jmp ..loop
..close:                    inc .t0
                            jmp ..loop
..done:                 jmp .bfloop

.bfincip:               inc16 bf_ip
                        jmp .bfloop

.bfdone:                ret
.t0:                    #res 1



bf_ip:                  #res 2
bf_dp:                  #res 2

#align 1024*8
tape: