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
    output led13, led14, led15
    );

    wire CLK_6P25M;
    wire left, middle, right;
    reg [15:0] oled_data = (sw4 == 1) ? 16'hF800 : 16'h07E0;
    

    clk6p25m clk625 (CLK, CLK_6P25M);
    // Delete this comment and write your codes and instantiations here
    Oled_Display oled (.clk(CLK_6P25M), .pixel_data(oled_data), .reset(btnC), .cs(JC[0]), .sdin(JC[1]),
    .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]));
    
    MouseCtl mouse(.clk(CLK), .ps2_clk(PS2Clk), .value(12'b0), .setx(0), .sety(0), .setmax_x(0), .setmax_y(0),
     .ps2_data(PS2Data), .left(left), .middle(middle), .right(right));
    assign led13 = right;
    assign led14 = middle;
    assign led15 = left;
    
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
