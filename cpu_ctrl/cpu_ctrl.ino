typedef unsigned char u8;
typedef unsigned short u16;

static_assert(sizeof(u8) == 1);
static_assert(sizeof(u16) == 2);
static_assert(sizeof(u32) == 4);


void panic() {
    for(;;) {
        for(u8 i = 0; i < 4; i++) {
            digitalWrite(LED_BUILTIN, HIGH);
            delay(25);
            digitalWrite(LED_BUILTIN, LOW);
            delay(25);
        }

        digitalWrite(LED_BUILTIN, HIGH);
        delay(250);
        digitalWrite(LED_BUILTIN, LOW);
        delay(100);
    }
}


#define INSN0                   17
#define INSN1                   16
#define INSN2                   2
#define INSN3                   3
#define INSN4                   4
#define INSN5                   5
#define INSN6                   19
#define INSN7                   18

#define FLAGZ                   6
#define FLAGC                   7

#define UPC0                    8
#define UPC1                    9
#define UPC2                    10
#define UPC3                    11

#define CTRL_CLR                12
#define CTRL_CLK                13
#define CTRL_LAT                14
#define CTRL_DAT                15

#define CPU_RST                 0
#define CPU_CLK                 1


#define SR_D0                   (1llu << 0llu)      //
#define SR_D1                   (1llu << 1llu)      //
#define SR_D2                   (1llu << 2llu)      //
#define SR_D3                   (1llu << 3llu)      //
#define SR_D4                   (1llu << 4llu)      //
#define SR_D5                   (1llu << 5llu)      //
#define SR_D6                   (1llu << 6llu)      //
#define SR_D7                   (1llu << 7llu)      //
#define SR_D_RD                 (1llu << 8llu)      // D            ->  data
#define SR_ALU_XORB             (1llu << 9llu)      //
#define SR_ALU_CI               (1llu << 10llu)     //
#define SR_2                    (1llu << 11llu)     //
#define SR_PC_RD                (1llu << 12llu)     // PC           ->  addr
#define SR_PC_INC               (1llu << 13llu)     //
#define SR_PC_LD                (1llu << 14llu)     // PC           :=  addr
#define SR_MAR_RD               (1llu << 15llu)     // MAR          ->  addr
#define SR_MAR_LO_LD            (1llu << 16llu)     // MAR[:7]      :=  addr[:7]
#define SR_MAR_HI_LD            (1llu << 17llu)     // MAR[8:]      :=  addr[8:]
#define SR_A_RD                 (1llu << 18llu)     // A            ->  data
#define SR_A_LD                 (1llu << 19llu)     // A            :=  data
#define SR_B_LD                 (1llu << 20llu)     // B            :=  data
#define SR_FLAGS_LD             (1llu << 21llu)     //  
#define SR_UPC_RST              (1llu << 22llu)     // 
#define SR_RAM_RD               (1llu << 23llu)     // ram[addr]    -> data
#define SR_RAM_WR               (1llu << 24llu)     // ram[addr]    := data
#define SR_IR_LD                (1llu << 25llu)     // IR           := data
#define SR_ADDR_LO_TO_D         (1llu << 26llu)     // x addr[:7]   -> data
#define SR_ADDR_HI_TO_D         (1llu << 27llu)     // x addr[8:]   -> data
#define SR_D_TO_MAR_LO          (1llu << 29llu)     // x data       -> MAR[:7]
#define SR_D_TO_MAR_HI          (1llu << 28llu)     // x data       -> MAR[8:]
#define SR_UPC_INC              (1llu << 30llu)     // x
#define SR_ALU_RD               (1llu << 31llu)     // x


inline u8 __attribute__((always_inline)) read_insn() {
    u8 res = 0;
    if(digitalRead(INSN0)) res |= 1;
    if(digitalRead(INSN1)) res |= 2;
    if(digitalRead(INSN2)) res |= 4;
    if(digitalRead(INSN3)) res |= 8;
    if(digitalRead(INSN4)) res |= 16;
    if(digitalRead(INSN5)) res |= 32;
    if(digitalRead(INSN6)) res |= 64;
    if(digitalRead(INSN7)) res |= 128;
    return res;
}

inline u8 __attribute__((always_inline)) read_upc() {
    u8 res = 0;
    if(digitalRead(UPC0)) res |= 1;
    if(digitalRead(UPC1)) res |= 2;
    if(digitalRead(UPC2)) res |= 4;
    if(digitalRead(UPC3)) res |= 8;
    return res;
}

inline u8 __attribute__((always_inline)) read_flags() {
    u8 f = 0;
    if(digitalRead(FLAGZ)) f |= 1;
    if(digitalRead(FLAGC)) f |= 2;
    return f;
}

inline void __attribute__((always_inline)) pulse_clk() {
    digitalWrite(CPU_CLK, HIGH);
    digitalWrite(CPU_CLK, LOW);
}

inline void __attribute__((always_inline)) write_sr(u8 a, u8 b, u8 c, u8 d) {
    digitalWrite(CTRL_LAT, LOW);
    shiftOut(CTRL_DAT, CTRL_CLK, MSBFIRST, a);
    shiftOut(CTRL_DAT, CTRL_CLK, MSBFIRST, b);
    shiftOut(CTRL_DAT, CTRL_CLK, MSBFIRST, c);
    shiftOut(CTRL_DAT, CTRL_CLK, MSBFIRST, d);
    digitalWrite(CTRL_LAT, HIGH);
}

