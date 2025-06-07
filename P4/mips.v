`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:14:58 10/30/2024 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );

wire EXTOp, GRFWrEn, DMWrEn, sllOp;
wire [2:0] NPCOp, DMOp, ALUBSel, WDSel, WRA3Sel;
wire [4:0] ALUOp;
wire [5:0] opcode, func;

DATAPATH datapath(
    .clk(clk),
    .reset(reset),
    .EXTOp(EXTOp),
    .NPCOp(NPCOp),
    .GRFWrEn(GRFWrEn),
    .ALUOp(ALUOp),
    .DMOp(DMOp),
    .DMWrEn(DMWrEn),
    .ALUBSel(ALUBSel),
    .WDSel(WDSel),
    .WRA3Sel(WRA3Sel),
    .sllOp(sllOp),
    .opcode(opcode), //output
    .func(func) //output
);

CONTROLLER controller(
    .opcode(opcode),
    .func(func),
    //output
    .EXTOp(EXTOp),
    .NPCOp(NPCOp),
    .GRFWrEn(GRFWrEn),
    .ALUOp(ALUOp),
    .DMOp(DMOp),
    .DMWrEn(DMWrEn),
    .ALUBSel(ALUBSel),
    .WDSel(WDSel),
    .WRA3Sel(WRA3Sel),
    .sllOp(sllOp)
);

endmodule
