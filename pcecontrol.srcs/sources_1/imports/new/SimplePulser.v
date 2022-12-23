`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2022 01:08:05 PM
// Design Name: 
// Module Name: SimplePulser
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SimplePulser(
    input CLK_IN,
    input [7:0] SW, 
    input [4:0] PUSH_BUTTONS, 
    output [7:0] LED,
    output [8:1] PMODB, 
    output reg VADJ_EN, 
    output [1:0] SET_VADJ, 
    input RESETn
    );
    wire clk_1Hz;
    wire clk_100Hz;
    wire clk_1k;
    wire clk_100M;
    wire clk_200M;
    wire locked;
//    wire [7:0] rd_data;
//    wire rd_valid;
    wire [1:0] mode;
    wire [7:0] frequency = 8'd1;
    wire [7:0] width;
    wire RESET = ~RESETn;
    
    initial begin
        VADJ_EN = 1'b0;
    end
    assign SET_VADJ = 2'b11;
    always @(posedge clk_1Hz) begin
        if (RESET) begin
            VADJ_EN = 1'b0;
        end
        else if (locked) begin
            VADJ_EN = 1'b1;
        end
    end
    
    ClockGen clockGen(
        .CLK_IN(CLK_IN), 
        .CLK_1Hz(clk_1Hz), 
        .CLK_100Hz(clk_100Hz), 
        .CLK_1k(clk_1k), 
        .CLK_100M(clk_100M), 
        .CLK_200M(clk_200M), 
        .LOCKED(locked), 
        .RESET(RESET)
        );
        
    assign LED[7] = locked;
    assign LED[6] = clk_1Hz;
    assign LED[1:0] = mode;
    assign LED[5:2] = width[3:0];
    
    assign mode = SW[1:0];
    assign width = {2'b00, SW[7:2]};
//    Config configData(
//        .CLK_WR(clk_100Hz), 
//        .CLK_RD(clk_100M), 
//        .WR_EN(1'b1), 
//        .WR_ADDR(2'b10), 
//        .WR_DATA(SW), 
//        .RD_EN(1'b0), 
//        .RD_ADDR(1'b0), 
//        .RD_DATA(rd_data), 
//        .RD_VALID(rd_valid), 
//        .OUT_MODE(mode), 
//        .OUT_FREQUENCY(frequency), 
//        .OUT_WIDTH(width),
//        .RESET(RESET)
//        );
        
    PulseGenerator pulseGen(
        .CLK_200M(clk_200M), 
        .MODE(mode), 
        .FREQUENCY(frequency), 
        .WIDTH(width), 
        .PMOD(PMODB), 
        .RESET(RESET)
        );
        
endmodule
