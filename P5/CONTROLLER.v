`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:57:28 10/31/2024 
// Design Name: 
// Module Name:    datapath 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "def.v"
module CONTROLLER(
    input [31:0] Instr,

    //译码
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd, 
    output [15:0] imm16,
    output [25:0] imm26,

    //控制信号
    output EXTOp,
    output [2:0] CMPOp,
    output [2:0] NPCOp,
    output [4:0] ALUOp,
    output [2:0] DMOp,
    output [2:0] ALUASel,
    output [2:0] ALUBSel,
    output [2:0] GRFWDSel,
    output [4:0] GRFA3,
    output DMWrEn,

    output add,
    output sub,
    output ori,
    output lw,
    output sw,
    output beq,
    output sll,
    output lui,
    output j,
    output jal,
    output jr,
    output jalr,
    output lb,
    output sb
    );

//译码

wire [5:0] opcode, func;

assign opcode = Instr[31:26];
assign func = Instr[5:0];
assign rs = Instr[25:21];
assign rt = Instr[20:16];
assign rd = Instr[15:11];
assign imm16 = Instr[15:0];
assign imm26 = Instr[25:0];

assign add = (opcode == `special) & (func == `ADD);
assign sub = (opcode == `special) & (func == `SUB);
assign ori = (opcode == `ORI);
assign lw = (opcode == `LW);
assign sw = (opcode == `SW);
assign beq = (opcode == `BEQ);
assign lui = (opcode == `LUI);
assign sll = (opcode == `special) & (func == `SLL);
assign j = (opcode == `J);
assign jal = (opcode == `JAL);
assign jr = (opcode == `special) & (func == `JR);
assign jalr = (opcode == `special) & (func == `JALR);
assign lb = (opcode == `LB);
assign sb = (opcode == `SB);

assign GRFA3 = (add | sub | sll | jalr) ? rd :
                (ori | lui | lw | lb) ? rt : 
                (jal) ? 5'd31 : 5'd0;

assign GRFWDSel = (lw | lb) ? `GRFWDSel_DM :
                    (add | sub | ori | lui | sll) ? `GRFWDSel_ALU :
                    (jal | jalr) ? `GRFWDSel_PC8 : 0;

assign EXTOp = (lw | sw | lb | sb) ? `EXT_sign : `EXT_zero;

assign ALUBSel = (ori | lw | sw | lui | sll | lb | sb) ? `ALU_B_IMM : `ALU_B_GRF;

assign ALUOp = (add) ? `ALU_add :
                (sub) ? `ALU_sub : 
                (ori) ? `ALU_ori :
                (sll) ? `ALU_sll :
                (lui) ? `ALU_lui : `ALU_add;
 
assign DMWrEn = sw | sb;

assign DMOp = (sb | lb) ? `DM_lb_sb : `DM_lw_sw;

assign NPCOp = (beq) ? `NPC_b :
                (j | jal) ? `NPC_j_jal :
                (jr | jalr) ? `NPC_jr_jalr : `NPC_PC4;

assign ALUASel = (sll) ? `ALU_A_rt : `ALU_A_rs;

assign CMPOp = (beq) ? `CMP_beq : 3'b0;

endmodule
