#once


#ruledef {
    call {addr: u16} => asm {   ; 189 cy
pc:     stpc                    ; 7
        lda pc+2                ; 6
        add #(pc2 - pc - 1)     ; 4
        sta pc+2                ; 6
        lda pc+1                ; 6
        adc #0                  ; 4
        push                    ; 72
        lda pc+2                ; 6
        push                    ; 72
        jmp {addr}              ; 6
pc2:    
    }

    ret => asm {                ; 142 cy
        pop                     ; 62
        sta pc+2                ; 6
        pop                     ; 62
        sta pc+1                ; 6
pc:     jmp 0x0000              ; 6
    }
}