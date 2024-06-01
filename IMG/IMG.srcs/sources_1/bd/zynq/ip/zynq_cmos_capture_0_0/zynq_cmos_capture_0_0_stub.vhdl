-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Sat May 25 23:23:04 2024
-- Host        : cigtry running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               d:/DESKTOP/code/IMG/IMG.srcs/sources_1/bd/zynq/ip/zynq_cmos_capture_0_0/zynq_cmos_capture_0_0_stub.vhdl
-- Design      : zynq_cmos_capture_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity zynq_cmos_capture_0_0 is
  Port ( 
    sys_rst_n : in STD_LOGIC;
    cmos_pclk : in STD_LOGIC;
    cmos_vsync : in STD_LOGIC;
    cmos_herf : in STD_LOGIC;
    cmos_data : in STD_LOGIC_VECTOR ( 7 downto 0 );
    cmos_pclk_ce : out STD_LOGIC;
    cmos_frame_vsync : out STD_LOGIC;
    cmos_frame_herf : out STD_LOGIC;
    cmos_frame_valid : out STD_LOGIC;
    cmos_frame_data : out STD_LOGIC_VECTOR ( 23 downto 0 )
  );

end zynq_cmos_capture_0_0;

architecture stub of zynq_cmos_capture_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "sys_rst_n,cmos_pclk,cmos_vsync,cmos_herf,cmos_data[7:0],cmos_pclk_ce,cmos_frame_vsync,cmos_frame_herf,cmos_frame_valid,cmos_frame_data[23:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "cmos_capture,Vivado 2018.3";
begin
end;
