`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:27:44 10/30/2024 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] A,
    input [31:0] B,
    output [31:0] C,
    output [4:0] BranchSel,
    input [4:0] ALUOp
    );

assign C = (ALUOp == `ALU_add) ? A + B :
            (ALUOp == `ALU_sub) ? A - B :
            (ALUOp == `ALU_ori) ? A | B :
            (ALUOp == `ALU_sll) ? A << B[10:6] :
            (ALUOp == `ALU_lui) ? {B[15:0], 16'b0} : A;

assign BranchSel = (A == B) ? 4'b1 : 4'b0;

endmodule
