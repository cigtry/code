// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Sat May 25 23:23:04 2024
// Host        : cigtry running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ zynq_cmos_capture_0_0_sim_netlist.v
// Design      : zynq_cmos_capture_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cmos_capture
   (cmos_pclk_ce,
    cmos_frame_data,
    cmos_frame_herf,
    cmos_frame_vsync,
    sys_rst_n,
    cmos_pclk,
    cmos_herf,
    cmos_vsync,
    cmos_data);
  output cmos_pclk_ce;
  output [15:0]cmos_frame_data;
  output cmos_frame_herf;
  output cmos_frame_vsync;
  input sys_rst_n;
  input cmos_pclk;
  input cmos_herf;
  input cmos_vsync;
  input [7:0]cmos_data;

  wire cmos_cfg_done;
  wire cmos_cfg_done_i_1_n_0;
  wire [7:0]cmos_data;
  wire [15:0]cmos_data_16b;
  wire cmos_data_16b0;
  wire [15:0]cmos_frame_data;
  wire cmos_frame_herf;
  wire cmos_frame_vsync;
  wire cmos_herf;
  wire \cmos_herf_r[1]_i_1_n_0 ;
  wire cmos_pclk;
  wire cmos_pclk_ce;
  wire cmos_valid_d;
  wire cmos_valid_r;
  wire cmos_valid_r_reg_n_0;
  wire cmos_vsync;
  wire \cmos_vsync_r_reg_n_0_[0] ;
  wire [1:1]p_0_in;
  wire p_0_in0_in;
  wire p_0_in_0;
  wire [15:8]p_0_in__0;
  wire [0:0]p_0_in__1;
  wire rst_n;
  wire sys_rst_n;
  wire sys_rst_n_d;
  wire wait_cnt0__0;
  wire [1:0]wait_cnt_reg;

  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h20)) 
    \/i_ 
       (.I0(cmos_cfg_done),
        .I1(cmos_valid_r_reg_n_0),
        .I2(cmos_herf),
        .O(cmos_valid_r));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hA2)) 
    \__0/i_ 
       (.I0(cmos_cfg_done),
        .I1(p_0_in0_in),
        .I2(cmos_valid_d),
        .O(cmos_pclk_ce));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hFFFF0020)) 
    cmos_cfg_done_i_1
       (.I0(\cmos_vsync_r_reg_n_0_[0] ),
        .I1(p_0_in_0),
        .I2(wait_cnt_reg[0]),
        .I3(wait_cnt_reg[1]),
        .I4(cmos_cfg_done),
        .O(cmos_cfg_done_i_1_n_0));
  FDCE cmos_cfg_done_reg
       (.C(cmos_pclk),
        .CE(1'b1),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_cfg_done_i_1_n_0),
        .Q(cmos_cfg_done));
  LUT2 #(
    .INIT(4'h8)) 
    \cmos_data_16b[15]_i_1 
       (.I0(cmos_cfg_done),
        .I1(cmos_valid_r_reg_n_0),
        .O(cmos_data_16b0));
  FDCE \cmos_data_16b_reg[0] 
       (.C(cmos_pclk),
        .CE(cmos_data_16b0),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_data[0]),
        .Q(cmos_data_16b[0]));
  FDCE \cmos_data_16b_reg[10] 
       (.C(cmos_pclk),
        .CE(cmos_data_16b0),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(p_0_in__0[10]),
        .Q(cmos_data_16b[10]));
  FDCE \cmos_data_16b_reg[11] 
       (.C(cmos_pclk),
        .CE(cmos_data_16b0),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(p_0_in__0[11]),
        .Q(cmos_data_16b[11]));
  FDCE \cmos_data_16b_reg[12] 
       (.C(cmos_pclk),
        .CE(cmos_data_16b0),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(p_0_in__0[12]),
        .Q(cmos_data_16b[12]));
  FDCE \cmos_data_16b_reg[13] 
       (.C(cmos_pclk),
        .CE(cmos_data_16b0),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(p_0_in__0[13]),
        .Q(cmos_data_16b[13]));
  FDCE \cmos_data_16b_reg[14] 
       (.C(cmos_pclk),
        .CE(cmos_data_16b0),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(p_0_in__0[14]),
        .Q(cmos_data_16b[14]));
  FDCE \cmos_data_16b_reg[15] 
       (.C(cmos_pclk),
        .CE(cmos_data_16b0),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(p_0_in__0[15]),
        .Q(cmos_data_16b[15]));
  FDCE \cmos_data_16b_reg[1] 
       (.C(cmos_pclk),
        .CE(cmos_data_16b0),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_data[1]),
        .Q(cmos_data_16b[1]));
  FDCE \cmos_data_16b_reg[2] 
       (.C(cmos_pclk),
        .CE(cmos_data_16b0),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_data[2]),
        .Q(cmos_data_16b[2]));
  FDCE \cmos_data_16b_reg[3] 
       (.C(cmos_pclk),
        .CE(cmos_data_16b0),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_data[3]),
        .Q(cmos_data_16b[3]));
  FDCE \cmos_data_16b_reg[4] 
       (.C(cmos_pclk),
        .CE(cmos_data_16b0),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_data[4]),
        .Q(cmos_data_16b[4]));
  FDCE \cmos_data_16b_reg[5] 
       (.C(cmos_pclk),
        .CE(cmos_data_16b0),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_data[5]),
        .Q(cmos_data_16b[5]));
  FDCE \cmos_data_16b_reg[6] 
       (.C(cmos_pclk),
        .CE(cmos_data_16b0),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_data[6]),
        .Q(cmos_data_16b[6]));
  FDCE \cmos_data_16b_reg[7] 
       (.C(cmos_pclk),
        .CE(cmos_data_16b0),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_data[7]),
        .Q(cmos_data_16b[7]));
  FDCE \cmos_data_16b_reg[8] 
       (.C(cmos_pclk),
        .CE(cmos_data_16b0),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(p_0_in__0[8]),
        .Q(cmos_data_16b[8]));
  FDCE \cmos_data_16b_reg[9] 
       (.C(cmos_pclk),
        .CE(cmos_data_16b0),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(p_0_in__0[9]),
        .Q(cmos_data_16b[9]));
  FDCE \cmos_data_r_reg[0] 
       (.C(cmos_pclk),
        .CE(1'b1),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_data[0]),
        .Q(p_0_in__0[8]));
  FDCE \cmos_data_r_reg[1] 
       (.C(cmos_pclk),
        .CE(1'b1),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_data[1]),
        .Q(p_0_in__0[9]));
  FDCE \cmos_data_r_reg[2] 
       (.C(cmos_pclk),
        .CE(1'b1),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_data[2]),
        .Q(p_0_in__0[10]));
  FDCE \cmos_data_r_reg[3] 
       (.C(cmos_pclk),
        .CE(1'b1),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_data[3]),
        .Q(p_0_in__0[11]));
  FDCE \cmos_data_r_reg[4] 
       (.C(cmos_pclk),
        .CE(1'b1),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_data[4]),
        .Q(p_0_in__0[12]));
  FDCE \cmos_data_r_reg[5] 
       (.C(cmos_pclk),
        .CE(1'b1),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_data[5]),
        .Q(p_0_in__0[13]));
  FDCE \cmos_data_r_reg[6] 
       (.C(cmos_pclk),
        .CE(1'b1),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_data[6]),
        .Q(p_0_in__0[14]));
  FDCE \cmos_data_r_reg[7] 
       (.C(cmos_pclk),
        .CE(1'b1),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_data[7]),
        .Q(p_0_in__0[15]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cmos_frame_data[10]_INST_0 
       (.I0(cmos_cfg_done),
        .I1(cmos_data_16b[5]),
        .O(cmos_frame_data[5]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cmos_frame_data[11]_INST_0 
       (.I0(cmos_cfg_done),
        .I1(cmos_data_16b[6]),
        .O(cmos_frame_data[6]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cmos_frame_data[12]_INST_0 
       (.I0(cmos_cfg_done),
        .I1(cmos_data_16b[7]),
        .O(cmos_frame_data[7]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cmos_frame_data[13]_INST_0 
       (.I0(cmos_cfg_done),
        .I1(cmos_data_16b[8]),
        .O(cmos_frame_data[8]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cmos_frame_data[14]_INST_0 
       (.I0(cmos_cfg_done),
        .I1(cmos_data_16b[9]),
        .O(cmos_frame_data[9]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cmos_frame_data[15]_INST_0 
       (.I0(cmos_cfg_done),
        .I1(cmos_data_16b[10]),
        .O(cmos_frame_data[10]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cmos_frame_data[19]_INST_0 
       (.I0(cmos_cfg_done),
        .I1(cmos_data_16b[11]),
        .O(cmos_frame_data[11]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cmos_frame_data[20]_INST_0 
       (.I0(cmos_cfg_done),
        .I1(cmos_data_16b[12]),
        .O(cmos_frame_data[12]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cmos_frame_data[21]_INST_0 
       (.I0(cmos_cfg_done),
        .I1(cmos_data_16b[13]),
        .O(cmos_frame_data[13]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cmos_frame_data[22]_INST_0 
       (.I0(cmos_cfg_done),
        .I1(cmos_data_16b[14]),
        .O(cmos_frame_data[14]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cmos_frame_data[23]_INST_0 
       (.I0(cmos_cfg_done),
        .I1(cmos_data_16b[15]),
        .O(cmos_frame_data[15]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cmos_frame_data[3]_INST_0 
       (.I0(cmos_cfg_done),
        .I1(cmos_data_16b[0]),
        .O(cmos_frame_data[0]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cmos_frame_data[4]_INST_0 
       (.I0(cmos_cfg_done),
        .I1(cmos_data_16b[1]),
        .O(cmos_frame_data[1]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cmos_frame_data[5]_INST_0 
       (.I0(cmos_cfg_done),
        .I1(cmos_data_16b[2]),
        .O(cmos_frame_data[2]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cmos_frame_data[6]_INST_0 
       (.I0(cmos_cfg_done),
        .I1(cmos_data_16b[3]),
        .O(cmos_frame_data[3]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cmos_frame_data[7]_INST_0 
       (.I0(cmos_cfg_done),
        .I1(cmos_data_16b[4]),
        .O(cmos_frame_data[4]));
  LUT2 #(
    .INIT(4'h8)) 
    cmos_frame_valid_INST_0
       (.I0(cmos_cfg_done),
        .I1(p_0_in0_in),
        .O(cmos_frame_herf));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h8)) 
    cmos_frame_vsync_INST_0
       (.I0(cmos_cfg_done),
        .I1(p_0_in_0),
        .O(cmos_frame_vsync));
  LUT1 #(
    .INIT(2'h1)) 
    \cmos_herf_r[1]_i_1 
       (.I0(rst_n),
        .O(\cmos_herf_r[1]_i_1_n_0 ));
  FDCE \cmos_herf_r_reg[0] 
       (.C(cmos_pclk),
        .CE(1'b1),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_herf),
        .Q(p_0_in));
  FDCE \cmos_herf_r_reg[1] 
       (.C(cmos_pclk),
        .CE(1'b1),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(p_0_in),
        .Q(p_0_in0_in));
  FDCE cmos_valid_d_reg
       (.C(cmos_pclk),
        .CE(1'b1),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_valid_r_reg_n_0),
        .Q(cmos_valid_d));
  FDCE cmos_valid_r_reg
       (.C(cmos_pclk),
        .CE(1'b1),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_valid_r),
        .Q(cmos_valid_r_reg_n_0));
  FDCE \cmos_vsync_r_reg[0] 
       (.C(cmos_pclk),
        .CE(1'b1),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(cmos_vsync),
        .Q(\cmos_vsync_r_reg_n_0_[0] ));
  FDCE \cmos_vsync_r_reg[1] 
       (.C(cmos_pclk),
        .CE(1'b1),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(\cmos_vsync_r_reg_n_0_[0] ),
        .Q(p_0_in_0));
  FDRE rst_n_reg
       (.C(cmos_pclk),
        .CE(1'b1),
        .D(sys_rst_n_d),
        .Q(rst_n),
        .R(1'b0));
  FDRE sys_rst_n_d_reg
       (.C(cmos_pclk),
        .CE(1'b1),
        .D(sys_rst_n),
        .Q(sys_rst_n_d),
        .R(1'b0));
  LUT3 #(
    .INIT(8'h04)) 
    wait_cnt0
       (.I0(p_0_in_0),
        .I1(\cmos_vsync_r_reg_n_0_[0] ),
        .I2(wait_cnt_reg[1]),
        .O(wait_cnt0__0));
  LUT1 #(
    .INIT(2'h1)) 
    \wait_cnt[0]_i_1 
       (.I0(wait_cnt_reg[0]),
        .O(p_0_in__1));
  FDCE \wait_cnt_reg[0] 
       (.C(cmos_pclk),
        .CE(wait_cnt0__0),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(p_0_in__1),
        .Q(wait_cnt_reg[0]));
  FDCE \wait_cnt_reg[1] 
       (.C(cmos_pclk),
        .CE(wait_cnt0__0),
        .CLR(\cmos_herf_r[1]_i_1_n_0 ),
        .D(wait_cnt_reg[0]),
        .Q(wait_cnt_reg[1]));
endmodule

(* CHECK_LICENSE_TYPE = "zynq_cmos_capture_0_0,cmos_capture,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "cmos_capture,Vivado 2018.3" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (sys_rst_n,
    cmos_pclk,
    cmos_vsync,
    cmos_herf,
    cmos_data,
    cmos_pclk_ce,
    cmos_frame_vsync,
    cmos_frame_herf,
    cmos_frame_valid,
    cmos_frame_data);
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 sys_rst_n RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME sys_rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input sys_rst_n;
  input cmos_pclk;
  input cmos_vsync;
  input cmos_herf;
  input [7:0]cmos_data;
  output cmos_pclk_ce;
  output cmos_frame_vsync;
  output cmos_frame_herf;
  output cmos_frame_valid;
  output [23:0]cmos_frame_data;

  wire \<const0> ;
  wire [7:0]cmos_data;
  wire [23:3]\^cmos_frame_data ;
  wire cmos_frame_herf;
  wire cmos_frame_vsync;
  wire cmos_herf;
  wire cmos_pclk;
  wire cmos_pclk_ce;
  wire cmos_vsync;
  wire sys_rst_n;

  assign cmos_frame_data[23:19] = \^cmos_frame_data [23:19];
  assign cmos_frame_data[18] = \<const0> ;
  assign cmos_frame_data[17] = \<const0> ;
  assign cmos_frame_data[16] = \<const0> ;
  assign cmos_frame_data[15:10] = \^cmos_frame_data [15:10];
  assign cmos_frame_data[9] = \<const0> ;
  assign cmos_frame_data[8] = \<const0> ;
  assign cmos_frame_data[7:3] = \^cmos_frame_data [7:3];
  assign cmos_frame_data[2] = \<const0> ;
  assign cmos_frame_data[1] = \<const0> ;
  assign cmos_frame_data[0] = \<const0> ;
  assign cmos_frame_valid = cmos_frame_herf;
  GND GND
       (.G(\<const0> ));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_cmos_capture inst
       (.cmos_data(cmos_data),
        .cmos_frame_data({\^cmos_frame_data [23:19],\^cmos_frame_data [15:10],\^cmos_frame_data [7:3]}),
        .cmos_frame_herf(cmos_frame_herf),
        .cmos_frame_vsync(cmos_frame_vsync),
        .cmos_herf(cmos_herf),
        .cmos_pclk(cmos_pclk),
        .cmos_pclk_ce(cmos_pclk_ce),
        .cmos_vsync(cmos_vsync),
        .sys_rst_n(sys_rst_n));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
