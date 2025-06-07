`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:38:22 11/05/2024 
// Design Name: 
// Module Name:    D_CMP 
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
module D_CMP(
    input [31:0] rs,
    input [31:0] rt,
    input [2:0] CMPOp,
    output b_jump
    );

assign b_jump = (CMPOp == `CMP_beq) ? (rs == rt) ? 1'b1 : 1'b0 : 1'b0;



endmodule
