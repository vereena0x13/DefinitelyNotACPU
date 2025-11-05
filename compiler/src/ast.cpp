struct Ast {};

struct Ast_Expr : public Ast {};
struct Ast_Type : public Ast {};
struct Ast_Stmt : public Ast {};

struct Ast_Decl : public Ast {
    str name;
    Ast_Decl(str _name) : Ast(), name(_name) {}
};


struct Ast_Ident : public Ast_Expr {
    str value;
    Ast_Ident(str _value) : Ast_Expr(), value(_value) {}
};

struct Ast_Int : public Ast_Expr {
    s32 value;
    Ast_Int(s32 _value) : Ast_Expr(), value(_value) {}
};

struct Ast_Paren : public Ast_Expr {
    Ast_Expr *value;
    Ast_Paren(Ast_Expr *_value) : Ast_Expr(), value(_value) {}
};

struct Ast_AddressOf : public Ast_Expr {
    Ast_Expr *value;
    Ast_AddressOf(Ast_Expr *_value) : Ast_Expr(), value(_value) {}
};

struct Ast_Deref : public Ast_Expr {
    Ast_Expr *value;
    Ast_Deref(Ast_Expr *_value) : Ast_Expr(), value(_value) {}
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
        : Ast_Expr(), op(_op), left(_left), right(_right) {}
};


struct Ast_Named_Type : public Ast_Type {
    Ast_Ident *name;
    Ast_Named_Type(Ast_Ident *_name) : Ast_Type(), name(_name) {}
};

struct Ast_Pointer_Type : public Ast_Type {
s    Ast_Type *pointed_type;
    Ast_Pointer_Type(Ast_Type *_pointed_type) : Ast_Type(), pointed_type(_pointed_type) {}
};


struct Ast_Struct : public Ast_Decl {
    struct Member {
        str name;
        Ast_Type *type;
    };

    Array<Member> members;

    Ast_Struct(str _name) : Ast_Decl(_name) {}
};

struct Ast_Func : public Ast_Decl {
    Ast_Func(str _name) : Ast_Decl(_name) {}
};

struct Ast_Var : public Ast_Decl {
    Ast_Type *type;
    Ast_Expr *value;

    Ast_Var(str _name, Ast_Type *_type, Ast_Expr *_value) 
        : Ast_Decl(_name), type(_type), value(_value) {}
};


struct Ast_File : public Ast {
    Array<Ast_Decl*> decls;

    Ast_File() : Ast() {}
};