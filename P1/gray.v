`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:00:39 10/05/2024 
// Design Name: 
// Module Name:    gray 
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
`define S0 3'b000
`define S1 3'b001
`define S2 3'b011
`define S3 3'b010
`define S4 3'b110
`define S5 3'b111
`define S6 3'b101
`define S7 3'b100
module gray(
    input Clk,
    input Reset,
    input En,
    output [2:0] Output,
    output Overflow
    );

reg [2:0] status;
reg wid;

initial begin
    status <= `S0;
    wid <= 0;
end

always@(posedge Clk) begin
    if (Reset == 1) begin
        status <= `S0;
        wid <= 0;
    end
    else if (En == 1) begin
        case (status)
        `S0 : begin
            status <= `S1;
        end
        `S1 : begin
            status <= `S2;
        end
        `S2 : begin
            status <= `S3;
        end
        `S3 : begin
            status <= `S4;
        end
        `S4 : begin
            status <= `S5;
        end
        `S5 : begin
            status <= `S6;
        end
        `S6 : begin
            status <= `S7;
        end
        `S7 : begin
            status <= `S0;
            wid <= 1;
        end
        endcase
    end
end
assign Output = (status == `S0) ? 3'b000 :
                (status == `S1) ? 3'b001 :
                (status == `S2) ? 3'b011 :
                (status == `S3) ? 3'b010 :
                (status == `S4) ? 3'b110 :
                (status == `S5) ? 3'b111 :
                (status == `S6) ? 3'b101 :
                3'b100;
assign Overflow = wid;
endmodule
