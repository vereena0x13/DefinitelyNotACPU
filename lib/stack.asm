#once


sp:     #d16 0xFFFF

#ruledef {
    push => asm {               ; 72 cy
        sta [sp]                ; 40
        dec16 sp                ; 32
    }

    pop => asm {                ; 62 cy
        inc16 sp                ; 32
        lda [sp]                ; 30
    }


    ; NOTE TODO: instead of doing sta a+2 after the add, we could
    ;            just sta [sp], 1 and remove the lda a+2 and the
    ;            sta [sp], 1 before the jmp -- except doing so clobbers
    ;            the carry flag which breaks the adc #0. that being
    ;            said, there's definitely still cycles squeeze out. :3
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

    ; NOTE TODO: we could almost certainly squeeze a few cycles
    ;            out of those two `lda [sp], x`s. hell... if we inlined
    ;            the ldas and the add16, surely there'd be a good,
    ;            idk, half dozen cycles that just fall out?
    ret => asm {                ; 126 cy
        lda [sp], 1             ; 38
        sta a+2                 ; 6
        lda [sp], 2             ; 38
        sta a+1                 ; 6
        add16 sp, sp, #2        ; 32
a:      jmp 0x0000              ; 6
    }
}