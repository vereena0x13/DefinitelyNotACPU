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
#define SR_ALU_BIT_RD           (1llu << 11llu)     //
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

#define ALU_BIT_AND             0
#define ALU_BIT_OR              SR_ALU_XORB
#define ALU_BIT_XOR             SR_ALU_CI
#define ALU_BIT_NOT             SR_ALU_XORB | SR_ALU_CI