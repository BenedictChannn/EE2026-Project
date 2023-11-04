`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2023 00:04:59
// Design Name: 
// Module Name: BrickBreaker_level1
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


module BrickBreaker_level1(
    output [259:0] brick_state
    );
    parameter N_BRICKS = 130;
    
    genvar i;
    for (i = 0; i < 130; i = i + 1) begin
        if (i == 0 || i == 1 || i == 2 || i == 3 || i == 4 || i == 5 || i == 6 || i == 7 || i == 8 || i == 9
        || i == 10
        || i == 20
        || i == 30 
        || i == 40 || i == 43 || i == 44 || i == 45 || i == 46 || i == 47 || i == 48 || i == 49
        || i == 50 || i == 53 || i == 59 
        || i == 60 || i == 63 || i == 65 || i == 66 || i == 69
        || i == 70 || i == 73 || i == 75 || i == 76 || i == 79
        || i == 80 || i == 83 || i == 86 || i == 89
        || i == 90 || i == 93 || i == 94 || i == 95 || i == 96 || i == 99
        || i == 100 || i == 109 
        || i == 110 || i == 119
        || i == 120 || i == 121 || i == 122 || i == 123 || i == 124 || i == 125 || i == 126 || i == 127 || i == 128 || i == 129) begin
            assign brick_state[i * 2 + 1: i * 2] = 2'b01;
        end else begin
            assign brick_state[i * 2 + 1: i * 2] = 2'b00;
        end
    end
endmodule



