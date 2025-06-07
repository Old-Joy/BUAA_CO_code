`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:13:43 11/15/2024 
// Design Name: 
// Module Name:    M_BE 
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
module M_BE(
    input [2:0] BEOp,
    input [31:0] Addr,
    input [31:0] rt_data,
    input Req,
    input EXC_DMOv,
    input store,
    output reg [3:0] m_data_byteen,
    output reg [31:0] m_data_wdata,
    output EXC_AdES
    );

always@(*) begin
    if (Req) begin
        m_data_byteen = 4'd0;
        m_data_wdata = 32'd0;
    end else begin
        case (BEOp)
            `BE_sw : begin
                m_data_byteen = 4'b1111;
                m_data_wdata = rt_data;
            end 
            `BE_sh : begin
                if (Addr[1] == 1'b0) begin
                    m_data_byteen = 4'b0011;
                    m_data_wdata = {16'b0, rt_data[15:0]};
                end else begin
                    m_data_byteen = 4'b1100;  
                    m_data_wdata = {rt_data[15:0], 16'b0};
                end
            end
            `BE_sb : begin
                if (Addr[1:0] == 2'b00) begin
                    m_data_byteen = 4'b0001;
                    m_data_wdata = {24'b0, rt_data[7:0]};
                end else if (Addr[1:0] == 2'b01) begin
                    m_data_byteen = 4'b0010;
                    m_data_wdata = {16'b0, rt_data[7:0], 8'b0};
                end else if (Addr[1:0] == 2'b10) begin
                    m_data_byteen = 4'b0100;
                    m_data_wdata = {8'b0, rt_data[7:0], 16'b0};
                end else begin
                    m_data_byteen = 4'b1000;
                    m_data_wdata = {rt_data[7:0], 24'b0};
                end
            end
            default : begin
                m_data_byteen = 4'b0000;
                m_data_wdata = 32'b0;
            end
        endcase
    end
end

wire Error_addr, Error_range, Error_timer;

assign Error_addr = ((BEOp == `BE_sw) && (Addr[1:0] != 2'b00)) || ((BEOp == `BE_sh) && (Addr[0] != 1'b0));

assign Error_range = !(((Addr >= `DM_begin) && (Addr <= `DM_end)) || ((Addr >= `TC1_begin) && (Addr <= `TC1_end)) || ((Addr >= `TC2_begin) && (Addr <= `TC2_end)));

assign Error_timer = ((Addr >= 32'h7f08) && (Addr <= 32'h7f0b)) || ((Addr >= 32'h7f18) && (Addr <= 32'h7f1b)) || ((BEOp != `BE_sw) && (Addr >= `TC1_begin));

assign EXC_AdES = store && (Error_addr || Error_range || Error_timer || EXC_DMOv);
endmodule
