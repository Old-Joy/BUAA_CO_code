`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:46:16 11/29/2024 
// Design Name: 
// Module Name:    mips_Bridge 
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
module mips_Bridge(
    input [31:0] temp_m_data_addr,
    input [31:0] temp_m_data_wdata,
    input [3:0] temp_m_data_byteen,
    output [31:0] temp_m_data_rdata,

    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3:0] m_data_byteen,
    input [31:0] m_data_rdata,

    output [31:0] m_int_addr,
    output [3:0] m_int_byteen,

    output [31:0] TC0_Addr,
    output TC0_WE,
    output [31:0] TC0_Data_in,
    input [31:0] TC0_Data_out,

    output [31:0] TC1_Addr,
    output TC1_WE,
    output [31:0] TC1_Data_in,
    input [31:0] TC1_Data_out
    );

wire DMSel = ((temp_m_data_addr >= `DM_begin) && (temp_m_data_addr <= `DM_end));
wire TC0Sel = (temp_m_data_addr >= `TC1_begin) && (temp_m_data_addr <= `TC1_end);
wire TC1Sel = (temp_m_data_addr >= `TC2_begin) && (temp_m_data_addr <= `TC2_end);
wire IntHit = ((temp_m_data_addr >= 32'h00007f20) && (temp_m_data_addr <= 32'h00007f23));

assign m_data_addr = temp_m_data_addr;
assign m_int_addr = temp_m_data_addr;

assign m_data_byteen = (TC0Sel || TC1Sel || IntHit) ? 4'b0000 : temp_m_data_byteen;
assign m_int_byteen = (IntHit) ? temp_m_data_byteen : 4'b0000;

assign TC0_Addr = temp_m_data_addr;
assign TC1_Addr = temp_m_data_addr;

assign TC0_Data_in = temp_m_data_wdata;
assign TC1_Data_in = temp_m_data_wdata;
assign m_data_wdata = temp_m_data_wdata;

wire WrEn = (temp_m_data_byteen != 4'b0000);

assign TC0_WE = WrEn && TC0Sel;
assign TC1_WE = WrEn && TC1Sel;

assign temp_m_data_rdata = (TC0Sel) ? TC0_Data_out :
                            (TC1Sel) ? TC1_Data_out : m_data_rdata;

endmodule
