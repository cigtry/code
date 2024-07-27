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
// Last modified Date:     2024/06/14 10:09:27 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/06/14 10:09:27 
// Version:                V1.0 
// TEXT NAME:              axi_ddr_ctrl.v 
// PATH:                   C:\Users\maccura\Desktop\code-main\fpga\axi_interface\axi_ddr_ctrl.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module fifo_axi_ddr_ctrl#(
    parameter integer C_M_AXI_ID_WIDTH      = 1 ,
    parameter integer C_M_AXI_ADDR_WIDTH    = 32,
    parameter integer C_M_AXI_DATA_WIDTH    = 32,
    parameter integer C_M_AXI_AWUSER_WIDTH  = 0 ,
    parameter integer C_M_AXI_ARUSER_WIDTH  = 0 ,
    parameter integer C_M_AXI_WUSER_WIDTH   = 0 ,
    parameter integer C_M_AXI_RUSER_WIDTH   = 0 ,
    parameter integer C_M_AXI_BUSER_WIDTH   = 0 )(
  input  wire                                    clk             ,//system clock 
  input  wire                                    wr_clk          ,
  input  wire                                    rst_n           ,//reset, low valid

  input                                          wr_begin        ,
  input                                          wr_data_valid   ,
  input          [  07:00]                       wr_data_in      ,
  input          [C_M_AXI_ADDR_WIDTH - 1 : 00]   wr_addr_begin   ,

  output wire                                    wr_start        ,
  output reg     [C_M_AXI_ADDR_WIDTH - 1 : 00]   wr_addr         ,
  output wire    [  07:00]                       wr_len          ,
  output wire    [C_M_AXI_DATA_WIDTH - 1 : 00]   wr_data         ,
  input  wire                                    wr_req          ,
  input  wire                                    wr_busy          

);
                                                                    
  assign                                             wr_len         = 8'd1;

  wire           [  10: 0]                       burst_size_bytes  ;
  assign                                             burst_size_bytes= wr_len * (C_M_AXI_DATA_WIDTH>>3);


  wire                                           wr_fifo_full    ;
  wire                                           wr_fifo_empty   ;
  wire           [  15:00]                       wr_fifo_din     ;
  assign                                             wr_fifo_din    = {8'b0,wr_data_in};
  wire                                           wr_fifo_wr_en   ;
  assign                                             wr_fifo_wr_en  = wr_data_valid && (!wr_fifo_full);
  wire           [ 127:00]                       wr_fifo_dout    ;
  wire                                           wr_fifo_rd_en   ;
  assign                                             wr_fifo_rd_en  = (!wr_fifo_empty && !wr_busy);
  wire           [  05:00]                       wr_fifo_rd_data_count  ;
  wire           [  08:00]                       wr_fifo_wr_data_count  ;
  wire                                           wr_fifo_wr_rst_busy  ;
  wire                                           wr_fifo_rd_rst_busy  ;


//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
wr_ddr3_fifo u_wr_ddr3_fifo (
  .rst                                               (!rst_n         ),// input wire rst
  .wr_clk                                            (wr_clk         ),// input wire wr_clk
  .rd_clk                                            (clk            ),// input wire rd_clk
  .din                                               (wr_fifo_din    ),// input wire [15 : 0] din
  .wr_en                                             (wr_fifo_wr_en  ),// input wire wr_en
  .rd_en                                             (wr_fifo_rd_en  ),// input wire rd_en
  .dout                                              (wr_fifo_dout   ),// output wire [127 : 0] dout
  .full                                              (wr_fifo_full   ),// output wire full
  .empty                                             (wr_fifo_empty  ),// output wire empty
  .rd_data_count                                     (wr_fifo_rd_data_count),// output wire [5 : 0] rd_data_count
  .wr_data_count                                     (wr_fifo_wr_data_count),// output wire [8 : 0] wr_data_count
  .wr_rst_busy                                       (wr_fifo_wr_rst_busy),// output wire wr_rst_busy
  .rd_rst_busy                                       (wr_fifo_rd_rst_busy) // output wire rd_rst_busy
);

  assign                                             wr_start       = wr_fifo_rd_en;


  reg                                            wr_begin_d      ;
  wire                                           pos_wr_begin    ;
  assign                                             pos_wr_begin   = wr_begin && !wr_begin_d;

  always @(posedge clk ) begin
    wr_begin_d <= wr_begin;
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wr_addr <= {C_M_AXI_ADDR_WIDTH{1'b0}};
    end
    else if(pos_wr_begin)begin
      wr_addr <= wr_addr_begin;
    end
    else if(wr_req)begin
      wr_addr <= wr_addr + burst_size_bytes;
    end
    else begin
      wr_addr <= wr_addr;
    end
  end

  assign                                             wr_data        = wr_fifo_dout;

endmodule
