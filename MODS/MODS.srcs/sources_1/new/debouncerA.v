`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/16 01:14:08
// Design Name: 
// Module Name: debouncerA
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


module debouncerA(input CLOCK, BTN, output reg btn = 0);
    always @ (posedge CLOCK)
    begin
        btn <= BTN;
    end
endmodule