inline void __attribute__((always_inline)) write_sr(u32 x) {
    write_sr(x & 0xFF, (x & 0x0000FF00) >> 8, (x & 0x00FF0000) >> 16, (x & 0xFF000000) >> 24);
}

inline void __attribute__((always_inline)) pulse_sr(u8 a, u8 b, u8 c, u8 d) {
    write_sr(a, b, c, d);
    pulse_clk();
}

inline void __attribute__((always_inline)) pulse_sr(u32 x) {
    pulse_sr(x & 0xFF, (x & 0x0000FF00) >> 8, (x & 0x00FF0000) >> 16, (x & 0xFF000000) >> 24);
}


#define OPMAX           32
#define UMAX            16
#define FMAX            4

const PROGMEM u8 ucode[FMAX*OPMAX*UMAX*4] = {
#include "ucode.h"
};

#define get_uinsn_b(i, u, f, b) pgm_read_byte(ucode + f*OPMAX*UMAX*4 + i*UMAX*4 + u*4 + b)


inline void __attribute__((always_inline)) cycle() {
    //delay(10);

    u8 insn     = read_insn();
    if(insn >= OPMAX) panic();
    
    u8 upc      = read_upc();
    u8 flags    = read_flags();
    pulse_sr(
        get_uinsn_b(insn, upc, flags, 3),
        get_uinsn_b(insn, upc, flags, 2),
        get_uinsn_b(insn, upc, flags, 1),
        get_uinsn_b(insn, upc, flags, 0)
    );
}


const PROGMEM u8 code[] = {
#include "program.h"
};

inline void __attribute__((always_inline)) load_code() {
    for(u16 i = 0; i < sizeof(code); i++) {
        pulse_sr(pgm_read_byte(code + i) | SR_D_RD | SR_PC_RD | SR_RAM_WR);
        pulse_sr(SR_PC_INC);
    }
}


inline void __attribute__((always_inline)) reset() {
    digitalWrite(CTRL_CLR, LOW);
    digitalWrite(CTRL_CLR, LOW);
    digitalWrite(CPU_RST, LOW);
    delay(1);
    digitalWrite(CTRL_CLR, HIGH);
    digitalWrite(CTRL_CLR, HIGH);
    digitalWrite(CPU_RST, HIGH);

    pulse_sr(0x00 | SR_D_RD | SR_MAR_LO_LD | SR_MAR_HI_LD | SR_D_TO_MAR_LO | SR_D_TO_MAR_HI | SR_IR_LD | SR_A_LD | SR_B_LD | SR_UPC_RST);
    write_sr(0);
}


void setup() {
    pinMode(INSN0, INPUT);
    pinMode(INSN1, INPUT);
    pinMode(INSN2, INPUT);
    pinMode(INSN3, INPUT);
    pinMode(INSN4, INPUT);
    pinMode(INSN5, INPUT);

    pinMode(FLAGZ, INPUT);
    pinMode(FLAGC, INPUT);

    pinMode(UPC0, INPUT);
    pinMode(UPC1, INPUT);
    pinMode(UPC2, INPUT);
    pinMode(UPC3, INPUT);

    pinMode(CTRL_CLR, OUTPUT);
    pinMode(CTRL_CLK, OUTPUT);
    pinMode(CTRL_LAT, OUTPUT);
    pinMode(CTRL_DAT, OUTPUT);
    digitalWrite(CTRL_CLK, LOW);
    digitalWrite(CTRL_LAT, LOW);

    pinMode(CPU_RST, OUTPUT);
    pinMode(CPU_CLK, OUTPUT);
    digitalWrite(CPU_RST, HIGH);
    digitalWrite(CPU_CLK, LOW);

    reset();
    load_code();
    reset();

#if 0
    u32 N = 500;
    //write_sr(SR_D_RD); delay(N);
    //write_sr(SR_ALU_CI); delay(N);
    //write_sr(SR_ALU_XORB); delay(N);
    //write_sr(SR_2); delay(N);
    //write_sr(SR_PC_RD); delay(N);
    //write_sr(SR_PC_INC); delay(N);
    //write_sr(SR_PC_LD); delay(N);
    //write_sr(SR_MAR_RD); delay(N);
    //write_sr(SR_MAR_LO_LD); delay(N);
    //write_sr(SR_MAR_HI_LD); delay(N);
    write_sr(SR_A_RD); delay(N);
    write_sr(SR_A_LD); delay(N);
    write_sr(SR_B_LD); delay(N);
    write_sr(SR_FLAGS_LD); delay(N);
    write_sr(SR_UPC_RST); delay(N);
    write_sr(SR_RAM_RD); delay(N);
    write_sr(SR_RAM_WR); delay(N);
    write_sr(SR_IR_LD); delay(N);
    write_sr(SR_ADDR_LO_TO_D); delay(N);
    write_sr(SR_ADDR_HI_TO_D); delay(N);
    write_sr(SR_D_TO_MAR_LO); delay(N);
    write_sr(SR_D_TO_MAR_HI); delay(N);
    write_sr(SR_UPC_INC); delay(N);
    write_sr(SR_ALU_RD); delay(N);
    reset();
#endif
}

void loop() {
    cycle();
}