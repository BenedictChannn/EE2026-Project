`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.10.2023 12:25:07
// Design Name: 
// Module Name: MouseOledPaint_Setup
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

module MouseOledPaint_Setup (
    // Delete this comment and include Basys3 inputs and outputs here
    input CLK,
    input btnC,
    input [12:0] pixel_index,
    inout PS2Clk, PS2Data,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    output [15:0] pixel_data
    );
    
    wire CLK_6P25M;
    wire left, right;
    wire [11:0] mouse_x_pos;
    wire [11:0] mouse_y_pos;
    wire [12:0] pixel_index;
    wire [15:0] colour_chooser;
    assign an = 4'b0000;
    //reg [15:0] oled_data = (sw4 == 1) ? 16'hF800 : 16'h07E0;
   
    // Generate clk signal of 6.25 MHz
    clk6p25m clk625 (CLK, CLK_6P25M);
    
    paint canvas (.clk_100M(CLK), .enable(1), .mouse_l(left), .reset(right), .mouse_x(mouse_x_pos), .mouse_y(mouse_y_pos), 
    .pixel_index(pixel_index), .colour_chooser(colour_chooser), .seg(seg), .led(led));
    
    // Instantiate mouse 
    MouseCtl mouse(.clk(CLK), .xpos(mouse_x_pos), .ypos(mouse_y_pos), .ps2_clk(PS2Clk), .value(12'b0), .setx(0), .sety(0), .setmax_x(0), .setmax_y(0),
     .ps2_data(PS2Data), .left(left), .middle(middle), .right(right));

//    // Instantiate Oled display to display either green or red depending on sw4
//    Oled_Display oled (.clk(CLK_6P25M), .pixel_index(pixel_index), .pixel_data(oled_data), .reset(btnC), .cs(JC[0]), .sdin(JC[1]),
//    .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]));
    
    assign pixel_data = colour_chooser;
    
endmodule