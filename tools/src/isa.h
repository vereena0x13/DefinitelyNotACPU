enum InsnFlag : u8 {
    INSN_IMM8   = 1,
    INSN_IMM16  = 2
};

#define INSTRUCTIONS(X)                       \
    X(nop,      0x00,   1,  2,  0           ) \
    X(ldz,      0x01,   1,  2,  0           ) \
    X(stz,      0x02,   3,  6,  INSN_IMM16  ) \
    X(ldai,     0x03,   2,  4,  INSN_IMM8   ) \
    X(ldam,     0x04,   3,  6,  INSN_IMM16  ) \
    X(sta,      0x05,   3,  6,  INSN_IMM16  ) \
    X(addi,     0x06,   2,  4,  INSN_IMM8   ) \
    X(addm,     0x07,   3,  7,  INSN_IMM16  ) \
    X(subi,     0x08,   2,  4,  INSN_IMM8   ) \
    X(subm,     0x09,   3,  7,  INSN_IMM16  ) \
    X(adci,     0x0A,   2,  4,  INSN_IMM8   ) \
    X(adcm,     0x0B,   3,  7,  INSN_IMM16  ) \
    X(sbci,     0x0C,   2,  4,  INSN_IMM8   ) \
    X(sbcm,     0x0D,   3,  7,  INSN_IMM16  ) \
    X(cmpi,     0x0E,   2,  4,  INSN_IMM8   ) \
    X(cmpm,     0x0F,   3,  7,  INSN_IMM16  ) \
    X(shli,     0x10,   2,  4,  INSN_IMM8   ) \
    X(shri,     0x11,   2,  7,  INSN_IMM8   ) \
    X(andi,     0x12,   2,  3,  INSN_IMM8   ) \
    X(xori,     0x13,   2,  4,  INSN_IMM8   ) \
    X(shl,      0x14,   1,  7,  0           ) \
    X(shr,      0x15,   1,  3,  0           ) \
    X(andm,     0x16,   3,  4,  INSN_IMM16  ) \
    X(xorm,     0x17,   3,  7,  INSN_IMM16  ) \
    X(shlm,     0x18,   3,  4,  INSN_IMM16  ) \
    X(shrm,     0x19,   3,  7,  INSN_IMM16  ) \
    X(ori,      0x1A,   2,  4,  INSN_IMM8   ) \
    X(ill0,     0x1B,   0,  0,  0           ) \
    X(ill1,     0x1C,   0,  0,  0           ) \
    X(ill2,     0x1D,   0,  0,  0           ) \
    X(orm,      0x1E,   3,  7,  INSN_IMM16  ) \
    X(ill3,     0x1F,   0,  0,  0           ) \
    X(jmp,      0x20,   3,  6,  INSN_IMM16  ) \
    X(jz,       0x21,   3,  6,  INSN_IMM16  ) \
    X(jc,       0x22,   3,  6,  INSN_IMM16  ) \
    X(jnz,      0x23,   3,  6,  INSN_IMM16  ) \
    X(jnc,      0x24,   3,  6,  INSN_IMM16  ) \
    X(stpc,     0x25,   3,  7,  0           ) \
    X(inc,      0x26,   1,  3,  0           ) \
    X(dec,      0x27,   1,  3,  0           ) \
    X(incm,     0x28,   3,  7,  INSN_IMM16  ) \
    X(decm,     0x29,   3,  7,  INSN_IMM16  )


#define X(name, op, size, cycles, flags) op_##name = op,
enum OpCode : u8 {
INSTRUCTIONS(X)
OP_COUNT
};
#undef X

#define X(name, op, size, cycles, flags) [op] = size,
u8 INSN_SIZE[256] = {
INSTRUCTIONS(X)
};
#undef X

#define X(name, op, size, cycles, flags) [op] = cycles,
u8 INSN_CYCLES[256] = {
INSTRUCTIONS(X)
};
#undef X

#define X(name, op, size, cycles, flags) [op] = flags,
u8 INSN_FLAGS[256] = {
INSTRUCTIONS(X)
};
#undef X

#define X(name, op, size, cycles, flags) [op] = #name,
rstr INSN_NAME[256] = {
INSTRUCTIONS(X)
};
#undef X