#once


sp:                     #d16 0xFFFF

#ruledef {
    push => asm {       ; 72
        sta [sp]        ; 40
        dec16 sp        ; 32
    }
    
    pop => asm {        ; 62
        inc16 sp        ; 32
        lda [sp]        ; 30
    }
}