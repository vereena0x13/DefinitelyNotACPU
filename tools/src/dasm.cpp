s32 disassemble(cstr path) {
    ByteBuf data;
    if(!data.read_from_file(path)) {
        printf("file not found: %s\n", path);
        return 1;
    }

    
    // TODO: add a more() function to ByteBuf that returns data.index < data.size
    while(data.index < data.size) {
        printf("%04X:    ", data.index);

        u8 op = data.read_u8();
        if(op < OP_COUNT) {
            s32 c = printf("%s", INSN_NAME[op]);

            u8 flags = INSN_FLAGS[op];
            if(flags & INSN_IMM8) {
                c += printf(" #%02X", data.read_u8());
            } else if(flags & INSN_IMM16) {
                c += printf(" %04X", data.read_u16());
            } else {
                data.index += INSN_SIZE[op] - 1;
            }

            for(s32 i = 0; i < 16 - c; i++) printf(" ");
            printf("; %d", INSN_CYCLES[op]);
        } else {
            printf("%02X", op);
        }

        printf("\n");
    }


    data.free();

    return 0;
}