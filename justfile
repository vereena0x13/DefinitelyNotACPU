ucode:
    customasm -f hexcomma -o cpu_ctrl/ucode_zc.h -dFLAG_Z=0 -dFLAG_C=0 arch/ucode.asm
    customasm -f hexcomma -o cpu_ctrl/ucode_Zc.h -dFLAG_Z=1 -dFLAG_C=0 arch/ucode.asm
    customasm -f hexcomma -o cpu_ctrl/ucode_zC.h -dFLAG_Z=0 -dFLAG_C=1 arch/ucode.asm
    customasm -f hexcomma -o cpu_ctrl/ucode_ZC.h -dFLAG_Z=1 -dFLAG_C=1 arch/ucode.asm

program prog port="/dev/ttyUSB0": (ctrl prog)
    arduino-cli upload -b arduino:avr:nano -p {{port}} cpu_ctrl

ctrl prog: ucode (asm prog)
    arduino-cli compile -b arduino:avr:nano --library cpu_ctrl cpu_ctrl

asm prog:
    customasm -f hexcomma -o cpu_ctrl/program.h "test/{{prog}}.asm"

clean:
    rm -f cpu_ctrl/ucode*
    rm -f cpu_ctrl/program.h