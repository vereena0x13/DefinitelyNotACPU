#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <float.h>
#include <time.h>
#include <dirent.h>
#include <sys/stat.h>
#include <pthread.h>
#include <unistd.h>

#ifdef _MSC_VER
#include <intrin.h>
#else
#include <x86intrin.h>
#endif


#define VSTD_IMPL
#include "vstd.hpp"


#include "arch.hpp"
#include "lexer.cpp"
#include "ast.cpp"
#include "parser.cpp"
#include "assembler.cpp"



s32 main(s32 argc, cstr *argv) {
    if(argc < 2) {
        printf("Usage: cc <file>\n");
        return 1;
    }

    str source = read_entire_file(argv[1]);
    if(!source) {
        printf("Unable to read file '%s'\n", argv[1]);
        return 1;
    }

    
    
    return 0;
}