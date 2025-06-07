`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:26:13 11/05/2024 
// Design Name: 
// Module Name:    E_reg 
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
module E_reg(
    input clk,
    input reset,
    input flush,
    input WrEn,
    input Req,

    input [31:0] D_PC,
    input [31:0] D_Instr,
    input [31:0] D_ext32,
    input [31:0] D_rs_data,
    input [31:0] D_rt_data,
    input D_b_jump,
    input D_Delayslot,
    input [4:0] D_EXCcode,

    output [31:0] E_PC,
    output [31:0] E_Instr,
    output [31:0] E_ext32,
    output [31:0] E_rs_data,
    output [31:0] E_rt_data,
    output E_b_jump,
    output E_Delayslot,
    output [4:0] E_EXCcode
    );

reg [31:0] PCReg, InstrReg, ext32Reg, rs_dataReg, rt_dataReg;
reg jumpReg, DelayslotReg;
reg [4:0] EXCcodeReg;

initial begin
    PCReg = 32'b0;
    InstrReg = 32'b0;
    ext32Reg = 32'b0;
    rs_dataReg = 32'b0;
    rt_dataReg = 32'b0;
    jumpReg = 1'b0;
    DelayslotReg = 1'b0;
    EXCcodeReg = 5'd0;
end

always @(posedge clk ) begin
    if (reset || flush || Req) begin
        PCReg <= flush ? D_PC : (Req ? 32'h4180 : 32'b0);
        InstrReg <= 32'b0;
        ext32Reg <= 32'b0;
        rs_dataReg <= 32'b0;
        rt_dataReg <= 32'b0;
        jumpReg <= 1'b0;
        DelayslotReg <= flush ? D_Delayslot : 1'b0;
        EXCcodeReg <= flush ? D_EXCcode : 5'd0;
    end else if (WrEn) begin
        PCReg <= D_PC;
        InstrReg <= D_Instr;
        ext32Reg <= D_ext32;
        rs_dataReg <= D_rs_data;
        rt_dataReg <= D_rt_data;
        jumpReg <= D_b_jump;
        DelayslotReg <= D_Delayslot;
        EXCcodeReg <= D_EXCcode;
    end
end

assign E_PC = PCReg;
assign E_Instr = InstrReg;
assign E_ext32 = ext32Reg;
assign E_rs_data = rs_dataReg;
assign E_rt_data = rt_dataReg;
assign E_b_jump = jumpReg;
assign E_Delayslot = DelayslotReg;
assign E_EXCcode = EXCcodeReg;

endmodule
