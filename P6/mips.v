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
`include "def.v"
module mips(
    input clk,
    input reset,

    input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,

    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3 :0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr

    );

wire [31:0] F_PC, F_Instr, D_PC, D_Instr, E_PC, E_Instr, M_PC, M_Instr, W_PC, W_Instr;//各级的PC值和指令值

wire [4:0] E_GRFA3, M_GRFA3, W_GRFA3;//各级的GRF写入地址
wire [31:0] F_GRFWD, D_GRFWD, E_GRFWD, M_GRFWD, W_GRFWD;//各级的GRF写入内容

wire D_b_jump, E_b_jump, M_b_jump, W_b_jump;//各级的跳转信号

wire stall;//阻塞信号
wire E_MDU_Busy, E_MDU_Start;

wire D_reg_WrEn, E_reg_WrEn, M_reg_WrEn, W_reg_WrEn;//流水线寄存器写使能信号（阻塞）
wire PCWrEn;

wire D_reg_flush, E_reg_flush, M_reg_flush, W_reg_flush;//流水线寄存器清空信号

wire [31:0] NPC;


STALL stallCtrl(
    .D_Instr(D_Instr), 
    .E_Instr(E_Instr), 
    .M_Instr(M_Instr),
    .E_MDU_Busy(E_MDU_Busy),
    .E_MDU_Start(E_MDU_Start),

    .Stall(stall)
);

assign D_reg_WrEn = !stall;
assign E_reg_WrEn = 1'b1;
assign M_reg_WrEn = 1'b1;
assign W_reg_WrEn = 1'b1;

assign PCWrEn = !stall;

assign D_reg_flush = 1'b0;
assign E_reg_flush = stall;
assign M_reg_flush = 1'b0;
assign W_reg_flush = 1'b0;


//********************** F级***************************

F_PC f_ifu(
    .clk(clk),
    .reset(reset),
    .PCWrEn(PCWrEn),
    .NPC(NPC),
    .PC(F_PC) // output
);

assign i_inst_addr = F_PC;
assign F_Instr = i_inst_rdata;

//********************** D级***************************

D_reg d_reg(
    .clk(clk),
    .reset(reset),
    .flush(D_reg_flush),
    .WrEn(D_reg_WrEn),

    .F_PC(F_PC),
    .F_Instr(F_Instr),

    .D_PC(D_PC), // output
    .D_Instr(D_Instr) // output
);

//D级译码得到的信息
wire [4:0] D_rs, D_rt;
wire [15:0] imm16;
wire [25:0] imm26;
//D级部件需要的控制信号
wire [2:0] CMPOp, NPCOp;
wire [1:0] EXTOp;
//D级部件给出的信号
wire [31:0] D_rs_data;
wire [31:0] D_rt_data;
wire [31:0] D_ext32;
//D级需要转发处理的信息
wire [31:0] D_Forword_rs_data;
wire [31:0] D_Forword_rt_data;

CONTROLLER d_ctrl(
    .Instr(D_Instr),
    // output
    .rs(D_rs), // A1
    .rt(D_rt), // A2
    .imm16(imm16),
    .imm26(imm26),
    .CMPOp(CMPOp),
    .EXTOp(EXTOp),
    .NPCOp(NPCOp)
);

D_GRF d_grf(
    .clk(clk),
    .reset(reset),
    .PC(W_PC),
    .A1(D_rs),
    .A2(D_rt),
    .A3(W_GRFA3),
    .RD1(D_rs_data), // output
    .RD2(D_rt_data), // output
    .WD(W_GRFWD)
);

D_EXT d_ext(
    .in(imm16),
    .EXTOp(EXTOp),
    .out(D_ext32) // output
);

assign D_Forword_rs_data = (D_rs == 5'd0) ? 32'd0 :
                            (D_rs == E_GRFA3) ? E_GRFWD : //if D_rs equals E's addr of GRF writing ,we should transform
                            (D_rs == M_GRFA3) ? M_GRFWD : //like that
                            D_rs_data;

assign D_Forword_rt_data = (D_rt == 5'd0) ? 32'd0 :
                            (D_rt == E_GRFA3) ? E_GRFWD : 
                            (D_rt == M_GRFA3) ? M_GRFWD : 
                            D_rt_data;

D_NPC d_npc(
    .F_PC(F_PC),
    .D_PC(D_PC),
    .b_jump(D_b_jump),
    .NPCOp(NPCOp),
    .IMM(imm26),
    .ra(D_Forword_rs_data),
    .NPC(NPC) // output
);

D_CMP d_cmp(
    .rs(D_Forword_rs_data),
    .rt(D_Forword_rt_data),
    .CMPOp(CMPOp),
    .b_jump(D_b_jump) // output
);

//********************** E级***************************

//E级得到的信息
wire [31:0] E_ext32;
wire [31:0] E_rs_data, E_rt_data;

E_reg e_reg(
    .clk(clk),
    .reset(reset),
    .flush(E_reg_flush),
    .WrEn(E_reg_WrEn),
    .D_PC(D_PC),
    .D_Instr(D_Instr),
    .D_ext32(D_ext32),
    .D_rs_data(D_Forword_rs_data),
    .D_rt_data(D_Forword_rt_data),
    // output
    .E_PC(E_PC),
    .E_Instr(E_Instr),
    .E_ext32(E_ext32),
    .E_rs_data(E_rs_data),
    .E_rt_data(E_rt_data)
);

//E级解码得到的信息
wire [4:0] E_rs, E_rt;
//E级部件需要的控制信号
wire [4:0] ALUOp;
wire [2:0] ALUASel;
wire [2:0] ALUBSel;
wire [2:0] E_GRFWDSel;
wire [4:0] MDUOp;
//E级部件得到的信息
wire [31:0] E_ALUAns;
wire [31:0] E_MDUAns;
wire [31:0] E_MDU_HI, E_MDU_LO;
//E级需要处理转发的信息
wire [31:0] E_Forword_rs_data;
wire [31:0] E_Forword_rt_data;

CONTROLLER e_ctrl(
    .Instr(E_Instr),

    // output
    .rs(E_rs),
    .rt(E_rt),
    .ALUOp(ALUOp),
    .ALUASel(ALUASel),
    .ALUBSel(ALUBSel),
    .GRFA3(E_GRFA3),
    .MDUOp(MDUOp),
    .MDUStart(E_MDU_Start)
);

assign E_Forword_rs_data = (E_rs == 5'd0) ? 32'd0 :
                            (E_rs == M_GRFA3) ? M_GRFWD :
                            (E_rs == W_GRFA3) ? W_GRFWD :
                            E_rs_data;
assign E_Forword_rt_data = (E_rt == 5'd0) ? 32'd0 :
                            (E_rt == M_GRFA3) ? M_GRFWD :
                            (E_rt == W_GRFA3) ? W_GRFWD :
                            E_rt_data;
assign E_GRFWD = E_PC + 32'd8;

wire [31:0] ALUA, ALUB;


assign ALUA = (ALUASel == `ALU_A_rs) ? E_Forword_rs_data : 
                (ALUASel == `ALU_A_rt) ? E_Forword_rt_data : 32'b0;
assign ALUB = (ALUBSel == `ALU_B_GRF) ? E_Forword_rt_data :
                (ALUBSel == `ALU_B_IMM) ? E_ext32 : 32'b0;

E_ALU e_alu(
    .A(ALUA),
    .B(ALUB),
    .ALUOp(ALUOp),
    .C(E_ALUAns) // output
);

E_MDU e_mdu(
    .clk(clk),
    .reset(reset),
    .MDUOp(MDUOp),
    .Data1(E_Forword_rs_data),
    .Data2(E_Forword_rt_data),
    .Start(E_MDU_Start),
    .Busy(E_MDU_Busy),
    .HI(E_MDU_HI),
    .LO(E_MDU_LO)
);

assign E_MDUAns = (MDUOp == `MDU_mfhi) ? E_MDU_HI :
                    (MDUOp == `MDU_mflo) ? E_MDU_LO : 32'd0;

//********************** M级***************************

//M级得到的信息
wire [31:0] M_ALUAns;
wire [31:0] M_ext32;
wire [31:0] M_rt_data;
wire [31:0] M_MDUAns;

M_reg m_reg(
    .clk(clk),
    .reset(reset),
    .flush(M_reg_flush),
    .WrEn(M_reg_WrEn),
    .E_PC(E_PC),
    .E_Instr(E_Instr),
    .E_ext32(E_ext32),
    .E_rt_data(E_Forword_rt_data),
    .E_ALUAns(E_ALUAns),
    .E_MDUAns(E_MDUAns),
    //output
    .M_PC(M_PC),
    .M_Instr(M_Instr),
    .M_ext32(M_ext32),
    .M_rt_data(M_rt_data),
    .M_ALUAns(M_ALUAns),
    .M_MDUAns(M_MDUAns)
);

//M级解码得到的信息
wire [4:0] M_rt;
//M级部件需要的控制信号
wire [2:0] DEOp, BEOp;
wire DMWrEn;
wire [2:0] M_GRFWDSel;
//M级部件得到的信息
wire [31:0] M_DMRD;
//M级需要转发的信息
wire [31:0] M_Forword_rt_data;

CONTROLLER m_ctrl(
    .Instr(M_Instr),
    // output
    .rt(M_rt),
    .BEOp(BEOp),
    .DEOp(DEOp),
    .GRFA3(M_GRFA3),
    .GRFWDSel(M_GRFWDSel)
);

assign M_Forword_rt_data = (M_rt == 5'd0) ? 32'd0 :
                            (M_rt == W_GRFA3) ? W_GRFWD : M_rt_data;

assign M_GRFWD = (M_GRFWDSel == `GRFWDSel_ALU) ? M_ALUAns : 
                (M_GRFWDSel == `GRFWDSel_PC8) ? M_PC + 8 :
                (M_GRFWDSel == `GRFWDSel_MDU) ? M_MDUAns : 0;

