`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2023 00:04:52
// Design Name: 
// Module Name: Brick_Breaker
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


module Brick_Breaker(
    input CLK, 
    output [7:0] JC,
    inout PS2Clk, PS2Data
    );
    
    // OLED
    parameter SCREEN_WIDTH = 96;
    parameter SCREEN_HEIGHT = 64;
    
    // Colours
    parameter WHITE = 16'hFFFF;
    parameter BLACK = 16'h0000;
    parameter RED = 16'hF800;
    
    // Board
    parameter BOARD_WIDTH = 16;
    parameter BOARD_HEIGHT = 3;
    parameter BOARD_COLOUR = WHITE;
    reg [11:0] board_position = 12'd32;
    
    wire [12:0] pixel_index;
    reg [15:0] pixel_data;
    
    wire [11:0] mouse_x_pos, mouse_y_pos;
    wire [6:0] col, row;
    
    assign col = pixel_index % SCREEN_WIDTH;
    assign row = pixel_index / SCREEN_WIDTH;
    
    clk6p25m clk625 (CLK, CLK_6P25M);
    
    always @ (posedge CLK) begin
        if ((mouse_x_pos > BOARD_WIDTH / 2) && (mouse_x_pos < (SCREEN_HEIGHT - BOARD_WIDTH / 2))) begin
            board_position <= mouse_x_pos;
        end
        
        if ((row > (board_position -  BOARD_WIDTH / 2) && row <= (board_position + BOARD_WIDTH / 2)) && (col > 87 && col <= 87 + BOARD_HEIGHT)) begin
            pixel_data <= BOARD_COLOUR;
        end else if (row == 0 || row == 63) begin
            pixel_data <= RED;
        end else begin
            pixel_data <= BLACK;
        end
    end
    
    
    
    
    // Instantiate mouse 
    MouseCtl mouse(
        .clk(CLK),
        .xpos(mouse_x_pos), 
        .ypos(mouse_y_pos), 
        .ps2_clk(PS2Clk), 
        .ps2_data(PS2Data),
        .value(12'b0),
        .setx(0), 
        .sety(0), 
        .setmax_x(SCREEN_WIDTH - 1), 
        .setmax_y(SCREEN_HEIGHT - 1)
    );
        
    // Instantiate Oled display to display either green or red depending on sw4
    Oled_Display oled (
        .clk(CLK_6P25M), 
        .pixel_index(pixel_index), 
        .pixel_data(pixel_data), 
        .reset(0), 
        .cs(JC[0]), 
        .sdin(JC[1]),
        .sclk(JC[3]), 
        .d_cn(JC[4]), 
        .resn(JC[5]), 
        .vccen(JC[6]), 
        .pmoden(JC[7])
    );
endmodule
