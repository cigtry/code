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
// Last modified Date:     2024/07/24 14:48:40 
// Last Version:           V1.0 
// Descriptions:            
//---------------------------------------------------------------------------------------- 
// Created by:             USER_NAME
// Created date:           2024/07/24 14:48:40 
// Version:                V1.0 
// TEXT NAME:              axi_ddr_top.v 
// PATH:                   C:\Users\maccura\Desktop\code_main\fpga\axi_interface\axi_ddr_top.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
//****************************************************************************************// 

module axi_ddr_top#(
    parameter integer C_M_AXI_ID_WIDTH      = 1 ,
    parameter integer C_M_AXI_ADDR_WIDTH    = 32,
    parameter integer C_M_AXI_DATA_WIDTH    = 32,
    parameter integer C_M_AXI_AWUSER_WIDTH  = 0 ,
    parameter integer C_M_AXI_ARUSER_WIDTH  = 0 ,
    parameter integer C_M_AXI_WUSER_WIDTH   = 0 ,
    parameter integer C_M_AXI_RUSER_WIDTH   = 0 ,
    parameter integer C_M_AXI_BUSER_WIDTH   = 0 )(
  input                                          clk             ,
  input                                          rst_n           ,
  // Inouts
  inout          [  31: 0]                       ddr3_dq         ,
  inout          [   3: 0]                       ddr3_dqs_n      ,
  inout          [   3: 0]                       ddr3_dqs_p      ,
   // Outputs
  output         [  14: 0]                       ddr3_addr       ,
  output         [   2: 0]                       ddr3_ba         ,
  output                                         ddr3_ras_n      ,
  output                                         ddr3_cas_n      ,
  output                                         ddr3_we_n       ,
  output                                         ddr3_reset_n    ,
  output         [   0: 0]                       ddr3_ck_p       ,
  output         [   0: 0]                       ddr3_ck_n       ,
  output         [   0: 0]                       ddr3_cke        ,
  output         [   0: 0]                       ddr3_cs_n       ,
  output         [   3: 0]                       ddr3_dm         ,
  output         [   0: 0]                       ddr3_odt        ,
   // user
  input                                          wr_clk          ,
  input                                          wr_begin        ,
  input                                          wr_data_valid   ,
  input          [  07:00]                       wr_data_in      ,
  input          [C_M_AXI_ADDR_WIDTH - 1 : 00]   wr_addr_begin   ,

  input                                          rd_clk          ,
  input                                          rd_begin        ,
  input          [C_M_AXI_ADDR_WIDTH - 1 : 00]   rd_addr_begin   ,
  input          [C_M_AXI_ADDR_WIDTH - 1 : 00]   rd_addr_end     ,
  output                                         rd_data_busy    ,
  output         [  07:00]                       rd_data_out     ,
  output                                         rd_valid_out    ,
   // Single-ended system clock
  output                                         tg_compare_error,
  output                                         init_calib_complete 
);

  wire           [C_M_AXI_ID_WIDTH   - 1 : 00]   axi_awid        ;
  wire           [C_M_AXI_ADDR_WIDTH - 1 : 00]   axi_awaddr      ;
  wire           [  07:00]                       axi_awlen       ;
  wire           [  02:00]                       axi_awsize      ;
  wire           [  01:00]                       axi_awburst     ;
  wire                                           axi_awlock      ;
  wire           [  03:00]                       axi_awcache     ;
  wire           [  02:00]                       axi_awprot      ;
  wire           [  03:00]                       axi_awqos       ;
  wire           [C_M_AXI_AWUSER_WIDTH-1:00]     axi_awuser      ;
  wire                                           axi_awvalid     ;
  wire                                           axi_awready     ;
  wire           [C_M_AXI_DATA_WIDTH - 1 : 00]   axi_wdata       ;
  wire           [C_M_AXI_DATA_WIDTH/8-1:00]     axi_wstrb       ;
  wire                                           axi_wlast       ;
  wire           [C_M_AXI_WUSER_WIDTH -1 : 00]   axi_wuser       ;
  wire                                           axi_wvalid      ;
  wire                                           axi_wready      ;
  wire           [C_M_AXI_ID_WIDTH     -1 : 00]  axi_bid         ;
  wire           [  01:00]                       axi_bresp       ;
  wire           [C_M_AXI_BUSER_WIDTH - 1 : 00]  axi_buser       ;
  wire                                           axi_bvalid      ;
  wire                                           axi_bready      ;
  wire           [C_M_AXI_ID_WIDTH   - 1 : 00]   axi_arid        ;
  wire           [C_M_AXI_ADDR_WIDTH - 1 : 00]   axi_araddr      ;
  wire           [  07:00]                       axi_arlen       ;
  wire           [  02:00]                       axi_arsize      ;
  wire           [  01:00]                       axi_arburst     ;
  wire                                           axi_arlock      ;
  wire           [  03:00]                       axi_arcache     ;
  wire           [  02:00]                       axi_arprot      ;
  wire           [  03:00]                       axi_arqos       ;
  wire           [C_M_AXI_AWUSER_WIDTH-1:00]     axi_aruser      ;
  wire                                           axi_arvalid     ;
  wire                                           axi_arready     ;
  wire           [C_M_AXI_ID_WIDTH   - 1 : 00]   axi_rid         ;
  wire           [C_M_AXI_DATA_WIDTH - 1 : 00]   axi_rdata       ;
  wire           [C_M_AXI_DATA_WIDTH/8-1:00]     axi_rresp       ;
  wire                                           axi_rlast       ;
  wire           [C_M_AXI_WUSER_WIDTH -1 : 00]   axi_ruser       ;
  wire                                           axi_rvalid      ;
  wire                                           axi_rready      ;

  wire                                           ui_clk          ;
  wire                                           ui_clk_sync_rst  ;
  wire                                           mmcm_locked     ;
  reg                                            aresetn         ;
  wire                                           app_sr_req      ;
  wire                                           app_ref_req     ;
  wire                                           app_zq_req      ;
  wire                                           app_sr_active   ;
  wire                                           app_ref_ack     ;
  wire                                           app_zq_ack      ;
  assign                                             app_sr_req     = 1'b0;//此三者要置零，否则 refresh DDR
  assign                                             app_ref_req    = 1'b0;
  assign                                             app_zq_req     = 1'b0;
  always @(posedge ui_clk) begin
    aresetn                <= ~ui_clk_sync_rst;
