`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2023 12:59:37
// Design Name: 
// Module Name: clk6p25m
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


module clk6p25m(
        input CLK,
        output clk_625
    );
    reg SLOW_CLK = 0;
    reg [2:0] COUNT = 3'b0;
    always @ (posedge CLK) begin
        COUNT <= (COUNT == 3'b111) ? 0 : COUNT + 1;
        SLOW_CLK <= (COUNT == 3'b0) ? ~SLOW_CLK : SLOW_CLK;
    end
    assign clk_625 = SLOW_CLK;
endmodule
