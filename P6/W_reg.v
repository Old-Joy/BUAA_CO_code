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
    input M_b_jump,
    input [31:0] M_MDUAns,

    output [31:0] W_PC,
    output [31:0] W_Instr,
    output [31:0] W_DMRD,
    output [31:0] W_ALUAns,
    output W_b_jump,
    output [31:0] W_MDUAns
    );

reg [31:0] PCReg, InstrReg, DMRDReg, ALUAnsReg, MDUAnsReg;
reg jumpReg;

initial begin
    PCReg = 32'b0;
    InstrReg = 32'b0;
    DMRDReg = 32'b0;
    ALUAnsReg = 32'b0;
    jumpReg = 1'b0;
    MDUAnsReg = 32'd0;
end

always @(posedge clk ) begin
    if (reset || flush) begin
        PCReg <= 32'b0;
        InstrReg <= 32'b0;
        DMRDReg <= 32'b0;
        ALUAnsReg <= 32'b0;   
        jumpReg <= 1'b0; 
        MDUAnsReg <= 32'd0;
    end else if (WrEn) begin
        PCReg <= M_PC;
        InstrReg <= M_Instr;
        DMRDReg <= M_DMRD;
        ALUAnsReg <= M_ALUAns; 
        jumpReg <= M_b_jump;
        MDUAnsReg <= M_MDUAns;
    end
end

assign W_PC = PCReg;
assign W_Instr = InstrReg;
assign W_DMRD = DMRDReg;
assign W_ALUAns = ALUAnsReg;
assign W_b_jump = jumpReg;
assign W_MDUAns = MDUAnsReg;

endmodule
