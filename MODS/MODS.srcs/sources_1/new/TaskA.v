`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/04 02:02:37
// Design Name: 
// Module Name: TaskA
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


module TaskA(
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
       
       parameter WHITE = 16'b11111_111111_11111;
       parameter ORANGE = 16'b11111_101101_00000;
       parameter BLUE = 16'b00000_000000_11111;
       parameter GREEN = 16'b00000_111111_00000;
       parameter RED = 16'b11111_000000_00000;
       parameter PURPLE = 16'b11111_000000_11110;
       parameter BLACK = 16'h0;
       parameter ONE_SECOND = 6_250_000;
       parameter TWO_SECOND = 12_500_000;
       parameter THREE_SECOND = 18_750_000;
       parameter FOUR_SECOND = 25_000_000;
       parameter FIVE_SECOND = 31_250_000;
   
       assign pixel_data = oled_data;
       assign x = pixel_index % 96;//95
       assign y = pixel_index / 96;//63
   
       clk_divider clk6p25m(CLOCK, 3'b111, clk);
       debouncerA btnC(.CLOCK(CLOCK), .btn(centre), .debounced_btn(btnc));
       debouncerA btnU(.CLOCK(CLOCK), .btn(up), .debounced_btn(btnu));
   
       reg [26:0] timer = 0;
       reg [26:0] timer1 = 0;
       reg [26:0] timer2 = 0;
       reg [26:0] timer3 = 0;
       reg [26:0] timer4 = 0;
       reg [26:0] timer5 = 0;
       reg border = 0;
       reg box = 0;
       reg btnuu = 0;
       reg step1 = 0;
       reg step2 = 0;
       reg step3 = 0;
       reg step4 = 0;
       reg step5 = 0;
       
       always @(posedge clk) begin
   // Initialization
           if (active == 0) begin
               timer = 0;
               timer1 = 0;
               timer2 = 0;
               timer3 = 0;
               timer4 = 0;
               timer5 = 0;
               border = 0;
               box = 0;
               btnuu = 0;
               step1 = 0;
               step2 = 0;
               step3 = 0;
               step4 = 0;
               step5 = 0;
           end
   
           if (btnu && border && btnuu == 0) begin
               btnuu = 1;
               box = ~box;
           end else if (btnu == 0 && border == 1 && btnuu == 1) begin
               btnuu = 0;
           end
   
           if (border && timer <= FIVE_SECOND) begin  
               if (timer < FIVE_SECOND) timer <= timer + 1;
               if (timer == FIVE_SECOND) timer = 0;
           end
   
           if (step1 && timer1 <= FIVE_SECOND) begin  
               if (timer1 < FIVE_SECOND) timer1 <= timer1 + 1;
               if (timer1 == FIVE_SECOND) timer1 = 0;
           end
           if (step2 && timer2 <= FIVE_SECOND) begin  
               if (timer2 < FIVE_SECOND) timer2 <= timer2 + 1;
               if (timer2 == FIVE_SECOND) timer2 = 0;
           end    
           if (step3 && timer3 <= FIVE_SECOND) begin  
               if (timer3 < FIVE_SECOND) timer3 <= timer3 + 1;
               if (timer3 == FIVE_SECOND) timer3 = 0;
           end    
           if (step4 && timer4 <= FIVE_SECOND) begin  
               if (timer4 < FIVE_SECOND) timer4 <= timer4 + 1;
               if (timer4 == FIVE_SECOND) timer4 = 0;
           end
           if (step5 && timer5 <= FIVE_SECOND) begin  
               if (timer5 < FIVE_SECOND) timer5 <= timer5 + 1;
               if (timer5 == FIVE_SECOND) timer5 = 0;
           end  
           // 1st border
           if (
               (0<=x && x<=95) &&
               (0<=y && y<=63) &&
               !((3<=x && x<=92)&&
               (3<=y && y<=60))
           ) 
               oled_data = RED;
           
           // 2st border       
           else if (
               (btnc || border) &&
               (ONE_SECOND >= timer) &&
               (5<=x && x<=90) &&
               (5<=y && y<=58) &&
               !((8<=x && x<=87) &&
               (8<=y && y<=55))
           ) begin
               oled_data = ORANGE;
               border = 1;               
           end else if (
               (border) && 
               (ONE_SECOND <= timer) && 
               (timer <= TWO_SECOND) && 
               (5<=x&&x<=90) &&
               (5<=y&&y<=58) &&
               !((8<=x&&x<=87) &&
               (8<=y&&y<=55))
           ) 
               oled_data = GREEN;
           else if (
               (border) && 
               (TWO_SECOND <= timer) && 
               (timer <= THREE_SECOND) && 
               (5<=x&&x<=90)&&
               (5<=y&&y<=58)&&
               !((8<=x&&x<=87)&&
               (8<=y&&y<=55))
           ) 
               oled_data = PURPLE;
           else if (
               (border) && 
               (THREE_SECOND <= timer) && (timer <= FOUR_SECOND) && 
               (5<=x&&x<=90)&&
               (5<=y&&y<=58)&&
               !((8<=x&&x<=87)&&
               (8<=y&&y<=55))
           ) 
               oled_data = BLUE;
           else if (
               (border) && 
               (timer >= FOUR_SECOND) && 
               (5<=x&&x<=90)&&
               (5<=y&&y<=58)&&
               !((8<=x&&x<=87)&&
               (8<=y&&y<=55))
           ) begin
               oled_data = RED;
               step1 <= 1;
           end
           
           // 3nd border      
           else if (
               (border) && 
               (step1) &&
               (timer1 <= ONE_SECOND) && 
               (10<=x&&x<=85)&&(10<=y&&y<=53) && 
               !((11<=x&&x<=84)&&(11<=y&&y<=52))
           )
           oled_data = GREEN; 
           else if (
               (border) && 
               (step1) &&
               (ONE_SECOND <= timer1) && 
               (timer1 <= TWO_SECOND ) && 
               (10<=x&&x<=85) && 
               (10<=y&&y<=53) && 
               !((11<=x&&x<=84) && 
               (11<=y&&y<=52))
           ) 
               oled_data = PURPLE;
   
           else if (
               (border) && 
               (step1) &&
               (TWO_SECOND <= timer1) &&
               (timer1 <= THREE_SECOND) &&
               (10<=x&&x<=85)&&
               (10<=y&&y<=53)&&
               !((11<=x&&x<=84)&&
               (11<=y&&y<=52))
           ) 
               oled_data = ORANGE;
           else if (
               (border) && 
               (step1) &&
               (THREE_SECOND <= timer1) && 
               (timer1 <= FOUR_SECOND) &&
               (10<=x&&x<=85) && 
               (10<=y&&y<=53) && 
               !((11<=x&&x<=84) && 
               (11<=y&&y<=52))
           ) 
               oled_data = BLUE;
           else if (
               (border) && 
               (step1) &&
               (timer1 >= FOUR_SECOND)&&
               (10<=x&&x<=85) && 
               (10<=y&&y<=53) && 
               !((11<=x&&x<=84) && 
               (11<=y&&y<=52))
           ) begin 
               oled_data = RED;
               step2 <= 1;
           end   
           //4st border
           else if (
               (border) && 
               (step2) &&
               (timer2 <= ONE_SECOND) && 
               (13<=x&&x<=82) && (13<=y&&y<=50) && !((15<=x&&x<=80) && (15<=y&&y<=48))
           ) 
               oled_data = GREEN; 
           else if (
               (border) && 
               (step2) &&
               (ONE_SECOND <= timer2) && 
               (timer2 <= TWO_SECOND) && 
               (13<=x&&x<=82) && (13<=y&&y<=50) && !((15<=x&&x<=80) && (15<=y&&y<=48))
           ) 
               oled_data = PURPLE;
           else if (
               (border) && 
               (step2) &&
               (TWO_SECOND <= timer2) &&
               (timer2 <= THREE_SECOND) &&
               (13<=x&&x<=82) && (13<=y&&y<=50) && !((15<=x&&x<=80) && (15<=y&&y<=48))
           ) 
               oled_data = ORANGE;
           else if (
               (border) && 
               (step2) &&
               (THREE_SECOND <= timer2) && 
               (timer2 <= FOUR_SECOND) &&
               (13<=x&&x<=82) && (13<=y&&y<=50) && !((15<=x&&x<=80) && (15<=y&&y<=48))
           ) 
               oled_data = BLUE;
           else if (
               (border) && 
               (step2) &&
               (timer2 >= FOUR_SECOND) &&
               (13<=x&&x<=82)&&(13<=y&&y<=50)&&!((15<=x&&x<=80)&&(15<=y&&y<=48))
           ) begin
               oled_data = RED;
               step3 <= 1;
           end    
           // 5th border
           else if (
               (border) && 
               (step3) &&
               (timer3 <= ONE_SECOND) && 
               (17<=x&&x<=78)&&(17<=y&&y<=46)&&!((20<=x&&x<=75)&&(20<=y&&y<=43))
           ) 
               oled_data = GREEN; 
           else if (
               (border) && 
               (step3) &&
               (ONE_SECOND <= timer3) && 
               (timer3 <= TWO_SECOND) && 
               (17<=x&&x<=78)&&(17<=y&&y<=46)&&!((20<=x&&x<=75)&&(20<=y&&y<=43))
           ) 
               oled_data = PURPLE;
           else if (
               (border) && 
               (step3) &&
               (TWO_SECOND <= timer3) &&
               (timer3 <= THREE_SECOND) &&
               (17<=x&&x<=78)&&(17<=y&&y<=46)&&!((20<=x&&x<=75)&&(20<=y&&y<=43))
           ) 
               oled_data = ORANGE;
           else if (
               (border) && 
               (step3) &&
               (THREE_SECOND <= timer3) && 
               (timer3 <= FOUR_SECOND) &&
               (17<=x&&x<=78)&&(17<=y&&y<=46)&&!((20<=x&&x<=75)&&(20<=y&&y<=43))
           ) 
               oled_data = BLUE;
           else if (
               (border) && 
               (step3) &&
               (timer3 >= FOUR_SECOND) &&
               (17<=x&&x<=78)&&(17<=y&&y<=46)&&!((20<=x&&x<=75)&&(20<=y&&y<=43))
           ) begin
               oled_data = RED;
               step4 <= 1;
           end
           // 6th border  
           else if (
               (border) && 
               (step4) &&
               (timer4 <= ONE_SECOND) && 
               (22<=x&&x<=73)&&(22<=y&&y<=41)&&!((26<=x&&x<=69)&&(26<=y&&y<=37))
           ) 
               oled_data = GREEN; 
           else if (
               (border) && 
               (step4) &&
               (ONE_SECOND <= timer4) && 
               (timer4 <= TWO_SECOND) && 
               (22<=x&&x<=73)&&(22<=y&&y<=41)&&!((26<=x&&x<=69)&&(26<=y&&y<=37))
           ) 
               oled_data = PURPLE;
           else if (
               (border) && 
               (step4) &&
               (TWO_SECOND <= timer4) &&
               (timer4 <= THREE_SECOND) &&
               (22<=x&&x<=73)&&(22<=y&&y<=41)&&!((26<=x&&x<=69)&&(26<=y&&y<=37))
           ) 
               oled_data = ORANGE;
           else if (
               (border) && 
               (step4) &&
               (THREE_SECOND <= timer4) && 
               (timer4 <= FOUR_SECOND) &&
               (22<=x&&x<=73)&&(22<=y&&y<=41)&&!((26<=x&&x<=69)&&(26<=y&&y<=37))
           ) 
               oled_data = BLUE;
           else if (
               (border) && 
               (step4) &&
               (timer4 >= FOUR_SECOND) &&
               (22<=x&&x<=73)&&(22<=y&&y<=41)&&!((26<=x&&x<=69)&&(26<=y&&y<=37))
           ) begin
               oled_data = RED;
               step5 <= 1;
           end  
           // solid square
           else if (
               (box) && 
               (step5) &&
               (timer5 <= ONE_SECOND) && 
               (30<=x&&x<=65) && (28<=y&&y<=35)
           ) 
               oled_data = GREEN; 
           else if (
               (box) && 
               (step5) &&
               (ONE_SECOND <= timer5) && 
               (timer5 <= TWO_SECOND) && 
               (30<=x&&x<=65) && (28<=y&&y<=35)
           ) 
               oled_data = PURPLE;
           else if (
               (box) && 
               (step5) &&
               (TWO_SECOND <= timer5) &&
               (timer5 <= THREE_SECOND) &&
               (30<=x&&x<=65) && (28<=y&&y<=35)
           ) 
               oled_data = ORANGE;
           else if (
               (box) && 
               (step5) &&
               (THREE_SECOND <= timer5) && 
               (timer5 <= FOUR_SECOND) &&
               (30<=x&&x<=65) && (28<=y&&y<=35)
           ) 
               oled_data = BLUE;
           else if (
               (box) && 
               (step5) &&
               (timer5 >= FOUR_SECOND) &&
               (30<=x&&x<=65) && (28<=y&&y<=35)
   
           ) 
               oled_data = RED;
           else
               oled_data = 0;
       end
endmodule
