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
module STALL(
    input [31:0] D_Instr,
    input [31:0] E_Instr,
    input [31:0] M_Instr,
    output Stall
    );

wire D_add, D_sub, D_ori, D_lw, D_sw, D_beq, D_sll, D_lui, D_j, D_jr, D_jal, D_jalr, D_lb, D_sb;
wire [4:0] D_rs, D_rt;

CONTROLLER D_control(
    .Instr(D_Instr),
    // output
    .rs(D_rs),
    .rt(D_rt),

    .add(D_add),
    .sub(D_sub),
    .ori(D_ori),
    .lw(D_lw),
    .sw(D_sw),
    .beq(D_beq),
    .sll(D_sll),
    .lui(D_lui),
    .j(D_j),
    .jal(D_jal),
    .jr(D_jr),
    .jalr(D_jalr),
    .lb(D_lb),
    .sb(D_sb)
);

wire [7:0] D_Tuse_rs, D_Tuse_rt;
assign D_Tuse_rs = (D_beq | D_jr | D_jalr) ? 8'd0 :
                    (D_add | D_sub | D_ori | D_lui | D_lw | D_sw | D_lb | D_sb) ? 8'd1 : 8'd3;
assign D_Tuse_rt = (D_beq) ? 8'd0 : 
                    (D_add | D_sub | D_sll) ? 8'd1 : 
                    (D_sw | D_sb) ? 8'd2 : 8'd3;

wire E_add, E_sub, E_ori, E_lw, E_sw, E_beq, E_sll, E_lui, E_j, E_jr, E_jal, E_jalr, E_lb, E_sb;
wire [4:0] E_GRFA3;

CONTROLLER E_control(
    .Instr(E_Instr),
    // output
    .GRFA3(E_GRFA3),
    .add(E_add),
    .sub(E_sub),
    .ori(E_ori),
    .lw(E_lw),
    .sw(E_sw),
    .beq(E_beq),
    .sll(E_sll),
    .lui(E_lui),
    .j(E_j),
    .jal(E_jal),
    .jr(E_jr),
    .jalr(E_jalr),
    .lb(E_lb),
    .sb(E_sb)
);

wire [7:0] E_Tnew;
assign E_Tnew = (E_add | E_sub | E_sll | E_ori | E_lui) ? 8'd1 :
                (E_lw | E_lb) ? 8'd2 : 8'd0;

wire M_add, M_sub, M_ori, M_lw, M_sw, M_beq, M_sll, M_lui, M_j, M_jr, M_jal, M_jalr, M_lb, M_sb;
wire [4:0] M_GRFA3;

CONTROLLER M_control(
    .Instr(M_Instr),
    // output
    .GRFA3(M_GRFA3),
    .add(M_add),
    .sub(M_sub),
    .ori(M_ori),
    .lw(M_lw),
    .sw(M_sw),
    .beq(M_beq),
    .sll(M_sll),
    .lui(M_lui),
    .j(M_j),
    .jal(M_jal),
    .jr(M_jr),
    .jalr(M_jalr),
    .lb(M_lb),
    .sb(M_sb)
);

wire [7:0] M_Tnew;
assign M_Tnew = (M_lw | M_lb) ? 8'd1 : 8'd0;

wire E_stall_rs, E_stall_rt, M_stall_rs, M_stall_rt;

assign E_stall_rs = (D_rs == E_GRFA3 && (D_rs != 0)) && (E_Tnew > D_Tuse_rs);
assign E_stall_rt = (D_rt == E_GRFA3 && (D_rt != 0)) && (E_Tnew > D_Tuse_rt);
assign M_stall_rs = (D_rs == M_GRFA3 && (D_rs != 0)) && (M_Tnew > D_Tuse_rs);
assign M_stall_rt = (D_rt == M_GRFA3 && (D_rt != 0)) && (M_Tnew > D_Tuse_rt);

assign Stall = E_stall_rs | E_stall_rt | M_stall_rs | M_stall_rt;

endmodule
