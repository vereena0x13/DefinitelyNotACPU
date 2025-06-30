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


#include "ctrl.h"
#include "isa.h"
#include "ucode.cpp"
#include "dasm.cpp"



void usage() {
    printf("usage: cputool <file>\n");
}

s32 main(s32 argc, cstr *argv) {
    if(argc < 2) {
        usage();
        return 1;
    }

    return disassemble(argv[1]);
}