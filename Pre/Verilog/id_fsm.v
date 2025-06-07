`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:12:14 10/05/2024 
// Design Name: 
// Module Name:    id_fsm 
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
`define S0 2'b00
`define S1 2'b01
`define S2 2'b10
module id_fsm(
    input [7:0] char,
    input clk,
    output out
    );

reg [1:0] status;

initial begin
    status <= `S0;
end    

always@(posedge clk) begin
    if (status == `S0) begin
        if ((char >= 8'b01100001 && char <= 8'b01111010) || (char >= 8'b01000001 && char <= 8'b01011010)) begin
            status <= `S1;
        end
        else begin
            status <= `S0;
        end
    end
    else if (status == `S1) begin
        if ((char >= 8'b01100001 && char <= 8'b01111010) || (char >= 8'b01000001 && char <= 8'b01011010)) begin
            status <= `S1;
        end
        else if (char >= 8'b00110000 && char <= 8'b00111001) begin
            status <= `S2;
        end
        else begin
            status <= `S0;
        end
    end
    else if (status == `S2) begin
        if((char >= 8'b01100001 && char <= 8'b01111010) || (char >= 8'b01000001 && char <= 8'b01011010)) begin
            status <= `S1;
        end
        else if (char >= 8'b00110000 && char <= 8'b00111001) begin
            status <= `S2;
        end
        else begin
            status <=`S0;
        end
    end
end

assign out = (status == `S2) ? 1'b1 : 1'b0;
endmodule
