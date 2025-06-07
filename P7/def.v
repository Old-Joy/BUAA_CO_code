// define of EXT
`define EXT_zero 2'b00
`define EXT_sign 2'b01
`define EXT_one 2'b10

// define of the source of ALU_A
`define ALU_A_rs 3'b000
`define ALU_A_rt 3'b001

// define of the source of ALU_B
`define ALU_B_GRF 3'b000
`define ALU_B_IMM 3'b001

// define of ALUOp
`define ALU_add 5'b00000
`define ALU_sub 5'b00001
`define ALU_or 5'b00010
`define ALU_sll 5'b00011
`define ALU_lui 5'b00100
`define ALU_and 5'b00101
`define ALU_slt 5'b00110
`define ALU_sltu 5'b00111

// define of NPCOp
`define NPC_PC4 3'b000
`define NPC_b 3'b001
`define NPC_j_jal 3'b010
`define NPC_jr_jalr 3'b011

// define of DEOp
`define DE_lw 3'b000
`define DE_lh 3'b001
`define DE_lb 3'b010

// define of BEOp
`define BE_null 3'b000
`define BE_sw 3'b001
`define BE_sh 3'b010
`define BE_sb 3'b011

// define of CMPOp
`define CMP_beq 3'b000
`define CMP_bne 3'b001

//define of GRFWDSel, to mark where the message comes from
`define GRFWDSel_ALU 3'b000
`define GRFWDSel_DM 3'b001
`define GRFWDSel_PC8 3'b010
`define GRFWDSel_MDU 3'b011
`define GRFWDSel_CP0 3'b100

// define of MDUOp
`define MDU_mult 5'b00000
`define MDU_multu 5'b00001
`define MDU_div 5'b00010
`define MDU_divu 5'b00011
`define MDU_mfhi 5'b00100
`define MDU_mflo 5'b00101
`define MDU_mthi 5'b00110
`define MDU_mtlo 5'b00111

// define of address 
`define DM_begin     32'h0000_0000
`define DM_end       32'h0000_2fff
`define TC1_begin    32'h0000_7f00
`define TC1_end      32'h0000_7f0b
`define TC2_begin    32'h0000_7f10
`define TC2_end      32'h0000_7f1b

// define of exception
`define exception_Int 5'd0
`define exception_AdEL 5'd4
`define exception_AdES 5'd5
`define exception_Syscall 5'd8
`define exception_RI 5'd10
`define exception_Ov 5'd12
`define exception_null 5'd0

// define of Instr of opcode or function
`define special 6'b00_0000
`define COP0 6'b01_0000

`define ADD 6'b10_0000 //func
`define SUB 6'b10_0010 //func
`define AND 6'b10_0100 //func
`define OR 6'b10_0101 //func
`define SLT 6'b10_1010 //func
`define SLTU 6'b10_1011 //func
`define LUI 6'b00_1111

`define ADDI 6'b00_1000
`define ANDI 6'b00_1100
`define ORI 6'b00_1101

`define LB 6'b10_0000
`define LH 6'b10_0001
`define LW 6'b10_0011
`define SB 6'b10_1000
`define SH 6'b10_1001
`define SW 6'b10_1011

`define MULT 6'b01_1000 //func
`define MULTU 6'b01_1001 //func
`define DIV 6'b01_1010 //func
`define DIVU 6'b01_1011 //func
`define MFHI 6'b01_0000 //func
`define MFLO 6'b01_0010 //func
`define MTHI 6'b01_0001 //func
`define MTLO 6'b01_0011 //func

`define BEQ 6'b00_0100
`define BNE 6'b00_0101
`define SLL 6'b00_0000 //func
`define J 6'b00_0010
`define JAL 6'b00_0011
`define JR 6'b00_1000 //func
`define JALR 6'b00_1001 //func

`define MFC0 5'b0_0000 //rs
`define MTC0 5'b0_0100 //rs
`define ERET 32'b0100_0010_0000_0000_0000_0000_0001_1000
`define SYSCALL 6'b00_1100 //func