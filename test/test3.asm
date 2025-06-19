#include "../arch/isa.asm"


N               = 64


                lda x
                #res N

                stz x
                #res N

                lda x

loop:           jmp loop


x:              #d8 0x5A