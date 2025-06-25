#once


#ruledef {
    call {addr: u16} => asm {
pc:     stpc
        lda pc+2
        add #(pc2 - pc - 1)
        sta pc+2
        lda pc+1
        adc #0
        push
        lda pc+2
        push
        jmp {addr}
pc2:    
    }

    ret => asm {
        pop
        sta pc+2
        pop
        sta pc+1
pc:     jmp 0x0000
    }
}