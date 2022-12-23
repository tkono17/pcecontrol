`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2022 01:08:05 PM
// Design Name: 
// Module Name: PulseGenerator
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


module PulseGenerator(
    input CLK_200M, 
    input [1:0] MODE, 
    input [7:0] FREQUENCY, 
    input [7:0] WIDTH, 
    output [8:1] PMOD, 
    input RESET
    );
    wire [19:0] period_m1;// = (20'h200_000/FREQUENCY) - 20'h1; // in unit of 5 ns (200 MHz running clock)
    assign period_m1 = 20'd199_999;
    
    reg [19:0] counter1;
    reg [7:0] counter2;
    reg counter2_en;
    reg waveForm;
    
    initial begin
        counter1 = 20'h0;
        counter2 = 8'h0;
        counter2_en = 1'b0;
        waveForm = 1'h0;
        
    end
    
    assign PMOD[1] = waveForm;
    assign PMOD[2] = 1'b0;
    assign PMOD[8:3] = 6'b0;
    
    wire reset_counter1 = (counter1 == period_m1);// && WIDTH > 8'h0);
    
    always @(posedge CLK_200M) begin
        if (RESET) begin
            counter1 <= 20'h0;
            counter2 <= 8'h0;
            counter2_en <= 1'b0;
            waveForm <= 1'h0;
        end
        else begin
            if (reset_counter1) begin
                counter1 <= 20'h0;
            end
            else begin
                counter1 <= counter1 + 20'h1;
            end
            
            if (counter2_en) begin
                if (counter2 == WIDTH) begin
                    counter2_en <= 1'b0;
                    counter2 <= 8'h0;
                end
                else begin
                    counter2 <= counter2 + 8'h1;
                end
            end
            else if (reset_counter1) begin
                counter2_en <= 1'b1;
                counter2 <= 1'h1;
            end
            
            if (MODE == 2'b0) begin
                waveForm <= 1'b0;
            end
            else if (MODE == 2'b1) begin
                if (counter2_en) begin
                    waveForm <= 1'b1;
                end
                else begin
                    waveForm <= 1'b0;
                end
            end
            else if (MODE == 2'b11) begin
                waveForm <= 1'b1;
            end

        end
    end
    
endmodule
