#include "../arch/isa.asm"

                        jmp start
                        #d16 (bf_jitbuf`16)

#include "../lib/macros.asm"
#include "../lib/stack.asm"

#include "../lib/extra/lcd.asm"
#include "../lib/extra/lcd_hex.asm"



CODE:                   #d "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++."
;CODE:                  #d "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+." ;>++."
;CODE:                   #d "+++++++++++[>++++++>+++++++++>++++++++>++++>+++>+<<<<<<-]>++++++.>++.+++++++..+++.>>.>-.<<-.<.+++.------.--------.>>>+."
CODELEN                 = $ - CODE
TAPE_SIZE               = 0x100




start:                  lcd_init
                        lcd_clear
                        lcd_goto 0, 0

                        call bf_compile
                        call bf_clear_tape

                        nop
                        jmp bf_jitbuf
bfdone:                                     

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
    .t2:                #res 2

    #ruledef {
        emit => asm {
            sta [.pc]
            inc16 .pc
        }

        emit #{imm: u8} => asm {
            lda #{imm}
            emit
        }

        emit_addr {addr: u16} => asm {
            emit #({addr}[7:0])`8
            emit #({addr}[15:8])`8
        }

        emit_ldam {addr: u16} => asm {
            emit #op_ldam
            emit_addr {addr}
        }

        emit_sta {addr: u16} => asm {
            emit #op_sta
            emit_addr {addr}
        }

        emit_jmp {addr: u16} => asm {
            emit #op_jmp
            emit_addr {addr}
        }

        emit_ret => asm {
            ; TODO
        }
    }

    .entry:             st16 .cptr, #CODE
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
        ..inc:          call .emit_ld_from_dp
                        emit #op_inc
                        call .emit_st_to_dp
                        jmp .lf
        ..dec:          ;call .emit_ld_from_dp
                        ;emit #op_dec
                        ;call .emit_st_to_dp
                        jmp .lf
        ..putc:         call .emit_ld_from_dp
                        emit_sta LCDDAT
                        jmp .lf
        ..open:         ;call .emit_ld_from_dp
                        ; TODO
                        jmp .lf
        ..close:        ;call .emit_ld_from_dp
                        ; TODO
                        jmp .lf

    .lf:
                        inc16 .cptr
                        jmp .lh

    .end:               emit_jmp bfdone ; TODO: replace with emit_ret
                        lda .pc+1
                        sta 0xcccc
                        lda .pc
                        sta 0xcccc
                        ret

    .emit_ld_from_dp: 
                        ; lda {addr}
                        emit_ldam bf_dp
                        ; sta a+1
                        emit #op_sta
                        mov16 .t0, .pc
                        emit #0x00
                        emit #0x00
                        ; lda {addr}+1
                        emit_ldam bf_dp+1
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
                        ret

    .emit_st_to_dp:     
                        ; sta a+1
;                        emit #op_sta
;                        mov16 .t2, .pc
;                        emit #0x00
;                        emit #0x00
;                        ; lda {addr}
;                        emit_ldam bf_dp
;                        ; sta a+1
;                        emit #op_sta
;                        mov16 .t0, .pc
;                        emit #0x00
;                        emit #0x00
;                        ; lda {addr}+1
;                        emit_ldam bf_dp+1
;                        ; sta a+2
;                        emit #op_sta
;                        mov16 .t1, .pc
;                        emit #0x00
;                        emit #0x00
;            ; a:        lda #0x00
;                        emit #op_ldai
;                        mov16 [.t2], .pc
;                        emit #0x00
;                        ; sta 0x0000
;                        emit #op_sta
;                        mov16 [.t0], .pc
;                        emit #0x00
;                        mov16 [.t1], .pc
;                        emit #0x00
                        ret


bf_clear_tape:          st16 bf_dp, #(bf_tape + TAPE_SIZE)
.clear_loop:            dec16 bf_dp
                        stz [bf_dp]
                        lda #bf_tape[15:8]
                        cmp bf_dp+1
                        jnz .clear_loop
                        lda #bf_tape[7:0]
                        cmp bf_dp
                        jnz .clear_loop
                        ret



bf_dp:                  #res 2


JITBUF_ADDR = 0x4000
TAPE_ADDR   = 0x6000

#assert $ < JITBUF_ADDR
#addr JITBUF_ADDR
bf_jitbuf:

#addr TAPE_ADDR
bf_tape: