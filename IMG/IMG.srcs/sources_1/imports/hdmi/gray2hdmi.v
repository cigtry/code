`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////
//Company        :    maccura    
//Engineer        :    FuXin     
//Creat Date      :    2023-01-01
//Design Name      :             
//Module Name      :             
//Project Name      :            
//Target Devices    :            
//Tool Version      :            
//Description      :             
//Revisoion      :               
//Additional Comments  :          
//
////////////////////////////////////////////////////////////////
module gray2hdmi(
  input   wire                   clk    , //system clock 50MHz
  input   wire                   rst_n  , //reset, low valid
  
  input   wire                   hsync,
  input   wire                   vsync,
  input   wire                   data_valid,
  input   wire      [7:0]        gray_data,
  
  output  wire                   post_hsync,
  output  wire                   post_vsync,
  output  wire                   post_valid,
  output  wire      [23:0]       hdmi_data
);
assign  post_hsync  =hsync;
assign  post_vsync  =vsync;
assign  post_valid  =data_valid;
assign  hdmi_data   ={3{gray_data}};

endmodule 