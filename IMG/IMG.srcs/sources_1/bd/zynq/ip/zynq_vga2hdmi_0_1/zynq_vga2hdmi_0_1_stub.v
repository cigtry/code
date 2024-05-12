// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Mon Apr 22 13:57:46 2024
// Host        : fy7245m220402 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/maccura/Desktop/DIP/IMG/IMG.srcs/sources_1/bd/zynq/ip/zynq_vga2hdmi_0_1/zynq_vga2hdmi_0_1_stub.v
// Design      : zynq_vga2hdmi_0_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vga2hdmi,Vivado 2018.3" *)
module zynq_vga2hdmi_0_1(clk_1x, clk_5x, rst_n, hsync, vsync, rgb_vlaid, 
  rgb_data, tmds_clk_p, tmds_clk_n, tmds_data_p, tmds_data_n)
/* synthesis syn_black_box black_box_pad_pin="clk_1x,clk_5x,rst_n,hsync,vsync,rgb_vlaid,rgb_data[23:0],tmds_clk_p,tmds_clk_n,tmds_data_p[2:0],tmds_data_n[2:0]" */;
  input clk_1x;
  input clk_5x;
  input rst_n;
  input hsync;
  input vsync;
  input rgb_vlaid;
  input [23:0]rgb_data;
  output tmds_clk_p;
  output tmds_clk_n;
  output [2:0]tmds_data_p;
  output [2:0]tmds_data_n;
endmodule
