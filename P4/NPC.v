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
module NPC(
    input [31:0] PC,
    input [2:0] NPCOp,
    input [31:0] RA,
    input [25:0] IMM,
    input [4:0] BranchSel,
    output [31:0] NPC,
    output [31:0] PC_4  
    );

wire [31:0] IMM_beq, IMM_beq_PC4, IMM_j_jal;

assign PC_4 = PC + 4;
assign IMM_beq = {{14{IMM[15]}}, IMM[15:0], 2'b0};
assign IMM_beq_PC4 = IMM_beq + PC_4;
assign IMM_j_jal = {PC[31:28], IMM, 2'b0};
assign NPC = (NPCOp == `NPC_PC4) ? PC_4 : 
            (NPCOp == `NPC_beq && BranchSel == 4'b0) ? PC_4 :
            (NPCOp == `NPC_beq && BranchSel == 1'b1) ? IMM_beq_PC4 : 
            (NPCOp == `NPC_j_jal) ? IMM_j_jal : 
            (NPCOp == `NPC_jr_jalr) ? RA : PC_4; 

endmodule
