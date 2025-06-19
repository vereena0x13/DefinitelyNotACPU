#include "../arch/isa.asm"


LCDCMD              = 0x7F00
LCDDAT              = 0x7F01


                    lda #0x38
                    sta LCDCMD
                    lda #0x06
                    sta LCDCMD
                    lda #0x0C
                    sta LCDCMD

                    lda #0x01
                    sta LCDCMD

                    lda #0x81
                    sta LCDCMD

                    ;lda #" "
                    ;sta LCDDAT
                    lda #"H"
                    sta LCDDAT
                    lda #"A"
                    sta LCDDAT
                    lda #"P"
                    sta LCDDAT
                    lda #"P"
                    sta LCDDAT
                    lda #"Y"
                    sta LCDDAT
                    lda #" "
                    sta LCDDAT
                    lda #"P"
                    sta LCDDAT
                    lda #"R"
                    sta LCDDAT
                    lda #"I"
                    sta LCDDAT
                    lda #"D"
                    sta LCDDAT
                    lda #"E"
                    sta LCDDAT
                    lda #" "
                    sta LCDDAT
                    lda #"M"
                    sta LCDDAT
                    lda #"Y"
                    sta LCDDAT

                    lda #0xC1
                    sta LCDCMD

                    ;lda #" "
                    ;sta LCDDAT
                    lda #"F"
                    sta LCDDAT
                    lda #"E"
                    sta LCDDAT
                    lda #"L"
                    sta LCDDAT
                    lda #"L"
                    sta LCDDAT
                    lda #"O"
                    sta LCDDAT
                    lda #"W"
                    sta LCDDAT
                    lda #" "
                    sta LCDDAT
                    lda #"F"
                    sta LCDDAT
                    lda #"A"
                    sta LCDDAT
                    lda #"G"
                    sta LCDDAT
                    lda #"G"
                    sta LCDDAT
                    lda #"O"
                    sta LCDDAT
                    lda #"T"
                    sta LCDDAT
                    lda #"S"
                    sta LCDDAT

loop:               #res 20
                    lda #0x08
                    sta LCDCMD
                    #res 20
                    lda #0x0C
                    sta LCDCMD
                    jmp loop