`timescale 1ns / 1ps

module D_reg(
    input clk,
    input reset,
    input flush,
    input WrEn,
    input Req,

    input [31:0] F_PC,
    input [31:0] F_Instr,
    input F_Delayslot, 
    input [4:0] F_EXCcode, 
    output [31:0] D_PC,
    output [31:0] D_Instr,
    output D_Delayslot,
    output [4:0] D_EXCcode
    );

reg [31:0] PCReg, InstrReg;
reg DelayslotReg;
reg [4:0] EXCcodeReg;

initial begin
    PCReg = 32'b0;
    InstrReg = 32'b0;
    DelayslotReg = 1'd0;
    EXCcodeReg = 5'd0;
end

always @(posedge clk ) begin
    if (reset || flush || Req) begin
        PCReg <= Req ? 32'h0000_4180 : 32'd0;
        InstrReg <= 32'b0;
        DelayslotReg <= 1'd0;
        EXCcodeReg <= 5'd0;
    end else if (WrEn) begin 
        PCReg <= F_PC;
        InstrReg <= F_Instr;
        DelayslotReg <= F_Delayslot;
        EXCcodeReg <= F_EXCcode;
    end
end

assign D_PC = PCReg;
assign D_Instr = InstrReg;
assign D_Delayslot = DelayslotReg;
assign D_EXCcode = EXCcodeReg;

endmodule
