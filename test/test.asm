#include "../arch/isa.asm"




loop:           lda a
                add b
                sta t0
                lda b
                sta a
                lda t0
                sta b

                lda left
                sub #1
                jz done
                sta left
                jmp loop


done:           lda b

                #res 16

                lda #1
                lda #2
                lda #4
                lda #8
                lda #16
                lda #32
                lda #64
                lda #128
                lda #64
                lda #32
                lda #16
                lda #8
                lda #4
                lda #2
                lda #1
                lda #2
                lda #4
                lda #8
                lda #16
                lda #32
                lda #64
                lda #128
                lda #64
                lda #32
                lda #16
                lda #8
                lda #4
                lda #2
                lda #1
                lda #2
                lda #4
                lda #8
                lda #16
                lda #32
                lda #64
                lda #128
                lda #64
                lda #32
                lda #16
                lda #8
                lda #4
                lda #2
                lda #1
                lda #2
                lda #4
                lda #8
                lda #16
                lda #32
                lda #64
                lda #128
                lda #64
                lda #32
                lda #16
                lda #8
                lda #4
                lda #2
                lda #1
                lda #2
                lda #4
                lda #8
                lda #16
                lda #32
                lda #64
                lda #128
                lda #64
                lda #32
                lda #16
                lda #8
                lda #4
                lda #2
                lda #1
                lda #2
                lda #4
                lda #8
                lda #16
                lda #32
                lda #64
                lda #128
                lda #64
                lda #32
                lda #16
                lda #8
                lda #4
                lda #2
                lda #1
                lda #2
                lda #4
                lda #8
                lda #16
                lda #32
                lda #64
                lda #128
                lda #64
                lda #32
                lda #16
                lda #8
                lda #4
                lda #2
                lda #1
                lda #2
                lda #4
                lda #8
                lda #16
                lda #32
                lda #64
                lda #128
                lda #64
                lda #32
                lda #16
                lda #8
                lda #4
                lda #2
                lda #1
                
                lda #0
                #res 16

                lda #12
                sta left
                lda #0
                sta a
                lda #1
                sta b

                jmp loop    


left:           #d8 12
a:              #d8 0
b:              #d8 1
t0:             #res 1