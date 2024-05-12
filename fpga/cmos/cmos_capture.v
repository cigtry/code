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
  input   wire                   rst_n  , //reset, low valid
  
  input   wire                   cmos_pclk,
  input   wire                   cmos_vsync,
  input   wire                   cmos_herf,
  input   wire        [7:0]      cmos_data,
  input   wire                   cmos_cfg_done,

  output  wire        [23:0]     cmos_frame_data,
  output  reg                    cmos_frame_valid,
  output  reg                    cmos_frame_sop,//帧头，与第一个数据对齐
  output  reg                    cmos_frame_eop//帧尾，与最后一个数据对齐
);

  parameter  H_DISP   =  11'd1280; //行有效数据
  parameter  V_DISP   =  11'd720;  //场有效数据

  reg               cmos_herf_r;
  reg               cmos_vsync_r;
  wire              cmos_vsync_neg;
  reg               data_capture_flag;
  reg    [11:0]     cnt_herf;
  reg    [9:0]      cnt_vsync;
  reg    [15:0]     cmos_data_r;

//检测到场同步信号的下降沿开始采集信号
  always @(posedge cmos_pclk) begin
    cmos_vsync_r <= cmos_vsync;
  end
  assign     cmos_vsync_neg  = (!cmos_vsync) &  cmos_vsync_r ;


  always @(posedge cmos_pclk or negedge rst_n)begin
    if(!rst_n)
      cnt_herf <= 12'd0;
    else if(cmos_vsync_neg)
      cnt_herf <= 12'd0;
    else if(cnt_herf == H_DISP - 1'b1)
      cnt_herf <= 12'd0;
    else if(data_capture_flag && cmos_herf)
      cnt_herf <= cnt_herf + 1'b1;
    else
      cnt_herf <= cnt_herf ;
  end

  always @(posedge cmos_pclk or negedge rst_n)begin
    if(!rst_n)
      cnt_vsync <= 10'd0;
    else if(cnt_vsync == V_DISP - 1'b1)
      cnt_vsync <= 10'd0;
    else if(cnt_herf == H_DISP - 1'b1)
      cnt_vsync <= cnt_vsync + 1'b1;
    else
      cnt_vsync <= cnt_vsync;
  end

  always @(posedge cmos_pclk or negedge rst_n) begin
    if(!rst_n)
      data_capture_flag <= 1'b0;
    else if(cnt_herf == H_DISP - 1'b1)
      data_capture_flag <= 1'b0;
    else if(cmos_vsync_neg)
      data_capture_flag <= 1'b1;
    else
      data_capture_flag <= data_capture_flag;
  end

  always @(posedge cmos_pclk or negedge rst_n) begin
    if(!rst_n)
      cmos_data_r <= 16'h00;
    else if(data_capture_flag && cmos_herf )
      cmos_data_r <= {cmos_data_r[7:0] , cmos_data};
    else
      cmos_data_r <= cmos_data_r;
  end

  always @ (posedge cmos_pclk or negedge rst_n)begin 
    if(!rst_n)begin  
      cmos_frame_valid <= 1'b0;
    end  
    else if(cnt_herf[0])begin  
      cmos_frame_valid <= 1'b1;
    end  
    else begin  
      cmos_frame_valid <= 1'b0;
    end  
  end //always end
  
  always @ (posedge cmos_pclk or negedge rst_n)begin 
    if(!rst_n)begin  
      cmos_frame_sop <= 1'b0;
    end  
    else if(cnt_herf == 1'b1)begin  
      cmos_frame_sop <= 1'b1;
    end  
    else begin  
      cmos_frame_sop <= 1'b0;
    end  
  end //always end

  always @ (posedge cmos_pclk or negedge rst_n)begin 
    if(!rst_n)begin  
      cmos_frame_eop <= 1'b0;
    end  
    else if((cnt_herf == H_DISP - 1'b1) && (cnt_vsync == V_DISP - 1'b1) )begin  
      cmos_frame_eop <= 1'b1;
    end  
    else begin  
      cmos_frame_eop <= 1'b0;
    end  
  end //always end
  
  assign     cmos_frame_data =  {cmos_data_r[15:11],3'b0,cmos_data_r[10:5],2'b0,cmos_data_r[4:0],3'b0};
endmodule 