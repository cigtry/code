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
// Last modified Date:     2024/07/24 14:02:48 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/07/24 14:02:48 
// Version:                V1.0 
// TEXT NAME:              axi_ddr3_adpter.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\axi_interface\axi_ddr3_adpter.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module axi_ddr3_adpter#(
    parameter integer C_M_AXI_ID_WIDTH      = 1 ,
    parameter integer C_M_AXI_ADDR_WIDTH    = 32,
    parameter integer C_M_AXI_DATA_WIDTH    = 32,
    parameter integer C_M_AXI_AWUSER_WIDTH  = 0 ,
    parameter integer C_M_AXI_ARUSER_WIDTH  = 0 ,
    parameter integer C_M_AXI_WUSER_WIDTH   = 0 ,
    parameter integer C_M_AXI_RUSER_WIDTH   = 0 ,
    parameter integer C_M_AXI_BUSER_WIDTH   = 0 )(
  input                                          clk             ,
  input                                          wr_clk          ,
  input                                          rd_clk          ,
  input                                          rst_n           ,

  input                                          wr_begin        ,
  input                                          wr_data_valid   ,
  input          [  07:00]                       wr_data_in      ,
  input          [C_M_AXI_ADDR_WIDTH - 1 : 00]   wr_addr_begin   ,

  input                                          rd_enable       ,
  input          [C_M_AXI_ADDR_WIDTH - 1 : 00]   rd_addr_begin   ,
  output         [  07:00]                       rd_data_out     ,
  output                                         rd_valid_out    ,
  //AXI
  output wire    [C_M_AXI_ID_WIDTH   - 1 : 00]   axi_awid        ,//
  output wire    [C_M_AXI_ADDR_WIDTH - 1 : 00]   axi_awaddr      ,//
  output wire    [  07:00]                       axi_awlen       ,//
  output wire    [  02:00]                       axi_awsize      ,//
  output wire    [  01:00]                       axi_awburst     ,//
  output wire                                    axi_awlock      ,//
  output wire    [  03:00]                       axi_awcache     ,//
  output wire    [  02:00]                       axi_awprot      ,//
  output wire    [  03:00]                       axi_awqos       ,//
  output wire    [C_M_AXI_AWUSER_WIDTH-1:00]     axi_awuser      ,//
  output wire                                    axi_awvalid     ,//
  input  wire                                    axi_awready     ,//
//AXI
  output wire    [C_M_AXI_DATA_WIDTH - 1 : 00]   axi_wdata       ,//
  output wire    [C_M_AXI_DATA_WIDTH/8-1:00]     axi_wstrb       ,//
  output wire                                    axi_wlast       ,//
  output wire    [C_M_AXI_WUSER_WIDTH -1 : 00]   axi_wuser       ,//
  output wire                                    axi_wvalid      ,//
  input  wire                                    axi_wready      ,//
//AXI
  input  wire    [C_M_AXI_ID_WIDTH     -1 : 00]  axi_bid         ,//
  input  wire    [  01:00]                       axi_bresp       ,//
  input  wire    [C_M_AXI_BUSER_WIDTH - 1 : 00]  axi_buser       ,//
  input  wire                                    axi_bvalid      ,//
  output wire                                    axi_bready      ,//
//AXI
  output wire    [C_M_AXI_ID_WIDTH   - 1 : 00]   axi_arid        ,//
  output wire    [C_M_AXI_ADDR_WIDTH - 1 : 00]   axi_araddr      ,//
  output wire    [  07:00]                       axi_arlen       ,//
  output wire    [  02:00]                       axi_arsize      ,//
  output wire    [  01:00]                       axi_arburst     ,//
  output wire                                    axi_arlock      ,//
  output wire    [  03:00]                       axi_arcache     ,//
  output wire    [  02:00]                       axi_arprot      ,//
  output wire    [  03:00]                       axi_arqos       ,//
  output wire    [C_M_AXI_AWUSER_WIDTH-1:00]     axi_aruser      ,//
  output wire                                    axi_arvalid     ,//
  input  wire                                    axi_arready     ,//
//AXI
  input  wire    [C_M_AXI_ID_WIDTH   - 1 : 00]   axi_rid         ,//
  input  wire    [C_M_AXI_DATA_WIDTH - 1 : 00]   axi_rdata       ,//
  input  wire    [C_M_AXI_DATA_WIDTH/8-1:00]     axi_rresp       ,//
  input  wire                                    axi_rlast       ,//
  input  wire    [C_M_AXI_WUSER_WIDTH -1 : 00]   axi_ruser       ,//
  input  wire                                    axi_rvalid      ,//
  output wire                                    axi_rready       //
);



  wire                                           wr_start        ;
  wire           [C_M_AXI_ADDR_WIDTH - 1 : 00]   wr_addr         ;
  wire           [  07:00]                       wr_len          ;
  wire           [C_M_AXI_DATA_WIDTH - 1 : 00]   wr_data         ;
  wire                                           wr_req          ;
  wire                                           wr_busy         ;

fifo_axi_ddr_ctrl#(
  .C_M_AXI_ID_WIDTH                                  (C_M_AXI_ID_WIDTH),
  .C_M_AXI_ADDR_WIDTH                                (C_M_AXI_ADDR_WIDTH),
  .C_M_AXI_DATA_WIDTH                                (C_M_AXI_DATA_WIDTH),
  .C_M_AXI_AWUSER_WIDTH                              (C_M_AXI_AWUSER_WIDTH),
  .C_M_AXI_ARUSER_WIDTH                              (C_M_AXI_ARUSER_WIDTH),
  .C_M_AXI_WUSER_WIDTH                               (C_M_AXI_WUSER_WIDTH),
  .C_M_AXI_RUSER_WIDTH                               (C_M_AXI_RUSER_WIDTH),
  .C_M_AXI_BUSER_WIDTH                               (C_M_AXI_BUSER_WIDTH  )) 
   u_fifo_axi_ddr_ctrl(
  .clk                                               (clk            ),
  .wr_clk                                            (wr_clk         ),
  .rst_n                                             (rst_n          ),
  .wr_begin                                          (wr_begin       ),
  .wr_data_valid                                     (wr_data_valid  ),
  .wr_data_in                                        (wr_data_in     ),
  .wr_addr_begin                                     (wr_addr_begin  ),
  .wr_start                                          (wr_start       ),
  .wr_addr                                           (wr_addr        ),
  .wr_len                                            (wr_len         ),
  .wr_data                                           (wr_data        ),
  .wr_req                                            (wr_req         ),
  .wr_busy                                           (wr_busy        ) 
);


m_axi_wr#(
  .C_M_AXI_ID_WIDTH                                  (C_M_AXI_ID_WIDTH),
  .C_M_AXI_ADDR_WIDTH                                (C_M_AXI_ADDR_WIDTH),
  .C_M_AXI_DATA_WIDTH                                (C_M_AXI_DATA_WIDTH),
  .C_M_AXI_AWUSER_WIDTH                              (C_M_AXI_AWUSER_WIDTH),
  .C_M_AXI_ARUSER_WIDTH                              (C_M_AXI_ARUSER_WIDTH),
  .C_M_AXI_WUSER_WIDTH                               (C_M_AXI_WUSER_WIDTH),
  .C_M_AXI_RUSER_WIDTH                               (C_M_AXI_RUSER_WIDTH),
  .C_M_AXI_BUSER_WIDTH                               (C_M_AXI_BUSER_WIDTH  )) 
   u_m_axi_wr(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
//
  .wr_start                                          (wr_start       ),
  .wr_addr                                           (wr_addr        ),
  .wr_len                                            (wr_len         ),
  .wr_data                                           (wr_data        ),
  .wr_req                                            (wr_req         ),
  .wr_busy                                           (wr_busy        ),
//AXI
  .axi_awid                                          (axi_awid       ),
  .axi_awaddr                                        (axi_awaddr     ),
  .axi_awlen                                         (axi_awlen      ),
  .axi_awsize                                        (axi_awsize     ),
  .axi_awburst                                       (axi_awburst    ),
  .axi_awlock                                        (axi_awlock     ),
  .axi_awcache                                       (axi_awcache    ),
  .axi_awprot                                        (axi_awprot     ),
  .axi_awqos                                         (axi_awqos      ),
  .axi_awuser                                        (axi_awuser     ),
  .axi_awvalid                                       (axi_awvalid    ),
  .axi_awready                                       (axi_awready    ),
//
  .axi_wdata                                         (axi_wdata      ),
  .axi_wstrb                                         (axi_wstrb      ),
  .axi_wlast                                         (axi_wlast      ),
  .axi_wuser                                         (axi_wuser      ),
  .axi_wvalid                                        (axi_wvalid     ),
  .axi_wready                                        (axi_wready     ),
//
  .axi_bid                                           (axi_bid        ),
  .axi_bresp                                         (axi_bresp      ),
  .axi_buser                                         (axi_buser      ),
  .axi_bvalid                                        (axi_bvalid     ),
  .axi_bready                                        (axi_bready     ) 
);




  wire                                           rd_start        ;
  wire           [C_M_AXI_ADDR_WIDTH - 1 : 00]   rd_addr         ;
  wire           [C_M_AXI_DATA_WIDTH-1: 0]       rd_data         ;
  wire           [  07:00]                       rd_len          ;
  wire                                           rd_done         ;
  wire                                           rd_vld          ;
  wire                                           rd_busy         ;
axi_fifo_ddr_ctrl#(
  .C_M_AXI_ID_WIDTH                                  (C_M_AXI_ID_WIDTH),
  .C_M_AXI_ADDR_WIDTH                                (C_M_AXI_ADDR_WIDTH),
  .C_M_AXI_DATA_WIDTH                                (C_M_AXI_DATA_WIDTH),
  .C_M_AXI_AWUSER_WIDTH                              (C_M_AXI_AWUSER_WIDTH),
  .C_M_AXI_ARUSER_WIDTH                              (C_M_AXI_ARUSER_WIDTH),
  .C_M_AXI_WUSER_WIDTH                               (C_M_AXI_WUSER_WIDTH),
  .C_M_AXI_RUSER_WIDTH                               (C_M_AXI_RUSER_WIDTH),
  .C_M_AXI_BUSER_WIDTH                               (C_M_AXI_BUSER_WIDTH  )) 
  u_axi_fifo_ddr_ctrl(
  .clk                                               (clk            ),
  .rd_clk                                            (rd_clk         ),
  .rst_n                                             (rst_n          ),
  .rd_enable                                         (rd_enable      ),
  .rd_busy                                           (rd_busy        ),
  .rd_addr_begin                                     (rd_addr_begin  ),
  .rd_data_out                                       (rd_data_out    ),
  .rd_valid_out                                      (rd_valid_out   ),
  .rd_start                                          (rd_start       ),
  .rd_addr                                           (rd_addr        ),
  .rd_data                                           (rd_data        ),
  .rd_len                                            (rd_len         ),
  .rd_done                                           (rd_done        ),
  .rd_vld                                            (rd_vld         ) 
);


m_axi_rd#(
  .C_M_AXI_ID_WIDTH                                  (C_M_AXI_ID_WIDTH),
  .C_M_AXI_ADDR_WIDTH                                (C_M_AXI_ADDR_WIDTH),
  .C_M_AXI_DATA_WIDTH                                (C_M_AXI_DATA_WIDTH),
  .C_M_AXI_AWUSER_WIDTH                              (C_M_AXI_AWUSER_WIDTH),
  .C_M_AXI_ARUSER_WIDTH                              (C_M_AXI_ARUSER_WIDTH),
  .C_M_AXI_WUSER_WIDTH                               (C_M_AXI_WUSER_WIDTH),
  .C_M_AXI_RUSER_WIDTH                               (C_M_AXI_RUSER_WIDTH),
  .C_M_AXI_BUSER_WIDTH                               (C_M_AXI_BUSER_WIDTH  )) 
   u_m_axi_rd(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
//
  .rd_start                                          (rd_start       ),
  .rd_addr                                           (rd_addr        ),
  .rd_data                                           (rd_data        ),
  .rd_len                                            (rd_len         ),
  .rd_done                                           (rd_done        ),
  .rd_busy                                           (rd_busy        ),
  .rd_vld                                            (rd_vld         ),
  //AXI
  .axi_arid                                          (axi_arid       ),
  .axi_araddr                                        (axi_araddr     ),
  .axi_arlen                                         (axi_arlen      ),
  .axi_arsize                                        (axi_arsize     ),
  .axi_arburst                                       (axi_arburst    ),
  .axi_arlock                                        (axi_arlock     ),
  .axi_arcache                                       (axi_arcache    ),
  .axi_arprot                                        (axi_arprot     ),
  .axi_arqos                                         (axi_arqos      ),
  .axi_aruser                                        (axi_aruser     ),
  .axi_arvalid                                       (axi_arvalid    ),
  .axi_arready                                       (axi_arready    ),
//AXI
  .axi_rid                                           (axi_rid        ),
  .axi_rdata                                         (axi_rdata      ),
  .axi_rresp                                         (axi_rresp      ),
  .axi_rlast                                         (axi_rlast      ),
  .axi_ruser                                         (axi_ruser      ),
  .axi_rvalid                                        (axi_rvalid     ),
  .axi_rready                                        (axi_rready     ) 
);

                                                                   
                                                                   
endmodule
