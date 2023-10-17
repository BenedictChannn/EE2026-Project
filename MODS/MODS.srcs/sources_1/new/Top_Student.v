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
    input [3:0] sw,
    output [7:0] JC,
    output reg [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    inout PS2Clk, PS2Data
    );
    reg [24:0] COUNT = 0;
    reg toggle = 1'b0;
    
    reg [15:0] pixel_data;
    wire [15:0] pixel_data_A;
    wire [15:0] pixel_data_B;
    wire [15:0] pixel_data_C;
    wire [15:0] pixel_data_D;
    wire [15:0] pixel_data_Paint;
    wire [12:0] pixel_index;
    wire CLK_6P25M;
    wire [15:0] led_blink;
    
    // Generate 6.25 MHz clock
    clk6p25m clk625 (CLK, CLK_6P25M);
    
    always @ (posedge CLK) begin
        COUNT <= (COUNT == 25'b1001100010010110100000000) ? 0 : COUNT + 1;
        toggle <= (COUNT == 0) ? ~toggle : toggle;
        
        case(sw)
            4'b0010: begin
                pixel_data <= pixel_data_B;
                led <= 16'b0000000000000010;
            end
            4'b0000: begin
                pixel_data <= pixel_data_Paint;
                if (toggle) begin
                    led <= led_blink;
                end else begin
                    led <= 16'b0;
                end
            end
        endcase
    end
            
    Basic_Task_B B (.CLK(CLK), .btnC(btnC), .btnR(btnR), .btnL(btnL), .PS2Clk(PS2Clk), .PS2Data(PS2Data), .pixel_index(pixel_index), .pixel_data(pixel_data_B));

    MouseOledPaint_Setup paint (.CLK(CLK), .btnC(btnC), .pixel_index(pixel_index), .PS2Clk(PS2Clk), 
    .PS2Data(PS2Data), .led(led_blink), .an(an), .seg(seg), .pixel_data(pixel_data_Paint));
    
    // Instantiate Oled display
    Oled_Display oled (.clk(CLK_6P25M), .pixel_index(pixel_index), .pixel_data(pixel_data), .reset(btnC), 
    .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]));
    
    
    
    
    
endmodule