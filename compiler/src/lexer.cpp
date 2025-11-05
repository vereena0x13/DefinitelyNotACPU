#define TOKEN_TYPES(X)      \
    X(LPAREN              ) \
    X(RPAREN              ) \
    X(LBRACE              ) \
    X(RBRACE              ) \
    X(LBRACK              ) \
    X(RBRACK              ) \
    X(SEMICOLON           ) \
    X(COLON               ) \
    X(COLON_COLON         ) \
    X(COLON_EQUALS        ) \
    X(COMMA               ) \
    X(PERIOD              ) \
    X(ARROW               ) \
    X(AMPERSAND           ) \
    X(STAR                ) \
    X(ADD                 ) \
    X(SUB                 ) \
    X(ASSIGN              ) \
    X(ADD_ASSIGN          ) \
    X(SUB_ASSIGN          ) \
    X(EQ                  ) \
    X(NE                  ) \
    X(IF                  ) \
    X(ELSE                ) \
    X(WHILE               ) \
    X(RETURN              ) \
    X(STRUCT              ) \
    X(FN                  ) \
    X(INTEGER             ) \
    X(IDENT               )


enum TokenType : u8 {
    #define X(t) TT_##t,
    TOKEN_TYPES(X)
    #undef X
};


rstr TOKEN_TYPE_NAME[] = {
    #define X(t) #t,
    TOKEN_TYPES(X)
    #undef X
};


using Token = u32;


struct SourcePosition {
    u32 line;
    u32 column;
    u32 index;

    SourcePosition(u32 _line, u32 _column, u32 _index) : line(_line), column(_column), index(_index) {}
};


struct Lexer {
    Lexer(cstr _filename, str _source) : filename(_filename), source(_source), source_len(strsz(_source)) {
        compute_line_map();
        tokenize();
    }

    void free() {
        start_positions.free();
        end_positions.free();
        types.free();
        values.free();
        string_arena.deinit();
        line_map.free();
    }

    Token peek_token() { return cast(Token, token); }
    Token next_token() { return cast(Token, token++); }
    Token prev_token() { return cast(Token, --token); }
    bool more_tokens() { return token < tokens;}

    SourcePosition token_start(Token t) { return start_positions[t]; }
    SourcePosition token_end(Token t) { return end_positions[t]; }
    TokenType token_type(Token t) { return types[t]; }
    str token_value(Token t) { return values[t]; }

    u32 index_to_line(u32 index) { return line_map[index]; }

    str get_in_span(u32 start, u32 end, Allocator *a = NULL) {
        assert(end >= start);
        return substr(source, start, end, a);            
    }

    str get_in_span(SourcePosition const& start, SourcePosition const& end, Allocator *a = NULL) {
        return get_in_span(start.index, end.index, a);
    }

    str get_line(u32 index, Allocator *a = NULL) {
        assert(source[index] != '\n');

        u32 start = index;
        while(start != 0 && source[start - 1] != '\n') start--;

        u32 end = index;
        while(end + 1 < source_len && source[end + 1] != '\n') end++;

        return get_in_span(start, end, a);
    }

    str get_line(SourcePosition const& pos, Allocator *a = NULL) {
        return get_line(pos.index, a);
    }

    str format_error_message(SourcePosition const& start, SourcePosition const& end, str error, Allocator *a = NULL) {
        ByteBuf result(a);
        auto mark = tmark();

        result.write_chars(tsprintf("\u001b[31m\u001b[1merror:\u001b[37m %s\u001b[0m\n", error));
        result.write_chars(tsprintf("   \u001b[34;1m-->\u001b[0m %s\n", filename));
        result.write_chars(tsprintf("    \u001b[34;1m|\u001b[0m\n"));

        u32 last_line = line_map[start.index];
        bool first = true;
        for(u32 index = start.index; index <= end.index; index++) {
            u32 line = line_map[index];
            str line_str = get_line(index, temp_allocator);
            if(line != last_line) {
                last_line = line;
                result.write_chars(tsprintf("\n  \u001b[34;1m%u |\u001b[0m %s", line, line_str));
            } else if(first) {
                first = false;
                result.write_chars(tsprintf("  \u001b[34;1m%u |\u001b[0m %s", line, line_str));
            }
        }

        result.write_chars(tsprintf("\n    \u001b[34;1m|\u001b[0m\n\n"));

        treset(mark);
        return result.tostr();
    }

private:
    cstr filename;
    str source;
    u64 source_len;
    u32 start = 0;
    u32 pos = 0;
    u32 start_line = 1;
    u32 start_column = 1;
    u32 line = 1;
    u32 column = 1;

    Arena string_arena;

    Array<SourcePosition> start_positions;
    Array<SourcePosition> end_positions;
    Array<TokenType> types;
    Array<str> values;
    u32 tokens = 0;
    u32 token = 0;

    Array<u32> line_map;

    void compute_line_map() {
        line_map.resize(source_len);

        u32 line = 1;
        for(u64 i = 0; i < source_len; i++) {
            if(source[i] == '\n') line++;
            line_map[i] = line;
        }
    }

