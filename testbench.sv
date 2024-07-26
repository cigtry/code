`timescale  100ps/100ps
module testbench;
    parameter integer C_M_AXI_ID_WIDTH      = 4 ;
    parameter integer C_M_AXI_ADDR_WIDTH    = 30;
    parameter integer C_M_AXI_DATA_WIDTH    = 128;
    parameter integer C_M_AXI_AWUSER_WIDTH  = 0 ;
    parameter integer C_M_AXI_ARUSER_WIDTH  = 0 ;
    parameter integer C_M_AXI_WUSER_WIDTH   = 0 ;
    parameter integer C_M_AXI_RUSER_WIDTH   = 0 ;
    parameter integer C_M_AXI_BUSER_WIDTH   = 0 ;
//----------------------------------------------------------------------
//  clk & rst_n
  reg                                            clk             ;
  reg                                            rst_n           ;
  reg                                            wr_clk          ;
  reg                                            rd_clk          ;
initial
begin
    clk = 1'b0;
    forever #25 clk = ~clk;
end
initial
begin
    rd_clk = 1'b0;
    forever #50 rd_clk = ~rd_clk;
end
initial
begin
    wr_clk = 1'b0;
    forever #50 wr_clk = ~wr_clk;
end
initial
begin
    rst_n = 1'b0;
    repeat(50) @(posedge clk);
    rst_n = 1'b1;
end
//----------------------------------------------------------------------
//  Image data prepred to be processed
  reg                                            wr_begin        ;
  reg                                            wr_data_valid   ;
  reg            [   7: 0]                       wr_data_in      ;
  reg            [  29:00]                       wr_addr_begin   ;
  reg                                            rd_enable       ;
  reg            [  29:00]                       rd_addr_begin   ;
  wire           [   7: 0]                       rd_data_out     ;
  wire                                           rd_valid_out    ;
  wire           [  31: 0]                       ddr3_dq         ;
  wire           [   3: 0]                       ddr3_dqs_n      ;
  wire           [   3: 0]                       ddr3_dqs_p      ;
  wire           [  14: 0]                       ddr3_addr       ;
  wire           [   2: 0]                       ddr3_ba         ;
  wire                                           ddr3_ras_n      ;
  wire                                           ddr3_cas_n      ;
  wire                                           ddr3_we_n       ;
  wire                                           ddr3_reset_n    ;
  wire           [   0: 0]                       ddr3_ck_p       ;
  wire           [   0: 0]                       ddr3_ck_n       ;
  wire           [   0: 0]                       ddr3_cke        ;
  wire           [   0: 0]                       ddr3_cs_n       ;
  wire           [   3: 0]                       ddr3_dm         ;
  wire           [   0: 0]                       ddr3_odt        ;
  wire                                           tg_compare_error  ;
  wire                                           init_calib_complete  ;

axi_ddr_top#(
  .C_M_AXI_ID_WIDTH                                  (C_M_AXI_ID_WIDTH),
  .C_M_AXI_ADDR_WIDTH                                (C_M_AXI_ADDR_WIDTH),
  .C_M_AXI_DATA_WIDTH                                (C_M_AXI_DATA_WIDTH),
  .C_M_AXI_AWUSER_WIDTH                              (C_M_AXI_AWUSER_WIDTH),
  .C_M_AXI_ARUSER_WIDTH                              (C_M_AXI_ARUSER_WIDTH),
  .C_M_AXI_WUSER_WIDTH                               (C_M_AXI_WUSER_WIDTH),
  .C_M_AXI_RUSER_WIDTH                               (C_M_AXI_RUSER_WIDTH),
  .C_M_AXI_BUSER_WIDTH                               (C_M_AXI_BUSER_WIDTH  )) 
   u_axi_ddr_top(
  .clk                                               (clk            ),
  .rst_n                                             (rst_n          ),
  // Inouts
  .ddr3_dq                                           (ddr3_dq        ),
  .ddr3_dqs_n                                        (ddr3_dqs_n     ),
  .ddr3_dqs_p                                        (ddr3_dqs_p     ),
   // Outputs
  .ddr3_addr                                         (ddr3_addr      ),
  .ddr3_ba                                           (ddr3_ba        ),
  .ddr3_ras_n                                        (ddr3_ras_n     ),
  .ddr3_cas_n                                        (ddr3_cas_n     ),
  .ddr3_we_n                                         (ddr3_we_n      ),
  .ddr3_reset_n                                      (ddr3_reset_n   ),
  .ddr3_ck_p                                         (ddr3_ck_p      ),
  .ddr3_ck_n                                         (ddr3_ck_n      ),
  .ddr3_cke                                          (ddr3_cke       ),
  .ddr3_cs_n                                         (ddr3_cs_n      ),
  .ddr3_dm                                           (ddr3_dm        ),
  .ddr3_odt                                          (ddr3_odt       ),
   // Inputs
  .wr_clk                                            (wr_clk         ),
  .rd_clk                                            (rd_clk         ),
  .wr_begin                                          (wr_begin       ),
  .wr_data_valid                                     (wr_data_valid  ),
  .wr_data_in                                        (wr_data_in     ),
  .wr_addr_begin                                     (wr_addr_begin  ),
  .rd_enable                                         (rd_enable      ),
  .rd_addr_begin                                     (rd_addr_begin  ),
  .rd_data_out                                       (rd_data_out    ),
  .rd_valid_out                                      (rd_valid_out   ),
   // Single-ended system clock
  .tg_compare_error                                  (tg_compare_error),
  .init_calib_complete                               (init_calib_complete) 
);



ddr3_model u_ddr3_model(
  .rst_n                                             (ddr3_reset_n   ),
  .ck                                                (ddr3_ck_p      ),
  .ck_n                                              (ddr3_ck_n      ),
  .cke                                               (ddr3_cke       ),
  .cs_n                                              (ddr3_cs_n      ),
  .ras_n                                             (ddr3_ras_n     ),
  .cas_n                                             (ddr3_cas_n     ),
  .we_n                                              (ddr3_we_n      ),
  .dm_tdqs                                           (ddr3_dm[1:0]   ),
  .ba                                                (ddr3_ba        ),
  .addr                                              (ddr3_addr      ),
  .dq                                                (ddr3_dq[15:0]  ),
  .dqs                                               (ddr3_dqs_p[1:0]),
  .dqs_n                                             (ddr3_dqs_n[1:0]),
  .tdqs_n                                            (               ),
  .odt                                               (ddr3_odt       ) 
);

ddr3_model u_ddr3_model2(
  .rst_n                                             (ddr3_reset_n   ),
  .ck                                                (ddr3_ck_p      ),
  .ck_n                                              (ddr3_ck_n      ),
  .cke                                               (ddr3_cke       ),
  .cs_n                                              (ddr3_cs_n      ),
  .ras_n                                             (ddr3_ras_n     ),
  .cas_n                                             (ddr3_cas_n     ),
  .we_n                                              (ddr3_we_n      ),
  .dm_tdqs                                           (ddr3_dm[3:2]   ),
  .ba                                                (ddr3_ba        ),
  .addr                                              (ddr3_addr      ),
  .dq                                                (ddr3_dq[31:16] ),
  .dqs                                               (ddr3_dqs_p[3:2]),
  .dqs_n                                             (ddr3_dqs_n[3:2]),
  .tdqs_n                                            (               ),
  .odt                                               (ddr3_odt       ) 
);

//----------------------------------------------------------------------
//  task and function





initial
begin
  wr_begin       =0;
  wr_data_valid     =0;
  wr_data_in           =0;
  wr_addr_begin  =0;
  rd_enable      =0;
  rd_addr_begin  =0;
end

initial
begin
    wait(rst_n);
    wait(init_calib_complete)
    repeat(5) @(posedge wr_clk);
    wr_addr_begin = 30'h0100_0000;
    wr_begin = 1'b1;
    repeat(2) @(posedge wr_clk);
     wr_begin = 1'b0;
     fork
      repeat(256)begin
        wr_data_in = wr_data_in + 1;
        wr_data_valid = 1;
        repeat(1) @(posedge wr_clk);
      end

     join
            wr_data_valid = 0;
    repeat(200) @(posedge wr_clk);
    rd_addr_begin = 30'h0100_0000;
    rd_enable = 1;
    repeat(500) @(posedge wr_clk);
     rd_enable = 0;
end

endmodule