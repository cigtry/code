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
module cmos_capture(
  //input   wire                   clk    , //system clock 50MHz
  input  wire                                    sys_rst_n       ,//reset, low valid
  
  input  wire                                    cmos_pclk       ,
  input  wire                                    cmos_vsync      ,
  input  wire                                    cmos_herf       ,
  input  wire    [   7: 0]                       cmos_data       ,


  output wire                                    cmos_pclk_ce    ,
  output wire                                    cmos_frame_vsync,
  output wire                                    cmos_frame_herf ,
  output wire                                    cmos_frame_valid,
  output wire    [  23: 0]                       cmos_frame_data  
);
//Parameter Declarations


//Internal wire/reg declarations
  reg            [   1: 0]                       cmos_vsync_r    ;
  wire                                           pos_vsync       ;
  assign                                             pos_vsync      = cmos_vsync_r[0]&& !cmos_vsync_r[1];
  reg            [   1: 0]                       cmos_herf_r     ;
  reg            [   7: 0]                       cmos_data_r     ;
  reg            [  15: 0]                       cmos_data_16b   ;
  reg                                            cmos_valid_r    ;
  reg                                            sys_rst_n_d     ;
  reg                                            rst_n           ;
  reg                                            cmos_cfg_done   ;
  reg            [  03:00]                       wait_cnt        ;
  localparam                                         WAIT_FRAM      = 4'd1  ;
  always @(posedge cmos_pclk or negedge rst_n ) begin
    if(!rst_n)begin
      wait_cnt <= 16'h00;
    end
    else if(wait_cnt <= WAIT_FRAM && pos_vsync)begin
      wait_cnt <= wait_cnt + 1'b1;
    end
    else begin
      wait_cnt <= wait_cnt;
    end
  end

  always @(posedge cmos_pclk or negedge rst_n ) begin
    if(!rst_n)begin
      cmos_cfg_done <= 16'h00;
    end
    else if(wait_cnt == WAIT_FRAM && pos_vsync)begin
      cmos_cfg_done <= 1'b1;
    end
    else begin
      cmos_cfg_done <= cmos_cfg_done;
    end
  end
  



//Module instantiations , self-build module
  always @(posedge cmos_pclk )begin
    sys_rst_n_d <= sys_rst_n;
    rst_n <= sys_rst_n_d;
  end
//Logic Description
  always @(posedge cmos_pclk or negedge rst_n) begin
    if(!rst_n)begin
      cmos_vsync_r<=2'b0;
      cmos_herf_r <= 2'b0;
    end
    else begin
      cmos_vsync_r <= {cmos_vsync_r[0],cmos_vsync};
      cmos_herf_r <= {cmos_herf_r[0],cmos_herf};
    end
  end
  
    always @(posedge cmos_pclk or negedge rst_n ) begin
    if(!rst_n)begin
      cmos_data_r <= 16'h00;
    end
    else begin
      cmos_data_r <= cmos_data;
    end
  end
  always @(posedge cmos_pclk or negedge rst_n ) begin
    if(!rst_n)begin
      cmos_data_16b <= 16'h00;
    end
    else if(cmos_cfg_done&&cmos_valid_r)begin
      cmos_data_16b <= {cmos_data_r,cmos_data};
    end
    else begin
      cmos_data_16b <= cmos_data_16b;
    end
  end



  always @(posedge cmos_pclk or negedge rst_n) begin
    if(!rst_n)
      cmos_valid_r <= 1'b0;
    else if(cmos_cfg_done&&cmos_herf)begin
      cmos_valid_r <= !cmos_valid_r;
    end
    else begin
      cmos_valid_r <= 1'b0;
    end
  end
  reg             cmos_valid_d;
  always @(posedge cmos_pclk or negedge rst_n) begin
    if(!rst_n)
    cmos_valid_d <= 1'b0;
    else begin
      cmos_valid_d <= cmos_valid_r;
    end
  end
  assign                                             cmos_frame_vsync= cmos_cfg_done ? cmos_vsync_r[1] : 1'b0;
  assign                                             cmos_frame_herf= cmos_cfg_done ?cmos_herf_r[1] : 1'b0;
  assign                                             cmos_frame_valid= cmos_frame_herf;
  assign                                             cmos_frame_data= cmos_cfg_done ?{cmos_data_16b[15:11],3'b0,cmos_data_16b[10:5],2'b0,cmos_data_16b[4:0],3'b0} : 24'h0;
  assign                                             cmos_pclk_ce   = cmos_cfg_done ?( (cmos_valid_d & cmos_frame_herf) || (!cmos_frame_herf) ): 1'b0;
endmodule