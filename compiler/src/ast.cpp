struct Ast {

};


struct Ast_Expr : public Ast {};

struct Ast_Ident : public Ast_Expr {
    str value;
    Ast_Ident(str _value) : value(_value) {}
};

struct Ast_String : public Ast_Expr {
    str value;
    Ast_String(str _value) : value(_value) {}
};

struct Ast_Bool : public Ast_Expr {
    bool value;
    Ast_Bool(bool _value) : value(_value) {}
};

struct Ast_Int : public Ast_Expr {
    s32 value;
    Ast_Int(s32 _value) : value(_value) {}
};

struct Ast_Paren : public Ast_Expr {
    Ast_Expr *value;
    Ast_Paren(Ast_Expr *_value) : value(_value) {}
};

struct Ast_Binary : public Ast_Expr {
    enum class Op : u8 {
        ADD,
        SUB,
        LSH,
        RSH,
        BIT_AND,
        BIT_OR,
        BIT_XOR,
        AND,
        OR,
        EQ,
        NE,
        LT,
        GT,
        LTE,
        GTE
    };

    Op op;
    Ast_Expr *left;
    Ast_Expr *right;

    Ast_Binary(Op _op, Ast_Expr *_left, Ast_Expr *_right) 
        : op(_op), left(_left), right(_right) {}
};


