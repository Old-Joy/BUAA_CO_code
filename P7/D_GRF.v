`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:47:17 10/30/2024 
// Design Name: 
// Module Name:    GRF 
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
module D_GRF(
	input [31:0] PC,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    output [31:0] RD1,
    output [31:0] RD2,
    input [31:0] WD,
    input clk,
    input reset
    );

reg [31:0] register[0:31];
integer i;

initial begin
    for (i = 0; i <= 31; i = i + 1) begin
        register[i] = 32'd0;
    end
end

always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i <= 31; i = i + 1) begin
            register[i] <= 32'd0;
        end
    end else begin
        if (A3 != 5'd0) begin
            register[A3] <= WD;
        end
    end
end

assign RD1 = (A1 == 5'd0) ? 32'd0 : 
                (A1 == A3) ? WD : register[A1];
assign RD2 = (A2 == 5'd0) ? 32'd0 : 
                (A2 == A3) ? WD : register[A2];

endmodule
