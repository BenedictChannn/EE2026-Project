`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    // Delete this comment and include Basys3 inputs and outputs here
    input CLK,
    input btnC,
    output [7:0] JC,
    inout PS2Clk, PS2Data
    );
    reg [15:0] pixel_data;
    wire [11:0] pixel_index;
    wire CLK_6P25M;
    
    // Generate clk signal of 6.25 MHz
    clk6p25m clk625 (CLK, CLK_6P25M);
    
    // Oled settings
    parameter SCREEN_HEIGHT = 64;
    parameter SCREEN_WIDTH = 96;
    
    // Border Thickness and colour
    parameter BORDER_THICKNESS = 3;
    parameter BORDER_COLOUR = 16'h07E0;
    
    // Box Colour
    parameter BOX_COLOUR = 16'hFFFF;
    
    wire [6:0] col, row;
    wire [12:0] pixel_index;
    reg [15:0] pixel_data;
    
    assign col = pixel_index % 96;
    assign row = pixel_index / 96;

    // Pixel data generation with border
    always @ (pixel_index) begin
        if ((col > 39 && col <= 57) && ((row > 23 && row <= 26) || (row > 38 && row <= 41)) || (row > 26 && row <= 38) && ((col > 39 && col <= 42) || (col > 54 && col <= 57))) begin
            pixel_data <= BORDER_COLOUR;
        end else if (col > 44 && col <= 52 & row > 28 && row <= 36) begin
            pixel_data <= BOX_COLOUR;
        end else begin 
            pixel_data <= 16'h0000;
        end
    end
      

    // Instantiate Oled display to display either green or red depending on sw4
    Oled_Display oled (.clk(CLK_6P25M), .pixel_index(pixel_index), .pixel_data(pixel_data), .reset(btnC), .cs(JC[0]), .sdin(JC[1]),
    .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]));
    
    
endmodule


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