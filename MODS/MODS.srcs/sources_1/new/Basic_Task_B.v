`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME: Benedict Chan
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////


module Basic_Task_B (
    // Delete this comment and include Basys3 inputs and outputs here
    input CLK,
    input btnC, btnR, btnL,
    input [12:0] pixel_index,
    output reg [15:0] pixel_data
    );
    wire CLK_6P25M;
    
    // Generate clk signal of 6.25 MHz
    clk6p25m clk625 (CLK, CLK_6P25M);
    
    // Border Thickness and colour
    parameter BORDER_THICKNESS = 3;
    parameter BORDER_COLOUR_GREEN = 16'h07E0;
    parameter LEFT_BORDER = -2 * SHIFT_ONE;
    parameter RIGHT_BORDER = 2 * SHIFT_ONE;
    reg signed [6:0] border_shift = 0;
    
    // Box parameters
    parameter BOX_COLOUR_WHITE = 16'hFFFF;
    parameter BOX_DELAY = 32'd300000000;
    parameter CENTER_BOX_LEFT = 44;
    parameter CENTER_BOX_RIGHT = 52;
    parameter CENTER_BOX_BOTTOM = 28;
    parameter CENTER_BOX_TOP = 36;
    parameter SHIFT_ONE = 19;
    
    // Debouncing
    parameter BOUNCE_TIME = 32'd10000000;
    reg [31:0] bounce_counter = 32'd0;
    
    wire signed [7:0] col, row;
//    wire [12:0] pixel_index_internal;
//    wire [15:0] pixel_data_internal;
    reg [31:0] box_delay_counter = 32'd0;
    reg draw_box = 1'b0;
    
    assign col = pixel_index % 96;
    assign row = pixel_index / 96;
    
    // Pixel data generation with border
    always @ (posedge CLK) begin
        // White boxes to only appear after 3 seconds
        if (box_delay_counter < BOX_DELAY) begin
            box_delay_counter <= box_delay_counter + 1;
        end else begin
            draw_box <= 1'b1;
        end
        
        //Debounce
        if (bounce_counter > 0) begin
            bounce_counter <= bounce_counter - 1;
        end
        
        // btn shift left/ right for green border
        if (btnL && (border_shift > LEFT_BORDER) && bounce_counter == 32'd0) begin
            bounce_counter <= BOUNCE_TIME;
            border_shift = border_shift - SHIFT_ONE;
        end else if (btnR && (border_shift < RIGHT_BORDER) && bounce_counter == 32'd0) begin
            bounce_counter <= BOUNCE_TIME;
            border_shift = border_shift + SHIFT_ONE;
        end
         
        // Logic white boxes and green border 
        if ((col > 39 + border_shift && col <= 57 + border_shift) && ((row > 23 && row <= 26) || (row > 38 && row <= 41)) 
        || (row > 26 && row <= 38) && ((col > 39 + border_shift && col <= 42 + border_shift) || (col > 54 + border_shift && col <= 57 + border_shift))) begin
            pixel_data <= BORDER_COLOUR_GREEN;
        end else if (((col > CENTER_BOX_LEFT && col <= CENTER_BOX_RIGHT && row > CENTER_BOX_BOTTOM && row <= CENTER_BOX_TOP) 
        || (col > CENTER_BOX_LEFT - SHIFT_ONE && col <= CENTER_BOX_RIGHT - SHIFT_ONE && row > CENTER_BOX_BOTTOM && row <= CENTER_BOX_TOP)
        || (col > CENTER_BOX_LEFT - 2 * SHIFT_ONE && col <= CENTER_BOX_RIGHT - 2 * SHIFT_ONE && row > CENTER_BOX_BOTTOM && row <= CENTER_BOX_TOP)
        || (col > CENTER_BOX_LEFT + SHIFT_ONE && col <= CENTER_BOX_RIGHT + SHIFT_ONE && row > CENTER_BOX_BOTTOM && row <= CENTER_BOX_TOP)
        || (col > CENTER_BOX_LEFT + 2 * SHIFT_ONE && col <= CENTER_BOX_RIGHT + 2 * SHIFT_ONE && row > CENTER_BOX_BOTTOM && row <= CENTER_BOX_TOP))
        && draw_box) begin
            pixel_data <= BOX_COLOUR_WHITE;
        end else begin 
            pixel_data <= 16'h0000;
        end
    end    
endmodule