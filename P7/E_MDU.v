`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:31:06 11/16/2024 
// Design Name: 
// Module Name:    E_MDU 
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
module E_MDU(
    input clk,
    input reset,
    input Req,

    input [4:0] MDUOp,
    input [31:0] Data1,
    input [31:0] Data2,
    input Start,

    output reg [31:0] HI,
    output reg [31:0] LO,
    output reg Busy
    );

reg [5:0] cycle_cnt;
reg [31:0] HIreg, LOreg;

initial begin
    cycle_cnt = 6'd0;
    HI = 32'b0;
    LO = 32'b0;
    HIreg = 32'd0;
    LOreg = 32'd0;
end

always @(posedge clk ) begin
    if (reset) begin
        cycle_cnt <= 6'd0;
        HI <= 32'b0;
        LO <= 32'b0;
        Busy <= 1'b0;
    end else if (Req == 1'b0) begin
        if (cycle_cnt == 6'd0) begin
            if (Start) begin
                Busy <= 1'b1;
                if (MDUOp == `MDU_mult) begin
                    cycle_cnt <= 6'd5;
                    {HIreg, LOreg} <= $signed(Data1) * $signed(Data2);
                end else if (MDUOp == `MDU_multu) begin
                    cycle_cnt <= 6'd5;
                    {HIreg, LOreg} <= Data1 * Data2;
                end else if (MDUOp == `MDU_div) begin
                    cycle_cnt <= 6'd10;
                    HIreg = $signed(Data1) % $signed(Data2);
                    LOreg = $signed(Data1) / $signed(Data2);
                end else if (MDUOp == `MDU_divu) begin
                    cycle_cnt <= 6'd10;
                    HIreg = Data1 % Data2;
                    LOreg = Data1 / Data2;
                end
            end else begin
                cycle_cnt <= 0;
            end
        end else if (cycle_cnt == 6'd1) begin
            HI <= HIreg;
            LO <= LOreg;
            Busy <= 1'b0;
            cycle_cnt <= 6'd0;
        end else begin
            cycle_cnt <= cycle_cnt - 1;
        end 
    end
    if (MDUOp == `MDU_mthi && Req == 1'b0) begin
        HI <= Data1;
    end else if (MDUOp == `MDU_mtlo && Req == 1'b0) begin
        LO <= Data1;
    end
end

endmodule
