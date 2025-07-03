#include "../arch/isa.asm"

                        jmp start
                        #d16 (bf_jitbuf`16)

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

                        jmp 0xFFFF

                        spin




; NOTE TODO: this is dumb lmao, and not _that_ beneficial -- but.. w/e idfk man,
;            write a fucking assembler already or just tolerate the silliness. >_>
bf_compile:             jmp .entry

    .cptr:              #res 2
    .pc:                #res 2
    .t0:                #res 2
    .t1:                #res 2

    #ruledef {
        emit => asm {
            sta [.pc]
            inc16 .pc
        }

        emit #{imm: u8} => asm {
            lda #{imm}
            emit
        }

        emit_ldam {addr: u16} => asm {
            emit #op_ldam
            emit #({addr}[7:0])`8
            emit #({addr}[15:8])`8
        }

        emit_lda_ind {addr: u16} => asm {
            ; lda {addr}
            emit_ldam {addr}
            
            ; sta a+1
            emit #op_sta
            mov16 .t0, .pc
            emit #0x00
            emit #0x00
            
            ; lda {addr}+1
            emit_ldam {addr}+1
            
            ; sta a+2
            emit #op_sta
            mov16 .t1, .pc
            emit #0x00
            emit #0x00

; a:        lda 0x0000
            emit #op_ldam
            mov16 [.t0], .pc
            emit #0x00
            mov16 [.t1], .pc
            emit #0x00
        }
    }

    .entry:             st16 .cptr, #CODE
                        st16 .pc, #bf_jitbuf

                        lda .pc+1
                        sta 0xCCCC
                        lda .pc
                        sta 0xCCCC
                        ret

    .lh:                lda .cptr+1
                        cmp #(CODE + CODELEN)[15:8]
                        jnz .lb
                        lda .cptr
                        cmp #(CODE + CODELEN)[7:0]
                        jz .end
    .lb:                
                        lda [.cptr]

                        cmp #">"
                        jz ..right
                        cmp #"<"
                        jz ..left
                        cmp #"+"
                        jz ..inc
                        cmp #"-"
                        jz ..dec
                        cmp #"."
                        jz ..putc
                        cmp #"["
                        jz ..open
                        cmp #"]"
                        jz ..close
                        jmp .lf

        ..right:        ; TODO
                        jmp .lf
        ..left:         ; TODO
                        jmp .lf
        ..inc:          ; TODO
                        jmp .lf
        ..dec:          ; TODO
                        jmp .lf
        ..putc:         ; TODO
                        jmp .lf
        ..open:         ; TODO
                        jmp .lf
        ..close:        ; TODO
                        jmp .lf

    .lf:
                        inc16 .cptr
                        jmp .lh
    .end:               
                        ret

    .emit_ld_from_dp: 
                        emit_lda_ind bf_dp

                        ret

    .emit_st_to_dp:     ; TODO
                        ret



bf_dp:                  #d16 le(0x8000) ; #res 2

#align 1024*4
bf_jitbuf: