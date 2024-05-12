-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Mon Apr 22 13:57:46 2024
-- Host        : fy7245m220402 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/Users/maccura/Desktop/DIP/IMG/IMG.srcs/sources_1/bd/zynq/ip/zynq_vga2hdmi_0_1/zynq_vga2hdmi_0_1_stub.vhdl
-- Design      : zynq_vga2hdmi_0_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity zynq_vga2hdmi_0_1 is
  Port ( 
    clk_1x : in STD_LOGIC;
    clk_5x : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    hsync : in STD_LOGIC;
    vsync : in STD_LOGIC;
    rgb_vlaid : in STD_LOGIC;
    rgb_data : in STD_LOGIC_VECTOR ( 23 downto 0 );
    tmds_clk_p : out STD_LOGIC;
    tmds_clk_n : out STD_LOGIC;
    tmds_data_p : out STD_LOGIC_VECTOR ( 2 downto 0 );
    tmds_data_n : out STD_LOGIC_VECTOR ( 2 downto 0 )
  );

end zynq_vga2hdmi_0_1;

architecture stub of zynq_vga2hdmi_0_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_1x,clk_5x,rst_n,hsync,vsync,rgb_vlaid,rgb_data[23:0],tmds_clk_p,tmds_clk_n,tmds_data_p[2:0],tmds_data_n[2:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vga2hdmi,Vivado 2018.3";
begin
end;
