struct CPU {
    u16 pc;
    u8 upc;
    u8 flags;
    u8 ir;
    u8 a;
    u8 b;
    u16 mar;

    u8 *ram;

    CPU() {
        ram = cast(u8*, xalloc(0x10000));
        reset();
    }

    void free() {
        xfree(ram);
        ram = NULL;
    }

    void reset() {
        pc      = 0x0000;
        upc     = 0;
        flags   = 0;
        ir      = 0x00;
        a       = 0x00;
        b       = 0x00;
        mar     = 0x0000;
    }

    void cycle() {
        u32 uinsn                   = get_uinsn(ir, upc, flags); 


        //auto insn_name = ir < OP_COUNT ? INSN_NAME[ir] : "???";
        //printf("%04X:  %02X %s %02X  %X  %02X %02X %04X\n", pc, ir, insn_name, upc, flags, a, b, mar);

        //bool ctrl_d0                = (uinsn & SR_D0) == SR_D0;
        //bool ctrl_d1                = (uinsn & SR_D1) == SR_D1;
        //bool ctrl_d2                = (uinsn & SR_D2) == SR_D2;
        //bool ctrl_d3                = (uinsn & SR_D3) == SR_D3;
        //bool ctrl_d4                = (uinsn & SR_D4) == SR_D4;
        //bool ctrl_d5                = (uinsn & SR_D5) == SR_D5;
        //bool ctrl_d6                = (uinsn & SR_D6) == SR_D6;
        //bool ctrl_d7                = (uinsn & SR_D7) == SR_D7;
        //bool ctrl_d_rd              = (uinsn & SR_D_RD) == SR_D_RD;
        bool ctrl_alu_xorb          = (uinsn & SR_ALU_XORB) == SR_ALU_XORB;
        bool ctrl_alu_ci            = (uinsn & SR_ALU_CI) == SR_ALU_CI;
        bool ctrl_alu_bit_rd        = (uinsn & SR_ALU_BIT_RD) == SR_ALU_BIT_RD;
        bool ctrl_pc_rd             = (uinsn & SR_PC_RD) == SR_PC_RD;
        bool ctrl_pc_inc            = (uinsn & SR_PC_INC) == SR_PC_INC;
        bool ctrl_pc_ld             = (uinsn & SR_PC_LD) == SR_PC_LD;
        bool ctrl_mar_rd            = (uinsn & SR_MAR_RD) == SR_MAR_RD;
        bool ctrl_mar_lo_ld         = (uinsn & SR_MAR_LO_LD) == SR_MAR_LO_LD;
        bool ctrl_mar_hi_ld         = (uinsn & SR_MAR_HI_LD) == SR_MAR_HI_LD;
        bool ctrl_a_rd              = (uinsn & SR_A_RD) == SR_A_RD;
        bool ctrl_a_ld              = (uinsn & SR_A_LD) == SR_A_LD;
        bool ctrl_b_ld              = (uinsn & SR_B_LD) == SR_B_LD;
        bool ctrl_flags_ld          = (uinsn & SR_FLAGS_LD) == SR_FLAGS_LD;
        bool ctrl_upc_rst           = (uinsn & SR_UPC_RST) == SR_UPC_RST;
        bool ctrl_ram_rd            = (uinsn & SR_RAM_RD) == SR_RAM_RD;
        bool ctrl_ram_wr            = (uinsn & SR_RAM_WR) == SR_RAM_WR;
        bool ctrl_ir_ld             = (uinsn & SR_IR_LD) == SR_IR_LD;
        bool ctrl_addr_lo_to_d      = (uinsn & SR_ADDR_LO_TO_D) == SR_ADDR_LO_TO_D;
        bool ctrl_addr_hi_to_d      = (uinsn & SR_ADDR_HI_TO_D) == SR_ADDR_HI_TO_D;
        bool ctrl_d_to_mar_lo       = (uinsn & SR_D_TO_MAR_LO) == SR_D_TO_MAR_LO;
        bool ctrl_d_to_mar_hi       = (uinsn & SR_D_TO_MAR_HI) == SR_D_TO_MAR_HI;
        bool ctrl_upc_inc           = (uinsn & SR_UPC_INC) == SR_UPC_INC;
        bool ctrl_alu_rd            = (uinsn & SR_ALU_RD) == SR_ALU_RD;


        u8 data                     = 0x00;
        u16 addr                    = 0x0000;
        u8 _mar_lo;
        u8 _mar_hi;
        bool zero;
        bool carry;


        if(ctrl_pc_rd)          addr = pc;
        if(ctrl_mar_rd)         addr = mar;
        
        if(ctrl_a_rd)           data = a;
        if(ctrl_addr_lo_to_d)   data = cast(u8, addr & 0xFF);
        if(ctrl_addr_hi_to_d)   data = cast(u8, (addr >> 8) & 0xFF);
        if(ctrl_ram_rd)         data = ram[addr];
        
        if(ctrl_d_to_mar_lo)    _mar_lo = data;
        if(ctrl_d_to_mar_hi)    _mar_hi = data;


        if(ctrl_alu_rd) {
            u16 sum;
            u8 c        = ctrl_alu_ci ? 1 : 0;
            if(ctrl_alu_xorb) { // NOTE TODO: hack
                sum     = a - b + c - 1;
                carry   = (sum & 0x100) == 0;
            } else {
                sum     = a + b + c;
                carry   = sum > 0xFF;
            }
            data        = cast(u8, sum & 0xFF);
            zero        = data == 0;
        }

        if(ctrl_alu_bit_rd) {
            switch(ir & 0b00000011) {
                case 0: {
                    data = b << 1;
                    break;
                }
                case 1: {
                    data = b >> 1;
                    break;
                }
                case 2:
                case 3: {
                    switch(uinsn & (SR_ALU_XORB | SR_ALU_CI)) {
                        case ALU_BIT_AND: {
                            data = a & b;
                            break;
                        }
                        case ALU_BIT_OR: {
                            data = a | b;
                            break;
                        }
                        case ALU_BIT_XOR: {
                            data = a ^ b;
                            break;
                        }
                        case ALU_BIT_NOT: {
                            data = ~a;
                            break;
                        }
                        default: {
                            unreachable();
                            break;
                        }
                    }
                    break;
                }
                default: {
                    unreachable();
                    break;
                }
            }
        }


        if(ctrl_pc_ld)          pc          = addr;
        if(ctrl_mar_lo_ld)      mar         = (mar & 0xFF00) | cast(u16, _mar_lo);
        if(ctrl_mar_hi_ld)      mar         = (mar & 0x00FF) | (cast(u16, _mar_hi) << 8);

        if(ctrl_a_ld)           a           = data;
        if(ctrl_b_ld)           b           = data;

        if(ctrl_flags_ld)       flags       = (zero ? 1 : 0) | (carry ? 2 : 0);
        if(ctrl_ram_wr)         ram[addr]   = data;
        if(ctrl_ir_ld)          ir          = data;

        if(ctrl_pc_inc)         pc          = pc + 1;
        if(ctrl_upc_inc)        upc         = (upc + 1) & 0xF;
        if(ctrl_upc_rst)        upc         = 0;


        if(ctrl_ram_wr && addr == 0xCCCC) printf("%02X\n", data);
        if(ctrl_ram_wr && addr == 0xCCCD) printf("%02X", data);
        if(ctrl_ram_wr && addr == 0x7F01) putchar(data);
    }
};


s32 emulate(cstr file) {
    ByteBuf data;
    if(!data.read_from_file(file)) {
        printf("file not found: %s\n", file);
        return 1;
    }

    auto cpu = xnew(CPU);

    memcpy(cpu->ram, data.data, data.size);
    data.free();

    while(cpu->pc != 0xFFFF) cpu->cycle();

    //hexdump(cpu->ram + 0x0600, 0x200);

    cpu->free();
    xfree(cpu);

    return 0;
}