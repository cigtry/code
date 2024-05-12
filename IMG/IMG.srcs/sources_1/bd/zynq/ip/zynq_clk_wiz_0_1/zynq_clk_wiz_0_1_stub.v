// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Mon Apr 22 16:35:36 2024
// Host        : fy7245m220402 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top zynq_clk_wiz_0_1 -prefix
//               zynq_clk_wiz_0_1_ zynq_clk_wiz_0_1_stub.v
// Design      : zynq_clk_wiz_0_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module zynq_clk_wiz_0_1(clk_1x, clk_5x, resetn, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_1x,clk_5x,resetn,locked,clk_in1" */;
  output clk_1x;
  output clk_5x;
  input resetn;
  output locked;
  input clk_in1;
endmodule
