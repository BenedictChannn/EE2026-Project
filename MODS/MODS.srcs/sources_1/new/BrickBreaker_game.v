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
    input CLK, btnU, btnD, btnC, btnR,
    output [7:0] JC,
    inout PS2Clk, PS2Data
    );
    
    // Debouncing
    parameter BOUNCE_TIME = 32'd15000000;
    reg [31:0] bounce_counter = 32'd0;
    
    // Boundaries
    parameter BOTTOM = 95;
    
    // OLED
    parameter SCREEN_WIDTH = 96;
    parameter SCREEN_HEIGHT = 64;
    reg unlock = 1'b0;
    reg game_over = 1'b0;
    
    // Colours
    parameter WHITE = 16'hFFFF;
    parameter BLACK = 16'h0000;
    parameter RED = 16'hF800;
    parameter GREEN = 16'h07E0;
    
    // Board
    parameter BOARD_WIDTH = 16;
    parameter BOARD_HEIGHT = 3;
    parameter BOARD_COLOUR = WHITE;
    reg [11:0] board_x_pos = 12'd32;
    reg [11:0] board_y_pos = 12'd87;
    
    // Brick
    parameter BRICK_WIDTH = 5;
    parameter BRICK_HEIGHT = 5;
    parameter BRICK_COLOUR = GREEN;
    parameter N_BRICKS = 130;
    reg [129:0] brick_state = {N_BRICKS{1'b1}};
    
    // Ball movement
    reg [11:0] ball_x_pos = 12'd32;
    reg [11:0] ball_y_pos = 12'd65;
    reg [1:0] current_state = BOUNCE_DOWN;
    reg [1:0] next_state;
    reg [31:0] ball_move_counter = 32'd0;
    parameter BALL_MOVE_DELAY = 32'd3000000;
    parameter BALL_COLOUR = RED;
    parameter BALL_RADIUS = 1;
    parameter BOUNCE_UP = 1;
    parameter BOUNCE_DOWN = 2;
    
    parameter DELTA_Y = 3;
    
    wire [12:0] pixel_index;
    reg [15:0] pixel_data;
    wire [15:0] screen_data;
    wire [15:0] over_data;
    
    //wire [11:0] mouse_x_pos, mouse_y_pos;
    wire [6:0] col, row;
    
    assign col = pixel_index % SCREEN_WIDTH;
    assign row = pixel_index / SCREEN_WIDTH;
    
    clk6p25m clk625 (CLK, CLK_6P25M);
    
    ///////////////////////////////////////////////////////////// Brick /////////////////////////////////////////////////////////////
    wire brick_1 = brick_state[0] && (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    wire brick_2 = brick_state[1] && (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    wire brick_3 = brick_state[2] && (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    wire brick_4 = brick_state[3] && (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    wire brick_5 = brick_state[4] && (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    wire brick_6 = brick_state[5] && (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    wire brick_7 = brick_state[6] && (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    wire brick_8 = brick_state[7] && (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    wire brick_9 = brick_state[8] && (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    wire brick_10 = brick_state[9] && (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 0 * BRICK_HEIGHT && row < 1 * BRICK_HEIGHT - 1);
    
    wire brick_11 = brick_state[10] && (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT  - 1);
    wire brick_12 = brick_state[11] && (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT - 1);
    wire brick_13 = brick_state[12] && (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT - 1);
    wire brick_14 = brick_state[13] && (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT - 1);
    wire brick_15 = brick_state[14] && (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT - 1);
    wire brick_16 = brick_state[15] && (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT - 1);
    wire brick_17 = brick_state[16] && (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT - 1);
    wire brick_18 = brick_state[17] && (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT - 1);
    wire brick_19 = brick_state[18] && (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT - 1);
    wire brick_20 = brick_state[19] && (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 1 * BRICK_HEIGHT && row < 2 * BRICK_HEIGHT - 1);
    
    wire brick_21 = brick_state[20] && (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    wire brick_22 = brick_state[21] && (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    wire brick_23 = brick_state[22] && (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    wire brick_24 = brick_state[23] && (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    wire brick_25 = brick_state[24] && (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    wire brick_26 = brick_state[25] && (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    wire brick_27 = brick_state[26] && (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    wire brick_28 = brick_state[27] && (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    wire brick_29 = brick_state[28] && (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    wire brick_30 = brick_state[29] && (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 2 * BRICK_HEIGHT && row < 3 * BRICK_HEIGHT - 1);
    
    wire brick_31 = brick_state[30] && (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    wire brick_32 = brick_state[31] && (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    wire brick_33 = brick_state[32] && (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    wire brick_34 = brick_state[33] && (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    wire brick_35 = brick_state[34] && (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    wire brick_36 = brick_state[35] && (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    wire brick_37 = brick_state[36] && (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    wire brick_38 = brick_state[37] && (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    wire brick_39 = brick_state[38] && (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    wire brick_40 = brick_state[39] && (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 3 * BRICK_HEIGHT && row < 4 * BRICK_HEIGHT - 1);
    
    wire brick_41 = brick_state[40] && (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);
    wire brick_42 = brick_state[41] && (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);
    wire brick_43 = brick_state[42] && (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);
    wire brick_44 = brick_state[43] && (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);
    wire brick_45 = brick_state[44] && (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);
    wire brick_46 = brick_state[45] && (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);
    wire brick_47 = brick_state[46] && (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);
    wire brick_48 = brick_state[47] && (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);
    wire brick_49 = brick_state[48] && (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);
    wire brick_50 = brick_state[49] && (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 4 * BRICK_HEIGHT && row < 5 * BRICK_HEIGHT - 1);

    wire brick_51 = brick_state[50] && (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);
    wire brick_52 = brick_state[51] && (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);
    wire brick_53 = brick_state[52] && (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);
    wire brick_54 = brick_state[53] && (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);
    wire brick_55 = brick_state[54] && (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);
    wire brick_56 = brick_state[55] && (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);
    wire brick_57 = brick_state[56] && (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);
    wire brick_58 = brick_state[57] && (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);
    wire brick_59 = brick_state[58] && (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);
    wire brick_60 = brick_state[59] && (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 5 * BRICK_HEIGHT && row < 6 * BRICK_HEIGHT - 1);

    wire brick_61 = brick_state[60] && (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);
    wire brick_62 = brick_state[61] && (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);
    wire brick_63 = brick_state[62] && (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);
    wire brick_64 = brick_state[63] && (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);
    wire brick_65 = brick_state[64] && (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);
    wire brick_66 = brick_state[65] && (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);
    wire brick_67 = brick_state[66] && (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);
    wire brick_68 = brick_state[67] && (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);
    wire brick_69 = brick_state[68] && (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);
    wire brick_70 = brick_state[69] && (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 6 * BRICK_HEIGHT && row < 7 * BRICK_HEIGHT - 1);

    wire brick_71 = brick_state[70] && (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);
    wire brick_72 = brick_state[71] && (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);
    wire brick_73 = brick_state[72] && (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);
    wire brick_74 = brick_state[73] && (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);
    wire brick_75 = brick_state[74] && (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);
    wire brick_76 = brick_state[75] && (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);
    wire brick_77 = brick_state[76] && (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);
    wire brick_78 = brick_state[77] && (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);
    wire brick_79 = brick_state[78] && (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);
    wire brick_80 = brick_state[79] && (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 7 * BRICK_HEIGHT && row < 8 * BRICK_HEIGHT - 1);

    wire brick_81 = brick_state[80] && (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);
    wire brick_82 = brick_state[81] && (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);
    wire brick_83 = brick_state[82] && (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);
    wire brick_84 = brick_state[83] && (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);
    wire brick_85 = brick_state[84] && (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);
    wire brick_86 = brick_state[85] && (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);
    wire brick_87 = brick_state[86] && (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);
    wire brick_88 = brick_state[87] && (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);
    wire brick_89 = brick_state[88] && (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);
    wire brick_90 = brick_state[89] && (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 8 * BRICK_HEIGHT && row < 9 * BRICK_HEIGHT - 1);

    wire brick_91 = brick_state[90] && (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);
    wire brick_92 = brick_state[91] && (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);
    wire brick_93 = brick_state[92] && (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);
    wire brick_94 = brick_state[93] && (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);
    wire brick_95 = brick_state[94] && (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);
    wire brick_96 = brick_state[95] && (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);
    wire brick_97 = brick_state[96] && (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);
    wire brick_98 = brick_state[97] && (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);
    wire brick_99 = brick_state[98] && (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);
    wire brick_100 = brick_state[99] && (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 9 * BRICK_HEIGHT && row < 10 * BRICK_HEIGHT - 1);

    wire brick_101 = brick_state[100] && (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);
    wire brick_102 = brick_state[101] && (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);
    wire brick_103 = brick_state[102] && (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);
    wire brick_104 = brick_state[103] && (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);
    wire brick_105 = brick_state[104] && (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);
    wire brick_106 = brick_state[105] && (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);
    wire brick_107 = brick_state[106] && (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);
    wire brick_108 = brick_state[107] && (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);
    wire brick_109 = brick_state[108] && (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);
    wire brick_110 = brick_state[109] && (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 10 * BRICK_HEIGHT && row < 11 * BRICK_HEIGHT - 1);

    wire brick_111 = brick_state[110] && (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);
    wire brick_112 = brick_state[111] && (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);
    wire brick_113 = brick_state[112] && (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);
    wire brick_114 = brick_state[113] && (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);
    wire brick_115 = brick_state[114] && (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);
    wire brick_116 = brick_state[115] && (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);
    wire brick_117 = brick_state[116] && (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);
    wire brick_118 = brick_state[117] && (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);
    wire brick_119 = brick_state[118] && (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);
    wire brick_120 = brick_state[119] && (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 11 * BRICK_HEIGHT && row < 12 * BRICK_HEIGHT - 1);

    wire brick_121 = brick_state[120] && (col >= 0 * BRICK_WIDTH && col < 1 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    wire brick_122 = brick_state[121] && (col >= 1 * BRICK_WIDTH && col < 2 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    wire brick_123 = brick_state[122] && (col >= 2 * BRICK_WIDTH && col < 3 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    wire brick_124 = brick_state[123] && (col >= 3 * BRICK_WIDTH && col < 4 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    wire brick_125 = brick_state[124] && (col >= 4 * BRICK_WIDTH && col < 5 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    wire brick_126 = brick_state[125] && (col >= 5 * BRICK_WIDTH && col < 6 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    wire brick_127 = brick_state[126] && (col >= 6 * BRICK_WIDTH && col < 7 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    wire brick_128 = brick_state[127] && (col >= 7 * BRICK_WIDTH && col < 8 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    wire brick_129 = brick_state[128] && (col >= 8 * BRICK_WIDTH && col < 9 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    wire brick_130 = brick_state[129] && (col >= 9 * BRICK_WIDTH && col < 10 * BRICK_WIDTH - 1 && row >= 12 * BRICK_HEIGHT && row < 13 * BRICK_HEIGHT - 1);
    ////////////////////////////////////////////////////////////// Brick //////////////////////////////////////////////////////////////
    
    always @ (posedge CLK) begin
        if (game_over) begin
            pixel_data <= over_data;
        end else if (unlock) begin   
            case(current_state)
                BOUNCE_UP: 
                    if (ball_move_counter == BALL_MOVE_DELAY) begin
                        ball_y_pos <= ball_y_pos - 1;
                        ball_move_counter <= 0;
                    end else  begin
                        ball_move_counter <= ball_move_counter + 1;
                    end
                BOUNCE_DOWN: 
                    if (ball_move_counter == BALL_MOVE_DELAY) begin
                        ball_y_pos <= ball_y_pos + 1;
                        ball_move_counter <= 0;
                    end else  begin
                        ball_move_counter <= ball_move_counter + 1;
                    end                 
            endcase
            
            
            if ((row > (board_x_pos -  BOARD_WIDTH / 2) && row <= (board_x_pos + BOARD_WIDTH / 2)) && (col > board_y_pos && col <= board_y_pos + BOARD_HEIGHT)) begin
                pixel_data <= BOARD_COLOUR;
            end else if (row > ball_x_pos - BALL_RADIUS && row <= ball_x_pos + BALL_RADIUS && col > ball_y_pos - BALL_RADIUS && col <= ball_y_pos + BALL_RADIUS) begin
                pixel_data <= BALL_COLOUR;
            end else if (brick_1 || brick_2 || brick_3 || brick_4 || brick_5 || brick_6 || brick_7 || brick_8 || brick_9 || brick_10 
            || brick_11 || brick_12 || brick_13 || brick_14 || brick_15 || brick_16 || brick_17 || brick_18 || brick_19 || brick_20
            || brick_21 || brick_22 || brick_23 || brick_24 || brick_25 || brick_26 || brick_27 || brick_28 || brick_29 || brick_30
            || brick_31 || brick_32 || brick_33 || brick_34 || brick_35 || brick_36 || brick_37 || brick_38 || brick_39 || brick_40
            || brick_41 || brick_42 || brick_43 || brick_44 || brick_45 || brick_46 || brick_47 || brick_48 || brick_49 || brick_50
            || brick_51 || brick_52 || brick_53 || brick_54 || brick_55 || brick_56 || brick_57 || brick_58 || brick_59 || brick_60
            || brick_61 || brick_62 || brick_63 || brick_64 || brick_65 || brick_66 || brick_67 || brick_68 || brick_69 || brick_70
            || brick_71 || brick_72 || brick_73 || brick_74 || brick_75 || brick_76 || brick_77 || brick_78 || brick_79 || brick_80
            || brick_81 || brick_82 || brick_83 || brick_84 || brick_85 || brick_86 || brick_87 || brick_88 || brick_89 || brick_90
            || brick_91 || brick_92 || brick_93 || brick_94 || brick_95 || brick_96 || brick_97 || brick_98 || brick_99 || brick_100
            || brick_101 || brick_102 || brick_103 || brick_104 || brick_105 || brick_106 || brick_107 || brick_108 || brick_109 || brick_110
            || brick_111 || brick_112 || brick_113 || brick_114 || brick_115 || brick_116 || brick_117 || brick_118 || brick_119 || brick_120
            || brick_121 || brick_122 || brick_123 || brick_124 || brick_125 || brick_126 || brick_127 || brick_128 || brick_129 || brick_130)
            begin
                pixel_data <= BRICK_COLOUR;
            end else begin
                pixel_data <= BLACK;
            end
           
        end else begin
            pixel_data <= screen_data;
        end
    end
    
    
    integer i;
    reg [3:0] brick_col, brick_row;
    always @ (posedge CLK) begin
        if (current_state == BOUNCE_UP) begin
            for (i = 0; i < N_BRICKS; i = i + 1) begin
                brick_col = i % 10;
                brick_row = i / 10;
                if (brick_state[i] && (ball_x_pos >= brick_row * BRICK_HEIGHT && ball_x_pos <= (brick_row + 1) * BRICK_HEIGHT - 1 
                && ball_y_pos >= brick_col * BRICK_WIDTH && ball_y_pos <= (brick_col + 1) * BRICK_WIDTH - 1)) begin
                    brick_state[i] <= 1'b0;
                    current_state <= BOUNCE_DOWN;
                end
            end
        end else if (current_state == BOUNCE_DOWN) begin
            if (ball_y_pos >= BOTTOM) begin
                game_over <= 1'b1;
            end else if (ball_x_pos >= board_x_pos - BOARD_WIDTH / 2 && ball_x_pos <= board_x_pos + BOARD_WIDTH / 2 && ball_y_pos >= board_y_pos && ball_y_pos <= board_y_pos + BOARD_HEIGHT) begin
                current_state <= BOUNCE_UP;
            end
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
                    board_x_pos <= (board_x_pos - 5 < BOARD_WIDTH / 2) ? BOARD_WIDTH / 2 : board_x_pos - 5;
                end else if (btnD) begin
                    board_x_pos <= (board_x_pos + 5 > SCREEN_HEIGHT - BOARD_WIDTH / 2 ) ? SCREEN_HEIGHT - BOARD_WIDTH / 2 : board_x_pos + 5;
                end
            end
        end
    end
    
    // Unlock to go the game 
    always @ (posedge CLK) begin
        if (btnC) begin
            unlock <= 1'b1;
        end else if (btnR) begin
            brick_state[9] <= 1'b0;
        end
    end
    
    
    
    
//    // Instantiate mouse 
//    MouseCtl mouse(
//        .clk(CLK),
//        .xpos(mouse_x_pos), 
//        .ypos(mouse_y_pos), 
//        .ps2_clk(PS2Clk), 
//        .ps2_data(PS2Data),
//        .value(12'b0),
//        .setx(0), 
//        .sety(0), 
//        .setmax_x(SCREEN_HEIGHT - 1), 
//        .setmax_y(SCREEN_WIDTH - 1)
//    );
        
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
    
    // Oled data for welcome screen
     BrickBreaker_display loadScreen (pixel_index, screen_data);
    
    // Oled data for game over screen
    BrickBreaker_gameOver gameOverScreen (pixel_index, over_data);
endmodule

