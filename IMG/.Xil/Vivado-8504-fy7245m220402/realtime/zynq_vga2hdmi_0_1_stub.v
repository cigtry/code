// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vga2hdmi,Vivado 2018.3" *)
module zynq_vga2hdmi_0_1(clk_1x, clk_5x, rst_n, hsync, vsync, rgb_vlaid, 
  rgb_data, tmds_clk_p, tmds_clk_n, tmds_data_p, tmds_data_n);
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
