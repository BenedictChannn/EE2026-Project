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


module Top_Student (
    // Delete this comment and include Basys3 inputs and outputs here
    input CLK,
    input btnC, btnR, btnL,
    output [7:0] JC,
    inout PS2Clk, PS2Data
    );
    wire [15:0] pixel_data;
    wire [12:0] pixel_index;
    wire CLK_6P25M;
    
    // Generate 6.25 MHz clock
    clk6p25m clk625 (CLK, CLK_6P25M);
        
    Basic_Task_B B (.CLK(CLK), .btnC(btnC), .btnR(btnR), .btnL(btnL), .PS2Clk(PS2Clk), .PS2Data(PS2Data), .pixel_index(pixel_index), .pixel_data(pixel_data));

    // Instantiate Oled display
    Oled_Display oled (.clk(CLK_6P25M), .pixel_index(pixel_index), .pixel_data(pixel_data), .reset(btnC), .cs(JC[0]), .sdin(JC[1]),
    .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]));
    
    
    
endmodule