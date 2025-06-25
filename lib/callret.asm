#once


#ruledef {
    call {addr: u16} => asm {   ; 173 cy
        sub16 sp, sp, #2        ; 32
a:      stpc                    ; 7
        lda a+2                 ; 6
        add #(b - a - 1)        ; 4
        sta a+2                 ; 6
        lda a+1                 ; 6
        adc #0                  ; 4
        sta [sp], 2             ; 48
        lda a+2                 ; 6
        sta [sp], 1             ; 48
        jmp {addr}              ; 6
b:
    }

    ret => asm {                ; 110 cy
        lda [sp], 1             ; 30 
        sta a+2                 ; 6
        lda [sp], 2             ; 30
        sta a+1                 ; 6
        add16 sp, sp, #2        ; 32        
a:      jmp 0x0000              ; 6
    }
}