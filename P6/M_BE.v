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
    output reg [3:0] m_data_byteen,
    output reg [31:0] m_data_wdata
    );

always@(*) begin
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

endmodule
