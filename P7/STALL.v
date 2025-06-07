`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:10:46 11/09/2024 
// Design Name: 
// Module Name:    STALL 
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
module STALL(
    input [31:0] D_Instr,
    input [31:0] E_Instr,
    input [31:0] M_Instr,

    input E_MDU_Busy,
    input E_MDU_Start,

    output Stall
    );

wire D_load, D_store, D_cal_r, D_cal_i, D_mcal, D_mf, D_mt, D_jump_addr, D_jump_link, D_jump_reg, D_branch, D_sll;
wire D_mfc0;
wire D_mtc0;
wire D_eret;
wire D_syscall;

wire [4:0] D_rs, D_rt;

CONTROLLER D_control(
    .Instr(D_Instr),
    // output
    .rs(D_rs),
    .rt(D_rt),

    .load(D_load),
    .store(D_store),
    .cal_r(D_cal_r),
    .cal_i(D_cal_i),
    .mcal(D_mcal),
    .mf(D_mf),
    .mt(D_mt),
    .jump_addr(D_jump_addr),
    .jump_link(D_jump_link),
    .jump_reg(D_jump_reg),
    .branch(D_branch),
    .sll(D_sll),

    .mfc0(D_mfc0),
    .mtc0(D_mtc0),
    .eret(D_eret),
    .syscall(D_syscall)
);

wire [7:0] D_Tuse_rs, D_Tuse_rt;
assign D_Tuse_rs = (D_branch | D_jump_reg) ? 8'd0 : 
                    ((D_cal_r && !D_sll) | D_mcal | D_mt | D_load | D_store | D_cal_i) ? 8'd1 : 8'd3;

assign D_Tuse_rt = (D_branch) ? 8'd0 : 
                    (D_cal_r | D_mcal) ? 8'd1 : 
                    (D_store | D_mtc0) ? 8'd2 : 8'd3;


wire E_load, E_store, E_cal_r, E_cal_i, E_mcal, E_mf, E_mt, E_jump_addr, E_jump_link, E_jump_reg, E_branch, E_sll;
wire E_mfc0;
wire E_mtc0;
wire E_eret;
wire E_syscall;

wire [4:0] E_GRFA3;
wire [4:0] E_rd;

CONTROLLER E_control(
    .Instr(E_Instr),
    // output
    .GRFA3(E_GRFA3),
    .rd(E_rd),

    .load(E_load),
    .store(E_store),
    .cal_r(E_cal_r),
    .cal_i(E_cal_i),
    .mcal(E_mcal),
    .mf(E_mf),
    .mt(E_mt),
    .jump_addr(E_jump_addr),
    .jump_link(E_jump_link),
    .jump_reg(E_jump_reg),
    .branch(E_branch),
    .sll(E_sll),

    .mfc0(E_mfc0),
    .mtc0(E_mtc0),
    .eret(E_eret),
    .syscall(E_syscall)
);

wire [7:0] E_Tnew;
assign E_Tnew = (E_cal_i | E_cal_r | E_mf) ? 8'd1 :
                (E_load | E_mfc0) ? 8'd2 : 8'd0;


wire M_load, M_store, M_cal_r, M_cal_i, M_mcal, M_mf, M_mt, M_jump_addr, M_jump_link, M_jump_reg, M_branch, M_sll;
wire M_mfc0;
wire M_mtc0;
wire M_eret;
wire M_syscall;

wire [4:0] M_GRFA3;
wire [4:0] M_rd;

CONTROLLER M_control(
    .Instr(M_Instr),
    // output
    .GRFA3(M_GRFA3),
    .rd(M_rd),

    .load(M_load),
    .store(M_store),
    .cal_r(M_cal_r),
    .cal_i(M_cal_i),
    .mcal(M_mcal),
    .mf(M_mf),
    .mt(M_mt),
    .jump_addr(M_jump_addr),
    .jump_link(M_jump_link),
    .jump_reg(M_jump_reg),
    .branch(M_branch),
    .sll(M_sll),

    .mfc0(M_mfc0),
    .mtc0(M_mtc0),
    .eret(M_eret),
    .syscall(M_syscall)
);

wire [7:0] M_Tnew;
assign M_Tnew = (M_load | M_mfc0) ? 8'd1 : 8'd0;

wire E_stall_rs, E_stall_rt, M_stall_rs, M_stall_rt, E_stall_mdu;

assign E_stall_rs = (D_rs == E_GRFA3 && (D_rs != 0)) && (E_Tnew > D_Tuse_rs);
assign E_stall_rt = (D_rt == E_GRFA3 && (D_rt != 0)) && (E_Tnew > D_Tuse_rt);
assign M_stall_rs = (D_rs == M_GRFA3 && (D_rs != 0)) && (M_Tnew > D_Tuse_rs);
assign M_stall_rt = (D_rt == M_GRFA3 && (D_rt != 0)) && (M_Tnew > D_Tuse_rt);

assign E_stall_mdu = ((D_mcal | D_mt | D_mf) && (E_MDU_Busy | E_MDU_Start));

assign M_stall_eret = (D_eret) && ((E_mtc0 && (E_rd == 5'd14)) || (M_mtc0 && (M_rd == 5'd14)));

assign Stall = E_stall_rs | E_stall_rt | M_stall_rs | M_stall_rt | E_stall_mdu | M_stall_eret;

endmodule
