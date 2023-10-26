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


module Brick_Breaker(
    input CLK, 
    output [7:0] JC,
    inout PS2Clk, PS2Data
    );
    
    // OLED
    parameter SCREEN_WIDTH = 96;
    parameter SCREEN_HEIGHT = 64;
    
    // Colours
    parameter WHITE = 16'hFFFF;
    parameter BLACK = 16'h0000;
    parameter RED = 16'hF800;
    parameter GREEN = 16'h07E0;
    
    // Board
    parameter BOARD_WIDTH = 16;
    parameter BOARD_HEIGHT = 3;
    parameter BOARD_COLOUR = WHITE;
    reg [11:0] board_position = 12'd32;
    
    // Brick
    parameter BRICK_WIDTH = 5;
    parameter BRICK_HEIGHT = 5;
    parameter BRICK_COLOUR = GREEN;
    
    wire [12:0] pixel_index;
    reg [15:0] pixel_data;
    
    wire [11:0] mouse_x_pos, mouse_y_pos;
    wire [6:0] col, row;
    
    assign col = pixel_index % SCREEN_WIDTH;
    assign row = pixel_index / SCREEN_WIDTH;
    
    clk6p25m clk625 (CLK, CLK_6P25M);
    
    /////////////////////////////////////////////////////// Brick ///////////////////////////////////////////////////////
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
    
    always @ (posedge CLK) begin
        if ((mouse_x_pos > BOARD_WIDTH / 2) && (mouse_x_pos < (SCREEN_HEIGHT - BOARD_WIDTH / 2))) begin
            board_position <= mouse_x_pos;
        end
        
        if ((row > (board_position -  BOARD_WIDTH / 2) && row <= (board_position + BOARD_WIDTH / 2)) && (col > 87 && col <= 87 + BOARD_HEIGHT)) begin
            pixel_data <= BOARD_COLOUR;
        end else begin
            pixel_data <= BLACK;
        end
        
        if (brick_1 || brick_2 || brick_3 || brick_4 || brick_5 || brick_6 || brick_7 || brick_8 || brick_9 || brick_10 
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
        end
    end
    
    
    
    
    // Instantiate mouse 
    MouseCtl mouse(
        .clk(CLK),
        .xpos(mouse_x_pos), 
        .ypos(mouse_y_pos), 
        .ps2_clk(PS2Clk), 
        .ps2_data(PS2Data),
        .value(12'b0),
        .setx(0), 
        .sety(0), 
        .setmax_x(SCREEN_WIDTH - 1), 
        .setmax_y(SCREEN_HEIGHT - 1)
    );
        
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
endmodule
