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
module IFU(
    input [31:0] NPC,
    output [31:0] PC,
    output [31:0] Instr,
    input clk,
    input reset
    );

reg [31:0] IM [0:4095];
reg [31:0] _PC;
integer i;

initial begin
    for (i = 0; i <= 1023; i = i + 1) begin
        IM[i] = 32'b0;
    end
    _PC = 32'h00003000;
    $readmemh("code.txt", IM);
end

always @(posedge clk ) begin
    if (reset) begin
        _PC <= 32'h00003000;
    end else begin
        _PC <= NPC;
    end
end

assign PC = _PC;
assign Instr = IM[(_PC-32'h00003000) / 4];

endmodule
