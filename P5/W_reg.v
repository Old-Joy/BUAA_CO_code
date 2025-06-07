`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:06:18 11/05/2024 
// Design Name: 
// Module Name:    W_reg 
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
module W_reg(
    input clk,
    input reset,
    input flush,
    input WrEn, 
    input [31:0] M_PC,
    input [31:0] M_Instr,
    input [31:0] M_DMRD,
    input [31:0] M_ALUAns,
    output [31:0] W_PC,
    output [31:0] W_Instr,
    output [31:0] W_DMRD,
    output [31:0] W_ALUAns
    );

reg [31:0] PCReg, InstrReg, DMRDReg, ALUAnsReg;

initial begin
    PCReg = 32'b0;
    InstrReg = 32'b0;
    DMRDReg = 32'b0;
    ALUAnsReg = 32'b0;
end

always @(posedge clk ) begin
    if (reset || flush) begin
        PCReg <= 32'b0;
        InstrReg <= 32'b0;
        DMRDReg <= 32'b0;
        ALUAnsReg <= 32'b0;    
    end else if (WrEn) begin
        PCReg <= M_PC;
        InstrReg <= M_Instr;
        DMRDReg <= M_DMRD;
        ALUAnsReg <= M_ALUAns; 
    end
end

assign W_PC = PCReg;
assign W_Instr = InstrReg;
assign W_DMRD = DMRDReg;
assign W_ALUAns = ALUAnsReg;

endmodule
