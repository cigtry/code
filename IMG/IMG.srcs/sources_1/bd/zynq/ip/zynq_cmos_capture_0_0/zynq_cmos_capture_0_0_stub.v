// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Sat May 25 23:23:04 2024
// Host        : cigtry running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/DESKTOP/code/IMG/IMG.srcs/sources_1/bd/zynq/ip/zynq_cmos_capture_0_0/zynq_cmos_capture_0_0_stub.v
// Design      : zynq_cmos_capture_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "cmos_capture,Vivado 2018.3" *)
module zynq_cmos_capture_0_0(sys_rst_n, cmos_pclk, cmos_vsync, cmos_herf, 
  cmos_data, cmos_pclk_ce, cmos_frame_vsync, cmos_frame_herf, cmos_frame_valid, 
  cmos_frame_data)
/* synthesis syn_black_box black_box_pad_pin="sys_rst_n,cmos_pclk,cmos_vsync,cmos_herf,cmos_data[7:0],cmos_pclk_ce,cmos_frame_vsync,cmos_frame_herf,cmos_frame_valid,cmos_frame_data[23:0]" */;
  input sys_rst_n;
  input cmos_pclk;
  input cmos_vsync;
  input cmos_herf;
  input [7:0]cmos_data;
  output cmos_pclk_ce;
  output cmos_frame_vsync;
  output cmos_frame_herf;
  output cmos_frame_valid;
  output [23:0]cmos_frame_data;
endmodule
