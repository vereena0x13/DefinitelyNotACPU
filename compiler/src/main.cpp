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




s32 main(s32 argc, cstr *argv) {
    printf("ayyy!\n");
    return 0;
}