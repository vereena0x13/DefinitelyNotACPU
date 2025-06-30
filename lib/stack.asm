#once


sp:     #d16 0xFFFF

#ruledef {
    push => asm {               ; 60 cy
        sta a-1                 ; 6
        lda sp                  ; 6
        sta a+1                 ; 6
        sub #1                  ; 4
        sta sp                  ; 6
        lda sp+1                ; 6
        sta a+2                 ; 6
        sbc #0                  ; 4
        sta sp+1                ; 6
        lda #0x00               ; 4
a:      sta 0x0000              ; 6
    }

    pop => asm {                ; 50 cy
        lda sp                  ; 6
        add #1                  ; 4
        sta sp                  ; 6
        sta a+1                 ; 6
        lda sp+1                ; 6
        adc #0                  ; 4
        sta sp+1                ; 6
        sta a+2                 ; 6
a:      lda 0x0000              ; 6
    }


    call {addr: u16} => asm {   ; 145 cy
a:      stpc                    ; 7
        lda sp                  ; 6
        sta c0+1                ; 6
        sub #1                  ; 4
        sta sp                  ; 6
        lda sp+1                ; 6
        sta c0+2                ; 6
        sbc #0                  ; 4
        sta sp+1                ; 6
        lda a+1                 ; 6
        add #(b - a - 1)        ; 4
        sta a+1                 ; 6
        lda a+2                 ; 6
        adc #0                  ; 4
c0:     sta 0x0000              ; 6
        lda sp                  ; 6
        sta c1+1                ; 6
        sub #1                  ; 4
        sta sp                  ; 6
        lda sp+1                ; 6
        sta c1+2                ; 6
        sbc #0                  ; 4
        sta sp+1                ; 6
        lda a+1                 ; 6
c1:     sta 0x0000              ; 6
        jmp {addr}              ; 6
b:
    }

    ret => asm {                ; 106 cy
        lda sp                  ; 6
        add #1                  ; 4
        sta b0+1                ; 6
        lda sp+1                ; 6
        adc #0                  ; 4
        sta b0+2                ; 6
b0:     lda 0x0000              ; 6
        sta a+1                 ; 6
        lda b0+1                ; 6
        add #1                  ; 4
        sta sp                  ; 6
        sta b1+1                ; 6
        lda b0+2                ; 6
        adc #0                  ; 4
        sta sp+1                ; 6
        sta b1+2                ; 6
b1:     lda 0x0000              ; 6
        sta a+2                 ; 6
a:      jmp 0x0000              ; 6
    }
}