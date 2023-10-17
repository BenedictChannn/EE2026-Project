`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/09 22:47:16
// Design Name: 
// Module Name: clk45khz
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


module clk45k(
    input CLOCK,      // 100 MHz input
    output reg clk_45kHz
);

    reg [11:0] count_45kHz = 0; // 12-bit counter for division by 2,222

    always @(posedge CLOCK) begin
        if(count_45kHz < 1111) begin  // Half the division factor for 50% duty cycle
            count_45kHz <= count_45kHz + 1'b1;
            clk_45kHz <= 0;
        end else begin
            count_45kHz <= 0;
            clk_45kHz <= ~clk_45kHz;
        end
    end

endmodule

