`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:30:54 10/30/2024 
// Design Name: 
// Module Name:    DM 
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
module DM(
    input [31:0] PC,
    input [31:0] Addr,
    input [31:0] WD,
    input clk,
    input reset,
    input DMWrEn,
    input [2:0] DMOp,
    output [31:0] RD
    );

reg [31:0] DM [0:4095];
wire [31:0] _WD, _RD;//_WD, _RD is the wire connecting to DM
wire [1:0] address;
wire [11:0] _Addr;
integer i;

assign _Addr = Addr[13:2];

initial begin
    for (i = 0; i <= 1023; i = i + 1) begin
        DM[i] = 32'b0;
    end
end

assign address = Addr[1:0];
assign _WD = (DMOp == `DM_lw_sw) ? WD :
            (DMOp == `DM_lb_sb) ? (address == 2'b00) ? {_RD[31:8], WD[7:0]} :
                                (address == 2'b01) ? {_RD[31:16], WD[7:0], _RD[7:0]} :
                                (address == 2'b10) ? {_RD[31:24], WD[7:0], _RD[15:0]} : {WD[7:0], _RD[23:0]} : -1;
assign RD = (DMOp == `DM_lw_sw) ? _RD :
            (DMOp == `DM_lb_sb) ? (address == 2'b00) ? {{24{_RD[7]}}, _RD[7:0]} :
                                (address == 2'b01) ? {{24{_RD[15]}}, _RD[15:8]} :
                                (address == 2'b10) ? {{24{_RD[23]}}, _RD[23:16]} : {{24{_RD[31]}}, _RD[31:24]} : -1;
assign _RD = DM[_Addr];

always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i <= 1023; i = i + 1) begin
            DM[i] <= 32'b0;
        end
    end else begin
        if (DMWrEn) begin
            DM[_Addr] <= _WD;
            $display("@%h: *%h <= %h", PC, {Addr[31:2], 2'b0}, _WD);
        end
    end
end

endmodule
