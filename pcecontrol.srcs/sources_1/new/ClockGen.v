`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2022 01:15:44 PM
// Design Name: 
// Module Name: ClockGen
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


module ClockGen(
    input CLK_IN,
    output CLK_100M,
    output CLK_200M,
    output reg CLK_1Hz,
    output reg CLK_100Hz,
    output reg CLK_1k,
    input RESET, 
    output LOCKED
    );
    reg [63:0] counter1;
    reg [63:0] counter2;
    reg [63:0] counter3;
    reg [63:0] counter4;
    
    initial begin
        counter1 = 64'h0;
        counter2 = 64'h0;
        counter3 = 64'h0;
        counter4 = 64'h0;
        CLK_1Hz = 1'b0;
        CLK_100Hz = 1'b0;
        CLK_1k = 1'b0;
    end
    
   clk_wiz_0 clkWiz0(
     .clk_in1(CLK_IN), 
     .clk_out1(CLK_100M), 
     .clk_out2(CLK_200M), 
           .reset(RESET), 
     .locked(LOCKED)
     );
      
      always @(posedge CLK_100M) begin
         if (counter1 == 64'd50_000_000) begin
             counter1 <= 64'd1;
             CLK_1Hz <= ~CLK_1Hz;
         end
         else begin
             counter1 <= counter1 + 64'd1;
         end
         
         if (counter2 == 64'd500_000) begin
             counter2 <= 64'd1;
             CLK_100Hz <= ~CLK_100Hz;
         end
         else begin
             counter2 <= counter2 + 64'd1;
         end
         if (counter3 == 64'd50_000) begin
             counter3 <= 64'd1;
             CLK_1k <= ~CLK_1k;
         end
         else begin
             counter3 <= counter3 + 64'd1;
         end
      end
      
endmodule
