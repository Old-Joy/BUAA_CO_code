`define EXT_zero 1'b0
`define EXT_sign 1'b1

`define ALU_add 5'b00000
`define ALU_sub 5'b1
`define ALU_ori 5'b10
`define ALU_sll 5'b11
`define ALU_lui 5'b100

`define NPC_PC4 3'b000
`define NPC_beq 3'b001
`define NPC_j_jal 3'b010
`define NPC_jr_jalr 3'b011

`define DM_lw_sw 3'b0
`define DM_lb_sb 3'b1
