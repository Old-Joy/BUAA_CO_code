`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:57:28 10/31/2024 
// Design Name: 
// Module Name:    datapath 
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
`define special 6'b00_0000
`define ADD 6'b10_0000 //func
`define SUB 6'b10_0010 //func
`define ORI 6'b00_1101
`define LW 6'b10_0011
`define SW 6'b10_1011
`define BEQ 6'b00_0100
`define LUI 6'b00_1111
`define SLL 6'b00_0000 //func
`define J 6'b00_0010
`define JAL 6'b00_0011
`define JR 6'b00_1000 //func
`define JALR 6'b00_1001 //func
`define LB 6'b10_0000
`define SB 6'b10_1000
module CONTROLLER(
    input [5:0] opcode,
    input [5:0] func,
    output EXTOp,
    output [2:0] NPCOp,
    output GRFWrEn,
    output [4:0] ALUOp,
    output [2:0] DMOp,
    output DMWrEn,
    output [2:0] ALUBSel,
    output [2:0] WDSel,
    output [2:0] WRA3Sel,
    output sllOp
    );

wire add, sub, ori, lw, sw, beq, sll, lui, j, jal, jr, jalr, lb, sb;

assign add = (opcode == `special) & (func == `ADD);
assign sub = (opcode == `special) & (func == `SUB);
assign ori = (opcode == `ORI);
assign lw = (opcode == `LW);
assign sw = (opcode == `SW);
assign beq = (opcode == `BEQ);
assign lui = (opcode == `LUI);
assign sll = (opcode == `special) & (func == `SLL);
assign j = (opcode == `J);
assign jal = (opcode == `JAL);
assign jr = (opcode == `special) & (func == `JR);
assign jalr = (opcode == `special) & (func == `JALR);
assign lb = (opcode == `LB);
assign sb = (opcode == `SB);


assign WRA3Sel[2] = 0;
assign WRA3Sel[1] = jal;
assign WRA3Sel[0] = ori | lw | lui | lb;

assign WDSel[2] = 0;
assign WDSel[1] = jal | jalr;
assign WDSel[0] = add | sub | ori | lui | sll;

assign EXTOp = lw | sw | lb | sb;

assign GRFWrEn = add | sub | ori | lw | lui | sll | jal | jalr | lb;

assign ALUBSel[2] = 0;
assign ALUBSel[1] = 0;
assign ALUBSel[0] = ori | lw | sw | lui | sll | lb | sb;

assign ALUOp[4] = 0;
assign ALUOp[3] = 0;
assign ALUOp[2] = lui;
assign ALUOp[1] = ori | sll;
assign ALUOp[0] = sub | beq | sll;

assign DMWrEn = sw | sb;

assign DMOp[2] = 0;
assign DMOp[1] = 0;
assign DMOp[0] = sb | lb;

assign NPCOp[2] = 0;
assign NPCOp[1] = j | jal | jr | jalr;
assign NPCOp[0] = beq | jr | jalr;

assign sllOp = sll;

endmodule
