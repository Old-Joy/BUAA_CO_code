`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:09:11 11/16/2024 
// Design Name: 
// Module Name:    M_DE 
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
module M_DE(
    input [31:0] Addr,
    input [2:0] DEOp,
    input [31:0] m_data_rdata,
    output reg [31:0] DMRD
    );

always @(*) begin
    case (DEOp)
        `DE_lw : begin
            DMRD = m_data_rdata;
        end
        `DE_lh : begin
            DMRD = {{16{m_data_rdata[16 * Addr[1] + 15]}}, m_data_rdata[(16 * Addr[1] + 15) -: 16]};
        end
        `DE_lb : begin
            DMRD = {{24{m_data_rdata[8 * Addr[1:0] + 7]}}, m_data_rdata[(8 * Addr[1:0] + 7) -: 8]};
        end
        default : DMRD = 32'd0;
    endcase
end

endmodule
