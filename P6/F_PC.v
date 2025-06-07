`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:21:00 10/30/2024 
// Design Name: 
// Module Name:    IFU 
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
module F_PC(
    input [31:0] NPC,
    output [31:0] PC,
    input clk,
    input reset,
    input PCWrEn
    );

reg [31:0] PCreg;

initial begin
    PCreg = 32'h00003000;
end

always @(posedge clk ) begin
    if (reset) begin
        PCreg <= 32'h00003000;
    end else if (PCWrEn) begin
        PCreg <= NPC;
    end
end

assign PC = PCreg;

endmodule
