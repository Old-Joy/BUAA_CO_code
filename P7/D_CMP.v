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
    output reg b_jump
    );

always@(*) begin
    case(CMPOp)
        `CMP_beq : begin
            if (rs == rt) begin
                b_jump = 1'b1;
            end else begin
                b_jump = 1'b0;
            end
        end
        `CMP_bne : begin
            if (rs == rt) begin
                b_jump = 1'b0;
            end else begin
                b_jump = 1'b1;
            end
        end
    endcase
end


endmodule
