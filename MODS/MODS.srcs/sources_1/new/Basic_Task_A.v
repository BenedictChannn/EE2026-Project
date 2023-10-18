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


module Basic_Task_A (
    input active,
    input CLOCK,centre,up,
    input [12:0] pixel_index,
    output reg [15:0]oled_data
);
   
   wire clk, reset, frame_begin, sending_pixels, sample_pixel, cs, sdin, sclk, d_cn, resn, vccen, pmoden;  
   wire btnc, btnu;
   wire [6:0] x;
   wire [5:0] y;
   wire [15:0] pixel_data;
   

   assign pixel_data = oled_data;
   assign x = pixel_index % 96;//95
   assign y = pixel_index / 96;//63
   
   clk_divider clk6p25m(CLOCK, 3'b111, clk);
   debouncerA btnC(.CLOCK(CLOCK),.BTN(centre),.btn(btnc));
   debouncerA btnU(.CLOCK(CLOCK),.BTN(up),.btn(btnu));
   
   reg [26:0] timer = 0;
   reg border = 0;
   reg box = 0;
   reg btnuu = 0;
   
    always @(posedge clk) begin
        if (active == 0) begin
            timer = 0;
            border = 0;
            box = 0;
            btnuu = 0;
        end
        if (btnu && border && btnuu == 0)begin
            btnuu = 1;
            box = ~box;
        end
        else if (btnu == 0 && border == 1 && btnuu == 1) begin
            btnuu = 0;
        end
        if (border && timer <= 34_375_000) begin  
            if (timer < 34_375_000) timer <= timer + 1;
            if (timer == 34_375_000) timer = 0;//5.5s loop
        end

        if ((2<=x&&x<=93)&&(2<=y&&y<=61)&&!((3<=x&&x<=92)&&(3<=y&&y<=60))) begin
            oled_data = 16'b11111_000000_00000;//red
        end
       
        else if ((btnc||border)&&(5<=x&&x<=90)&&(5<=y&&y<=58)&&!((8<=x&&x<=87)&&(8<=y&&y<=55))) begin
            oled_data = 16'b11111_101101_00000;//orange
            border = 1;
        end
       
        else if (border && (12_500_000 <= timer)&&(10<=x&&x<=85)&&(10<=y&&y<=53)&&!((11<=x&&x<=84)&&(11<=y&&y<=52))) begin
            oled_data = 16'b00000_111111_00000;//green,2.0s
        end
       
        else if (border && (21_875_000 <= timer)&&(13<=x&&x<=82)&&(13<=y&&y<=50)&&!((15<=x&&x<=80)&&(15<=y&&y<=48))) begin
            oled_data = 16'b00000_111111_00000;//green,3.5s
        end
       
        else if (border && (28_125_000 <= timer)&&(17<=x&&x<=78)&&(17<=y&&y<=46)&&!((20<=x&&x<=75)&&(20<=y&&y<=43))) begin
            oled_data = 16'b00000_111111_00000;//green,4.5s
        end
       
        else if (box && (46<=x&&x<=49)&&(30<=y&&y<=33)) begin
            oled_data = 16'b11111_000000_00000;//red solid square
        end
       
        else begin
            oled_data = 0;
        end
    end
endmodule

