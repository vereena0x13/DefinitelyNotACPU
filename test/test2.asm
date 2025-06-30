#include "../arch/isa.asm"

                        jmp start


#include "../lib/macros.asm"
#include "../lib/stack.asm"

#include "../lib/extra/oled.asm"




start:                  oled_init


                        oled_command SSD1325_DRAWRECT
                        oled_command 2
                        oled_command 3
                        oled_command 7
                        oled_command 5
                        oled_command 0x39


                        #res 128
                        jmp start


l00p5ever:              #res 64
                        jmp l00p5ever