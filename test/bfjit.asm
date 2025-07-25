#include "../arch/isa.asm"

                        jmp start

#include "../lib/macros.asm"
#include "../lib/stack.asm"

#include "../lib/extra/lcd.asm"
#include "../lib/extra/lcd_hex.asm"




;CODE:                   #d "++[->+<]>.\0"
;CODE:                   #d "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.>++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.<.>.\0"
;CODE:                   #d "++++++[->++++++++++<]>+++++.\0"
;CODE:                   #d "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+." ;>++.\0"
CODE:                   #d "+++++++++++[>++++++>+++++++++>++++++++>++++>+++>+<<<<<<-]>++++++.>++.+++++++..+++.>>.>-.<<-.<.+++.------.--------.>>>+.\0"
;CODE:                   #d "-[------->+<]>---.---.++++++++.---[->++++<]>.++[->++<]>.[--->+<]>+++.-.-------------.+++++++++++.--------.-[--->+<]>-.>-[--->+<]>-.-[--->+<]>+.+++.--------.+++.\0"
CODELEN                 = $ - CODE

TAPE_SIZE               = 0x0100
JITBUF_ADDR             = 0x2000
TAPE_ADDR               = 0x8000



start:                  lcd_init

                        call bf_compile

bfstart:                
                        lcd_clear
                        lcd_goto 0, 1
                        lda counter+3
                        lcd_write_hex_byte
                        lda counter+2
                        lcd_write_hex_byte
                        lda counter+1
                        lcd_write_hex_byte
                        lda counter
                        lcd_write_hex_byte
                        lcd_goto 0, 0

                        call bf_clear_tape
                        jmp bf_jitbuf
bfdone:                
                        inc32 counter
                        
                        spin #0x0200
                        jmp bfstart

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

        emit #{imm: u8}, {addr: u16} => asm {
            emit #{imm}
            emit #lo({addr})
            emit #hi({addr})
        }

        ;emit_ret => asm {
        ;    ; TODO
        ;}
    }

    .entry:             st16 .cptr, #CODE
                        st16 .pc, #bf_jitbuf

    .lh:                lda [.cptr]
                        cmp #0
                        jz .end

        ..cr:           cmp #">"
                        jnz ..cl
                            emit #op_ldam, bf_dp
                            emit #op_addi
                            emit #1
                            emit #op_sta, bf_dp
                            emit #op_ldam, bf_dp+1
                            emit #op_adci
                            emit #0
                            emit #op_sta, bf_dp+1
                            jmp .lf
        ..cl:           cmp #"<"
                        jnz ..ci
                            emit #op_ldam, bf_dp
                            emit #op_subi
                            emit #1
                            emit #op_sta, bf_dp
                            emit #op_ldam, bf_dp+1
                            emit #op_sbci
                            emit #0
                            emit #op_sta, bf_dp+1
                            jmp .lf
        ..ci:           cmp #"+"
                        jnz ..cd
                            call .emit_ld_from_dp
                            emit #op_inc
                            call .emit_st_to_dp
                            jmp .lf
        ..cd:           cmp #"-"
                        jnz ..cp
                            call .emit_ld_from_dp
                            emit #op_dec
                            call .emit_st_to_dp
                            jmp .lf
        ..cp:           cmp #"."
                        jnz ..co
                            call .emit_ld_from_dp
                            emit #op_sta, LCDDAT
                            jmp .lf
        ..co:           cmp #"["
                        jnz ..cc
                            push16 .pc
                            call .emit_ld_from_dp
                            emit #op_cmpi
                            emit #0
                            emit #op_jz
                            push16 .pc
                            emit #0x00
                            emit #0x00
                            jmp .lf
        ..cc:           cmp #"]"
                        jnz .lf
                            pop16 .t1
                            pop16 .t0
                            emit #op_jmp
                            lda .t0
                            emit
                            lda .t0+1
                            emit
                            mov16 [.t1], .pc                   

    .lf:                inc16 .cptr
                        jmp .lh

    .end:               emit #op_jmp, bfdone ; TODO: replace with emit_ret
                        ret

    .emit_ld_from_dp: 
                        ; lda {addr}
                        emit #op_ldam, bf_dp
                        ; sta a+1
                        emit #op_sta
                        mov16 .t0, .pc
                        emit #0x00
                        emit #0x00
                        ; lda {addr}+1
                        emit #op_ldam, bf_dp+1
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
                        emit #op_sta
                        mov16 .t2, .pc
                        emit #0x00
                        emit #0x00
                        ; lda {addr}
                        emit #op_ldam, bf_dp
                        ; sta a+1
                        emit #op_sta
                        mov16 .t0, .pc
                        emit #0x00
                        emit #0x00
                        ; lda {addr}+1
                        emit #op_ldam, bf_dp+1
                        ; sta a+2
                        emit #op_sta
                        mov16 .t1, .pc
                        emit #0x00
                        emit #0x00
            ; a:        lda #0x00
                        emit #op_ldai
                        mov16 [.t2], .pc
                        emit #0x00
                        ; sta 0x0000
                        emit #op_sta
                        mov16 [.t0], .pc
                        emit #0x00
                        mov16 [.t1], .pc
                        emit #0x00
                        ret


bf_clear_tape:          st16 bf_dp, #(bf_tape + TAPE_SIZE)
.clear_loop:            dec16 bf_dp
                        stz [bf_dp]
                        lda #hi(bf_tape)
                        cmp bf_dp+1
                        jnz .clear_loop
                        lda #lo(bf_tape)
                        cmp bf_dp
                        jnz .clear_loop
                        ret



bf_dp:                  #d16 0x0000
counter:                #d32 0x00000000


#assert $ < JITBUF_ADDR
#addr JITBUF_ADDR
bf_jitbuf:

#addr TAPE_ADDR
bf_tape: