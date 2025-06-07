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
module CONTROLLER(
    input [31:0] Instr,
    input b_jump,

    //译码
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd, 
    output [15:0] imm16,
    output [25:0] imm26,

    //控制信号
    output [1:0] EXTOp,
    output [2:0] CMPOp,
    output [2:0] NPCOp,
    output [4:0] ALUOp,
    output [2:0] DEOp,
    output [2:0] BEOp,
    output [2:0] ALUASel,
    output [2:0] ALUBSel,
    output [2:0] GRFWDSel,
    output [4:0] GRFA3,
    output [4:0] MDUOp,
    output MDUStart,
    output DMWrEn,
    output GRFWrEn,

    output load,
    output store,
    output cal_r,
    output cal_i,
    output mcal,
    output mf,
    output mt,
    output jump_addr,
    output jump_link,
    output jump_reg,
    output branch,
    output sll
    );


//**译码**

wire [5:0] opcode, func;

assign opcode = Instr[31:26];
assign func = Instr[5:0];
assign rs = Instr[25:21];
assign rt = Instr[20:16];
assign rd = Instr[15:11];
assign imm16 = Instr[15:0];
assign imm26 = Instr[25:0];


//**指令**

wire add, sub, _and, _or, slt, sltu, lui;
wire addi, andi, ori;
wire lb, lh, lw, sb, sh, sw;
wire mult, multu, div, divu, mfhi, mflo, mthi, mtlo;
wire beq, bne, jal, jr;
wire j, jalr;

assign add = (opcode == `special) & (func == `ADD);
assign sub = (opcode == `special) & (func == `SUB);
assign _and = (opcode == `special) & (func == `AND);
assign _or = (opcode == `special) & (func == `OR);
assign slt = (opcode == `special) & (func == `SLT);
assign sltu = (opcode == `special) & (func == `SLTU);
assign lui = (opcode == `LUI);

assign addi = (opcode == `ADDI);
assign andi = (opcode == `ANDI);
assign ori = (opcode == `ORI);

assign lb = (opcode == `LB);
assign lh = (opcode == `LH);
assign lw = (opcode == `LW);
assign sb = (opcode == `SB);
assign sh = (opcode == `SH);
assign sw = (opcode == `SW);

assign mult = (opcode == `special) & (func == `MULT);
assign multu = (opcode == `special) & (func == `MULTU);
assign div = (opcode == `special) & (func == `DIV);
assign divu = (opcode == `special) & (func == `DIVU);
assign mfhi = (opcode == `special) & (func == `MFHI);
assign mflo = (opcode == `special) & (func == `MFLO);
assign mthi = (opcode == `special) & (func == `MTHI);
assign mtlo = (opcode == `special) & (func == `MTLO);

assign beq = (opcode == `BEQ);
assign bne = (opcode == `BNE);
assign sll = (opcode == `special) & (func == `SLL);
assign j = (opcode == `J);
assign jal = (opcode == `JAL);
assign jr = (opcode == `special) & (func == `JR);
assign jalr = (opcode == `special) & (func == `JALR);

//指令类型
assign load = lw | lh | lb;
assign store = sw | sh | sb;
assign cal_r = add | sub | slt | sltu | _and | _or | sll;
assign cal_i = addi | andi | ori | lui;
assign mcal = mult | multu | div | divu;
assign mf = mfhi | mflo;
assign mt = mthi | mtlo;
assign jump_addr = j | jal;
assign jump_link = jal | jalr;
assign jump_reg = jr | jalr;
assign branch = beq | bne;


//控制信号

assign GRFA3 = (cal_r | jalr | mf) ? rd :
                (cal_i | load) ? rt : 
                (jal) ? 5'd31 : 5'd0;

assign GRFWDSel = (load) ? `GRFWDSel_DM :
                    (cal_i | cal_r) ? `GRFWDSel_ALU :
                    (jump_link ) ? `GRFWDSel_PC8 : 
                    (mf) ? `GRFWDSel_MDU : 0;

assign EXTOp = (load | store | (cal_i && !andi && !ori)) ? `EXT_sign : `EXT_zero;

assign ALUBSel = (load | store | cal_i | sll) ? `ALU_B_IMM : `ALU_B_GRF;

assign ALUOp = (add | addi) ? `ALU_add :
                (sub) ? `ALU_sub : 
                (_or | ori) ? `ALU_or :
                (sll) ? `ALU_sll :
                (lui) ? `ALU_lui : 
                (slt) ? `ALU_slt :
                (sltu) ? `ALU_sltu :
                (_and | andi) ? `ALU_and : `ALU_add;
 
assign DMWrEn = store;

assign DEOp = (lw) ? `DE_lw : 
                (lh) ? `DE_lh :
                (lb) ? `DE_lb : `DE_lw;

assign BEOp = (sw) ? `BE_sw :
                (sh) ? `BE_sh :
                (sb) ? `BE_sb : `BE_null;

assign NPCOp = (beq | bne) ? `NPC_b :
                (j | jal) ? `NPC_j_jal :
                (jr | jalr) ? `NPC_jr_jalr : `NPC_PC4;

assign ALUASel = (sll) ? `ALU_A_rt : `ALU_A_rs;

assign CMPOp = (beq) ? `CMP_beq :
                (bne) ? `CMP_bne : `CMP_beq;

assign MDUOp = (mult) ? `MDU_mult :
                (multu) ? `MDU_multu :
                (div) ? `MDU_div :
                (divu) ? `MDU_divu :
                (mfhi) ? `MDU_mfhi :
                (mflo) ? `MDU_mflo :
                (mthi) ? `MDU_mthi :
                (mtlo) ? `MDU_mtlo : `MDU_mult;

assign MDUStart = mcal;

assign GRFWrEn = load | cal_i | cal_r | mf | jump_link;
endmodule
