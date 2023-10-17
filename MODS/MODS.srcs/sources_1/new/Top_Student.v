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
    input btnC, btnR, btnL, btnU, btnD,
    input [3:0] sw,
    output [7:0] JC,
    output reg [15:0] led,
    output reg [6:0] seg,
    output reg [3:0] an,
    output reg dp,
    inout PS2Clk, PS2Data
    );
    reg [24:0] COUNT = 0;
    reg toggle = 1'b0;
    
    wire [6:0] seg_paint; // Must be placed before seg_v a l
    wire [6:0] seg_v = 7'b1000001;
    wire [6:0] seg_a = 7'b0001000;
    wire [6:0] seg_l = 7'b1000111;
    reg [1:0] mux_counter = 2'b00;
    reg [31:0] cyc_cnt = 32'd0;
    reg [31:0] div_cnt = 1000;
    
    reg [15:0] pixel_data;
    wire [15:0] pixel_data_A;
    wire [15:0] pixel_data_B;
    wire [15:0] pixel_data_C;
    wire [15:0] pixel_data_D;
    wire [15:0] pixel_data_paint;
    wire [12:0] pixel_index;
    wire CLK_6P25M;
    wire [15:0] led_blink;
    
    // Generate 6.25 MHz clock
    clk6p25m clk625 (CLK, CLK_6P25M);
    
    always @ (posedge CLK) begin
        COUNT <= (COUNT == 25'b1001100010010110100000000) ? 0 : COUNT + 1;
        toggle <= (COUNT == 0) ? ~toggle : toggle;
        an = 4'b1111;
        
        case(sw)
            4'b0001: begin
                pixel_data <= pixel_data_A;
                led = 16'b0000000000000001;
            end
            4'b0010: begin
                pixel_data <= pixel_data_B;
                led = 16'b0000000000000010;
            end
            4'b0100: begin
                pixel_data <= pixel_data_C;
                led = 16'b0000000000000100;
            end
            4'b0000: begin
                pixel_data <= pixel_data_paint;
                if (toggle) begin
                    led <= led_blink;
                end else begin
                    led <= 16'b0;
                end
                
                // Counter to cycle through segments               
                if(cyc_cnt >= div_cnt) begin
                    cyc_cnt <= 32'd0;
                    mux_counter <= mux_counter + 1;
                end else begin
                    cyc_cnt <= cyc_cnt + 1;
                end
                                
                // Logic to select which segment and character to display
                dp = 1'b1;  // Decimal point default off
                case (mux_counter)
                    2'b00: begin // Display V
                        an = 4'b0111;
                        seg = seg_v;
                    end
                    2'b01: begin // Display A
                        an = 4'b1011;
                        seg = seg_a;
                    end
                    2'b10: begin // Display L
                        an = 4'b1101;
                        seg = seg_l;
                        dp = 1'b0;  // Decimal point on for L
                    end
                    2'b11: begin 
                        an = 4'b1110;  
                        seg = seg_paint;
                    end
                endcase
            end
        endcase
    end
    
    Basic_Task_A A (.CLOCK(CLK), .centre(btnC), .up(btnU), .pixel_index(pixel_index), .oled_data(pixel_data_A));
    Basic_Task_B B (.CLK(CLK), .btnC(btnC), .btnR(btnR), .btnL(btnL), .pixel_index(pixel_index), .pixel_data(pixel_data_B));
    Basic_Task_C C (.CLOCK(CLK), .btnC(btnC), .pixel_index(pixel_index), .oled_data(pixel_data_C));

    MouseOledPaint_Setup paint (.CLK(CLK), .pixel_index(pixel_index), .PS2Clk(PS2Clk), 
    .PS2Data(PS2Data), .led(led_blink), .seg(seg_paint), .pixel_data(pixel_data_paint));
    
    // Instantiate Oled display
    Oled_Display oled (.clk(CLK_6P25M), .pixel_index(pixel_index), .pixel_data(pixel_data), .reset(0), 
    .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]));
    
    
    
    
    
endmodule