end

axi_ddr3_adpter#(
  .C_M_AXI_ID_WIDTH                                  (C_M_AXI_ID_WIDTH),
  .C_M_AXI_ADDR_WIDTH                                (C_M_AXI_ADDR_WIDTH),
  .C_M_AXI_DATA_WIDTH                                (C_M_AXI_DATA_WIDTH),
  .C_M_AXI_AWUSER_WIDTH                              (C_M_AXI_AWUSER_WIDTH),
  .C_M_AXI_ARUSER_WIDTH                              (C_M_AXI_ARUSER_WIDTH),
  .C_M_AXI_WUSER_WIDTH                               (C_M_AXI_WUSER_WIDTH),
  .C_M_AXI_RUSER_WIDTH                               (C_M_AXI_RUSER_WIDTH),
  .C_M_AXI_BUSER_WIDTH                               (C_M_AXI_BUSER_WIDTH  )) 
   u_axi_ddr3_adpter(
  .clk                                               (ui_clk         ),
  .wr_clk                                            (wr_clk         ),
  .rd_clk                                            (rd_clk         ),
  .rst_n                                             (mmcm_locked    ),
  .wr_begin                                          (wr_begin       ),
  .wr_data_valid                                     (wr_data_valid  ),
  .wr_data_in                                        (wr_data_in     ),
  .wr_addr_begin                                     (wr_addr_begin  ),
  .rd_begin                                          (rd_begin       ),
  .rd_addr_begin                                     (rd_addr_begin  ),
  .rd_addr_end                                       (rd_addr_end    ),
  .rd_data_busy                                      (rd_data_busy   ),
  .rd_data_out                                       (rd_data_out    ),
  .rd_valid_out                                      (rd_valid_out   ),
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
//AXI
  .axi_wdata                                         (axi_wdata      ),
  .axi_wstrb                                         (axi_wstrb      ),
  .axi_wlast                                         (axi_wlast      ),
  .axi_wuser                                         (axi_wuser      ),
  .axi_wvalid                                        (axi_wvalid     ),
  .axi_wready                                        (axi_wready     ),
//AXI
  .axi_bid                                           (axi_bid        ),
  .axi_bresp                                         (axi_bresp      ),
  .axi_buser                                         (axi_buser      ),
  .axi_bvalid                                        (axi_bvalid     ),
  .axi_bready                                        (axi_bready     ),
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
                                                                   
    mig_7series_0 u_mig_7series_0 (
    // Memory interface ports
  .ddr3_addr                                         (ddr3_addr      ),// output [14:0]		ddr3_addr
  .ddr3_ba                                           (ddr3_ba        ),// output [2:0]		ddr3_ba
  .ddr3_cas_n                                        (ddr3_cas_n     ),// output			ddr3_cas_n
  .ddr3_ck_n                                         (ddr3_ck_n      ),// output [0:0]		ddr3_ck_n
  .ddr3_ck_p                                         (ddr3_ck_p      ),// output [0:0]		ddr3_ck_p
  .ddr3_cke                                          (ddr3_cke       ),// output [0:0]		ddr3_cke
  .ddr3_ras_n                                        (ddr3_ras_n     ),// output			ddr3_ras_n
  .ddr3_reset_n                                      (ddr3_reset_n   ),// output			ddr3_reset_n
  .ddr3_we_n                                         (ddr3_we_n      ),// output			ddr3_we_n
  .ddr3_dq                                           (ddr3_dq        ),// inout [31:0]		ddr3_dq
  .ddr3_dqs_n                                        (ddr3_dqs_n     ),// inout [3:0]		ddr3_dqs_n
  .ddr3_dqs_p                                        (ddr3_dqs_p     ),// inout [3:0]		ddr3_dqs_p
  .init_calib_complete                               (init_calib_complete),// output			init_calib_complete
  .ddr3_cs_n                                         (ddr3_cs_n      ),// output [0:0]		ddr3_cs_n
  .ddr3_dm                                           (ddr3_dm        ),// output [3:0]		ddr3_dm
  .ddr3_odt                                          (ddr3_odt       ),// output [0:0]		ddr3_odt
    // Application interface ports
  .ui_clk                                            (ui_clk         ),// output			ui_clk
  .ui_clk_sync_rst                                   (ui_clk_sync_rst),// output			ui_clk_sync_rst
  .mmcm_locked                                       (mmcm_locked    ),// output			mmcm_locked
  .aresetn                                           (aresetn        ),// input			aresetn
  .app_sr_req                                        (app_sr_req     ),// input			app_sr_req
  .app_ref_req                                       (app_ref_req    ),// input			app_ref_req
  .app_zq_req                                        (app_zq_req     ),// input			app_zq_req
  .app_sr_active                                     (app_sr_active  ),// output			app_sr_active
  .app_ref_ack                                       (app_ref_ack    ),// output			app_ref_ack
  .app_zq_ack                                        (app_zq_ack     ),// output			app_zq_ack
    // Slave Interface Write Address Ports
  .s_axi_awid                                        (axi_awid       ),// input [3:0]			s_axi_awid
  .s_axi_awaddr                                      (axi_awaddr     ),// input [29:0]			s_axi_awaddr
  .s_axi_awlen                                       (axi_awlen      ),// input [7:0]			s_axi_awlen
  .s_axi_awsize                                      (axi_awsize     ),// input [2:0]			s_axi_awsize
  .s_axi_awburst                                     (axi_awburst    ),// input [1:0]			s_axi_awburst
  .s_axi_awlock                                      (axi_awlock     ),// input [0:0]			s_axi_awlock
  .s_axi_awcache                                     (axi_awcache    ),// input [3:0]			s_axi_awcache
  .s_axi_awprot                                      (axi_awprot     ),// input [2:0]			s_axi_awprot
  .s_axi_awqos                                       (axi_awqos      ),// input [3:0]			s_axi_awqos
  .s_axi_awvalid                                     (axi_awvalid    ),// input			s_axi_awvalid
  .s_axi_awready                                     (axi_awready    ),// output			s_axi_awready
    // Slave Interface Write Data Ports
  .s_axi_wdata                                       (axi_wdata      ),// input [127:0]			s_axi_wdata
  .s_axi_wstrb                                       (axi_wstrb      ),// input [15:0]			s_axi_wstrb
  .s_axi_wlast                                       (axi_wlast      ),// input			s_axi_wlast
  .s_axi_wvalid                                      (axi_wvalid     ),// input			s_axi_wvalid
  .s_axi_wready                                      (axi_wready     ),// output			s_axi_wready
    // Slave Interface Write Response Ports
  .s_axi_bid                                         (axi_bid        ),// output [3:0]			s_axi_bid
  .s_axi_bresp                                       (axi_bresp      ),// output [1:0]			s_axi_bresp
  .s_axi_bvalid                                      (axi_bvalid     ),// output			s_axi_bvalid
  .s_axi_bready                                      (axi_bready     ),// input			s_axi_bready
    // Slave Interface Read Address Ports
  .s_axi_arid                                        (axi_arid       ),// input [3:0]			s_axi_arid
  .s_axi_araddr                                      (axi_araddr     ),// input [29:0]			s_axi_araddr
  .s_axi_arlen                                       (axi_arlen      ),// input [7:0]			s_axi_arlen
  .s_axi_arsize                                      (axi_arsize     ),// input [2:0]			s_axi_arsize
  .s_axi_arburst                                     (axi_arburst    ),// input [1:0]			s_axi_arburst
  .s_axi_arlock                                      (axi_arlock     ),// input [0:0]			s_axi_arlock
  .s_axi_arcache                                     (axi_arcache    ),// input [3:0]			s_axi_arcache
  .s_axi_arprot                                      (axi_arprot     ),// input [2:0]			s_axi_arprot
  .s_axi_arqos                                       (axi_arqos      ),// input [3:0]			s_axi_arqos
  .s_axi_arvalid                                     (axi_arvalid    ),// input			s_axi_arvalid
  .s_axi_arready                                     (axi_arready    ),// output			s_axi_arready
    // Slave Interface Read Data Ports
  .s_axi_rid                                         (axi_rid        ),// output [3:0]			s_axi_rid
  .s_axi_rdata                                       (axi_rdata      ),// output [127:0]			s_axi_rdata
  .s_axi_rresp                                       (axi_rresp      ),// output [1:0]			s_axi_rresp
  .s_axi_rlast                                       (axi_rlast      ),// output			s_axi_rlast
  .s_axi_rvalid                                      (axi_rvalid     ),// output			s_axi_rvalid
  .s_axi_rready                                      (axi_rready     ),// input			s_axi_rready
    // System Clock Ports
  .sys_clk_i                                         (clk            ),
  .sys_rst                                           (rst_n          ) // input sys_rst
    );
endmodule
