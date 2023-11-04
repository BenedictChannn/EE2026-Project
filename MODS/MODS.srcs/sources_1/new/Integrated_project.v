`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.11.2023 19:37:24
// Design Name: 
// Module Name: Integrated_project
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


module Integrate(
    input CLK,input btnC, btnR, btnL, btnU, btnD,
    output [7:0] JC,
    input [3:0] sw,
    input sw15,
    output reg [15:0] led
    );
    reg active = 0;
    wire CLK_6P25M, CLK_10;
    wire [12:0] pixel_index;
    reg [15:0] pixel_data;
    wire [15:0] colour_chooser;
    wire [15:0] pixel_data_A;
    wire [15:0] pixel_data_C;
    wire [15:0] pixel_data_D;
    wire [15:0] led_snake;
    wire [15:0] welcome_A;
    wire [15:0] welcome_B;
    wire [15:0] welcome_c;
    wire [15:0] welcome_D;
    
    always @ (posedge CLK) begin
            active = 1;
             case(sw)
                 4'b0001: begin
                     pixel_data <= welcome_A;
                     if (sw15) begin
                         pixel_data <= pixel_data_A;
                         led = 16'b0000000000000000;
                     end
                 end
                 4'b0010: begin
                     pixel_data <= welcome_B;
                     //pixel_data <= pixel_data_B;
                     //led = 16'b0000000000000000;
                 end
                 4'b0100: begin
                     pixel_data <= welcome_C;
//                     pixel_data <= pixel_data_C;
//                     led = 16'b0000000000000000;
                 end
                 4'b1000: begin
                     pixel_data <= welcome_D;
//                     pixel_data <= pixel_data_D;
//                     led = led_snake;
                 end
                 default: begin
                     active = 0;
                     pixel_data <= welcome_A;
                     led = 16'b0000000000000000;
                 end
             endcase
         end
         
    clk6p25m clk625 (CLK, CLK_6P25M);
    // clk10kHz clk10(CLK, CLK_10);
    // group group(pixel_index, group_img);

    TaskA TaskA (.active(active), .CLOCK(CLK), .centre(btnC), .up(btnU), .pixel_index(pixel_index), .oled_data(pixel_data_A));
//    Simon TaskC (.active(active), .CLK(CLK), .btnC(btnC), .btnR(btnR), .btnL(btnL), .btnU(btnU), .btnD(btnD), .pixel_index(pixel_index), .pixel_data(pixel_data_C));
//    Snake TaskD (.active(active),.clk(CLK_10),.pixel_index(pixel_index),.reset(btnC),.move_left(btnL),.move_right(btnR),.move_up(btnU),.move_down(btnD),.colour_chooser(pixel_data_D),.led(led_snake));

    // Instantiate Oled display
    Oled_Display oled (.clk(CLK_6P25M), .pixel_index(pixel_index), .pixel_data(pixel_data), .reset(0), 
    .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]));
  
  // Welcome screens
  Welcome_A Welcome_A (pixel_index, welcome_A);
  Welcome_B Welcome_B (pixel_index, welcome_B);
  Welcome_C Welcome_C (pixel_index, welcome_C);
  Welcome_D Welcome_D (pixel_index, welcome_D);
 
endmodule
