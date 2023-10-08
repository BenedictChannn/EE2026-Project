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
    input sw4,
    output [7:0] JC,
    inout PS2Clk, PS2Data,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an
    );

    wire CLK_6P25M;
    wire left, right;
    wire [11:0] mouse_x_pos;
    wire [11:0] mouse_y_pos;
    wire [12:0] pixel_index;
    wire [15:0] colour_chooser;
    wire [15:0] oled_data;
    assign an = 4'b0000;
    //reg [15:0] oled_data = (sw4 == 1) ? 16'hF800 : 16'h07E0;
   
    // Generate clk signal of 6.25 MHz
    clk6p25m clk625 (CLK, CLK_6P25M);
    
    paint canvas (.clk_100M(CLK), .enable(1), .mouse_l(left), .reset(right), .mouse_x(mouse_x_pos), .mouse_y(mouse_y_pos), 
    .pixel_index(pixel_index), .colour_chooser(colour_chooser), .seg(seg), .led(led));
    
    // Instantiate mouse 
    MouseCtl mouse(.clk(CLK), .xpos(mouse_x_pos), .ypos(mouse_y_pos), .ps2_clk(PS2Clk), .value(12'b0), .setx(0), .sety(0), .setmax_x(0), .setmax_y(0),
     .ps2_data(PS2Data), .left(left), .middle(middle), .right(right));

    // Instantiate Oled display to display either green or red depending on sw4
    Oled_Display oled (.clk(CLK_6P25M), .pixel_index(pixel_index), .pixel_data(oled_data), .reset(btnC), .cs(JC[0]), .sdin(JC[1]),
    .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]));
    
    assign pixel_index = oled.pixel_index;
    assign colour_chooser = oled_data;
    
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
