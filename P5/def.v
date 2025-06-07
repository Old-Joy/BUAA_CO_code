// define of EXT
`define EXT_zero 1'b0
`define EXT_sign 1'b1

// define of the source of ALU_A
`define ALU_A_rs 3'b000
`define ALU_A_rt 3'b001

// define of the source of ALU_B
`define ALU_B_GRF 3'b0
`define ALU_B_IMM 3'b001

// define of ALUOp
`define ALU_add 5'b00000
`define ALU_sub 5'b00001
`define ALU_ori 5'b00010
`define ALU_sll 5'b00011
`define ALU_lui 5'b00100

// define of NPCOp
`define NPC_PC4 3'b000
`define NPC_b 3'b001
`define NPC_j_jal 3'b010
`define NPC_jr_jalr 3'b011

// define of DMOp
`define DM_lw_sw 3'b0
`define DM_lb_sb 3'b1

// define of CMPOp
`define CMP_beq 3'b000
`define CMP_bne 3'b001

//define of GRFWDSel, to mark where the message comes from
`define GRFWDSel_ALU 3'b000
`define GRFWDSel_DM 3'b001
`define GRFWDSel_PC8 3'b010

// define of Instr of opcode or function
`define special 6'b00_0000
`define ADD 6'b10_0000 //func
`define SUB 6'b10_0010 //func
`define ORI 6'b00_1101
`define LW 6'b10_0011
`define SW 6'b10_1011
`define BEQ 6'b00_0100
`define LUI 6'b00_1111
`define SLL 6'b00_0000 //func
`define J 6'b00_0010
`define JAL 6'b00_0011
`define JR 6'b00_1000 //func
`define JALR 6'b00_1001 //func
`define LB 6'b10_0000
`define SB 6'b10_1000