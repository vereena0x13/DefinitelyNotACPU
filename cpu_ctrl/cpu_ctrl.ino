typedef unsigned char u8;
typedef unsigned short u16;

static_assert(sizeof(u8) == 1);
static_assert(sizeof(u16) == 2);
static_assert(sizeof(u32) == 4);


#define nop() __asm__ __volatile__ ("nop\n\t")


#if 0
#define begin_critical()    \
    u8 sreg = SREG;         \
    cli()
#define end_critical()      \
    SREG = sreg;
#define eep() nop(); nop(); nop(); nop()
#else
#define begin_critical()
#define end_critical()
#define eep()
#endif


void panic(u8 a, u8 b, u8 c) {
    sei();
    for(;;) {
        for(u8 i = 0; i < 4; i++) {
            digitalWrite(LED_BUILTIN, HIGH);
            delay(a);
            digitalWrite(LED_BUILTIN, LOW);
            delay(a);
        }

        digitalWrite(LED_BUILTIN, HIGH);
        delay(b);
        digitalWrite(LED_BUILTIN, LOW);
        delay(c);
    }
}


#define CTRL_CLR                12                  // B4
#define CTRL_CLK                13                  // B5
#define CTRL_LAT                14                  // C0
#define CTRL_DAT                15                  // C1

#define CPU_RST                 0                   // D0
#define CPU_CLK                 1                   // D1

#define INSN0                   17                  // C3
#define INSN1                   16                  // C2
#define INSN2                   2                   // D2
#define INSN3                   3                   // D3
#define INSN4                   4                   // D4
#define INSN5                   5                   // D5
#define INSN6                   19                  // C5
#define INSN7                   18                  // C4

#define FLAGZ                   6                   // D6
#define FLAGC                   7                   // D7

#define UPC0                    8                   // B0
#define UPC1                    9                   // B1
#define UPC2                    10                  // B2
#define UPC3                    11                  // B3


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
    if(PINC & (1 << 3)) res |= 1;
    if(PINC & (1 << 2)) res |= 2;
    if(PIND & (1 << 2)) res |= 4;
    if(PIND & (1 << 3)) res |= 8;
    if(PIND & (1 << 4)) res |= 16;
    if(PIND & (1 << 5)) res |= 32;
    if(PINC & (1 << 5)) res |= 64;
    if(PINC & (1 << 4)) res |= 128;
    return res;
}

inline u8 __attribute__((always_inline)) read_upc() {
    u8 res = 0;
    if(PINB & (1 << 0)) res |= 1;
    if(PINB & (1 << 1)) res |= 2;
    if(PINB & (1 << 2)) res |= 4;
    if(PINB & (1 << 3)) res |= 8;
    return res;
}

inline u8 __attribute__((always_inline)) read_flags() {
    u8 f = 0;
    if(PIND & (1 << 6)) f |= 1;
    if(PIND & (1 << 7)) f |= 2;
    return f;
}

inline void __attribute__((always_inline)) pulse_clk() {
    begin_critical();
    {
        PORTD |= (1 << 1);
        eep();
        PORTD &= ~(1 << 1);
        eep();
    }
    end_critical();
}

inline void __attribute__((always_inline)) write_sr(u8 a, u8 b, u8 c, u8 d) {
    begin_critical();
    {
        PORTC |= (1 << 0);
        #define SO(x, n)                            \
            if(x & (1 << n))    PORTC |= (1 << 1);  \
            else                PORTC &= ~(1 << 1); \
            eep();                                  \
            PORTB |= (1 << 5);                      \
            eep();                                  \
            PORTB &= ~(1 << 5);                     \
            eep();
        SO(a, 7)
        SO(a, 6)
        SO(a, 5)
        SO(a, 4)
        SO(a, 3)
        SO(a, 2)
        SO(a, 1)
        SO(a, 0)
        SO(b, 7)
        SO(b, 6)
        SO(b, 5)
        SO(b, 4)
        SO(b, 3)
        SO(b, 2)
        SO(b, 1)
        SO(b, 0)
        SO(c, 7)
        SO(c, 6)
        SO(c, 5)
        SO(c, 4)
        SO(c, 3)
        SO(c, 2)
        SO(c, 1)
        SO(c, 0)
        SO(d, 7)
        SO(d, 6)
        SO(d, 5)
        SO(d, 4)
        SO(d, 3)
        SO(d, 2)
        SO(d, 1)
        SO(d, 0)
        #undef SO
        PORTC &= ~(1 << 0);
    }
    end_critical();
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


#define OPMAX           64
#define UMAX            16
#define FMAX            4

const PROGMEM u8 ucode[FMAX*OPMAX*UMAX*4] = {
#include "ucode_zc.h"
,
#include "ucode_Zc.h"
,
#include "ucode_zC.h"
,
#include "ucode_ZC.h"
};

#define get_uinsn_b(i, u, f, b) pgm_read_byte(ucode + f*OPMAX*UMAX*4 + i*UMAX*4 + u*4 + b)


inline void __attribute__((always_inline)) cycle() {
    u8 insn     = read_insn();
    if(insn >= OPMAX) panic(25, 250, 100);

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
    begin_critical();
    {
        digitalWrite(CTRL_CLR, LOW);
        digitalWrite(CPU_RST, LOW);
        eep();
        digitalWrite(CTRL_CLR, HIGH);
        digitalWrite(CPU_RST, HIGH);
        eep();


        // NOTE TODO: This is _totally_ a _perfectly reasonable_ _engineering-coded_ solution to our flaky reset issue.
        u8 insn, upc, flags;
        do {
            insn    = read_insn();
            upc     = read_upc();
            flags   = read_flags();
            pulse_sr(SR_D_TO_MAR_LO | SR_MAR_LO_LD | SR_D_TO_MAR_HI | SR_MAR_HI_LD | SR_IR_LD | SR_A_LD | SR_B_LD | SR_UPC_RST);
        } while(insn | upc | flags);


        write_sr(0);
    }
    end_critical();
}


void setup() {
    pinMode(CTRL_CLR, OUTPUT);
    pinMode(CTRL_CLK, OUTPUT);
    pinMode(CTRL_LAT, OUTPUT);
    pinMode(CTRL_DAT, OUTPUT);
    digitalWrite(CTRL_CLR, HIGH);
    digitalWrite(CTRL_CLK, LOW);
    digitalWrite(CTRL_LAT, LOW);
    digitalWrite(CTRL_DAT, LOW);

    pinMode(CPU_RST, OUTPUT);
    pinMode(CPU_CLK, OUTPUT);
    digitalWrite(CPU_RST, HIGH);
    digitalWrite(CPU_CLK, LOW);

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

    reset();
    load_code();
    reset();

    cli();
}

void loop() {
    cycle();
}