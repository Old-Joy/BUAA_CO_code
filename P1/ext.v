`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:42:18 10/05/2024 
// Design Name: 
// Module Name:    ext 
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
module ext(
    input [15:0] imm,
    input [1:0] EOp,
    output [31:0] ext
    );

wire [31:0] out1, out2, out3, out4;
assign out1 = {{16{imm[15]}}, imm};
assign out2 = {16'b0, imm};
assign out3 = {imm, 16'b0};
assign out4 = {{14{imm[15]}}, imm, 2'b0};
assign ext = (EOp == 2'b00) ? out1 :
                (EOp == 2'b01) ? out2 :
                (EOp == 2'b10) ? out3 :
                out4;

endmodule
