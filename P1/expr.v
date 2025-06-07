`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:18:38 10/06/2024 
// Design Name: 
// Module Name:    expr 
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
`define S2 3'b010
`define S3 3'b011
`define S4 3'b100
`define S5 3'b101
`define S6 3'b110

module expr(
    input clk,
    input clr,
    input [7:0] in,
    output out
    );

reg [3:0] status;
reg true;

initial begin
    true <= 0;
    status <= `S0;
end

always @(posedge clk, posedge clr) begin
    if (clr == 1) begin
        true <= 0;
        status <= `S0;
    end
    else begin
        case (status)
            `S0 : begin
                if (in >= "0" && in <= "9") begin
                    status <= `S1;
                    true <= 1;
                end
                else begin
                    status <= `S6;
                    true <= 0;
                end
            end
            `S1 : begin
                if (in >= "0" && in <= "9") begin
                    status <= `S2;
                    true <= 0;
                end
                else begin
                    status <= `S3;
                    true <= 0;
                end
            end
            `S2 : begin
                status <= `S2;
                true <= 0;
            end
            `S3 : begin
                if (in >= "0" && in <= "9") begin
                    status <= `S4;
                    true <= 1;
                end
                else begin
                    status <= `S5;
                    true <= 0;
                end
            end
            `S4 : begin
                if (in >= "0" && in <= "9") begin
                    status <= `S2;
                    true <= 0;
                end
                else begin
                    status <= `S3;
                    true <= 0;
                end
            end
            `S5 : begin
                status <= `S5;
                true <= 0;
            end
            `S6 : begin
                status <= `S6;
                true <= 0;
            end
        endcase
    end
end

assign out = (true == 1) ? 1'b1 : 1'b0;

endmodule
