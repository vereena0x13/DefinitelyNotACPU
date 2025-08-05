struct Label {
    u32 index;
    s32 addr = -1;

    Label(u32 index) : index(index) {}
};

struct Assembler {
    Assembler() {}

    void free() {
        labels.free();
        patches.free();
    }

    Label* label() {
        auto i = labels.push(Label(labels.count));
        return &labels[i];
    }

    void mark(Label *l) {
        l->addr = buf.index;
    }

    void nop()              { emit(OP_NOP); }

    void ldz()              { emit(OP_LDZ); }
    void stz(Label *l)      { emit(OP_STZ, l); }
    void stz(u16 a)         { emit(OP_STZ, a); }

    void ldai(u8 x)         { emit(OP_LDAI, x); }
    void ldam(Label *l)     { emit(OP_LDAM, l); }
    void ldam(u16 a)        { emit(OP_LDAM, a); }

    void sta(Label *l)      { emit(OP_STA, l); }
    void sta(u16 a)         { emit(OP_STA, a); }

    void addi(u8 x)         { emit(OP_ADDI, x); }
    void addm(Label *l)     { emit(OP_ADDM, l); }
    void addm(u16 a)        { emit(OP_ADDM, a); }
    void subi(u8 x)         { emit(OP_SUBI, x); }
    void subm(Label *l)     { emit(OP_SUBM, l); }
    void subm(u16 a)        { emit(OP_SUBM, a); }
    void adci(u8 x)         { emit(OP_ADCI, x); }
    void adcm(Label *l)     { emit(OP_ADCM, l); }
    void adcm(u16 a)        { emit(OP_ADCM, a); }
    void sbci(u8 x)         { emit(OP_SBCI, x); }
    void sbcm(Label *l)     { emit(OP_SBCM, l); }
    void sbcm(u16 a)        { emit(OP_SBCM, a); }

    void cmpi(u8 x)         { emit(OP_CMPI, x); }
    void cmpm(Label *l)     { emit(OP_CMPM, l); }
    void cmpm(u16 a)        { emit(OP_CMPM, a); }

    void shli(u8 x)         { emit(OP_SHLI, x); }
    void shri(u8 x)         { emit(OP_SHRI, x); }
    void andi(u8 x)         { emit(OP_ANDI, x); }
    void xori(u8 x)         { emit(OP_XORI, x); }
    void shl()              { emit(OP_SHL); }
    void shr()              { emit(OP_SHR); }
    void andm(Label *l)     { emit(OP_ANDM, l); }
    void andm(u16 a)        { emit(OP_ANDM, a); }
    void xorm(Label *l)     { emit(OP_XORM, l); }
    void xorm(u16 a)        { emit(OP_XORM, a); }
    void shlm(Label *l)     { emit(OP_SHLM, l); }
    void shlm(u16 a)        { emit(OP_SHLM, a); }
    void shrm(Label *l)     { emit(OP_SHRM, l); }
    void shrm(u16 a)        { emit(OP_SHRM, a); }
    void ori(u8 x)          { emit(OP_ORI, x); }
    void orm(Label *l)      { emit(OP_ORM, l); }
    void orm(u16 a)         { emit(OP_ORM, a); }

    void jmp(Label *l)      { emit(OP_JMP, l); }
    void jmp(u16 a)         { emit(OP_JMP, a); }
    void jz(Label *l)       { emit(OP_JZ, l); }
    void jz(u16 a)          { emit(OP_JZ, a); }
    void jc(Label *l)       { emit(OP_JC, l); }
    void jc(u16 a)          { emit(OP_JC, a); }
    void jnz(Label *l)      { emit(OP_JNZ, l); }
    void jnz(u16 a)         { emit(OP_JNZ, a); }
    void jnc(Label *l)      { emit(OP_JNC, l); }
    void jnc(u16 a)         { emit(OP_JNC, a); }

    void stpc()             { emit(OP_STPC); }

    void inc()              { emit(OP_INC); }
    void dec()              { emit(OP_DEC); }
    
    void incm(Label *l)     { emit(OP_INCM, l); }
    void incm(u16 a)        { emit(OP_INCM, a); }
    void decm(Label *l)     { emit(OP_DECM, l); }
    void decm(u16 a)        { emit(OP_DECM, a); }

private:
    struct Patch {
        u32 index;
        u32 addr;
        
        Patch(u32 _index, u32 _addr) : index(_index), addr(_addr) {}
    };

    ByteBuf buf;
    Array<Label> labels;
    Array<Patch> patches;

    void emit(u8 opcode) {
        buf.write_u8(opcode);
    }
    
    void emit(u8 opcode, Label *l) {
        buf.write_u8(opcode);
        patches.push(Patch(l->index, buf.index));
        buf.write_u16(0);
    }

    void emit(u8 opcode, u16 a) {
        buf.write_u8(opcode);
        buf.write_u16(a);
    }
};