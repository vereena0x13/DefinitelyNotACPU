#include "../arch/isa.asm"


#ruledef {
    lda [{addr: u16}] => asm {
        lda {addr}
        sta $+10
        lda {addr}+1
        sta $+5
        lda 0x0000
    }

    sta [{addr: u16}] => asm {
        sta $+16
        lda {addr}
        sta $+12
        lda {addr}+1
        sta $+7
        lda #0x00
        sta 0x0000
    }
}


                lda [my_addr]
                
                #res 64

                lda #0x33
                sta [my_addr]
                lda #0x00

                #res 64
                
                lda [my_addr]

loop:           jmp loop


my_addr:        #d16 x
x:              #d8 0x5A


t0:             #res 1