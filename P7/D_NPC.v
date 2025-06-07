`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:29:39 10/30/2024 
// Design Name: 
// Module Name:    NPC 
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
module D_NPC(
    input [31:0] EPC,
    input Req,
    input eret,
    input [31:0] F_PC,
    input [31:0] D_PC,
    input b_jump,
    input [2:0] NPCOp,
    input [31:0] ra,
    input [25:0] IMM,
    output [31:0] NPC,
    output Delayslot
    );

wire [31:0] IMM_b, IMM_b_PC4, IMM_j_jal;
wire [31:0] PC_4;

assign PC_4 = F_PC + 4;
assign IMM_b = {{14{IMM[15]}}, IMM[15:0], 2'b0};
assign IMM_b_PC4 = IMM_b + D_PC + 4;
assign IMM_j_jal = {D_PC[31:28], IMM, 2'b0};

assign NPC = (Req) ? 32'h0000_4180 :
            (eret) ? EPC + 4 :
            (NPCOp == `NPC_PC4) ? PC_4 : 
            (NPCOp == `NPC_b) ? (b_jump == 1'b1) ? IMM_b_PC4 : PC_4 :
            (NPCOp == `NPC_j_jal) ? IMM_j_jal :
            (NPCOp == `NPC_jr_jalr) ? ra : PC_4;

assign Delayslot = (NPCOp != `NPC_PC4) ? 1'b1 : 1'b0; 

endmodule
