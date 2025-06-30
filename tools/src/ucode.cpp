#define OPMAX   64
#define UMAX    16
#define FMAX    4


const u8 ucode[FMAX*OPMAX*UMAX*4] = {
#include "ucode_zc.h"
,
#include "ucode_Zc.h"
,
#include "ucode_zC.h"
,
#include "ucode_ZC.h"
};