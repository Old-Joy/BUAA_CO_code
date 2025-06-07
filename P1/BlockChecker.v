`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:59:04 10/13/2024 
// Design Name: 
// Module Name:    BlockChecker 
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
`define S0 4'b0000
`define S1 4'b0001
`define S2 4'b0010
`define S3 4'b0011
`define S4 4'b0100
`define S5 4'b0101
`define S6 4'b0110
`define S7 4'b0111
`define S8 4'b1000
`define S9 4'b1001
module BlockChecker(
    input clk,
    input reset,
    input [7:0] in,
    output result
    );

reg [31:0] begincounter, endcounter;
reg [3:0] status;

initial begin
    status <= `S0;
    begincounter <= 0;
    endcounter <= 0;
end

always @(posedge clk, posedge reset) begin
    if (reset == 1) begin
        status <= `S0;
        begincounter <= 0;
        endcounter <= 0;
    end
    else if (endcounter != 2) begin
        case(status)
            `S0 : begin
                if (in == "b" || in == "B") begin
                    status <= `S1;
                end
                else if (in == "e" || in == "E") begin
                    status <= `S6;
                end
                else if (in == " ") begin
                    status <= `S0;
                end
                else begin
                    status <= `S9;
                end
            end
            `S1 : begin
                if (in == "e" || in == "E") begin
                    status <= `S2;
                end
                else if (in == " ") begin
                    status <= `S0;
                end
                else begin
                    status <= `S9;
                end
            end
            `S2 : begin
                if (in == "g" || in == "G") begin
                    status <= `S3;
                end
                else if (in == " ") begin
                    status <= `S0;
                end
                else begin
                    status <= `S9;
                end
            end
            `S3 : begin
                if (in == "i" || in == "I") begin
                    status <= `S4;
                end
                else if (in == " ") begin
                    status <= `S0;
                end
                else begin
                    status <= `S9;
                end
            end
            `S4 : begin
                if (in == "n" || in == "N") begin
                    status <= `S5;
                    begincounter <= begincounter + 1;
                end
                else if (in == " ") begin
                    status <= `S0;
                end
                else begin
                    status <= `S9;
                end
            end
            `S5 : begin
                if (in == " ") begin
                    status <= `S0;
                end
                else begin
                    status <= `S9;
                    begincounter <= begincounter - 1;
                end
            end
            `S6 : begin
                if (in == "n" || in == "N") begin
                    status <= `S7;
                end
                else if (in == " ") begin
                    status <= `S0;
                end
                else begin
                    status <= `S9;
                end
            end
            `S7 : begin
                if (in == "d" || in == "D") begin
                    status <= `S8;
                    if (begincounter > 0) begin
                        begincounter <= begincounter - 1;
                    end
                    else begin
                        endcounter <= 1;
                    end
                end
                else if (in == " ") begin
                    status <= `S0;
                end
                else begin
                    status <= `S9;
                end
            end
            `S8 : begin
                if (in == " ") begin
                    status <= `S0;
                    if (endcounter == 1) begin
                        endcounter <= 2;
                    end
                end
                else begin
                    status <= `S9;
                    if (endcounter == 1) begin
                        endcounter <= 0;
                    end
                    else begin
                        begincounter <= begincounter + 1;
                    end
                end
            end
            default : begin
                if (in == " ") begin
                    status <= `S0;
                end
                else begin
                    status <= `S9;
                end
            end
        endcase
    end
    else status <= `S0;
end

assign result = (begincounter == 0 && endcounter == 0) ? 1 : 0;

endmodule
