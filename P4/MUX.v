`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:20:58 11/01/2024 
// Design Name: 
// Module Name:    MUX 
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
module MUX(
    input [31:0] GRF_WDMux0,
    input [31:0] GRF_WDMux1,
    input [31:0] GRF_WDMux2,
    input [2:0] GRF_WDSel,
    output [31:0] realGRF_WD,
    input [31:0] ALU_AMux0,
    input [31:0] ALU_AMux1,
    input ALU_ASel,
    output [31:0] realALU_A,
    input [31:0] ALU_BMux0,
    input [31:0] ALU_BMux1,
    input [2:0] ALU_BSel,
    output [31:0] realALU_B,
    input [4:0] GRF_A3Mux0,
    input [4:0] GRF_A3Mux1,
    input [4:0] GRF_A3Mux2,
    input [2:0] GRF_A3Sel,
    output [4:0] realGRF_A3
    );

assign realGRF_WD = (GRF_WDSel == 3'b000) ? GRF_WDMux0 :
                    (GRF_WDSel == 3'b001) ? GRF_WDMux1 :
                    (GRF_WDSel == 3'b010) ? GRF_WDMux2 : -1;

assign realGRF_A3 = (GRF_A3Sel == 3'b000) ? GRF_A3Mux0 :
                    (GRF_A3Sel == 3'b001) ? GRF_A3Mux1 :
                    (GRF_A3Sel == 3'b010) ? GRF_A3Mux2 : -1;

assign realALU_A = (ALU_ASel == 1'b0) ? ALU_AMux0 : ALU_AMux1;

assign realALU_B = (ALU_BSel == 3'b000) ? ALU_BMux0 :
                    (ALU_BSel == 3'b001) ? ALU_BMux1 : -1;

endmodule
