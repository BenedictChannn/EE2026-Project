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
    output [129:0] brick_state
    );
    parameter N_BRICKS = 130;
    
    genvar i;
    for (i = 0; i < 130; i = i + 1) begin
        if (i == 50 || i == 60 || i == 70
        || i == 61 || i == 71 || i == 81
        || i == 72 || i == 82 || i == 92
        || i == 83 || i == 93 || i == 103
        || i == 94 || i == 104 || i == 114
        || i == 85 || i == 95 || i == 105
        || i == 76 || i == 86 || i == 96
        || i == 67 || i == 77 || i == 87
        || i == 58 || i == 68 || i == 78
        || i == 49|| i == 59 || i == 69) begin
            assign brick_state[i] = 1'b0;
        end else begin
            assign brick_state[i] = 1'b1;
        end
    end
endmodule



