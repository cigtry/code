// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module zynq_clk_wiz_0_0(clk_1x, clk_5x, reset, locked, clk_in1);
  output clk_1x;
  output clk_5x;
  input reset;
  output locked;
  input clk_in1;
endmodule