M_BE m_be(
    .BEOp(BEOp),
    .Addr(M_ALUAns),
    .rt_data(M_Forword_rt_data),
    .m_data_byteen(m_data_byteen),
    .m_data_wdata(m_data_wdata)
);

assign m_inst_addr = M_PC;
assign m_data_addr = M_ALUAns;

M_DE m_de(
    .Addr(M_ALUAns),
    .DEOp(DEOp),
    .m_data_rdata(m_data_rdata),
    .DMRD(M_DMRD)
);

//********************** W级***************************

//W级得到的信息
wire [31:0] W_DMRD;
wire [31:0] W_ALUAns;
wire [31:0] W_MDUAns;

W_reg w_reg(
    .clk(clk),
    .reset(reset),
    .flush(W_reg_flush),
    .WrEn(W_reg_WrEn),
    .M_PC(M_PC),
    .M_Instr(M_Instr),
    .M_DMRD(M_DMRD),
    .M_ALUAns(M_ALUAns),
    .M_MDUAns(M_MDUAns),
    // output
    .W_PC(W_PC),
    .W_Instr(W_Instr),
    .W_DMRD(W_DMRD),
    .W_ALUAns(W_ALUAns),
    .W_MDUAns(W_MDUAns)
);

wire [2:0] W_GRFWDSel;

CONTROLLER w_ctrl(
    .Instr(W_Instr),
    .GRFA3(W_GRFA3),
    .GRFWDSel(W_GRFWDSel)
);

assign W_GRFWD = (W_GRFWDSel == `GRFWDSel_ALU) ? W_ALUAns :
                    (W_GRFWDSel == `GRFWDSel_DM) ? W_DMRD :
                    (W_GRFWDSel == `GRFWDSel_PC8) ? W_PC + 8 :
                    (W_GRFWDSel == `GRFWDSel_MDU) ? W_MDUAns : 0;

assign w_grf_addr = W_GRFA3;
assign w_grf_wdata = W_GRFWD;
assign w_grf_we = 1'b1;
assign w_inst_addr = W_PC;

endmodule
