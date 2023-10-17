`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/09 01:28:24
// Design Name: 
// Module Name: Basic_taskD
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

module Basic_Task_D(
    input clk,                // Clock signal
    input reset,              // Center pushbutton
    input move_left,          // Left pushbutton
    input move_right,         // Right pushbutton
    input move_up,            //up
    input move_down,          // down
    input [12:0] pixel_index,
    output reg [15:0] colour_chooser
);

// Parameters for colors
parameter BLUE = 16'b00000_000000_11111;
parameter GREEN = 16'b00000_111111_00000;
parameter BLACK = 16'b00000_000000_00000;

parameter TOP_LEFT = 0;
parameter CENTER = 1;
parameter MOVING_RIGHT = 2;
parameter MOVING_LEFT = 3;
parameter MOVING_UP = 4;
parameter MOVING_DOWN = 5;
parameter EDGE = 6;
parameter Width = 96;
parameter Height = 64;
parameter Pixel_Delay = 1000;

reg [2:0] current_state = TOP_LEFT;  
reg [2:0] next_state;  
reg [6:0] square_x = 2;  
reg [6:0] square_y = 2;  
reg [10:0] movement_counter = 0; 

wire [6:0] row, col;
assign col = pixel_index % 96;
assign row = pixel_index / 96;

always @(posedge clk) begin
    // Check direction button presses first
    if (move_right && current_state != MOVING_RIGHT) next_state <= MOVING_RIGHT;
    else if (move_left && current_state != MOVING_LEFT) next_state <= MOVING_LEFT;
    else if (move_up && current_state != MOVING_UP) next_state <= MOVING_UP;
    else if (move_down && current_state != MOVING_DOWN) next_state <= MOVING_DOWN;

    case(current_state)
        TOP_LEFT:
            if (reset) begin
                square_x <= Width/2 - 3; 
                square_y <= Height/2 - 3;
                next_state <= CENTER;
            end
        CENTER:
            begin
            square_x <= Width/2 - 3; 
            square_y <= Height/2 - 3;
            end
        MOVING_RIGHT:
            if(movement_counter >= Pixel_Delay) begin
                if (square_x < Width - 6) square_x <= square_x + 1;
                else next_state <= EDGE;
                movement_counter <= 0;
            end else movement_counter <= movement_counter + 1;
        MOVING_LEFT:
            if(movement_counter >= Pixel_Delay) begin
                if (square_x > 0) square_x <= square_x - 1;
                else next_state <= EDGE;
                movement_counter <= 0;
            end else movement_counter <= movement_counter + 1;
        MOVING_UP:
            if(movement_counter >= Pixel_Delay) begin
                if (square_y > 0) square_y <= square_y - 1;
                else next_state <= EDGE;
                movement_counter <= 0;
            end else movement_counter <= movement_counter + 1;
        MOVING_DOWN:
            if(movement_counter >= Pixel_Delay) begin
                if (square_y < Height - 6) square_y <= square_y + 1;
                else next_state <= EDGE;
                movement_counter <= 0;
            end else movement_counter <= movement_counter + 1;
        EDGE:
            if (move_right && square_x < Width - 6) next_state <= MOVING_RIGHT;
            else if (move_left && square_x > 0) next_state <= MOVING_LEFT;
            else if (move_up && square_y > 0) next_state <= MOVING_UP;
            else if (move_down && square_y < Height - 6) next_state <= MOVING_DOWN;
            else if (reset) begin
                square_x <= Width/2 - 3;
                square_y <= Height/2 - 3;
                next_state <= CENTER;
            end
    endcase

    // If state changes or the box reaches an edge, reset the movement counter
    if (current_state != next_state) begin
        current_state <= next_state;
        movement_counter <= 0;
    end
end

always @(*) begin
    if (row >= square_y && row < square_y + 5 && col >= square_x && col < square_x + 5) begin
        if (current_state == TOP_LEFT) colour_chooser = BLUE;
        else colour_chooser = GREEN;
    end else colour_chooser = BLACK;
end
endmodule