    inline bool more() { return pos < strsz(source); }

    inline char next() {
        assert(more());
        char c = source[pos];
        pos++;
        column++;
        return c;
    }

    inline char peek() {
        assert(more());
        return source[pos];
    }

    inline void ignore() {
        start = pos;
        start_line = line;
        start_column = column;
    }

    bool accept(char c) {
        if(!more()) return false;
        if(c == peek()) {
            next();
            return true;
        }
        return false;
    }

    bool accept(rstr valid) {
        for(u32 i = 0; i < strlen(valid); i++) {
            if(accept(valid[i])) return true;
        }
        return false;
    }

    void accept_run(rstr valid) {
        while(accept(valid));
    }

    bool accept_seq(rstr seq) {
        u32 _start = start;
        u32 _pos = pos;
        u32 _column = column;
        for(u32 i = 0; i < strlen(seq); i++) {
            if(!accept(seq[i])) {
                start = _start;
                pos = _pos;
                column = _column;
                return false;
            }
        }
        return true;
    }

    void skip_whitespace() {
        bool r = true;
        while(r) {
            switch(peek()) {
                case '\n': {
                    line++;
                    column = 0;
                    next();
                    break;
                }
                case '\t':
                case '\r':
                case ' ': {
                    next();
                    break;
                }
                default: {
                    r = false;
                    break;
                }
            }
        }
        ignore();
    }

    inline void emit(TokenType type) {
        tokens++;
        start_positions.push(SourcePosition(start_line, start_column, start));
        end_positions.push(SourcePosition(line, column, pos-1));
        types.push(type);
        values.push(substr(source, start, pos-1, &string_arena));
    }
    
    #define CASE(x, c) case x: { c; break; } // TODO: add this to vstd?

    void tokenize() {
        while(more()) {
            skip_whitespace();

            char c = next();
            switch(c) {
                CASE('(', emit(TT_LPAREN))
                CASE(')', emit(TT_RPAREN))
                CASE('{', emit(TT_LBRACE))
                CASE('}', emit(TT_RBRACE))
                CASE('[', emit(TT_LBRACK))
                CASE(']', emit(TT_RBRACK))
                CASE(';', emit(TT_SEMICOLON))
                CASE(':',
                    if(accept(":"))         emit(TT_COLON_COLON);
                    else if(accept("="))    emit(TT_COLON_EQUALS);
                    else                    todo();
                )
                CASE(',', emit(TT_COMMA))
                CASE('.', emit(TT_PERIOD))
                CASE('&', emit(TT_AMPERSAND))
                CASE('+',
                    if(accept('='))         emit(TT_ADD_ASSIGN);
                    else                    emit(TT_ADD);
                )
                CASE('-',
                    if(accept(">"))         emit(TT_ARROW);
                    else if(accept("="))    emit(TT_SUB_ASSIGN);
                    else                    emit(TT_SUB);
                )
                CASE('*', emit(TT_STAR))
                CASE('/',
                    if(accept('/')) {
                        while(!accept('\n')) next();
                        line++;
                        column = 1;
                        ignore();
                    } else if(accept('*')) {
                        u32 depth = 1;

                        while(more() && depth > 0) {
                            if(accept_seq("/*")) {
                                depth++;
                            } else if(accept_seq("*/")) {
                                depth--;
                            } else if(peek() == '\n') {
                                line++;
                                column = 1;
                            }

                            if(depth > 0) next();
                        }

                        if(depth > 0) {
                            todo();
                        }

                        ignore();
                    } else {
                        todo();
                    }
                )
                CASE('!',
                    if(accept('='))     emit(TT_NE);
                    else                todo();
                )
                CASE('=',
                    if(accept('='))     emit(TT_EQ);
                    else                emit(TT_ASSIGN);
                )
                default: {
                    if(is_letter(c) || c == '_') {
                        // TODO: don't do this, idiot.
                        pos--;
                        column--;

                        if(accept_seq("if"))            emit(TT_IF);
                        else if(accept_seq("else"))     emit(TT_ELSE);
                        else if(accept_seq("while"))    emit(TT_WHILE);
                        else if(accept_seq("return"))   emit(TT_RETURN);
                        else if(accept_seq("struct"))   emit(TT_STRUCT);
                        else if(accept_seq("fn"))       emit(TT_FN);
                        else {
                            while(more() && is_alpha(peek()) || peek() == '_') next();
                            emit(TT_IDENT);
                        }
                    } else if(is_digit(c)) {
                        if(c == '0' && (peek() == 'x' || peek() == 'b')) {
                            if(accept('x'))      accept_run("0123456789ABCDEFabcdef");
                            else if(accept('b')) accept_run("01");
                        } else {
                            accept_run("0123456789");
                        }
                        emit(TT_INTEGER);
                    } else {
                        printf("%c\n", c);
                        todo();
                    }
                    break;
                }
            }
        }
    }

    static bool is_letter(char c) { return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'); }
    static bool is_digit(char c) { return c >= '0' && c <= '9'; }
    static bool is_alpha(char c) { return is_letter(c) || is_digit(c); }
};