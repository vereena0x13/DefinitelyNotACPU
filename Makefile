PORT?=/dev/ttyUSB0
PROGRAM?=test

.PHONY: program cpu_ctrl ucode asm clean

program: cpu_ctrl
	arduino-cli upload -b arduino:avr:nano -p ${PORT} cpu_ctrl

cpu_ctrl: ucode asm
	arduino-cli compile -b arduino:avr:nano --library cpu_ctrl cpu_ctrl

ucode:
	customasm -f hexcomma -o cpu_ctrl/ucode_zc.h -dFLAG_Z=0 -dFLAG_C=0 arch/ucode.asm
	customasm -f hexcomma -o cpu_ctrl/ucode_Zc.h -dFLAG_Z=1 -dFLAG_C=0 arch/ucode.asm
	customasm -f hexcomma -o cpu_ctrl/ucode_zC.h -dFLAG_Z=0 -dFLAG_C=1 arch/ucode.asm
	customasm -f hexcomma -o cpu_ctrl/ucode_ZC.h -dFLAG_Z=1 -dFLAG_C=1 arch/ucode.asm

asm:
	customasm -f hexcomma -o cpu_ctrl/program.h "test/${PROGRAM}.asm"

clean:
	rm -f cpu_ctrl/ucode*
	rm -f cpu_ctrl/program.h