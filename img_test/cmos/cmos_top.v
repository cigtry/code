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
module cmos_top(
  input   wire                   clk    , //system clock 50MHz
  input   wire                   rst_n  , //reset, low valid
  
  output  wire                   iic_scl,
  inout   wire                   iic_sda,
  output  wire                   config_done
);
//Parameter Declarations


//Internal wire/reg declarations
  wire          wr_done,write;
  wire  [23:0]  config_data;
//Module instantiations , self-build module
cmos_config  cmos_config(
  .clk             (clk), //system clock 50MHz
  .rst_n           (rst_n), //reset, low valid

  .wr_done         (wr_done),  
  .write           (write),
  .config_data     (config_data),

  .config_done     (config_done)
);

iic#(
  .IIC_PERIOD (250),
  .IIC_ADDR_BYTE  (2)//（寄存器地址有两个字节）
) iic(
  .clk              ( clk ), //system clock 50MHz
  .rst_n            ( rst_n ), //reset, low valid

  .iic_scl          ( iic_scl ),
  .iic_sda          ( iic_sda ),

  .iic_slave_addr   ( 7'h3c ),//从机地址
  .wr_address       ( config_data[23:8] ),//寄存器地址（分为多字节地址和单字节地址）
  
  .write            ( write ),
  .wr_data          ( config_data[7:0] ),
  .wr_done          ( wr_done ),

  .read             (  ),
  .rd_data          (  ),
  .rd_done          (  )

);
  
//Logic Description


endmodule 