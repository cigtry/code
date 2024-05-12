-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Mon Apr 22 16:35:36 2024
-- Host        : fy7245m220402 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top zynq_clk_wiz_0_1 -prefix
--               zynq_clk_wiz_0_1_ zynq_clk_wiz_0_1_stub.vhdl
-- Design      : zynq_clk_wiz_0_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity zynq_clk_wiz_0_1 is
  Port ( 
    clk_1x : out STD_LOGIC;
    clk_5x : out STD_LOGIC;
    resetn : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end zynq_clk_wiz_0_1;

architecture stub of zynq_clk_wiz_0_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_1x,clk_5x,resetn,locked,clk_in1";
begin
end;
