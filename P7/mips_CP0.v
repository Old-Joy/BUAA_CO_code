`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:10:46 11/28/2024 
// Design Name: 
// Module Name:    mips_CP0 
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
`define IM SR[15:10] //  6 位中断屏蔽位，对应 6 类外部中断；相应位为 1 时，允许对应中断；相应位为 0 时，禁止对应中断；
                     // 只能通过 mtc0 指令修改

`define EXL SR[1] // 异常级 该位为 1 时，表示已经进入异常，不允许中断；该位为 0 时，允许中断

`define IE SR[0] // 全局中断使能，该位为 1 时，允许中断；该位为 0 时，不允许中断

`define BD Cause[31] // 延时槽标记。该位为 1 时，EPC指向当前指令的前一条指令（跳转）；该位为 0 时，EPC指向当前指令

`define IP Cause[15:10] //  6 位待决中断位，对应 6 类外部中断；相应位为 1 时，存在中断；相应位为 0 时，没有中断
                        // 将会每个周期被修改一次，修改的内容来自计时器和外部中断。

`define ExcCode Cause[6:2]

module mips_CP0(
    input [4:0] A1,  // 读 CP0 寄存器编号	执行 mfc0 指令
    input [4:0] A2,  // 写 CP0 寄存器编号	执行 mtc0 指令
    input [31:0] WD, // CP0 寄存器的写入数据
    input [31:0] PC,  // 中断 或 异常时的 PC
    input branchDelay, // 是否是延时槽
    input [4:0] EXCcode, // 中断 或 异常的类型
    input [5:0] HWInt,  // 6 个设备中断	外部
    input WrEn, // CP0 寄存器写使能
    input EXLclr,  // 置 0 SR 的EXL 位	执行 eret 指令时产生
    input clk,
    input reset,

    output Req, // 中断请求
    output [31:0] EPCOut, // EPC 寄存器输出至 NPC
    output [31:0] DataOut // CP0 寄存器的输出数据
    );

reg [31:0] SR;
reg [31:0] Cause;
reg [31:0] EPC;
reg [31:0] PrID;

wire ExcReq = !`EXL & (EXCcode != `exception_null); // 存在异常 且 不在中断中
wire IntReq = (| (HWInt & `IM)) && !`EXL && `IE; // 允许当前中断 且 不在中断中 且 允许中断发生
assign Req = ExcReq | IntReq;

initial begin
    SR <= 32'd0;
    Cause <= 32'd0;
    EPC <= 32'd0;
    PrID <= 32'h23371323;
end

wire [31:0] temp_EPC = (!Req) ? EPC :
                        branchDelay ? PC - 32'd4 : PC;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        SR <= 32'd0;
        Cause <= 32'd0;
        EPC <= 32'd0;
        PrID <= 32'h23371323;
    end else begin
        if (EXLclr) begin
            `EXL <= 1'b0;
        end
        if (Req) begin
            `ExcCode <= IntReq ? 5'd0 : EXCcode; // 异常的优先级高于中断
            `EXL <= 1'b1;
            EPC <= temp_EPC;
            `BD <= branchDelay;
        end else if (WrEn) begin
            if (A2 == 5'd12) begin
                SR <= WD;
            end else if (A2 == 5'd14) begin
                EPC <= WD;
            end
        end
        `IP <= HWInt;
    end
end

assign EPCOut = temp_EPC;

assign DataOut = (A1 == 5'd12) ? SR :
                    (A1 == 5'd13) ? Cause :
                    (A1 == 5'd14) ? EPCOut :
                    (A1 == 5'd15) ? PrID : 5'd0;

endmodule
