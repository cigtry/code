`timescale 1ns / 1ps
//****************************************VSCODE PLUG-IN**********************************// 
//---------------------------------------------------------------------------------------- 
// IDE :                   VSCODE      
// VSCODE plug-in version: Verilog-Hdl-Format-1.8.20240408
// VSCODE plug-in author : Jiang Percy 
//---------------------------------------------------------------------------------------- 
//****************************************Copyright (c)***********************************// 
// Copyright(C)            COMPANY_NAME
// All rights reserved      
// File name:               
// Last modified Date:     2024/05/27 09:12:44 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/05/27 09:12:44 
// Version:                V1.0 
// TEXT NAME:              avg_fliter.v 
// PATH:                   C:\Users\maccura\Desktop\code-main\fpga\avg_filter\src\avg_fliter.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module avg_fliter(
  input                                          clk             ,
  input                                          rst_n           ,
  input                                          pre_img_vsync   ,
  input                                          pre_img_hsync   ,
  input                                          pre_img_valid   ,
  input          [  07:00]                       pre_img_data    ,

  output reg                                     post_img_vsync  ,
  output reg                                     post_img_hsync  ,
  output reg                                     post_img_valid  ,
  output reg     [  07:00]                       post_img_data    
);
  wire                                           matrix_img_vsync  ;
  wire                                           matrix_img_hsync  ;
  wire                                           matrix_img_valid  ;
  wire                                           matrix_top_edge_flag  ;
  wire                                           matrix_bottom_edge_flag  ;
  wire                                           matrix_left_edge_flag  ;
  wire                                           matrix_right_edge_flag  ;
  wire           [   7: 0]                       matrix_p11      ;
  wire           [   7: 0]                       matrix_p12      ;
  wire           [   7: 0]                       matrix_p13      ;
  wire           [   7: 0]                       matrix_p21      ;
  wire           [   7: 0]                       matrix_p22      ;
  wire           [   7: 0]                       matrix_p23      ;
  wire           [   7: 0]                       matrix_p31      ;
  wire           [   7: 0]                       matrix_p32      ;
  wire           [   7: 0]                       matrix_p33      ;

generate_3x3_winndows u_generate_3x3_winndows(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  .pre_img_vsync                                     (pre_img_vsync  ),
  .pre_img_hsync                                     (pre_img_hsync  ),
  .pre_img_valid                                     (pre_img_valid  ),
  .pre_img_data                                      (pre_img_data   ),
    //  Image data has been processed
  .matrix_img_vsync                                  (matrix_img_vsync),
  .matrix_img_hsync                                  (matrix_img_hsync),
  .matrix_img_valid                                  (matrix_img_valid),
  .matrix_top_edge_flag                              (matrix_top_edge_flag),
  .matrix_bottom_edge_flag                           (matrix_bottom_edge_flag),
  .matrix_left_edge_flag                             (matrix_left_edge_flag),
  .matrix_right_edge_flag                            (matrix_right_edge_flag),
  .matrix_p11                                        (matrix_p11     ),
  .matrix_p12                                        (matrix_p12     ),
  .matrix_p13                                        (matrix_p13     ),
  .matrix_p21                                        (matrix_p21     ),
  .matrix_p22                                        (matrix_p22     ),
  .matrix_p23                                        (matrix_p23     ),
  .matrix_p31                                        (matrix_p31     ),
  .matrix_p32                                        (matrix_p32     ),
  .matrix_p33                                        (matrix_p33     ) 
);

  reg            [  09:00]                       data_sum1       ;
  reg            [  09:00]                       data_sum2       ;
  reg            [  09:00]                       data_sum3       ;
  reg            [  11: 0]                       data_sum        ;
    always @ (posedge clk )begin
        data_sum1 <= matrix_p11 + matrix_p12 + matrix_p13;
        data_sum2 <= matrix_p21 + matrix_p22 + matrix_p23;
        data_sum3 <= matrix_p31 + matrix_p32 + matrix_p33;
        data_sum<= data_sum1 + data_sum2 + data_sum3;
    end                                                             //always end
 //  avg_data = round(data_sum/9.0) -> avg_data = round(data_sum*3641 >> 15)
reg             [22:0]          data_mult;

always @(posedge clk)
begin
    data_mult <= data_sum * 12'd3641;
end

reg             [7:0]           avg_data;

always @(posedge clk)
begin
    avg_data <= data_mult[22:15] + data_mult[14];
end

//----------------------------------------------------------------------
//  lag 4 clocks signal sync
reg             [3:0]           matrix_img_vsync_r1;
reg             [3:0]           matrix_img_hsync_r1;
reg             [3:0]           matrix_edge_flag_r1;
reg             [3:0]           matrix_img_valid_r1  ;


always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        matrix_img_vsync_r1 <= 4'b0;
        matrix_img_hsync_r1  <= 4'b0;
        matrix_edge_flag_r1 <= 4'b0;
        matrix_img_valid_r1 <= 4'b0;
    end
    else
    begin
        matrix_img_vsync_r1 <= {matrix_img_vsync_r1[2:0],matrix_img_vsync};
        matrix_img_hsync_r1  <= {matrix_img_hsync_r1[2:0],matrix_img_hsync};
        matrix_img_valid_r1 <= {matrix_img_valid_r1[2:0],matrix_img_valid};
        matrix_edge_flag_r1 <= {matrix_edge_flag_r1[2:0],matrix_top_edge_flag | matrix_bottom_edge_flag | matrix_left_edge_flag | matrix_right_edge_flag};
    end
end

reg             [7:0]           matrix_p22_r1       [0:3];

always @(posedge clk)
begin
    matrix_p22_r1[0] <= matrix_p22;
    matrix_p22_r1[1] <= matrix_p22_r1[0];
    matrix_p22_r1[2] <= matrix_p22_r1[1];
    matrix_p22_r1[3] <= matrix_p22_r1[2];
end

//----------------------------------------------------------------------
//  result output
always @(posedge clk)
begin
    if(matrix_edge_flag_r1[3] == 1'b1)
        post_img_data <= matrix_p22_r1[3];
    else
        post_img_data <= avg_data;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        post_img_vsync <= 1'b0;
        post_img_hsync  <= 1'b0;
        post_img_valid <= 1'b0;
    end
    else
    begin
        post_img_vsync <= matrix_img_vsync_r1[3];
        post_img_hsync  <= matrix_img_hsync_r1[3];
        post_img_valid <= matrix_img_valid_r1[3];
    end
end



endmodule
