`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:01:16 09/22/2024 
// Design Name: 
// Module Name:    code 
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
module code(
    input Clk,
    input Reset,
    input Slt,
    input En,
    output [63:0] Output0,
    output [63:0] Output1
    );

    reg [63:0] count0, count1;
    reg [3:0] num1, num0;

    initial begin
        count0 <= 64'b0;
        count1 <= 64'b0;
    end
    
    always @(posedge Clk) begin
        if (Reset) begin
            count0 <= 64'b0;
            count1 <= 64'b0;
            num0 <= 4'b0;
            num1 <= 4'b0;
        end
        else begin
            if (En) begin
                if (Slt) begin
                    if (num1 <= 4'b10) begin
                        num1 <= num1 + 1;
                    end
                    else begin
                        num1 <= 4'b0;
                        count1 <= count1 + 1;
                    end
                end
                else begin
                    count0 <= count0 + 1;
                end
            end
        end
    end

    assign Output0 = count0;
    assign Output1 = count1;
endmodule
