struct Ast {

};

struct Ast_Expr : public Ast {};
struct Ast_Stmt : public Ast {};
struct Ast_Decl : public Ast_Stmt {};


struct Ast_Ident : public Ast_Expr {
    str value;
    Ast_Ident(str _value) : value(_value) {}
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
        EQ,
        NE
    };

    Op op;
    Ast_Expr *left;
    Ast_Expr *right;

    Ast_Binary(Op _op, Ast_Expr *_left, Ast_Expr *_right) 
        : op(_op), left(_left), right(_right) {}
};


struct Ast_Struct : public Ast_Decl {

};

struct Ast_Fn : public Ast_Decl {

};

struct Ast_Var : public Ast_Decl {

};


struct Ast_File : public Ast {
    Array<Ast_Struct*> structs;
    Array<Ast_Fn*> funcs;
    Array<Ast_Var*> vars;
};