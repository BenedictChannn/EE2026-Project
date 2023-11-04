`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2023 00:04:52
// Design Name: 
// Module Name: Brick_Breaker
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


module BrickBreaker_game(
    input CLK, btnU, btnD, btnC, btnL, btnR,
    output reg [6:0] seg, 
    output reg [3:0]an,
    output [7:0] JC,
    inout PS2Clk, PS2Data
    );
       
    // Boundaries
    parameter BOUNDARY_TOP = 0;
    parameter BOUNDARY_BOTTOM = 95;
    parameter BOUNDARY_LEFT = 63;
    parameter BOUNDARY_RIGHT = 0;
    
    // OLED
    parameter SCREEN_WIDTH = 96;
    parameter SCREEN_HEIGHT = 64;
    reg unlock = 1'b0;
    reg game_over = 1'b0;
    reg win_game = 1'b0;
    
    // Colours
    parameter WHITE = 16'hFFFF;
    parameter BLACK = 16'h0000;
    parameter RED = 16'hF800;
    parameter BLUE = 16'h001F;
    parameter GREEN = 16'h07E0;
    parameter YELLOW = 16'hFFE0;
    
    // Board
    parameter BOARD_WIDTH = 16;
    parameter BOARD_HEIGHT = 3;
    parameter BOARD_COLOUR = WHITE;
    parameter BOUNCE_TIME = 32'd5000000;
    reg [31:0] bounce_counter = 32'd0;
    reg [11:0] board_x_prev = 12'd32;
    reg [11:0] board_x_curr = 12'd32;
    reg [11:0] board_y_pos = 12'd87;
    
    // Brick
    parameter BRICK_WIDTH = 5;
    parameter BRICK_HEIGHT = 5;
    parameter BRICK_COLOUR_3 = BLUE;
    parameter BRICK_COLOUR_2 = GREEN;
    parameter BRICK_COLOUR_1 = YELLOW;
    parameter N_BRICKS = 130;
    // To keep track whether brick has been destroyed already
    reg [1:0] brick_state [129:0];
    wire [259:0] brick_state_1;
    wire [259:0] brick_state_2;
    reg [259:0] brick_state_chosen;
    reg game_win_state;
    
    // Ball movement
    reg [11:0] ball_x_pos = 12'd32;
    reg [11:0] ball_y_pos = 12'd65;
    reg [3:0] current_state = BOUNCE_STOP;
    reg [31:0] ball_move_counter = 32'd0;
    parameter BALL_MOVE_DELAY = 32'd1750000;
    parameter BALL_COLOUR = RED;
    parameter BALL_RADIUS = 1;
    parameter BOUNCE_STOP = 0;
    parameter BOUNCE_UP = 1;
    parameter BOUNCE_DOWN = 2;
    parameter BOUNCE_UP_LEFT = 3;
    parameter BOUNCE_DOWN_LEFT = 4;
    parameter BOUNCE_DOWN_RIGHT = 5;
    parameter BOUNCE_UP_RIGHT = 6;
    parameter BALL_START_DELAY = 32'd300000000;
    reg [31:0] ball_start_counter = 32'd0;
    
    // Countdown for start of game
    reg [6:0] seg_3 = 7'b0110000;
    reg [6:0] seg_2 = 7'b0100100;
    reg [6:0] seg_1 = 7'b1111001;
    
    // Reset
    parameter RESET_COUNT = 32'd500000000;
    reg [31:0] reset_counter = 32'd0;
    
    wire [12:0] pixel_index;
    reg [15:0] pixel_data;
    wire [15:0] screen1_data;
    wire [15:0] screen2_data;
    reg game_level = 1'b0;
    wire [15:0] over_data;
    wire [15:0] win_data;

    wire [6:0] col, row;
    
    assign col = pixel_index % SCREEN_WIDTH;
    assign row = pixel_index / SCREEN_WIDTH;
    
    clk6p25m clk625 (CLK, CLK_6P25M);
    
    ///////////////////////////////////////////////////////////// Brick /////////////////////////////////////////////////////////////
    wire brick_1 = (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    wire brick_2 = (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    wire brick_3 = (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    wire brick_4 = (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    wire brick_5 = (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    wire brick_6 = (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    wire brick_7 = (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    wire brick_8 = (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    wire brick_9 = (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    wire brick_10 = (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    
    wire brick_11 = (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT  - 1);
    wire brick_12 = (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT - 1);
    wire brick_13 = (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT - 1);
    wire brick_14 = (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT - 1);
    wire brick_15 = (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT - 1);
    wire brick_16 = (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT - 1);
    wire brick_17 = (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT - 1);
    wire brick_18 = (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT - 1);
    wire brick_19 = (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT - 1);
    wire brick_20 = (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT - 1);
    
    wire brick_21 = (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    wire brick_22 = (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    wire brick_23 = (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    wire brick_24 = (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    wire brick_25 = (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    wire brick_26 = (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    wire brick_27 = (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    wire brick_28 = (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    wire brick_29 = (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    wire brick_30 = (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    
    wire brick_31 = (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    wire brick_32 = (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    wire brick_33 = (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    wire brick_34 = (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    wire brick_35 = (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    wire brick_36 = (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    wire brick_37 = (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    wire brick_38 = (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    wire brick_39 = (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    wire brick_40 = (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    
    wire brick_41 = (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);
    wire brick_42 = (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);
    wire brick_43 = (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);
    wire brick_44 = (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);
    wire brick_45 = (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);
    wire brick_46 = (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);
    wire brick_47 = (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);
    wire brick_48 = (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);
    wire brick_49 = (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);
    wire brick_50 = (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);

    wire brick_51 = (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);
    wire brick_52 = (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);
    wire brick_53 = (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);
    wire brick_54 = (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);
    wire brick_55 = (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);
    wire brick_56 = (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);
    wire brick_57 = (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);
    wire brick_58 = (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);
    wire brick_59 = (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);
    wire brick_60 = (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);

    wire brick_61 = (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);
    wire brick_62 = (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);
    wire brick_63 = (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);
    wire brick_64 = (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);
    wire brick_65 = (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);
    wire brick_66 = (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);
    wire brick_67 = (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);
    wire brick_68 = (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);
    wire brick_69 = (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);
    wire brick_70 = (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);

    wire brick_71 = (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);
    wire brick_72 = (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);
    wire brick_73 = (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);
    wire brick_74 = (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);
    wire brick_75 = (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);
    wire brick_76 = (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);
    wire brick_77 = (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);
    wire brick_78 = (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);
    wire brick_79 = (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);
    wire brick_80 = (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);

    wire brick_81 = (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);
    wire brick_82 = (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);
    wire brick_83 = (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);
    wire brick_84 = (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);
    wire brick_85 = (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);
    wire brick_86 = (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);
    wire brick_87 = (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);
    wire brick_88 = (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);
    wire brick_89 = (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);
    wire brick_90 = (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);

    wire brick_91 = (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);
    wire brick_92 = (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);
    wire brick_93 = (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);
    wire brick_94 = (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);
    wire brick_95 = (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);
    wire brick_96 = (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);
    wire brick_97 = (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);
    wire brick_98 = (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);
    wire brick_99 = (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);
    wire brick_100 = (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);

    wire brick_101 = (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);
    wire brick_102 = (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);
    wire brick_103 = (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);
    wire brick_104 = (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);
    wire brick_105 = (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);
    wire brick_106 = (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);
    wire brick_107 = (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);
    wire brick_108 = (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);
    wire brick_109 = (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);
    wire brick_110 = (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);

    wire brick_111 = (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);
    wire brick_112 = (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);
    wire brick_113 = (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);
    wire brick_114 = (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);
    wire brick_115 = (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);
    wire brick_116 = (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);
    wire brick_117 = (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);
    wire brick_118 = (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);
    wire brick_119 = (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);
    wire brick_120 = (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);

    wire brick_121 = (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    wire brick_122 = (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    wire brick_123 = (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    wire brick_124 = (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    wire brick_125 = (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    wire brick_126 = (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    wire brick_127 = (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    wire brick_128 = (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    wire brick_129 = (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    wire brick_130 = (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    ////////////////////////////////////////////////////////////// Brick //////////////////////////////////////////////////////////////
    
    wire paddle_collision = ball_x_pos >= board_x_curr - BOARD_WIDTH / 2 && ball_x_pos <= board_x_curr + BOARD_WIDTH / 2 && ball_y_pos >= board_y_pos && ball_y_pos <= board_y_pos + BOARD_HEIGHT;
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    always @ (posedge CLK) begin
        if (game_over) begin
            pixel_data <= over_data;
        end else if (win_game) begin
            pixel_data <= win_data;
        end else if (unlock) begin   
            case(current_state)
                BOUNCE_STOP:
                    // Do nothing
                    if (ball_move_counter == BALL_MOVE_DELAY) begin
                        ball_y_pos <= ball_y_pos;
                        ball_x_pos <= ball_x_pos;
                        ball_move_counter <= 0;
                    end else begin
                        ball_move_counter <= ball_move_counter + 1;
                    end  
                BOUNCE_UP: 
                    if (ball_move_counter == BALL_MOVE_DELAY) begin
                        ball_y_pos <= ball_y_pos - 1;
                        ball_move_counter <= 0;
                    end else begin
                        ball_move_counter <= ball_move_counter + 1;
                    end
                BOUNCE_DOWN: 
                    if (ball_move_counter == BALL_MOVE_DELAY) begin
                        ball_y_pos <= ball_y_pos + 1;
                        ball_move_counter <= 0;
                    end else begin
                        ball_move_counter <= ball_move_counter + 1;
                    end   
                BOUNCE_UP_LEFT:
                    if (ball_move_counter == BALL_MOVE_DELAY) begin
                        ball_x_pos <= ball_x_pos + 1;
                        ball_y_pos <= ball_y_pos - 1;
                        ball_move_counter <= 0;
                    end else begin
                        ball_move_counter <= ball_move_counter + 1;
                    end                    
                BOUNCE_DOWN_LEFT:
                    if (ball_move_counter == BALL_MOVE_DELAY) begin
                        ball_x_pos <= ball_x_pos + 1;
                        ball_y_pos <= ball_y_pos + 1;
                        ball_move_counter <= 0;
                    end else begin
                        ball_move_counter <= ball_move_counter + 1;
                    end 
                BOUNCE_DOWN_RIGHT:
                    if (ball_move_counter == BALL_MOVE_DELAY) begin
                        ball_x_pos <= ball_x_pos - 1;
                        ball_y_pos <= ball_y_pos + 1;
                        ball_move_counter <= 0;
                    end else begin
                        ball_move_counter <= ball_move_counter + 1;
                    end
                BOUNCE_UP_RIGHT:     
                    if (ball_move_counter == BALL_MOVE_DELAY) begin
                        ball_x_pos <= ball_x_pos - 1;
                        ball_y_pos <= ball_y_pos - 1;
                        ball_move_counter <= 0;
                    end else begin
                        ball_move_counter <= ball_move_counter + 1;
                    end    
            endcase
            
            
            if ((row > (board_x_curr -  BOARD_WIDTH / 2) && row <= (board_x_curr + BOARD_WIDTH / 2)) && (col > board_y_pos && col <= board_y_pos + BOARD_HEIGHT)) begin
                pixel_data <= BOARD_COLOUR;
            end else if (row > ball_x_pos - BALL_RADIUS && row <= ball_x_pos + BALL_RADIUS && col > ball_y_pos - BALL_RADIUS && col <= ball_y_pos + BALL_RADIUS) begin
                pixel_data <= BALL_COLOUR;
            end else if (brick_1 && brick_state[0] == 2'b11 || brick_2 && brick_state[1] == 2'b11 || brick_3 && brick_state[2] == 2'b11 || brick_4 && brick_state[3] == 2'b11 || brick_5 && brick_state[4] == 2'b11 || brick_6 && brick_state[5] == 2'b11 || brick_7 && brick_state[6] == 2'b11 || brick_8 && brick_state[7] == 2'b11 || brick_9 && brick_state[8] == 2'b11 || brick_10 && brick_state[9] == 2'b11 
            || brick_11 && brick_state[10] == 2'b11 || brick_12 && brick_state[11] == 2'b11 || brick_13 && brick_state[12] == 2'b11 || brick_14 && brick_state[13] == 2'b11 || brick_15 && brick_state[14] == 2'b11 || brick_16 && brick_state[15] == 2'b11 || brick_17 && brick_state[16] == 2'b11 || brick_18 && brick_state[17] == 2'b11 || brick_19 && brick_state[18] == 2'b11 || brick_20 && brick_state[19] == 2'b11
            || brick_21 && brick_state[20] == 2'b11 || brick_22 && brick_state[21] == 2'b11 || brick_23 && brick_state[22] == 2'b11 || brick_24 && brick_state[23] == 2'b11 || brick_25 && brick_state[24] == 2'b11 || brick_26 && brick_state[25] == 2'b11 || brick_27 && brick_state[26] == 2'b11 || brick_28 && brick_state[27] == 2'b11 || brick_29 && brick_state[28] == 2'b11 || brick_30 && brick_state[29] == 2'b11
            || brick_31 && brick_state[30] == 2'b11 || brick_32 && brick_state[31] == 2'b11 || brick_33 && brick_state[32] == 2'b11 || brick_34 && brick_state[33] == 2'b11 || brick_35 && brick_state[34] == 2'b11 || brick_36 && brick_state[35] == 2'b11 || brick_37 && brick_state[36] == 2'b11 || brick_38 && brick_state[37] == 2'b11 || brick_39 && brick_state[38] == 2'b11 || brick_40 && brick_state[39] == 2'b11 
            || brick_41 && brick_state[40] == 2'b11 || brick_42 && brick_state[41] == 2'b11 || brick_43 && brick_state[42] == 2'b11 || brick_44 && brick_state[43] == 2'b11 || brick_45 && brick_state[44] == 2'b11 || brick_46 && brick_state[45] == 2'b11 || brick_47 && brick_state[46] == 2'b11 || brick_48 && brick_state[47] == 2'b11 || brick_49 && brick_state[48] == 2'b11 || brick_50 && brick_state[49] == 2'b11 
            || brick_51 && brick_state[50] == 2'b11 || brick_52 && brick_state[51] == 2'b11 || brick_53 && brick_state[52] == 2'b11 || brick_54 && brick_state[53] == 2'b11 || brick_55 && brick_state[54] == 2'b11 || brick_56 && brick_state[55] == 2'b11 || brick_57 && brick_state[56] == 2'b11 || brick_58 && brick_state[57] == 2'b11 || brick_59 && brick_state[58] == 2'b11 || brick_60 && brick_state[59] == 2'b11 
            || brick_61 && brick_state[60] == 2'b11 || brick_62 && brick_state[61] == 2'b11 || brick_63 && brick_state[62] == 2'b11 || brick_64 && brick_state[63] == 2'b11 || brick_65 && brick_state[64] == 2'b11 || brick_66 && brick_state[65] == 2'b11 || brick_67 && brick_state[66] == 2'b11 || brick_68 && brick_state[67] == 2'b11 || brick_69 && brick_state[68] == 2'b11 || brick_70 && brick_state[69] == 2'b11 
            || brick_71 && brick_state[70] == 2'b11 || brick_72 && brick_state[71] == 2'b11 || brick_73 && brick_state[72] == 2'b11 || brick_74 && brick_state[73] == 2'b11 || brick_75 && brick_state[74] == 2'b11 || brick_76 && brick_state[75] == 2'b11 || brick_77 && brick_state[76] == 2'b11 || brick_78 && brick_state[77] == 2'b11 || brick_79 && brick_state[78] == 2'b11 || brick_80 && brick_state[79] == 2'b11 
            || brick_81 && brick_state[80] == 2'b11 || brick_82 && brick_state[81] == 2'b11 || brick_83 && brick_state[82] == 2'b11 || brick_84 && brick_state[83] == 2'b11 || brick_85 && brick_state[84] == 2'b11 || brick_86 && brick_state[85] == 2'b11 || brick_87 && brick_state[86] == 2'b11 || brick_88 && brick_state[87] == 2'b11 || brick_89 && brick_state[88] == 2'b11 || brick_90 && brick_state[89] == 2'b11 
            || brick_91 && brick_state[90] == 2'b11 || brick_92 && brick_state[91] == 2'b11 || brick_93 && brick_state[92] == 2'b11 || brick_94 && brick_state[93] == 2'b11 || brick_95 && brick_state[94] == 2'b11 || brick_96 && brick_state[95] == 2'b11 || brick_97 && brick_state[96] == 2'b11 || brick_98 && brick_state[97] == 2'b11 || brick_99 && brick_state[98] == 2'b11 || brick_100 && brick_state[99] == 2'b11 
            || brick_101 && brick_state[100] == 2'b11 || brick_102 && brick_state[101] == 2'b11 || brick_103 && brick_state[102] == 2'b11 || brick_104 && brick_state[103] == 2'b11 || brick_105 && brick_state[104] == 2'b11 || brick_106 && brick_state[105] == 2'b11 || brick_107 && brick_state[106] == 2'b11 || brick_108 && brick_state[107] == 2'b11 || brick_109 && brick_state[108] == 2'b11 || brick_110 && brick_state[109] == 2'b11 
            || brick_111 && brick_state[110] == 2'b11 || brick_112 && brick_state[111] == 2'b11 || brick_113 && brick_state[112] == 2'b11 || brick_114 && brick_state[113] == 2'b11 || brick_115 && brick_state[114] == 2'b11 || brick_116 && brick_state[115] == 2'b11 || brick_117 && brick_state[116] == 2'b11 || brick_118 && brick_state[117] == 2'b11 || brick_119 && brick_state[118] == 2'b11 || brick_120 && brick_state[119] == 2'b11 
            || brick_121 && brick_state[120] == 2'b11 || brick_122 && brick_state[121] == 2'b11 || brick_123 && brick_state[122] == 2'b11 || brick_124 && brick_state[123] == 2'b11 || brick_125 && brick_state[124] == 2'b11 || brick_126 && brick_state[125] == 2'b11 || brick_127 && brick_state[126] == 2'b11 || brick_128 && brick_state[127] == 2'b11 || brick_129 && brick_state[128] == 2'b11 || brick_130 && brick_state[129] == 2'b11 )
            begin
                pixel_data <= BRICK_COLOUR_3;
            end else if (brick_1 && brick_state[0] == 2'b10 || brick_2 && brick_state[1] == 2'b10 || brick_3 && brick_state[2] == 2'b10 || brick_4 && brick_state[3] == 2'b10 || brick_5 && brick_state[4] == 2'b10 || brick_6 && brick_state[5] == 2'b10 || brick_7 && brick_state[6] == 2'b10 || brick_8 && brick_state[7] == 2'b10 || brick_9 && brick_state[8] == 2'b10 || brick_10 && brick_state[9] == 2'b10 
            || brick_11 && brick_state[10] == 2'b10 || brick_12 && brick_state[11] == 2'b10 || brick_13 && brick_state[12] == 2'b10 || brick_14 && brick_state[13] == 2'b10 || brick_15 && brick_state[14] == 2'b10 || brick_16 && brick_state[15] == 2'b10 || brick_17 && brick_state[16] == 2'b10 || brick_18 && brick_state[17] == 2'b10 || brick_19 && brick_state[18] == 2'b10 || brick_20 && brick_state[19] == 2'b10
            || brick_21 && brick_state[20] == 2'b10 || brick_22 && brick_state[21] == 2'b10 || brick_23 && brick_state[22] == 2'b10 || brick_24 && brick_state[23] == 2'b10 || brick_25 && brick_state[24] == 2'b10 || brick_26 && brick_state[25] == 2'b10 || brick_27 && brick_state[26] == 2'b10 || brick_28 && brick_state[27] == 2'b10 || brick_29 && brick_state[28] == 2'b10 || brick_30 && brick_state[29] == 2'b10
            || brick_31 && brick_state[30] == 2'b10 || brick_32 && brick_state[31] == 2'b10 || brick_33 && brick_state[32] == 2'b10 || brick_34 && brick_state[33] == 2'b10 || brick_35 && brick_state[34] == 2'b10 || brick_36 && brick_state[35] == 2'b10 || brick_37 && brick_state[36] == 2'b10 || brick_38 && brick_state[37] == 2'b10 || brick_39 && brick_state[38] == 2'b10 || brick_40 && brick_state[39] == 2'b10 
            || brick_41 && brick_state[40] == 2'b10 || brick_42 && brick_state[41] == 2'b10 || brick_43 && brick_state[42] == 2'b10 || brick_44 && brick_state[43] == 2'b10 || brick_45 && brick_state[44] == 2'b10 || brick_46 && brick_state[45] == 2'b10 || brick_47 && brick_state[46] == 2'b10 || brick_48 && brick_state[47] == 2'b10 || brick_49 && brick_state[48] == 2'b10 || brick_50 && brick_state[49] == 2'b10 
            || brick_51 && brick_state[50] == 2'b10 || brick_52 && brick_state[51] == 2'b10 || brick_53 && brick_state[52] == 2'b10 || brick_54 && brick_state[53] == 2'b10 || brick_55 && brick_state[54] == 2'b10 || brick_56 && brick_state[55] == 2'b10 || brick_57 && brick_state[56] == 2'b10 || brick_58 && brick_state[57] == 2'b10 || brick_59 && brick_state[58] == 2'b10 || brick_60 && brick_state[59] == 2'b10 
            || brick_61 && brick_state[60] == 2'b10 || brick_62 && brick_state[61] == 2'b10 || brick_63 && brick_state[62] == 2'b10 || brick_64 && brick_state[63] == 2'b10 || brick_65 && brick_state[64] == 2'b10 || brick_66 && brick_state[65] == 2'b10 || brick_67 && brick_state[66] == 2'b10 || brick_68 && brick_state[67] == 2'b10 || brick_69 && brick_state[68] == 2'b10 || brick_70 && brick_state[69] == 2'b10 
            || brick_71 && brick_state[70] == 2'b10 || brick_72 && brick_state[71] == 2'b10 || brick_73 && brick_state[72] == 2'b10 || brick_74 && brick_state[73] == 2'b10 || brick_75 && brick_state[74] == 2'b10 || brick_76 && brick_state[75] == 2'b10 || brick_77 && brick_state[76] == 2'b10 || brick_78 && brick_state[77] == 2'b10 || brick_79 && brick_state[78] == 2'b10 || brick_80 && brick_state[79] == 2'b10 
            || brick_81 && brick_state[80] == 2'b10 || brick_82 && brick_state[81] == 2'b10 || brick_83 && brick_state[82] == 2'b10 || brick_84 && brick_state[83] == 2'b10 || brick_85 && brick_state[84] == 2'b10 || brick_86 && brick_state[85] == 2'b10 || brick_87 && brick_state[86] == 2'b10 || brick_88 && brick_state[87] == 2'b10 || brick_89 && brick_state[88] == 2'b10 || brick_90 && brick_state[89] == 2'b10 
            || brick_91 && brick_state[90] == 2'b10 || brick_92 && brick_state[91] == 2'b10 || brick_93 && brick_state[92] == 2'b10 || brick_94 && brick_state[93] == 2'b10 || brick_95 && brick_state[94] == 2'b10 || brick_96 && brick_state[95] == 2'b10 || brick_97 && brick_state[96] == 2'b10 || brick_98 && brick_state[97] == 2'b10 || brick_99 && brick_state[98] == 2'b10 || brick_100 && brick_state[99] == 2'b10 
            || brick_101 && brick_state[100] == 2'b10 || brick_102 && brick_state[101] == 2'b10 || brick_103 && brick_state[102] == 2'b10 || brick_104 && brick_state[103] == 2'b10 || brick_105 && brick_state[104] == 2'b10 || brick_106 && brick_state[105] == 2'b10 || brick_107 && brick_state[106] == 2'b10 || brick_108 && brick_state[107] == 2'b10 || brick_109 && brick_state[108] == 2'b10 || brick_110 && brick_state[109] == 2'b10 
            || brick_111 && brick_state[110] == 2'b10 || brick_112 && brick_state[111] == 2'b10 || brick_113 && brick_state[112] == 2'b10 || brick_114 && brick_state[113] == 2'b10 || brick_115 && brick_state[114] == 2'b10 || brick_116 && brick_state[115] == 2'b10 || brick_117 && brick_state[116] == 2'b10 || brick_118 && brick_state[117] == 2'b10 || brick_119 && brick_state[118] == 2'b10 || brick_120 && brick_state[119] == 2'b10 
            || brick_121 && brick_state[120] == 2'b10 || brick_122 && brick_state[121] == 2'b10 || brick_123 && brick_state[122] == 2'b10 || brick_124 && brick_state[123] == 2'b10 || brick_125 && brick_state[124] == 2'b10 || brick_126 && brick_state[125] == 2'b10 || brick_127 && brick_state[126] == 2'b10 || brick_128 && brick_state[127] == 2'b10 || brick_129 && brick_state[128] == 2'b10 || brick_130 && brick_state[129] == 2'b10 )
            begin
                pixel_data <= BRICK_COLOUR_2;
            end else if (brick_1 && brick_state[0] == 2'b01 || brick_2 && brick_state[1] == 2'b01 || brick_3 && brick_state[2] == 2'b01 || brick_4 && brick_state[3] == 2'b01 || brick_5 && brick_state[4] == 2'b01 || brick_6 && brick_state[5] == 2'b01 || brick_7 && brick_state[6] == 2'b01 || brick_8 && brick_state[7] == 2'b01 || brick_9 && brick_state[8] == 2'b01 || brick_10 && brick_state[9] == 2'b01 
            || brick_11 && brick_state[10] == 2'b01 || brick_12 && brick_state[11] == 2'b01 || brick_13 && brick_state[12] == 2'b01 || brick_14 && brick_state[13] == 2'b01 || brick_15 && brick_state[14] == 2'b01 || brick_16 && brick_state[15] == 2'b01 || brick_17 && brick_state[16] == 2'b01 || brick_18 && brick_state[17] == 2'b01 || brick_19 && brick_state[18] == 2'b01 || brick_20 && brick_state[19] == 2'b01
            || brick_21 && brick_state[20] == 2'b01 || brick_22 && brick_state[21] == 2'b01 || brick_23 && brick_state[22] == 2'b01 || brick_24 && brick_state[23] == 2'b01 || brick_25 && brick_state[24] == 2'b01 || brick_26 && brick_state[25] == 2'b01 || brick_27 && brick_state[26] == 2'b01 || brick_28 && brick_state[27] == 2'b01 || brick_29 && brick_state[28] == 2'b01 || brick_30 && brick_state[29] == 2'b01
            || brick_31 && brick_state[30] == 2'b01 || brick_32 && brick_state[31] == 2'b01 || brick_33 && brick_state[32] == 2'b01 || brick_34 && brick_state[33] == 2'b01 || brick_35 && brick_state[34] == 2'b01 || brick_36 && brick_state[35] == 2'b01 || brick_37 && brick_state[36] == 2'b01 || brick_38 && brick_state[37] == 2'b01 || brick_39 && brick_state[38] == 2'b01 || brick_40 && brick_state[39] == 2'b01 
            || brick_41 && brick_state[40] == 2'b01 || brick_42 && brick_state[41] == 2'b01 || brick_43 && brick_state[42] == 2'b01 || brick_44 && brick_state[43] == 2'b01 || brick_45 && brick_state[44] == 2'b01 || brick_46 && brick_state[45] == 2'b01 || brick_47 && brick_state[46] == 2'b01 || brick_48 && brick_state[47] == 2'b01 || brick_49 && brick_state[48] == 2'b01 || brick_50 && brick_state[49] == 2'b01 
            || brick_51 && brick_state[50] == 2'b01 || brick_52 && brick_state[51] == 2'b01 || brick_53 && brick_state[52] == 2'b01 || brick_54 && brick_state[53] == 2'b01 || brick_55 && brick_state[54] == 2'b01 || brick_56 && brick_state[55] == 2'b01 || brick_57 && brick_state[56] == 2'b01 || brick_58 && brick_state[57] == 2'b01 || brick_59 && brick_state[58] == 2'b01 || brick_60 && brick_state[59] == 2'b01 
            || brick_61 && brick_state[60] == 2'b01 || brick_62 && brick_state[61] == 2'b01 || brick_63 && brick_state[62] == 2'b01 || brick_64 && brick_state[63] == 2'b01 || brick_65 && brick_state[64] == 2'b01 || brick_66 && brick_state[65] == 2'b01 || brick_67 && brick_state[66] == 2'b01 || brick_68 && brick_state[67] == 2'b01 || brick_69 && brick_state[68] == 2'b01 || brick_70 && brick_state[69] == 2'b01 
            || brick_71 && brick_state[70] == 2'b01 || brick_72 && brick_state[71] == 2'b01 || brick_73 && brick_state[72] == 2'b01 || brick_74 && brick_state[73] == 2'b01 || brick_75 && brick_state[74] == 2'b01 || brick_76 && brick_state[75] == 2'b01 || brick_77 && brick_state[76] == 2'b01 || brick_78 && brick_state[77] == 2'b01 || brick_79 && brick_state[78] == 2'b01 || brick_80 && brick_state[79] == 2'b01 
            || brick_81 && brick_state[80] == 2'b01 || brick_82 && brick_state[81] == 2'b01 || brick_83 && brick_state[82] == 2'b01 || brick_84 && brick_state[83] == 2'b01 || brick_85 && brick_state[84] == 2'b01 || brick_86 && brick_state[85] == 2'b01 || brick_87 && brick_state[86] == 2'b01 || brick_88 && brick_state[87] == 2'b01 || brick_89 && brick_state[88] == 2'b01 || brick_90 && brick_state[89] == 2'b01 
            || brick_91 && brick_state[90] == 2'b01 || brick_92 && brick_state[91] == 2'b01 || brick_93 && brick_state[92] == 2'b01 || brick_94 && brick_state[93] == 2'b01 || brick_95 && brick_state[94] == 2'b01 || brick_96 && brick_state[95] == 2'b01 || brick_97 && brick_state[96] == 2'b01 || brick_98 && brick_state[97] == 2'b01 || brick_99 && brick_state[98] == 2'b01 || brick_100 && brick_state[99] == 2'b01 
            || brick_101 && brick_state[100] == 2'b01 || brick_102 && brick_state[101] == 2'b01 || brick_103 && brick_state[102] == 2'b01 || brick_104 && brick_state[103] == 2'b01 || brick_105 && brick_state[104] == 2'b01 || brick_106 && brick_state[105] == 2'b01 || brick_107 && brick_state[106] == 2'b01 || brick_108 && brick_state[107] == 2'b01 || brick_109 && brick_state[108] == 2'b01 || brick_110 && brick_state[109] == 2'b01 
            || brick_111 && brick_state[110] == 2'b01 || brick_112 && brick_state[111] == 2'b01 || brick_113 && brick_state[112] == 2'b01 || brick_114 && brick_state[113] == 2'b01 || brick_115 && brick_state[114] == 2'b01 || brick_116 && brick_state[115] == 2'b01 || brick_117 && brick_state[116] == 2'b01 || brick_118 && brick_state[117] == 2'b01 || brick_119 && brick_state[118] == 2'b01 || brick_120 && brick_state[119] == 2'b01 
            || brick_121 && brick_state[120] == 2'b01 || brick_122 && brick_state[121] == 2'b01 || brick_123 && brick_state[122] == 2'b01 || brick_124 && brick_state[123] == 2'b01 || brick_125 && brick_state[124] == 2'b01 || brick_126 && brick_state[125] == 2'b01 || brick_127 && brick_state[126] == 2'b01 || brick_128 && brick_state[127] == 2'b01 || brick_129 && brick_state[128] == 2'b01 || brick_130 && brick_state[129] == 2'b01 )
            begin
                pixel_data <= BRICK_COLOUR_1;
            end else begin
                pixel_data <= BLACK;
            end
        // Before game starts, display welcome screen
        // Reset when unlock is false
        end else if (!unlock && !game_over) begin
            ball_x_pos <= 12'd32;
            ball_y_pos <= 12'd65;
            if (game_level == 1'b0) begin
                pixel_data <= screen1_data;
                brick_state_chosen <= brick_state_1;
            end else if (game_level == 1'b1) begin
                pixel_data <= screen2_data;
                brick_state_chosen <= brick_state_2;
            end
        end
    end
    
    // Bouncing logic
    integer i, j, k;
    reg [3:0] brick_col, brick_row;
    always @ (posedge CLK) begin
        if (unlock) begin
            if (current_state == BOUNCE_STOP) begin
                if (ball_start_counter == BALL_START_DELAY) begin
                    current_state <= BOUNCE_DOWN;
                    // Turn 7 seg off once ball drop
                    seg <= 7'b1111111;
                    an <= 4'b1111;
                    ball_start_counter <= 32'd0;
                end else begin
                    ball_start_counter <= ball_start_counter + 1;
                    if (ball_start_counter == 0) begin
                        // Countdown set to '3'
                        seg <= seg_3;
                        an <= 4'b1110;
                    end else if (ball_start_counter == 32'd100000000) begin
                        // countdown set to "2"
                        seg <= seg_2;
                        an <= 4'b1110;
                    end else if (ball_start_counter == 32'd200000000) begin
                        // countdown set to "1"
                        seg <= seg_1;
                        an <= 4'b1110;
                    end
                end
            end else if (current_state == BOUNCE_UP) begin
                if (ball_y_pos <= BOUNDARY_TOP) begin
                    current_state <= BOUNCE_DOWN;
                end else begin
                    for (i = 0; i < N_BRICKS; i = i + 1) begin
                        brick_col = i % 10;
                        brick_row = i / 10;
                        if (brick_state[i] && ((ball_x_pos - 1 >= brick_row * BRICK_HEIGHT && ball_x_pos - 1 <= (brick_row + 1) * BRICK_HEIGHT - 1
                        || ball_x_pos + 1 >= brick_row * BRICK_HEIGHT && ball_x_pos + 1 <= (brick_row + 1) * BRICK_HEIGHT - 1) 
                        && ball_y_pos - 1 >= brick_col * BRICK_WIDTH && ball_y_pos - 1 <= (brick_col + 1) * BRICK_WIDTH - 1)) begin
                            brick_state[i] <= brick_state[i] - 1;
                            current_state <= BOUNCE_DOWN;
                        end
                    end
                end
            end else if (current_state == BOUNCE_DOWN) begin
                if (ball_y_pos >= BOUNDARY_BOTTOM) begin
                    game_over <= 1'b1;
                end else if (paddle_collision) begin
                    if (board_x_curr - board_x_prev > 0) begin
                        current_state <= BOUNCE_UP_LEFT;
                    end else if (board_x_curr - board_x_prev < 0) begin
                        current_state <= BOUNCE_UP_RIGHT;
                    end else begin
                        current_state <= BOUNCE_UP;
                    end
                end else begin
                    for (i = 0; i < N_BRICKS; i = i + 1) begin
                        brick_col = i % 10;
                        brick_row = i / 10;
                        if (brick_state[i] && ((ball_x_pos - 1 >= brick_row * BRICK_HEIGHT && ball_x_pos - 1 <= (brick_row + 1) * BRICK_HEIGHT - 1 
                        || ball_x_pos + 1 >= brick_row * BRICK_HEIGHT && ball_x_pos + 1 <= (brick_row + 1) * BRICK_HEIGHT - 1)
                        && ball_y_pos + 1 >= brick_col * BRICK_WIDTH && ball_y_pos + 1 <= (brick_col + 1) * BRICK_WIDTH - 1)) begin
                            brick_state[i] <= brick_state[i] - 1;
                            current_state <= BOUNCE_UP;
                        end
                    end
                end
            end else if (current_state == BOUNCE_UP_LEFT) begin
                if (ball_x_pos >= BOUNDARY_LEFT && ball_y_pos <= BOUNDARY_TOP) begin
                    current_state <= BOUNCE_DOWN_RIGHT;
                end else if (ball_x_pos >= BOUNDARY_LEFT) begin
                    current_state <= BOUNCE_UP_RIGHT;
                end else if (ball_y_pos <= BOUNDARY_TOP) begin
                    current_state <= BOUNCE_DOWN_LEFT;
                end else begin
                    for (i = 0; i < N_BRICKS; i = i + 1) begin
                        brick_col = i % 10;
                        brick_row = i / 10;
                        if (brick_state[i] && ((ball_x_pos - 1 >= brick_row * BRICK_HEIGHT && ball_x_pos - 1<= (brick_row + 1) * BRICK_HEIGHT - 1
                        || ball_x_pos + 1 >= brick_row * BRICK_HEIGHT && ball_x_pos + 1 <= (brick_row + 1) * BRICK_HEIGHT - 1) 
                        && ball_y_pos - 1 >= brick_col * BRICK_WIDTH && ball_y_pos - 1 <= (brick_col + 1) * BRICK_WIDTH - 1)) begin
                            brick_state[i] <= brick_state[i] - 1;
                            current_state <= BOUNCE_DOWN_LEFT;
                        end else if (brick_state[i] && (ball_x_pos + 1 >= brick_row * BRICK_HEIGHT && ball_x_pos + 1 <= (brick_row + 1) * BRICK_HEIGHT - 1 
                        && (ball_y_pos - 1 >= brick_col * BRICK_WIDTH && ball_y_pos - 1 <= (brick_col + 1) * BRICK_WIDTH - 1
                        || ball_y_pos + 1 >= brick_col * BRICK_WIDTH && ball_y_pos + 1 <= (brick_col + 1) * BRICK_WIDTH - 1))) begin
                            brick_state[i] <= brick_state[i] - 1;
                            current_state <= BOUNCE_UP_RIGHT;
                        end
                    end
                end
            end else if (current_state == BOUNCE_DOWN_LEFT) begin
                if (ball_y_pos >= BOUNDARY_BOTTOM) begin
                    game_over = 1'b1;
                end else if (ball_x_pos >= BOUNDARY_LEFT) begin
                    current_state <= BOUNCE_DOWN_RIGHT;
                end else if (paddle_collision) begin
                    if (board_x_curr - board_x_prev > 0) begin
                        current_state <= BOUNCE_UP;
                    end else if (board_x_curr - board_x_prev < 0) begin
                        current_state <= BOUNCE_UP_RIGHT;
                    end else begin
                        current_state <= BOUNCE_UP_LEFT;
                    end
                end else begin
                    for (i = 0; i < N_BRICKS; i = i + 1) begin
                        brick_col = i % 10;
                        brick_row = i / 10;
                        if (brick_state[i] && ((ball_x_pos - 1 >= brick_row * BRICK_HEIGHT && ball_x_pos - 1 <= (brick_row + 1) * BRICK_HEIGHT - 1
                        || ball_x_pos + 1 >= brick_row * BRICK_HEIGHT && ball_x_pos + 1 <= (brick_row + 1) * BRICK_HEIGHT - 1 ) 
                        && ball_y_pos + 1 >= brick_col * BRICK_WIDTH && ball_y_pos + 1 <= (brick_col + 1) * BRICK_WIDTH - 1)) begin
                            brick_state[i] <= brick_state[i] - 1;
                            current_state <= BOUNCE_UP_LEFT;
                        end else if (brick_state[i] && (ball_x_pos + 1 >= brick_row * BRICK_HEIGHT && ball_x_pos + 1 <= (brick_row + 1) * BRICK_HEIGHT - 1 
                        && (ball_y_pos - 1 >= brick_col * BRICK_WIDTH && ball_y_pos - 1 <= (brick_col + 1) * BRICK_WIDTH - 1
                        || ball_y_pos + 1 >= brick_col * BRICK_WIDTH && ball_y_pos + 1 <= (brick_col + 1) * BRICK_WIDTH - 1))) begin
                            brick_state[i] <= brick_state[i] - 1;
                            current_state <= BOUNCE_DOWN_RIGHT;
                        end
                    end
                end
            end else if (current_state == BOUNCE_DOWN_RIGHT) begin
                if (ball_y_pos >= BOUNDARY_BOTTOM) begin
                    game_over = 1'b1;
                end else if (ball_x_pos <= BOUNDARY_RIGHT) begin
                    current_state <= BOUNCE_DOWN_LEFT;
                end else if (paddle_collision) begin
                    if (board_x_curr - board_x_prev > 0) begin
                        current_state <= BOUNCE_UP_LEFT;
                    end else if (board_x_curr - board_x_prev < 0) begin
                        current_state <= BOUNCE_UP;
                    end else begin
                        current_state <= BOUNCE_UP_RIGHT;
                    end
                end else begin
                    for (i = 0; i < N_BRICKS; i = i + 1) begin
                        brick_col = i % 10;
                        brick_row = i / 10;
                        if (brick_state[i] && ((ball_x_pos - 1 >= brick_row * BRICK_HEIGHT && ball_x_pos - 1 <= (brick_row + 1) * BRICK_HEIGHT - 1
                        || ball_x_pos + 1 >= brick_row * BRICK_HEIGHT && ball_x_pos + 1 <= (brick_row + 1) * BRICK_HEIGHT - 1) 
                        && ball_y_pos + 1 >= brick_col * BRICK_WIDTH && ball_y_pos + 1 <= (brick_col + 1) * BRICK_WIDTH - 1)) begin
                            brick_state[i] <= brick_state[i] - 1;
                            current_state <= BOUNCE_UP_RIGHT;
                        end else if (brick_state[i] && (ball_x_pos - 1 >= brick_row * BRICK_HEIGHT && ball_x_pos - 1 <= (brick_row + 1) * BRICK_HEIGHT - 1 
                        && (ball_y_pos - 1 >= brick_col * BRICK_WIDTH && ball_y_pos - 1 <= (brick_col + 1) * BRICK_WIDTH - 1
                        || ball_y_pos + 1 >= brick_col * BRICK_WIDTH && ball_y_pos + 1 <= (brick_col + 1) * BRICK_WIDTH - 1))) begin
                            brick_state[i] <= brick_state[i] - 1;
                            current_state <= BOUNCE_DOWN_LEFT;
                        end
                    end
                end
            end else if (current_state == BOUNCE_UP_RIGHT) begin
                if (ball_x_pos <= BOUNDARY_RIGHT && ball_y_pos <= BOUNDARY_TOP) begin
                    current_state <= BOUNCE_DOWN_LEFT;
                end else if (ball_x_pos <= BOUNDARY_RIGHT) begin
                    current_state <= BOUNCE_UP_LEFT;
                end else if (ball_y_pos <= BOUNDARY_TOP) begin
                    current_state <= BOUNCE_DOWN_RIGHT;
                end else begin
                    for (i = 0; i < N_BRICKS; i = i + 1) begin
                        brick_col = i % 10;
                        brick_row = i / 10;
                        if (brick_state[i] && ((ball_x_pos - 1 >= brick_row * BRICK_HEIGHT && ball_x_pos - 1 <= (brick_row + 1) * BRICK_HEIGHT - 1
                        || ball_x_pos + 1 >= brick_row * BRICK_HEIGHT && ball_x_pos + 1 <= (brick_row + 1) * BRICK_HEIGHT - 1) 
                        && ball_y_pos - 1 >= brick_col * BRICK_WIDTH && ball_y_pos - 1 <= (brick_col + 1) * BRICK_WIDTH - 1)) begin
                            brick_state[i] <= brick_state[i] - 1;
                            current_state <= BOUNCE_DOWN_RIGHT;
                        end else if (brick_state[i] && (ball_x_pos - 1 >= brick_row * BRICK_HEIGHT && ball_x_pos - 1 <= (brick_row + 1) * BRICK_HEIGHT - 1 
                        && (ball_y_pos - 1 >= brick_col * BRICK_WIDTH && ball_y_pos - 1 <= (brick_col + 1) * BRICK_WIDTH - 1
                        || ball_y_pos + 1 >= brick_col * BRICK_WIDTH && ball_y_pos + 1 <= (brick_col + 1) * BRICK_WIDTH - 1))) begin
                            brick_state[i] <= brick_state[i] - 1;
                            current_state <= BOUNCE_UP_LEFT;
                        end
                    end
                end
            end
        
            if (!brick_state[0] && !brick_state[1] && !brick_state[2] && !brick_state[3] && !brick_state[4] && !brick_state[5] && !brick_state[6] && !brick_state[7] && !brick_state[8] && !brick_state[9]
            && !brick_state[10] && !brick_state[11] && !brick_state[12] && !brick_state[13] && !brick_state[14] && !brick_state[15] && !brick_state[16] && !brick_state[17] && !brick_state[18] && !brick_state[19]
            && !brick_state[20] && !brick_state[21] && !brick_state[22] && !brick_state[23] && !brick_state[24] && !brick_state[25] && !brick_state[26] && !brick_state[27] && !brick_state[28] && !brick_state[29]
            && !brick_state[30] && !brick_state[31] && !brick_state[32] && !brick_state[33] && !brick_state[34] && !brick_state[35] && !brick_state[36] && !brick_state[37] && !brick_state[38] && !brick_state[39]
            && !brick_state[40] && !brick_state[41] && !brick_state[42] && !brick_state[43] && !brick_state[44] && !brick_state[45] && !brick_state[46] && !brick_state[47] && !brick_state[48] && !brick_state[49]
            && !brick_state[50] && !brick_state[51] && !brick_state[52] && !brick_state[53] && !brick_state[54] && !brick_state[55] && !brick_state[56] && !brick_state[57] && !brick_state[58] && !brick_state[59]
            && !brick_state[60] && !brick_state[61] && !brick_state[62] && !brick_state[63] && !brick_state[64] && !brick_state[65] && !brick_state[66] && !brick_state[67] && !brick_state[68] && !brick_state[69]
            && !brick_state[70] && !brick_state[71] && !brick_state[72] && !brick_state[73] && !brick_state[74] && !brick_state[75] && !brick_state[76] && !brick_state[77] && !brick_state[78] && !brick_state[19]
            && !brick_state[80] && !brick_state[81] && !brick_state[82] && !brick_state[83] && !brick_state[84] && !brick_state[85] && !brick_state[86] && !brick_state[87] && !brick_state[88] && !brick_state[19]
            && !brick_state[90] && !brick_state[91] && !brick_state[92] && !brick_state[93] && !brick_state[94] && !brick_state[95] && !brick_state[96] && !brick_state[97] && !brick_state[98] && !brick_state[19]
            && !brick_state[100] && !brick_state[101] && !brick_state[102] && !brick_state[103] && !brick_state[104] && !brick_state[105] && !brick_state[106] && !brick_state[107] && !brick_state[108] && !brick_state[19]
            && !brick_state[110] && !brick_state[111] && !brick_state[112] && !brick_state[113] && !brick_state[114] && !brick_state[115] && !brick_state[116] && !brick_state[117] && !brick_state[118] && !brick_state[19]
            && !brick_state[120] && !brick_state[121] && !brick_state[122] && !brick_state[123] && !brick_state[124] && !brick_state[125] && !brick_state[126] && !brick_state[127] && !brick_state[128] && !brick_state[19]) begin
                win_game <= 1'b1;
            end
        // Reset when unlock is false
        end else begin
            for (k = 0; k < N_BRICKS; k = k + 1) begin
                brick_state[0] <= brick_state_chosen[1:0];
                brick_state[1] <= brick_state_chosen[3:2];
                brick_state[2] <= brick_state_chosen[5:4];
                brick_state[3] <= brick_state_chosen[7:6];
                brick_state[4] <= brick_state_chosen[9:8];
                brick_state[5] <= brick_state_chosen[11:10];
                brick_state[6] <= brick_state_chosen[13:12];
                brick_state[7] <= brick_state_chosen[15:14];
                brick_state[8] <= brick_state_chosen[17:16];
                brick_state[9] <= brick_state_chosen[19:18];
                brick_state[10] <= brick_state_chosen[21:20];
                brick_state[11] <= brick_state_chosen[23:22];
                brick_state[12] <= brick_state_chosen[25:24];
                brick_state[13] <= brick_state_chosen[27:26];
                brick_state[14] <= brick_state_chosen[29:28];
                brick_state[15] <= brick_state_chosen[31:30];
                brick_state[16] <= brick_state_chosen[33:32];
                brick_state[17] <= brick_state_chosen[35:34];
                brick_state[18] <= brick_state_chosen[37:36];
                brick_state[19] <= brick_state_chosen[39:38];          
                brick_state[20] <= brick_state_chosen[41:40];
                brick_state[21] <= brick_state_chosen[43:42];
                brick_state[22] <= brick_state_chosen[45:44];
                brick_state[23] <= brick_state_chosen[47:46];
                brick_state[24] <= brick_state_chosen[49:48];
                brick_state[25] <= brick_state_chosen[51:50];
                brick_state[26] <= brick_state_chosen[53:52];
                brick_state[27] <= brick_state_chosen[55:54];
                brick_state[28] <= brick_state_chosen[57:56];
                brick_state[29] <= brick_state_chosen[59:58];
                brick_state[30] <= brick_state_chosen[61:60];
                brick_state[31] <= brick_state_chosen[63:62];
                brick_state[32] <= brick_state_chosen[65:64];
                brick_state[33] <= brick_state_chosen[67:66];
                brick_state[34] <= brick_state_chosen[69:68];
                brick_state[35] <= brick_state_chosen[71:70];
                brick_state[36] <= brick_state_chosen[73:72];
                brick_state[37] <= brick_state_chosen[75:74];
                brick_state[38] <= brick_state_chosen[77:76];
                brick_state[39] <= brick_state_chosen[79:78];
                brick_state[40] <= brick_state_chosen[81:80];
                brick_state[41] <= brick_state_chosen[83:82];
                brick_state[42] <= brick_state_chosen[85:84];
                brick_state[43] <= brick_state_chosen[87:86];
                brick_state[44] <= brick_state_chosen[89:88];
                brick_state[45] <= brick_state_chosen[91:90];
                brick_state[46] <= brick_state_chosen[93:92];
                brick_state[47] <= brick_state_chosen[95:94];
                brick_state[48] <= brick_state_chosen[97:96];
                brick_state[49] <= brick_state_chosen[99:98];
                brick_state[50] <= brick_state_chosen[101:100];
                brick_state[51] <= brick_state_chosen[103:102];
                brick_state[52] <= brick_state_chosen[105:104];
                brick_state[53] <= brick_state_chosen[107:106];
                brick_state[54] <= brick_state_chosen[109:108];
                brick_state[55] <= brick_state_chosen[111:110];
                brick_state[56] <= brick_state_chosen[113:112];
                brick_state[57] <= brick_state_chosen[115:114];
                brick_state[58] <= brick_state_chosen[117:116];
                brick_state[59] <= brick_state_chosen[119:118];
                brick_state[60] <= brick_state_chosen[121:120];
                brick_state[61] <= brick_state_chosen[123:122];
                brick_state[62] <= brick_state_chosen[125:124];
                brick_state[63] <= brick_state_chosen[127:126];
                brick_state[64] <= brick_state_chosen[129:128];
                brick_state[65] <= brick_state_chosen[131:130];
                brick_state[66] <= brick_state_chosen[133:132];
                brick_state[67] <= brick_state_chosen[135:134];
                brick_state[68] <= brick_state_chosen[137:136];
                brick_state[69] <= brick_state_chosen[139:138];
                brick_state[70] <= brick_state_chosen[141:140];
                brick_state[71] <= brick_state_chosen[143:142];
                brick_state[72] <= brick_state_chosen[145:144];
                brick_state[73] <= brick_state_chosen[147:146];
                brick_state[74] <= brick_state_chosen[149:148];
                brick_state[75] <= brick_state_chosen[151:150];
                brick_state[76] <= brick_state_chosen[153:152];
                brick_state[77] <= brick_state_chosen[155:154];
                brick_state[78] <= brick_state_chosen[157:156];
                brick_state[79] <= brick_state_chosen[159:158];
                brick_state[80] <= brick_state_chosen[161:160];
                brick_state[81] <= brick_state_chosen[163:162];
                brick_state[82] <= brick_state_chosen[165:164];
                brick_state[83] <= brick_state_chosen[167:166];
                brick_state[84] <= brick_state_chosen[169:168];
                brick_state[85] <= brick_state_chosen[171:170];
                brick_state[86] <= brick_state_chosen[173:172];
                brick_state[87] <= brick_state_chosen[175:174];
                brick_state[88] <= brick_state_chosen[177:176];
                brick_state[89] <= brick_state_chosen[179:178];
                brick_state[90] <= brick_state_chosen[181:180];
                brick_state[91] <= brick_state_chosen[183:182];
                brick_state[92] <= brick_state_chosen[185:184];
                brick_state[93] <= brick_state_chosen[187:186];
                brick_state[94] <= brick_state_chosen[189:188];
                brick_state[95] <= brick_state_chosen[191:190];
                brick_state[96] <= brick_state_chosen[193:192];
                brick_state[97] <= brick_state_chosen[195:194];
                brick_state[98] <= brick_state_chosen[197:196];
                brick_state[99] <= brick_state_chosen[199:198];
                brick_state[100] <= brick_state_chosen[201:200];
                brick_state[101] <= brick_state_chosen[203:202];
                brick_state[102] <= brick_state_chosen[205:204];
                brick_state[103] <= brick_state_chosen[207:206];
                brick_state[104] <= brick_state_chosen[209:208];
                brick_state[105] <= brick_state_chosen[211:210];
                brick_state[106] <= brick_state_chosen[213:212];
                brick_state[107] <= brick_state_chosen[215:214];
                brick_state[108] <= brick_state_chosen[217:216];
                brick_state[109] <= brick_state_chosen[219:218];
                brick_state[110] <= brick_state_chosen[221:220];
                brick_state[111] <= brick_state_chosen[223:222];
                brick_state[112] <= brick_state_chosen[225:224];
                brick_state[113] <= brick_state_chosen[227:226];
                brick_state[114] <= brick_state_chosen[229:228];
                brick_state[115] <= brick_state_chosen[231:230];
                brick_state[116] <= brick_state_chosen[233:232];
                brick_state[117] <= brick_state_chosen[235:234];
                brick_state[118] <= brick_state_chosen[237:236];
                brick_state[119] <= brick_state_chosen[239:238];
                brick_state[120] <= brick_state_chosen[241:240];
                brick_state[121] <= brick_state_chosen[243:242];
                brick_state[122] <= brick_state_chosen[245:244];
                brick_state[123] <= brick_state_chosen[247:246];
                brick_state[124] <= brick_state_chosen[249:248];
                brick_state[125] <= brick_state_chosen[251:250];
                brick_state[126] <= brick_state_chosen[253:252];
                brick_state[127] <= brick_state_chosen[255:254];
                brick_state[128] <= brick_state_chosen[257:256];
                brick_state[129] <= brick_state_chosen[259:258];
            end
            current_state <= BOUNCE_STOP;
        end
        
        if (game_over) begin
            if (reset_counter == RESET_COUNT) begin
                // Reset states
                game_over <= 1'b0;
                unlock <= 1'b0;
                game_level <= 1'b0;
                
                reset_counter <= 32'd0;
            end else begin
                reset_counter <= reset_counter + 1;
            end
        end else if (win_game) begin
            if (reset_counter == RESET_COUNT) begin
                // Reset states
                win_game <= 1'b0;
                unlock <= 1'b0;
                     
                reset_counter <= 32'd0;
            end else begin
                reset_counter <= reset_counter + 1;
            end
        end
        
        if (btnC && !game_over) begin
            unlock <= 1'b1;
        end
        
        if (btnL && !unlock) begin
            game_level <= (game_level == 1'b0) ? game_level : game_level + 1;
        end else if (btnR && !unlock) begin
            game_level <= (game_level == 1'b1) ? game_level : game_level - 1;
        end
    end
    
    // Control board movement
    always @ (posedge CLK) begin
        if (unlock) begin
            if (bounce_counter > 0) begin
                bounce_counter <= bounce_counter - 1;
            end else if (bounce_counter == 0) begin
                bounce_counter <= BOUNCE_TIME;
                if (btnU) begin
                    board_x_prev <= board_x_curr;
                    board_x_curr <= (board_x_curr - 5 < BOARD_WIDTH / 2) ? BOARD_WIDTH / 2 : board_x_curr - 5;
                end else if (btnD) begin
                    board_x_prev <= board_x_curr;
                    board_x_curr <= (board_x_curr + 5 > SCREEN_HEIGHT - BOARD_WIDTH / 2 ) ? SCREEN_HEIGHT - BOARD_WIDTH / 2 : board_x_curr + 5;
                end else begin
                    board_x_prev <= board_x_curr;
                end                
            end
        // Reset when unlock is false
        end else begin
            board_x_curr <= 12'd32;
            board_x_prev <= 12'd32;
        end
    end
        
    // Instantiate Oled display to display either green or red depending on sw4
    Oled_Display oled (
        .clk(CLK_6P25M), 
        .pixel_index(pixel_index), 
        .pixel_data(pixel_data), 
        .reset(0), 
        .cs(JC[0]), 
        .sdin(JC[1]),
        .sclk(JC[3]), 
        .d_cn(JC[4]), 
        .resn(JC[5]), 
        .vccen(JC[6]), 
        .pmoden(JC[7])
    );
    
    // Oled data for welcome lvl 2 screen
     BrickBreaker_display loadScreen (pixel_index, screen1_data);
     
    // Oled data for welcome lvl 2 screen
    BrickBreaker_display2 load2Screen (pixel_index, screen2_data);
    
    // Oled data for game over screen
    BrickBreaker_gameOver gameOverScreen (pixel_index, over_data);
    
    // Oled data for win screen
    BrickBreaker_winScreen winScreen (pixel_index, win_data);
    
    // Game display for level 1
    BrickBreaker_level1 brick_setting_1 (.brick_state(brick_state_1));
    
    // Game display for level 2
    BrickBreaker_level2 brick_setting_2 (.brick_state(brick_state_2));
endmodule