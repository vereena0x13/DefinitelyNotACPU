struct Parser {
    Parser(cstr name, str src) : lexer(Lexer(name, src)) {}

    void free() {
        lexer.free();
        node_arena.deinit();
    }
    
private:
    Lexer lexer;
    Arena node_arena;

    inline bool more() { return lexer.more_tokens(); }
    inline Token next() { return lexer.next_token(); }
    inline Token prev() { return lexer.prev_token(); }
    inline Token peek() { return lexer.peek_token(); }

    template<typename... T>
    inline bool accept(T... _types) {
        static_assert((otr::type_eq<T, TokenType> && ...));

        if(!more()) return false;

        auto n = sizeof...(_types);
        TokenType types[] = { _types... };

        auto t = lexer.token_type(peek());
        for(u32 i = 0; i < n; i++) {
            if(t == types[i]) return true;
        }

        return false;
    }

    template<typename... T>
    inline bool accept_next(T... types) {
        if(accept(types...)) {
            next();
            return true;
        }
        return false;
    }

    template<typename... T>
    inline void unexpected(T... _expected) {
        static_assert((otr::type_eq<T, TokenType> && ...));
        
        //auto n = sizeof...(_expected);
        //TokenType expected[] = { _expected... };

        auto t = peek();
        auto ty = lexer.token_type(t);
        auto st = lexer.token_start(t);
        
        auto msg = tsprintf("unexpected token %s at %u:%u", TOKEN_TYPE_NAME[ty], st.line, st.column);
        str e = lexer.format_error_message(st, lexer.token_end(t), msg);
        fwrite(e, 1, strsz(e), stdout);
        freestr(e);

        exit(EXIT_FAILURE);
    }

    template<typename... T>
    inline Token expect(T... types) {
        if(!accept(types...)) {
            unexpected(types...);
        }
        return peek();
    }

    template<typename... T>
    inline Token expect_next(T... types) {
        expect(types...);
        return next();
    }

    template<typename... T>
    inline Token expect_not(T... types) {
        if(accept(types...)) {
            panic("expect_not failed"); // TODO
        }
        return peek();
    }

    #define mknod(t, ...) xanew(t, &node_arena, __VA_ARGS__)

    Ast_Ident* parse_ident() {
        auto t = expect_next(TT_IDENT);
        return mknod(Ast_Ident, lexer.token_value(t));
    }

    Ast_Int* parse_int() {
        auto t = expect_next(TT_INTEGER);
        auto v = lexer.token_value(t);
        if(strsz(v) > 1) {
            if(v[0] == '0' && v[1] == 'x') {
                return mknod(Ast_Int, cast(s32, strtol(v + 2, NULL, 16)));
            } else if(v[0] == 0 && v[1] == 'b') {
                return mknod(Ast_Int, cast(s32, strtol(v + 2, NULL, 2)));
            }
        }
        return mknod(Ast_Int, cast(s32, strtol(v, NULL, 10)));
    }

    Ast_Type* parse_type() {
        Ast_Type *t = mknod(Ast_Named_Type, parse_ident());
        while(accept_next(TT_STAR)) t = mknod(Ast_Pointer_Type, t);
        return t;
    }

    Ast_Struct* parse_struct() {
        todo();
    }

    Ast_Func* parse_func() {
        todo();
    }

    Ast_Decl* parse_decl() {
        
    }

public:
    Ast_File* parse() {
        auto n = mknod(Ast_File);

        while(more()) {
            n->decls.push(parse_decl());
        }

        return n;
    }

    #undef mknod
};