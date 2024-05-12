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
module histEQ_proc#(
  parameter Index = 27,
  parameter Multiplier = 136957
)(
  input   wire                    clk              , //system clock 50MHz
  input   wire                    rst_n            , //reset, low valid
  
  input   wire                    pre_img_vsync    ,
  input   wire                    pre_img_hsync    ,
  input   wire    [07:00]         pre_img_gray     ,

  input  wire    [07:00]          pixel_level      ,
  input  wire    [20:00]          pixel_cnt_num    ,
  input  wire                     pixel_level_vld  ,
  output reg                      pixel_write_ok   ,

  output   wire                   post_img_vsync   ,
  output   wire                   post_img_hsync   ,
  output   wire    [07:00]        post_img_gray    
);
    //创建一个二维数组用于存储灰度级的个数
    reg  [20:00]    mem    [255:00];
    reg  [Index+7 : 00]   mult_result;
    reg  [20:00]    gray_data_reg;//存储映射的数据用于运算
    reg  [2:0]      img_vsync_r;
    reg  [2:0]      img_hsync_r;
    reg  [7:0]      img_gray_reg;//储存乘法的数据并四舍五入
    //帧头和帧尾
    reg         img_vsync_r1;
    wire        img_sop,img_eop;
    always @(posedge clk) begin
      img_vsync_r1  <= pre_img_vsync;
    end
    assign    img_sop =  !img_vsync_r1 & pre_img_vsync ;
    assign    img_eop =  img_vsync_r1 & !pre_img_vsync ;

    //将统计模块的数据存入数组里面
    integer i;
    always @ (posedge clk or negedge rst_n)begin 
      if(!rst_n)begin  
         for(i=0;i<256;i=i+1)begin
          mem[i] <= 20'b0;
        end
      end  
      else if( pixel_level_vld)begin  
        mem[pixel_level] <= pixel_cnt_num;
      end  
      else begin  
         mem[pixel_level] <= mem[pixel_level] ;
      end  
    end //always end
    
    always @ (posedge clk or negedge rst_n)begin 
      if(!rst_n)begin  
        pixel_write_ok <= 1'b0;
      end  
      else if((pixel_level == 255) && pixel_level_vld)begin  
        pixel_write_ok <= 1'b1;
      end  
      else begin  
        pixel_write_ok <= 1'b0;
      end  
    end //always end
    
    always @ (posedge clk or negedge rst_n)begin 
      if(!rst_n)begin  
        gray_data_reg <= 20'd0;
      end  
      else if(pre_img_vsync  &&  pre_img_hsync)begin  
        gray_data_reg <= mem[pre_img_gray];
      end  
      else begin  
        gray_data_reg <= gray_data_reg ;
      end  
    end //always end
    
    always @ (posedge clk or negedge rst_n)begin 
      if(!rst_n)begin  
        img_vsync_r <= 2'b0;
        img_hsync_r <= 2'b0;
      end  
      else begin  
        img_vsync_r <= {img_vsync_r[1:0], pre_img_vsync};
        img_hsync_r <= {img_hsync_r[1:0], pre_img_hsync};
      end  
    end //always end
    
    always @ (posedge clk or negedge rst_n)begin 
      if(!rst_n)begin  
        mult_result <= {Index+8{1'b0} };
      end  
      else if(img_vsync_r[0] && img_hsync_r[0])begin  
        mult_result <= gray_data_reg * Multiplier;
      end  
      else begin  
        mult_result <= mult_result;
      end  
    end //always end
    
    always @ (posedge clk or negedge rst_n)begin 
      if(!rst_n)begin  
        img_gray_reg <= 8'b0;
      end  
      else if(img_vsync_r[1] && img_hsync_r[1])begin  
        img_gray_reg <= mult_result[(Index+7)-:8] + mult_result[Index-1];
      end  
      else begin  
        img_gray_reg <= img_gray_reg;
      end  
    end //always end

    assign    post_img_gray =  img_gray_reg ;
    assign    post_img_vsync = img_vsync_r[2];
    assign    post_img_hsync = img_hsync_r[2];
endmodule 