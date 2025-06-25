#once


#ruledef {
    lda [{addr: u16}] => asm {                      ; 30 cy
        lda {addr}+1                                ; 6
        sta a+2                                     ; 6
        lda {addr}                                  ; 6
        sta a+1                                     ; 6
a:      lda 0x0000                                  ; 6
    }

    sta [{addr: u16}] => asm {                      ; 40 cy
        sta a-1                                     ; 6
        lda {addr}+1                                ; 6
        sta a+2                                     ; 6
        lda {addr}                                  ; 6
        sta a+1                                     ; 6
        lda #0x00                                   ; 4
a:      sta 0x0000                                  ; 6
    }


    lda [{addr: u16}], {offset: u16} => asm {       ; 38 cy
        lda {addr}+1                                ; 6
        add #({offset} & 0xFF)                      ; 4
        sta a+2                                     ; 6
        lda {addr}                                  ; 6
        adc #(({offset} >> 8) & 0xFF)               ; 4
        sta a+1                                     ; 6
a:      lda 0x0000                                  ; 6
    }

    sta [{addr: u16}], {offset: u16} => asm {       ; 48 cy
        sta a-1                                     ; 6
        lda {addr}+1                                ; 6
        add #({offset} & 0xFF)                      ; 4
        sta a+2                                     ; 6
        lda {addr}                                  ; 6
        adc #(({offset} >> 8) & 0xFF)               ; 4
        sta a+1                                     ; 6
        lda #0x00                                   ; 4
a:      sta 0x0000                                  ; 6
    }


    inc16 {addr: u16} => asm {                      ; 32 cy
        lda {addr}+1                                ; 6
        add #1                                      ; 4
        sta {addr}+1                                ; 6
        lda {addr}                                  ; 6
        adc #0                                      ; 4
        sta {addr}                                  ; 6
    }

    dec16 {addr: u16} => asm {                      ; 32 cy                                      
        lda {addr}+1                                ; 6    
        sub #1                                      ; 4
        sta {addr}+1                                ; 6    
        lda {addr}                                  ; 6    
        sbc #0                                      ; 4
        sta {addr}                                  ; 6    
    }
}