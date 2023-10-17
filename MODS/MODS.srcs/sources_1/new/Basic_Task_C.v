`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2023 12:41:30
// Design Name: 
// Module Name: Basic_taskC
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


module Basic_Task_C(
    input CLOCK,
    input btnC,
    input [12:0] pixel_index,
    output reg [15:0] oled_data
    );
    reg [2:0] COUNT_6P25MHZ = 3'b000;
    reg clk6p25m = 0;
    reg [31:0] COUNT_20HZ = 32'b0;
    reg clk20 = 0;
    reg [31:0] COUNT_GREEN = 32'b0;
    reg [31:0] COUNT_RED = 32'b0;
    reg first = 0;
    reg button_pressed = 0;
    reg green_reverse = 0;
    reg green_square = 0;
    reg [6:0] row_end = 2;
    reg [6:0] col_end = 49;
    reg [6:0] green_row_end = 30;
    reg [6:0] green_col_end = 63;
    wire [6:0] pixel_row, pixel_col;
    assign pixel_col = pixel_index % 96;
    assign pixel_row = pixel_index / 96;
    always @ (posedge CLOCK) begin
        COUNT_6P25MHZ <= (COUNT_6P25MHZ == 3'b111) ? 0 : COUNT_6P25MHZ + 1;
        clk6p25m <= (COUNT_6P25MHZ == 3'b111) ? ~clk6p25m : clk6p25m;
        COUNT_20HZ <= (COUNT_20HZ == 32'd2_500_000 - 1) ? 0 : COUNT_20HZ + 1;
        clk20 <= (COUNT_20HZ == 32'd2_500_000 - 1) ? ~clk20 : clk20;
    end
    
    always @ (pixel_index) begin
        if (first == 0) begin
            if (pixel_row <= row_end && (pixel_col <= 49 && pixel_col >= 47)) begin
                oled_data = 16'b11111_000000_00000;
            end else if ((pixel_col <= col_end && pixel_col >= 50) && (pixel_row <= 32 && pixel_row >= 30)) begin
                oled_data = 16'b11111_000000_00000;
            end else begin
                oled_data = 16'b00000_000000_00000;
            end
            if (col_end == 65 && green_square == 1) begin
                if ((pixel_row <= 32 && pixel_row >= 30) && (pixel_col <= 65 && pixel_col >= green_col_end)) begin
                    oled_data = 16'b00000_111111_00000;
                end else if ((pixel_col <= 49 && pixel_col >= 47) && (pixel_row <= 29 && pixel_row >= green_row_end)) begin
                    oled_data = 16'b00000_111111_00000;
                end
            end
        end else begin
            if (pixel_row <= row_end && (pixel_col <= 49 && pixel_col >= 47)) begin
                oled_data = 16'b11111_000000_00000;
            end else if ((pixel_col <= col_end && pixel_col >= 50) && (pixel_row <= 32 && pixel_row >= 30)) begin
                oled_data = 16'b11111_000000_00000;
            end else if (pixel_row <= 32 && (pixel_col <= 49 && pixel_col >= 47) || (pixel_col <= 65 && pixel_col >= 50) && (pixel_row <= 32 && pixel_row >= 30)) begin
                oled_data = 16'b00000_111111_00000;
            end else begin
                oled_data = 16'b00000_000000_00000;
            end
            if (col_end == 65 && green_square == 1) begin
                if ((pixel_row <= 32 && pixel_row >= 30) && (pixel_col <= 65 && pixel_col >= green_col_end)) begin
                    oled_data = 16'b00000_111111_00000;
                end else if ((pixel_col <= 49 && pixel_col >= 47) && (pixel_row <= 29 && pixel_row >= green_row_end)) begin
                    oled_data = 16'b00000_111111_00000;
                end
            end
        end
    end
    
    always @ (posedge clk20) begin
        if (btnC == 1) begin
            button_pressed = 1;
        end
        if (button_pressed == 1) begin
            if(row_end != 32) begin
                row_end = row_end + 1;
            end else if (col_end != 65) begin
                col_end = col_end + 1;
            end else if (green_reverse == 0) begin
                COUNT_GREEN = COUNT_GREEN + 1;
                if (COUNT_GREEN == 32'd20) begin
                    green_square = 1;
                end
                if (COUNT_GREEN == 32'd40) begin
                    green_reverse = 1;
                end
            end else if (green_col_end != 47) begin
                green_col_end = green_col_end - 1;
            end else if (green_row_end != 0) begin
                green_row_end = green_row_end - 1;
            end else begin
                COUNT_RED = COUNT_RED + 1;
                if (COUNT_RED == 32'd20) begin
                    first = 1;
                    button_pressed = 0;
                    green_reverse = 0;
                    green_square = 0;
                    COUNT_GREEN = 0;
                    COUNT_RED = 0;
                    row_end = 2;
                    col_end = 49;
                    green_row_end = 30;
                    green_col_end = 63;
                end
    
            end
        end
    end
endmodule
