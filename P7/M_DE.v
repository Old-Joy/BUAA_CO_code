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
    input [2:0] DEOp,
    input [31:0] Addr,
    input [31:0] m_data_rdata,

    input EXC_DMOv,
    input load,
    
    output reg [31:0] DMRD,
    output EXC_AdEL
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

wire Error_addr, Error_range, Error_timer;

assign Error_addr = ((DEOp == `DE_lw) && (Addr[1:0] != 2'b00)) || ((DEOp == `DE_lh) && (Addr[0] != 1'b0));

assign Error_range = !(((Addr >= `DM_begin) && (Addr <= `DM_end)) || ((Addr >= `TC1_begin) && (Addr <= `TC1_end)) || ((Addr >= `TC2_begin) && (Addr <= `TC2_end)));

assign Error_timer = (DEOp != `DE_lw) && (Addr >= `TC1_begin);

assign EXC_AdEL = (load) && (Error_addr || Error_range || Error_timer || EXC_DMOv);

endmodule
