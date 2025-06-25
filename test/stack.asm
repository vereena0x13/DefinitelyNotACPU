#once


sp:                     #d16 0xFFFF

#ruledef {
    push => asm {
        sta [sp]
        dec16 sp
    }
    
    pop => asm {
        inc16 sp
        lda [sp]
    }
}