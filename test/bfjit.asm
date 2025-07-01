#include "../arch/isa.asm"

                        jmp start

#include "../lib/macros.asm"
#include "../lib/stack.asm"

#include "../lib/extra/lcd.asm"
#include "../lib/extra/lcd_hex.asm"



;CODE:                  #d "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+." ;>++."
CODE:                   #d "+++++++++++[>++++++>+++++++++>++++++++>++++>+++>+<<<<<<-]>++++++.>++.+++++++..+++.>>.>-.<<-.<.+++.------.--------.>>>+."
CODELEN                 = $ - CODE
TAPE_SIZE               = 0x100




start:                  lcd_init
                        lcd_clear
                        lcd_goto 0, 0

                        call bf_compile

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

                        ;#res 1024*8
                        ;jmp start

                        spin



bf_compile:             st16 .cptr, #CODE
                        st16 .pc, #bf_jitbuf

    .lh:                lda .cptr+1
                        cmp #(CODE + CODELEN)[15:8]
                        jnz .lb
                        lda .cptr
                        cmp #(CODE + CODELEN)[7:0]
                        jz .end
    .lb:                
                        lda [.cptr]
                        cmp #">"
                        jz .right
                        cmp #"<"
                        jz .left
                        cmp #"+"
                        jz .inc
                        cmp #"-"
                        jz .dec
                        cmp #"."
                        jz .putc
                        cmp #"["
                        jz .open
                        cmp #"]"
                        jz .close
                        jmp .lf

        .right:         ; TODO
                        jmp .lf
        .left:          ; TODO
                        jmp .lf
        .inc:           ; TODO
                        jmp .lf
        .dec:           ; TODO
                        jmp .lf
        .putc:          ; TODO
                        jmp .lf
        .open:          ; TODO
                        jmp .lf
        .close:         ; TODO
                        jmp .lf

    .lf:
                        inc16 .cptr
                        jmp .lh
    .end:               
                        ret
    .cptr:              #res 2
    .pc:                #res 2




bf_dp:                  #d16 le(0x8000) ; #res 2

#align 1024*8
bf_jitbuf: