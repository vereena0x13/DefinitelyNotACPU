#include "../arch/isa.asm"

                        jmp start


#include "../lib/macros.asm"
#include "../lib/stack.asm"
#include "../lib/oled.asm"




start:                  lda #1

                        N = 512
loop:                   shl
                        #res N
                        shl
                        #res N
                        shl
                        #res N
                        shl
                        #res N
                        shl
                        #res N
                        shl
                        #res N
                        shl
                        #res N
                        shr
                        #res N
                        shr
                        #res N
                        shr
                        #res N
                        shr
                        #res N
                        shr
                        #res N
                        shr
                        #res N
                        shr
                        #res N
                        jmp loop