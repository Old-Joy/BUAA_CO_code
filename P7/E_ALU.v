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
module E_ALU(
    input [31:0] A,
    input [31:0] B,
    input ALUDMOv,
    input ALUAriOv,
    output reg [31:0] C,
    input [4:0] ALUOp,
    output EXC_AriOv,
    output EXC_DMOv
    );

always @(*) begin
    case (ALUOp)
        `ALU_add : C = A + B;
        `ALU_sub : C = A - B;
        `ALU_or : C = A | B;
        `ALU_sll : C = A << B[10:6];
        `ALU_lui : C = {B[15:0], 16'b0};
        `ALU_and : C = A & B;
        `ALU_slt : C = $signed(A) < $signed(B);
        `ALU_sltu : C = A < B;
        default : C = 32'd0; 
    endcase
end

wire [32:0] ext_A, ext_B;
wire [32:0] ext_add, ext_sub;

assign ext_A = {A[31], A};
assign ext_B = {B[31], B};
assign ext_add = ext_A + ext_B;
assign ext_sub = ext_A - ext_B;

wire overflow;
assign overflow = (ALUOp == `ALU_add && ext_add[32] != ext_add[31]) || (ALUOp == `ALU_sub && ext_sub[32] != ext_sub[31]);

assign EXC_AriOv = (ALUAriOv) && overflow;
assign EXC_DMOv = (ALUDMOv) && overflow;

endmodule