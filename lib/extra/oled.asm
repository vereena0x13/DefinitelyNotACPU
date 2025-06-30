#once


OLED_DAT                         = 0x7F00
OLED_CMD                         = 0x7F01

OLED_WIDTH   					= 128
OLED_HEIGHT  					= 64


SSD1325_SETCOLADDR  			= 0x15
SSD1325_SETROWADDR  			= 0x75
SSD1325_SETCONTRAST 			= 0x81
SSD1325_SETCURRENT  			= 0x84

SSD1325_SETREMAP 				= 0xA0
SSD1325_SETSTARTLINE 			= 0xA1
SSD1325_SETOFFSET 				= 0xA2
SSD1325_NORMALDISPLAY 			= 0xA4
SSD1325_DISPLAYALLON 			= 0xA5
SSD1325_DISPLAYALLOFF 			= 0xA6
SSD1325_INVERTDISPLAY 			= 0xA7
SSD1325_SETMULTIPLEX 			= 0xA8
SSD1325_MASTERCONFIG 			= 0xAD
SSD1325_DISPLAYOFF 				= 0xAE
SSD1325_DISPLAYON 				= 0xAF

SSD1325_SETPRECHARGECOMPENABLE 	= 0xB0
SSD1325_SETPHASELEN 			= 0xB1
SSD1325_SETROWPERIOD 			= 0xB2
SSD1325_SETCLOCK 				= 0xB3
SSD1325_SETPRECHARGECOMP 		= 0xB4
SSD1325_SETGRAYTABLE 			= 0xB8
SSD1325_SETPRECHARGEVOLTAGE 	= 0xBC
SSD1325_SETVCOMLEVEL 			= 0xBE
SSD1325_SETVSL 					= 0xBF

SSD1325_GFXACCEL 				= 0x23
SSD1325_DRAWRECT 				= 0x24
SSD1325_COPY 					= 0x25


#ruledef {
    oled_init => asm {
        ; TODO: reset?

        oled_command SSD1325_DISPLAYOFF

        oled_command SSD1325_SETCLOCK
        oled_command 0xF1
        oled_command SSD1325_SETMULTIPLEX
        oled_command 0x3F
        oled_command SSD1325_SETOFFSET
        oled_command 0x4C
        oled_command SSD1325_SETSTARTLINE
        oled_command 0x00
        oled_command SSD1325_MASTERCONFIG
        oled_command 0x02
        oled_command SSD1325_SETREMAP
        oled_command 0x56

        oled_command SSD1325_SETCURRENT + 0x02

        oled_command SSD1325_SETGRAYTABLE
        oled_command 0x01
        oled_command 0x11
        oled_command 0x22
        oled_command 0x32
        oled_command 0x43
        oled_command 0x54
        oled_command 0x65
        oled_command 0x76

        oled_command SSD1325_SETCONTRAST
        oled_command 0x7F

        oled_command SSD1325_SETROWPERIOD
        oled_command 0x51
        oled_command SSD1325_SETPHASELEN
        oled_command 0x55
        oled_command SSD1325_SETPRECHARGECOMP
        oled_command 0x02
        oled_command SSD1325_SETPRECHARGECOMPENABLE
        oled_command 0x28
        oled_command SSD1325_SETVCOMLEVEL
        oled_command 0x1C                
        oled_command SSD1325_SETVSL      
        oled_command 0x0D | 0x02

        oled_command SSD1325_NORMALDISPLAY
        oled_command SSD1325_DISPLAYON
    }

    oled_command {imm: u8} => asm {
        lda #{imm}
        sta OLED_CMD
    }

    oled_data {imm: u8} => asm {
        lda #{imm}
        sta OLED_DAT
    }
}