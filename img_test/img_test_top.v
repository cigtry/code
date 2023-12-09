`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////
//Company        :    maccura    
//Engineer        :    FuXin     
//Creat Date      :    2023-01-01
//Design Name      :             
//Module Name      :             
//Project Name      :            
//Target Devices    :            
//Tool Version      :            
//Description      :             
//Revisoion      :               
//Additional Comments  :          
//
////////////////////////////////////////////////////////////////
module img_test_top(
  input   wire                   clk    , //system clock 50MHz
  input   wire                   rst_n  , //reset, low valid
  //the interface of camemra 
  inout   wire                   iic_sda,
  output  wire                   iic_scl,
  input   wire                   cmos_pclk,//数据像素时钟
  input   wire                   cmos_vsync,//场同步信号
  input   wire                   cmos_herf,//行同步信号
  input   wire    [7:0]          cmos_data,//数据
  output  wire                   cmos_rst_n,//复位信号 LOW VALID
  output  wire                   cmos_pwdn,//电源休眠模式选择 0：正常模式 1：电源休眠模式
  
  //the interface of TCP

  /* input   wire                  eth_rxc,//RGMII接收数据时钟
  input   wire                  eth_rx_ctl,//RGMII输入时钟有效信号
  input   wire    [3:0]         eth_rxd,//RGMII输入数据
  output  wire                  eth_txc,//RGMII输出数据时钟
  output  wire                  eth_tx_ctl,//RGMII输出数据有效信号
  output  wire    [3:0]         eth_txd,//RGMII输出数据
  output  wire                  eth_rst_n//RGMII复位信号 LOW VALID */

  //HDMI
  output  wire                  HDMI_CLK_P,
  output  wire                  HDMI_CLK_N,
  //output  wire                  HDMI_OUT_EN,
  //output  wire                  HDMI_CEC    ,
  //output  wire                  HDMI_HPD    ,
  output  wire                  HDMI_DATA0_P,
  output  wire                  HDMI_DATA0_N,
  output  wire                  HDMI_DATA1_P,
  output  wire                  HDMI_DATA1_N,
  output  wire                  HDMI_DATA2_P,
  output  wire                  HDMI_DATA2_N
);
//Parameter Declarations
  wire                   config_done;
 (* dont_touch = "true" *)wire                   cmos_frame_vsync;
 (* dont_touch = "true" *)wire                   cmos_frame_herf;
 (* dont_touch = "true" *)wire                   cmos_frame_valid;
 (* dont_touch = "true" *)wire        [23:0]     cmos_frame_data;
//Internal wire/reg declarations
cmos_top   cmos_top(
 .clk           ( clk         ), //system clock 50MHz
 .rst_n         ( rst_n       ), //reset, low valid

 .iic_scl       ( iic_scl     ),
 .iic_sda       ( iic_sda     ),
 .config_done   ( config_done )
);


cmos_capture   cmos_capture(
  .rst_n               ( rst_n            ), //reset, low valid

  .cmos_pclk           ( cmos_pclk        ),
  .cmos_vsync          ( cmos_vsync       ),
  .cmos_herf           ( cmos_herf        ),
  .cmos_data           ( cmos_data        ),
  .cmos_cfg_done       ( config_done      ),

  .cmos_frame_vsync    ( cmos_frame_vsync ),
  .cmos_frame_herf     ( cmos_frame_herf  ),
  .cmos_frame_valid    ( cmos_frame_valid ),
  .cmos_frame_data     ( cmos_frame_data  )
);



////////////////////////////////////////////////////////
//////////////////////HDMI//////////////////////////////
////////////////////////////////////////////////////////

wire  [10:0]  pixel_xpos_w;
wire  [10:0]  pixel_ypos_w;
wire  [23:0]  pixel_data_w;

wire          video_hs;
wire          video_vs;
wire          video_de;
wire  [23:0]  video_rgb;

hdmi_clk inst_clk
 (
  // Clock out ports
  .clk5x    (clk5x  ),
  .clk_1x   (clk_1x ),//pixel clk 75M
  // Status and control signals
  .reset    (!rst_n ),
 // Clock in ports
  .clk_in1  (clk)
 );

 //例化视频显示驱动模块
video_driver u_video_driver(
    .pixel_clk      (clk_1x),
    .sys_rst_n      (rst_n),

    .video_hs       (video_hs),
    .video_vs       (video_vs),
    .video_de       (video_de),
    .video_rgb      (video_rgb),

    .pixel_xpos     (pixel_xpos_w),
    .pixel_ypos     (pixel_ypos_w),
    .pixel_data     (pixel_data_w)
    );

//例化视频显示模块
video_display  u_video_display(
    .pixel_clk      (clk_1x),
    .sys_rst_n      (rst_n),

    .pixel_xpos     (pixel_xpos_w),
    .pixel_ypos     (pixel_ypos_w),
    .pixel_data     (pixel_data_w)
    );
hdmi  hdmi(
    /* input                    */.clk_1x                       ( clk_1x       ), //system clock 50MHz
    /* input                    */.clk5x                        ( clk5x       ), //system clock 50MHz
    /* input                    */.rst_n                        ( rst_n     ), //reset, low valid
    /* input                    */.hsync                        ( video_hs     ),
    /* input                    */.vsync                        ( video_vs    ),
    /* input                    */.rgb_vlaid                    ( video_de ),
    /* input       [7:0]        */.red                          ( video_rgb[23:16]     ),
    /* input       [7:0]        */.blue                         ( video_rgb[15:8]     ),
    /* input       [7:0]        */.green                        ( video_rgb[7:0]     ),
    /* output                   */.clk_p                        ( HDMI_CLK_P     ),
    /* output                   */.clk_n                        ( HDMI_CLK_N     ),
    /* output                   */.red_p                        ( HDMI_DATA0_P   ),
    /* output                   */.red_n                        ( HDMI_DATA0_N   ),
    /* output                   */.blue_p                       ( HDMI_DATA1_P   ),
    /* output                   */.blue_n                       ( HDMI_DATA1_N   ),
    /* output                   */.green_p                      ( HDMI_DATA2_P   ),
    /* output                   */.green_n                      ( HDMI_DATA2_N   )   
);
//Module instantiations , self-build module
assign    cmos_rst_n = 1'b1;
assign    cmos_pwdn = 1'b0;
//assign    HDMI_OUT_EN = 1'b1;
//assign    HDMI_CEC    = 1'b1;
//assign    HDMI_HPD    = 1'b1;

//Logic Description


ila_1 your_instance_name (
	.clk(clk5x), // input wire clk

	.trig_in(1'b1),// input wire trig_in 
	.trig_in_ack(),// output wire trig_in_ack 
	.probe0(cmos_data), // input wire [7:0]  probe0  
	.probe1(video_rgb), // input wire [23:0]  probe1 
	.probe2(video_hs), // input wire [0:0]  probe2 
	.probe3(config_done), // input wire [0:0]  probe3 
	.probe4(video_de) // input wire [0:0]  probe4
); 

endmodule 