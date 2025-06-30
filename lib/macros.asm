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

    stz [{addr: u16}] => asm {                                  ; 32 cy
        lda {addr}                                              ; 6
        sta a+1                                                 ; 6
        lda {addr}+1                                            ; 6
        sta a+2                                                 ; 6
        ldz                                                     ; 2
a:      stz 0x0000                                              ; 6
    }

    
    st16 {addr: u16}, #{imm: u16} => asm {
        lda #({imm} & 0xFF)
        sta {addr}
        lda #(({imm} >> 8) & 0xFF)
        sta {addr}+1
    }


    lda [{addr: u16}], {offset: u16} => asm {                   ; 38 cy
        lda {addr}                                              ; 6
        add #({offset} & 0xFF)                                  ; 4
        sta a+1                                                 ; 6
        lda {addr}+1                                            ; 6
        adc #(({offset} >> 8) & 0xFF)                           ; 4
        sta a+2                                                 ; 6
a:      lda 0x0000                                              ; 6
    }

    sta [{addr: u16}], {offset: u16} => asm {                   ; 48 cy
        sta a-1                                                 ; 6
        lda {addr}                                              ; 6
        add #({offset} & 0xFF)                                  ; 4
        sta a+1                                                 ; 6
        lda {addr}+1                                            ; 6
        adc #(({offset} >> 8) & 0xFF)                           ; 4
        sta a+2                                                 ; 6
        lda #0x00                                               ; 4
a:      sta 0x0000                                              ; 6
    }


    inc {addr: u16} => asm {
        lda {addr}
        add #1
        sta {addr}
    }

    dec {addr: u16} => asm {
        lda {addr}
        sub #1
        sta {addr}
    }


    add16 {dst: u16}, {src: u16}, #{imm: u16} => asm {          ; 32 cy
        lda {src}                                               ; 6               
        add #({imm} & 0xFF)                                     ; 4           
        sta {dst}                                               ; 6   
        lda {src}+1                                             ; 6   
        add #(({imm} >> 8) & 0xFF)                              ; 4                   
        sta {dst}+1                                             ; 6   
    }

    sub16 {dst: u16}, {src: u16}, #{imm: u16} => asm {          ; 32 cy
        lda {src}                                               ; 6
        sub #({imm} & 0xFF)                                     ; 4
        sta {dst}                                               ; 6
        lda {src}+1                                             ; 6
        sbc #(({imm} >> 8) & 0xFF)                              ; 4
        sta {dst}+1                                             ; 6
    }

    inc16 {addr: u16} => asm {                                  ; 32 cy
        add16 {addr}, {addr}, #1                                ; 32
    }

    dec16 {addr: u16} => asm {                                  ; 32 cy
        sub16 {addr}, {addr}, #1                                ; 32
    }


    spin => asm {
l:      jmp l
    }
}