#include "../isa/arch.asm"


                lda x
                sub #0x02
                sta x
                lda y
                sbc #0x00
                sta y

                lda x

loop:           jmp loop

x:              #d8 0x00
y:              #d8 0x02