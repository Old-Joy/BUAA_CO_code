`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:58:54 10/31/2024 
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
module DATAPATH(
    input clk,
    input reset,
    input EXTOp,
    input [2:0] NPCOp,
    input GRFWrEn,
    input [4:0] ALUOp,
    input [2:0] DMOp,
    input DMWrEn,
    input [2:0] ALUBSel,
    input [2:0] WDSel,
    input [2:0] WRA3Sel,
    input sllOp,
    output [5:0] opcode,
    output [5:0] func
    );

wire [31:0] _npc_pc; //NPC set next addr to PC
wire [31:0] _ifuPc;
wire [31:0] INSTR;
wire [31:0] _rd1;
wire [31:0] _rd2;
wire [31:0] _npc_PC4;
wire [31:0] ALU_C;
wire [31:0] _ext;
wire [31:0] _realALUA;
wire [31:0] _realALUB;
wire [31:0] _dm_rd;
wire [31:0] _realWD;
wire [4:0] _realA3;
wire [4:0] ALU_BranchSel;

MUX mux (
    .GRF_WDMux0(_dm_rd),
    .GRF_WDMux1(ALU_C),
    .GRF_WDMux2(_npc_PC4),
    .GRF_WDSel(WDSel),
    .realGRF_WD(_realWD), //output
    .GRF_A3Mux0(INSTR[15:11]),
    .GRF_A3Mux1(INSTR[20:16]),
    .GRF_A3Mux2(5'h1f),
    .GRF_A3Sel(WRA3Sel),
    .realGRF_A3(_realA3), //output
    .ALU_AMux0(_rd1),
    .ALU_AMux1(_rd2),
    .ALU_ASel(sllOp),
    .realALU_A(_realALUA), //output
    .ALU_BMux0(_rd2),
    .ALU_BMux1(_ext),
    .ALU_BSel(ALUBSel),
    .realALU_B(_realALUB) //output
);

NPC npc (
    .PC(_ifuPc),
    .NPCOp(NPCOp),
    .RA(_rd1),
    .IMM(INSTR[25:0]),
    .BranchSel(ALU_BranchSel),
    .NPC(_npc_pc), //output
    .PC_4(_npc_PC4) //output
);

IFU ifu (
    .NPC(_npc_pc),
    .PC(_ifuPc), //output
    .Instr(INSTR), //output
    .clk(clk),
    .reset(reset)
);

GRF grf (
    .PC(_ifuPc),
    .A1(INSTR[25:21]),
    .A2(INSTR[20:16]),
    .A3(_realA3),
    .RD1(_rd1), //output
    .RD2(_rd2), //output
    .WD(_realWD),
    .GRFWrEn(GRFWrEn),
    .clk(clk),
    .reset(reset)
);

ALU alu (
    .A(_realALUA),
    .B(_realALUB),
    .C(ALU_C), //output
    .BranchSel(ALU_BranchSel), //output
    .ALUOp(ALUOp)
);

DM dm (
    .PC(_ifuPc),
    .Addr(ALU_C),
    .WD(_rd2),
    .clk(clk),
    .reset(reset),
    .DMWrEn(DMWrEn),
    .DMOp(DMOp),
    .RD(_dm_rd) //output
);

EXT ext (
    .in(INSTR[15:0]),
    .out(_ext), //output
    .EXTOp(EXTOp)
);

assign opcode = INSTR[31:26];
assign func = INSTR[5:0];

endmodule
