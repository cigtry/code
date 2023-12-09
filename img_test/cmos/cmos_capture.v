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
  input   wire                   rst_n  , //reset, low valid
  
  input   wire                   cmos_pclk,
  input   wire                   cmos_vsync,
  input   wire                   cmos_herf,
  input   wire        [7:0]      cmos_data,
  input   wire                   cmos_cfg_done,

  output  wire                   cmos_frame_valid,
  output  wire        [15:0]     cmos_frame_data
);
//Parameter Declarations


//Internal wire/reg declarations
  reg   [1:0]       cmos_vsync_r;
  reg   [1:0]       cmos_herf_r;
  reg   [15:0]      cmos_data_r;
  reg   [1:0]       cnt;
  reg               cmos_valid_r;

//Module instantiations , self-build module

//Logic Description

  
  always @(posedge cmos_pclk or negedge rst_n ) begin
    if(!rst_n)begin
      cmos_data_r <= 16'h00; 
    end
    else if(cmos_herf)begin
      cmos_data_r <= {cmos_data_r[7:0],cmos_data};
    end
    else begin
      cmos_data_r <= cmos_data_r;
    end
  end

  always @ (posedge cmos_pclk or negedge rst_n)begin 
    if(!rst_n)begin  
      cnt <= 2'b0;
    end  
    else if(cnt==2'd1)begin
      cnt <= 2'b0;
    end
    else if(cmos_cfg_done&&cmos_herf)begin  
      cnt <= cnt + 1'b1;
    end  
    else begin  
      cnt <= cnt;
    end  
  end //always end
  

  always @(posedge cmos_pclk or negedge rst_n) begin
    if(!rst_n)
      cmos_valid_r <= 1'b0;
    else if(cnt==2'd1)begin
     cmos_valid_r <=1'b1;
    end
    else begin
      cmos_valid_r <= 1'b0;
    end
  end

  assign    cmos_frame_valid  =cmos_valid_r;
  assign    cmos_frame_data =cmos_data_r;

endmodule 