#once


#ruledef {
    lda [{addr: u16}] => asm {                                  ; 30 cy
        lda {addr}                                              ; 6
        sta a+1                                                 ; 6
        lda {addr}+1                                            ; 6
        sta a+2                                                 ; 6
a:      lda 0x0000                                              ; 6
    }

    sta [{addr: u16}] => asm {                                  ; 40 cy
        sta a-1                                                 ; 6
        lda {addr}                                              ; 6
        sta a+1                                                 ; 6
        lda {addr}+1                                            ; 6
        sta a+2                                                 ; 6
        lda #0x00                                               ; 4
a:      sta 0x0000                                              ; 6
    }

    stz [{addr: u16}] => asm {                                  ; 30 cy
        lda {addr}                                              ; 6
        sta a+1                                                 ; 6
        lda {addr}+1                                            ; 6
        sta a+2                                                 ; 6
a:      stz 0x0000                                              ; 6
    }

    
    st16 {addr: u16}, #{imm: u16} => asm {                      ; 20 cy
        lda #lo({imm})                                          ; 4
        sta {addr}                                              ; 6
        lda #hi({imm})                                          ; 4
        sta {addr}+1                                            ; 6
    }

    mov16 {dst: u16}, {src: u16} => asm {                       ; 24 cy
        lda {src}                                               ; 6
        sta {dst}                                               ; 6
        lda {src}+1                                             ; 6
        sta {dst}+1                                             ; 6
    }


    mov16 [{dst: u16}], {src: u16} => asm {                     ; 100 cy
        lda {src}                                               ; 6
        sta [{dst}]                                             ; 40
        lda {src}+1                                             ; 6
        sta [{dst}], 1                                          ; 48
    }


    lda [{addr: u16}], {offset: u16} => asm {                   ; 38 cy
        lda {addr}                                              ; 6
        add #lo({offset})                                       ; 4
        sta a+1                                                 ; 6
        lda {addr}+1                                            ; 6
        adc #hi({offset})                                       ; 4
        sta a+2                                                 ; 6
a:      lda 0x0000                                              ; 6
    }

    sta [{addr: u16}], {offset: u16} => asm {                   ; 48 cy
        sta a-1                                                 ; 6
        lda {addr}                                              ; 6
        add #lo({offset})                                       ; 4
        sta a+1                                                 ; 6
        lda {addr}+1                                            ; 6
        adc #hi({offset})                                       ; 4
        sta a+2                                                 ; 6
        lda #0x00                                               ; 4
a:      sta 0x0000                                              ; 6
    }


    add16 {dst: u16}, {src: u16}, #{imm: u16} => asm {          ; 32 cy
        lda {src}                                               ; 6               
        add #lo({imm})                                          ; 4           
        sta {dst}                                               ; 6   
        lda {src}+1                                             ; 6   
        adc #hi({imm})                                          ; 4                   
        sta {dst}+1                                             ; 6   
    }

    add32 {dst: u16}, {src: u16}, #{imm: u32} => asm {          ; 64 cy
        lda {src}                                               ; 6               
        add #lo({imm})                                          ; 4           
        sta {dst}                                               ; 6   
        lda {src}+1                                             ; 6   
        adc #hi({imm})                                          ; 4                   
        sta {dst}+1                                             ; 6   
        lda {src}+2                                             ; 6   
        adc #hi({imm})                                          ; 4                   
        sta {dst}+2                                             ; 6   
        lda {src}+3                                             ; 6   
        adc #hi({imm})                                          ; 4                   
        sta {dst}+3                                             ; 6   
    }

    sub16 {dst: u16}, {src: u16}, #{imm: u16} => asm {          ; 32 cy
        lda {src}                                               ; 6
        sub #lo({imm})                                          ; 4
        sta {dst}                                               ; 6
        lda {src}+1                                             ; 6
        sbc #hi({imm})                                          ; 4
        sta {dst}+1                                             ; 6
    }

    sub32 {dst: u16}, {src: u16}, #{imm: u32} => asm {          ; 64 cy
        lda {src}                                               ; 6
        sub #lo({imm})                                          ; 4
        sta {dst}                                               ; 6
        lda {src}+1                                             ; 6
        sbc #hi({imm})                                          ; 4
        sta {dst}+1                                             ; 6
        lda {src}+2                                             ; 6
        sbc #hi({imm})                                          ; 4
        sta {dst}+2                                             ; 6
        lda {src}+3                                             ; 6
        sbc #hi({imm})                                          ; 4
        sta {dst}+3                                             ; 6
    }

    inc16 {addr: u16} => asm {                                  ; 32 cy
        add16 {addr}, {addr}, #1                                ; 32
    }

    inc32 {addr: u16} => asm {                                  ; 64 cy
        add32 {addr}, {addr}, #1                                ; 64
    }

    dec16 {addr: u16} => asm {                                  ; 32 cy
        sub16 {addr}, {addr}, #1                                ; 32
    }

    dec32 {addr: u16} => asm {                                  ; 64 cy
        sub32 {addr}, {addr}, #1                                ; 64
    }


    spin => asm {                                               ; 6 cy
l:      jmp l                                                   ; 6
    }


    spin #{imm: u16} => asm {
        lda #lo({imm})
        sta a
        lda #hi({imm})
        sta a+1
l:      lda a+1
        cmp #0
        jnz c
        lda a
        cmp #0
        jz b
c:      lda a
        sub #1
        sta a
        lda a+1
        sbc #0
        sta a+1
        jmp l
a:      nop
        nop
b:
    }
}