ARDUINO_PORT?=/dev/ttyUSB0
PROGRAM?=test

.PHONY: program cpu_ctrl ucode asm

program: cpu_ctrl
	arduino-cli upload -b arduino:avr:nano -p ${ARDUINO_PORT} cpu_ctrl

cpu_ctrl: ucode asm
	arduino-cli compile -b arduino:avr:nano --library cpu_ctrl cpu_ctrl

ucode:
	customasm -f hexcomma -o cpu_ctrl/ucode.h arch/ucode.asm

asm:
	customasm -f hexcomma -o cpu_ctrl/program.h "test/${PROGRAM}.asm"