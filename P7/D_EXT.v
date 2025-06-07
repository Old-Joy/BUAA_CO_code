`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:23:30 10/30/2024 
// Design Name: 
// Module Name:    EXT 
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
module D_EXT(
    input [15:0] in,
    output [31:0] out,
    input [1:0] EXTOp
    );

assign out = (EXTOp == `EXT_zero) ? {16'b0, in} : {{16{in[15]}}, in};

endmodule
