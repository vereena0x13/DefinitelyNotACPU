#include "../arch/isa.asm"

                        jmp start




start:                  lda #1

                        ;N = 512
                        N = 4
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