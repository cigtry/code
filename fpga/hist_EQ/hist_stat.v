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
module hist_stat(
  input   wire                    clk             , //system clock 50MHz
  input   wire                    rst_n           , //reset, low valid
  
  input   wire                    pre_img_vsync   ,
  input   wire                    pre_img_hsync   ,
  input   wire    [07:00]         pre_img_gray    ,

  output  reg     [07:00]         pixel_level_data,
  output  reg     [20:00]         pixel_cnt_num   ,
  output  reg                     pixel_level_vld
);
    //创建一个二维数组用于累积灰度级的个数
    reg  [20:00]    mem    [255:00];
    reg  [07:00]         pixel_level;
    //帧头和帧尾
    reg         img_vsync_r1;
    wire        img_sop,img_eop;
    always @(posedge clk) begin
      img_vsync_r1  <= pre_img_vsync;
    end
    assign    img_sop =  !img_vsync_r1 & pre_img_vsync ;
    assign    img_eop =  img_vsync_r1 & !pre_img_vsync ;

    reg     stat_end_flag;//一帧图像统计完成标志，在统计完成后置1，将统计数据发送完成后置0；
    reg     stat_end_flag_r;
    wire    neg_stat_end_flag;

    always @ (posedge clk or negedge rst_n)begin 
      if(!rst_n)begin  
        stat_end_flag_r <=1'b0;
      end  
      else begin  
        stat_end_flag_r <= stat_end_flag;
      end  
    end //always end

    assign    neg_stat_end_flag = !stat_end_flag  & stat_end_flag_r;

    //初始化数组，在数据有效时开始统计
    integer i;
    always @(posedge clk or negedge rst_n) begin
      if(!rst_n ||  neg_stat_end_flag )begin
        for(i=0;i<256;i=i+1)begin
          mem[i] <= 20'b0;
        end
      end
      else if(pre_img_hsync)begin
        mem[pre_img_gray] <= mem[pre_img_gray] + 1'b1;
      end
      else begin
        mem[pre_img_gray] <= mem[pre_img_gray];
      end
    end

    always @ (posedge clk or negedge rst_n)begin 
      if(!rst_n)begin  
        stat_end_flag <= 1'b0;
      end  
      else if(pixel_level == 8'd255)begin  
        stat_end_flag <= 1'b0;
      end  
      else if(img_eop)begin
        stat_end_flag <= 1'b1;
      end
      else begin  
        stat_end_flag <= stat_end_flag;
      end  
    end //always end

    always @ (posedge clk or negedge rst_n)begin 
      if(!rst_n)begin  
        pixel_level <= 8'd0;
      end  
      else if(stat_end_flag)begin  
        pixel_level <= pixel_level + 1'b1;
      end  
      else begin  
        pixel_level <= 8'd0;
      end  
    end //always end

    always @ (posedge clk or negedge rst_n)begin 
      if(!rst_n)begin  
        pixel_cnt_num <= 21'b0;
      end  
      else if(stat_end_flag)begin  
        pixel_cnt_num <= pixel_cnt_num + mem[pixel_level];
      end  
      else begin  
        pixel_cnt_num <= 21'b0;
      end  
    end //always end

    always @ (posedge clk or negedge rst_n)begin 
      if(!rst_n)begin  
        pixel_level_vld <= 1'b0;
      end  
      else if(stat_end_flag)begin  
        pixel_level_vld <= 1'b1;
      end  
      else begin  
        pixel_level_vld <= 1'b0;
      end  
    end //always end

    always @ (posedge clk or negedge rst_n)begin 
      if(!rst_n)begin  
        pixel_level_data <= 8'd0;
      end  
      else begin  
        pixel_level_data <= pixel_level;
      end  
    end //always end

endmodule 