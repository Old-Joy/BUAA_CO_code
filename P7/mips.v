`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:18:08 11/29/2024 
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
    input clk,                    // 时钟信号
    input reset,                  // 同步复位信号
    input interrupt,              // 外部中断信号
    output [31:0] macroscopic_pc, // 宏观 PC

    output [31:0] i_inst_addr,    // IM 读取地址（取指 PC）
    input  [31:0] i_inst_rdata,   // IM 读取数据

    output [31:0] m_data_addr,    // DM 读写地址
    input  [31:0] m_data_rdata,   // DM 读取数据
    output [31:0] m_data_wdata,   // DM 待写入数据
    output [3 :0] m_data_byteen,  // DM 字节使能信号

    output [31:0] m_int_addr,     // 中断发生器待写入地址
    output [3 :0] m_int_byteen,   // 中断发生器字节使能信号

    output [31:0] m_inst_addr,    // M 级 PC

    output w_grf_we,              // GRF 写使能信号
    output [4 :0] w_grf_addr,     // GRF 待写入寄存器编号
    output [31:0] w_grf_wdata,    // GRF 待写入数据

    output [31:0] w_inst_addr     // W 级 PC
    );

wire [31:0] temp_m_data_wdata, temp_m_data_addr;
wire [3:0] temp_m_data_byteen;
wire [31:0] temp_m_data_rdata;

wire [5:0] HWInt;
wire TC0_IRQ, TC1_IRQ;

assign HWInt = {3'b0, interrupt, TC1_IRQ, TC0_IRQ}; // 中断信号

wire [31:0] TC0_Addr, TC0_Data_in, TC0_Data_out;
wire TC0_WD;

wire [31:0] TC1_Addr, TC1_Data_in, TC1_Data_out;
wire TC1_WD;

CPU mips_cpu(
    .clk(clk),
    .reset(reset),
    
    .HWInt(HWInt),
    
    .i_inst_rdata(i_inst_rdata),
    .m_data_rdata(temp_m_data_rdata),

    // output 
    .i_inst_addr(i_inst_addr),
    .m_inst_addr(m_inst_addr),
    .m_data_addr(temp_m_data_addr),
    .m_data_wdata(temp_m_data_wdata),
    .m_data_byteen(temp_m_data_byteen),

    .w_grf_we(w_grf_we),
    .w_grf_addr(w_grf_addr),
    .w_grf_wdata(w_grf_wdata),
    .w_inst_addr(w_inst_addr),

    .macroscopic_pc(macroscopic_pc)
);

mips_Bridge bridge(
    .temp_m_data_addr(temp_m_data_addr),
    .temp_m_data_wdata(temp_m_data_wdata),
    .temp_m_data_byteen(temp_m_data_byteen),
    .temp_m_data_rdata(temp_m_data_rdata),

    .m_data_addr(m_data_addr),
    .m_data_wdata(m_data_wdata),
    .m_data_byteen(m_data_byteen),
    .m_data_rdata(m_data_rdata),

    .m_int_addr(m_int_addr),
    .m_int_byteen(m_int_byteen),

    .TC0_Addr(TC0_Addr),
    .TC0_WE(TC0_WE),
    .TC0_Data_in(TC0_Data_in),
    .TC0_Data_out(TC0_Data_out),

    .TC1_Addr(TC1_Addr),
    .TC1_WE(TC1_WE),
    .TC1_Data_in(TC1_Data_in),
    .TC1_Data_out(TC1_Data_out)
);

TC tc0(
    .clk(clk),
    .reset(reset),
    .Addr(TC0_Addr[31:2]),
    .WE(TC0_WE),
    .Din(TC0_Data_in),
    .Dout(TC0_Data_out),
    .IRQ(TC0_IRQ)
);

TC tc1(
    .clk(clk),
    .reset(reset),
    .Addr(TC1_Addr[31:2]),
    .WE(TC1_WE),
    .Din(TC1_Data_in),
    .Dout(TC1_Data_out),
    .IRQ(TC1_IRQ)
);

endmodule
