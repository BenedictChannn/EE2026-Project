`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/04 02:07:53
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


module debouncerA(input CLOCK, btn, output reg debounced_btn = 0);
    reg [31:0]count = 0, counter = 0;
    reg state = 0;
    always @ (posedge CLOCK)
    begin
        if (debounced_btn) begin
            if (btn == 0) count <= count + 1;
            else count <= 0;
            if (count == 100_000) debounced_btn <= 0;
        end else begin
            if (btn && state == 0) 
                count <= count + 1;
            else count <= 0;
            if (count == 100_000) 
                debounced_btn <= 1;
        end

        if (debounced_btn) state <= 1;
        if (state) counter <= counter + 1;
        if (counter == 10_000_000) begin
            counter <= 0;
            state <= 0;
        end
    end
endmodule
