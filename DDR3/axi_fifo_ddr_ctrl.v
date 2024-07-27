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
// Last modified Date:     2024/07/24 11:24:38 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/07/24 11:24:38 
// Version:                V1.0 
// TEXT NAME:              axi_fifo_ddr_ctrl.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\axi_interface\axi_fifo_ddr_ctrl.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module axi_fifo_ddr_ctrl#(
    parameter integer C_M_AXI_ID_WIDTH      = 1 ,
    parameter integer C_M_AXI_ADDR_WIDTH    = 32,
    parameter integer C_M_AXI_DATA_WIDTH    = 32,
    parameter integer C_M_AXI_AWUSER_WIDTH  = 0 ,
    parameter integer C_M_AXI_ARUSER_WIDTH  = 0 ,
    parameter integer C_M_AXI_WUSER_WIDTH   = 0 ,
    parameter integer C_M_AXI_RUSER_WIDTH   = 0 ,
    parameter integer C_M_AXI_BUSER_WIDTH   = 0 )(
  input                                          clk             ,//ddr系统时钟
  input                                          rd_clk          ,//fifo读取时钟
  input                                          rst_n           ,

  input                                          rd_enable       ,
  input          [C_M_AXI_ADDR_WIDTH - 1 : 00]   rd_addr_begin   ,
  output         [  07:00]                       rd_data_out     ,
  output reg                                     rd_valid_out    ,

  output wire                                    rd_start        ,
  output reg     [C_M_AXI_ADDR_WIDTH - 1 : 00]   rd_addr         ,
  input  wire    [C_M_AXI_DATA_WIDTH-1: 0]       rd_data         ,
  output wire    [  07:00]                       rd_len          ,
  input  wire                                    rd_done         ,
  input  wire                                    rd_busy         ,
  input  wire                                    rd_vld           
);

  
  reg                                            rd_enable_d     ;
  wire                                           pos_rd_enable   ;
  assign                                             pos_rd_enable  = rd_enable && !rd_enable_d;
  always @(posedge clk ) begin
    rd_enable_d <= rd_enable;
  end

  wire           [  10: 0]                       burst_size_bytes  ;
  assign                                             burst_size_bytes= rd_len * (C_M_AXI_DATA_WIDTH>>3);

  wire                                           rd_fifo_full    ;
  wire                                           rd_fifo_empty   ;
  wire           [ 127:00]                       rd_fifo_din     ;
  assign                                             rd_fifo_din    = rd_data;
  wire                                           rd_fifo_wr_en   ;
  assign                                             rd_fifo_wr_en  = rd_vld && (!rd_fifo_full);
  wire           [  15:00]                       rd_fifo_dout    ;
  wire                                           rd_fifo_rd_en   ;
  assign                                             rd_fifo_rd_en  = rd_enable && (!rd_fifo_empty);
  wire           [  08:00]                       rd_fifo_rd_data_count  ;
  wire           [  05:00]                       rd_fifo_wr_data_count  ;
  wire                                           rd_fifo_wr_rst_busy  ;
  wire                                           rd_fifo_rd_rst_busy  ;
  //----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
rd_ddr3_fifo u_rd_ddr3_fifo (
  .rst                                               (!rst_n         ),// input wire rst
  .wr_clk                                            (clk            ),// input wire wr_clk
  .rd_clk                                            (rd_clk         ),// input wire rd_clk
  .din                                               (rd_fifo_din    ),// input wire [127 : 0] din
  .wr_en                                             (rd_fifo_wr_en  ),// input wire wr_en
  .rd_en                                             (rd_fifo_rd_en  ),// input wire rd_en
  .dout                                              (rd_fifo_dout   ),// output wire [15 : 0] dout
  .full                                              (rd_fifo_full   ),// output wire full
  .empty                                             (rd_fifo_empty  ),// output wire empty
  .rd_data_count                                     (rd_fifo_rd_data_count),// output wire [8 : 0] rd_data_count
  .wr_data_count                                     (rd_fifo_wr_data_count),// output wire [5 : 0] wr_data_count
  .wr_rst_busy                                       (rd_fifo_wr_rst_busy),// output wire wr_rst_busy
  .rd_rst_busy                                       (rd_fifo_rd_rst_busy) // output wire rd_rst_busy
);
// INST_TAG_END ------ End INSTANTIATION Template ---------
  always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
        rd_addr <= {C_M_AXI_ADDR_WIDTH{1'b0}};
    else if(pos_rd_enable) begin
        rd_addr <= rd_addr_begin;
    end
    else if(rd_done)begin
      rd_addr <= rd_addr + burst_size_bytes;
    end
    else begin
      rd_addr <= rd_addr;
    end
  end

  assign                                             rd_len         = 8'd1;
  assign                                             rd_start       = (!rd_fifo_full) && (!rd_busy) && rd_enable;
  assign                                             rd_data_out    = rd_fifo_dout[7:0];
always @(posedge rd_clk )begin
  rd_valid_out = rd_enable && !rd_fifo_empty;
end
                                                                   
endmodule
