`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:53:13 11/05/2024 
// Design Name: 
// Module Name:    M_reg 
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
module M_reg(
    input clk,
    input reset,
    input flush,
    input WrEn,
    input [31:0] E_PC,
    input [31:0] E_Instr,
    input [31:0] E_ext32,
    input [31:0] E_rt_data,
    input [31:0] E_ALUAns,
    output [31:0] M_PC,
    output [31:0] M_Instr,
    output [31:0] M_ext32,
    output [31:0] M_rt_data,
    output [31:0] M_ALUAns
    );

reg [31:0] PCReg, InstrReg, ext32Reg, rt_dataReg, ALUAnsReg;

initial begin
    PCReg = 32'b0;
    InstrReg = 32'b0;
    ext32Reg = 32'b0;
    rt_dataReg = 32'b0;
    ALUAnsReg = 32'b0;
end

always@(posedge clk) begin
    if (reset || flush) begin
        PCReg <= 32'b0;
        InstrReg <= 32'b0;
        ext32Reg <= 32'b0;
        rt_dataReg <= 32'b0;
        ALUAnsReg <= 32'b0;
    end else if (WrEn) begin
        PCReg <= E_PC;
        InstrReg <= E_Instr;
        ext32Reg <= E_ext32;
        rt_dataReg <= E_rt_data;
        ALUAnsReg <= E_ALUAns;
    end
end

assign M_PC = PCReg;
assign M_Instr = InstrReg;
assign M_ext32 = ext32Reg;
assign M_ALUAns = ALUAnsReg;
assign M_rt_data = rt_dataReg;

endmodule
