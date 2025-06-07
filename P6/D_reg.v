`timescale 1ns / 1ps

module D_reg(
    input clk,
    input reset,
    input flush,
    input WrEn,
    input [31:0] F_PC,
    input [31:0] F_Instr,
    output [31:0] D_PC,
    output [31:0] D_Instr
    );

reg [31:0] PCReg, InstrReg;

initial begin
    PCReg = 32'b0;
    InstrReg = 32'b0;
end

always @(posedge clk ) begin
    if (reset || flush) begin
        PCReg <= 32'b0;
        InstrReg <= 32'b0;
    end else if (WrEn) begin 
        PCReg <= F_PC;
        InstrReg <= F_Instr;
    end
end

assign D_PC = PCReg;
assign D_Instr = InstrReg;

endmodule
