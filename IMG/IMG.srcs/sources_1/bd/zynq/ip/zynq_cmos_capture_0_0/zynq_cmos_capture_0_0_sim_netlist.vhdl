-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Sat May 25 23:23:04 2024
-- Host        : cigtry running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               d:/DESKTOP/code/IMG/IMG.srcs/sources_1/bd/zynq/ip/zynq_cmos_capture_0_0/zynq_cmos_capture_0_0_sim_netlist.vhdl
-- Design      : zynq_cmos_capture_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity zynq_cmos_capture_0_0_cmos_capture is
  port (
    cmos_pclk_ce : out STD_LOGIC;
    cmos_frame_data : out STD_LOGIC_VECTOR ( 15 downto 0 );
    cmos_frame_herf : out STD_LOGIC;
    cmos_frame_vsync : out STD_LOGIC;
    sys_rst_n : in STD_LOGIC;
    cmos_pclk : in STD_LOGIC;
    cmos_herf : in STD_LOGIC;
    cmos_vsync : in STD_LOGIC;
    cmos_data : in STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of zynq_cmos_capture_0_0_cmos_capture : entity is "cmos_capture";
end zynq_cmos_capture_0_0_cmos_capture;

architecture STRUCTURE of zynq_cmos_capture_0_0_cmos_capture is
  signal cmos_cfg_done : STD_LOGIC;
  signal cmos_cfg_done_i_1_n_0 : STD_LOGIC;
  signal cmos_data_16b : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal cmos_data_16b0 : STD_LOGIC;
  signal \cmos_herf_r[1]_i_1_n_0\ : STD_LOGIC;
  signal cmos_valid_d : STD_LOGIC;
  signal cmos_valid_r : STD_LOGIC;
  signal cmos_valid_r_reg_n_0 : STD_LOGIC;
  signal \cmos_vsync_r_reg_n_0_[0]\ : STD_LOGIC;
  signal p_0_in : STD_LOGIC_VECTOR ( 1 to 1 );
  signal p_0_in0_in : STD_LOGIC;
  signal p_0_in_0 : STD_LOGIC;
  signal \p_0_in__0\ : STD_LOGIC_VECTOR ( 15 downto 8 );
  signal \p_0_in__1\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal rst_n : STD_LOGIC;
  signal sys_rst_n_d : STD_LOGIC;
  signal \wait_cnt0__0\ : STD_LOGIC;
  signal wait_cnt_reg : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \/i_\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \__0/i_\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of cmos_cfg_done_i_1 : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \cmos_frame_data[10]_INST_0\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \cmos_frame_data[11]_INST_0\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \cmos_frame_data[12]_INST_0\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \cmos_frame_data[13]_INST_0\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \cmos_frame_data[14]_INST_0\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \cmos_frame_data[15]_INST_0\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \cmos_frame_data[19]_INST_0\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \cmos_frame_data[20]_INST_0\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \cmos_frame_data[21]_INST_0\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \cmos_frame_data[22]_INST_0\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \cmos_frame_data[23]_INST_0\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \cmos_frame_data[3]_INST_0\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \cmos_frame_data[4]_INST_0\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \cmos_frame_data[5]_INST_0\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \cmos_frame_data[6]_INST_0\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \cmos_frame_data[7]_INST_0\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of cmos_frame_vsync_INST_0 : label is "soft_lutpair0";
begin
\/i_\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"20"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => cmos_valid_r_reg_n_0,
      I2 => cmos_herf,
      O => cmos_valid_r
    );
\__0/i_\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A2"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => p_0_in0_in,
      I2 => cmos_valid_d,
      O => cmos_pclk_ce
    );
cmos_cfg_done_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF0020"
    )
        port map (
      I0 => \cmos_vsync_r_reg_n_0_[0]\,
      I1 => p_0_in_0,
      I2 => wait_cnt_reg(0),
      I3 => wait_cnt_reg(1),
      I4 => cmos_cfg_done,
      O => cmos_cfg_done_i_1_n_0
    );
cmos_cfg_done_reg: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => '1',
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_cfg_done_i_1_n_0,
      Q => cmos_cfg_done
    );
\cmos_data_16b[15]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => cmos_valid_r_reg_n_0,
      O => cmos_data_16b0
    );
\cmos_data_16b_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => cmos_data_16b0,
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_data(0),
      Q => cmos_data_16b(0)
    );
\cmos_data_16b_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => cmos_data_16b0,
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => \p_0_in__0\(10),
      Q => cmos_data_16b(10)
    );
\cmos_data_16b_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => cmos_data_16b0,
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => \p_0_in__0\(11),
      Q => cmos_data_16b(11)
    );
\cmos_data_16b_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => cmos_data_16b0,
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => \p_0_in__0\(12),
      Q => cmos_data_16b(12)
    );
\cmos_data_16b_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => cmos_data_16b0,
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => \p_0_in__0\(13),
      Q => cmos_data_16b(13)
    );
\cmos_data_16b_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => cmos_data_16b0,
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => \p_0_in__0\(14),
      Q => cmos_data_16b(14)
    );
\cmos_data_16b_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => cmos_data_16b0,
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => \p_0_in__0\(15),
      Q => cmos_data_16b(15)
    );
\cmos_data_16b_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => cmos_data_16b0,
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_data(1),
      Q => cmos_data_16b(1)
    );
\cmos_data_16b_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => cmos_data_16b0,
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_data(2),
      Q => cmos_data_16b(2)
    );
\cmos_data_16b_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => cmos_data_16b0,
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_data(3),
      Q => cmos_data_16b(3)
    );
\cmos_data_16b_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => cmos_data_16b0,
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_data(4),
      Q => cmos_data_16b(4)
    );
\cmos_data_16b_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => cmos_data_16b0,
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_data(5),
      Q => cmos_data_16b(5)
    );
\cmos_data_16b_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => cmos_data_16b0,
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_data(6),
      Q => cmos_data_16b(6)
    );
\cmos_data_16b_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => cmos_data_16b0,
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_data(7),
      Q => cmos_data_16b(7)
    );
\cmos_data_16b_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => cmos_data_16b0,
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => \p_0_in__0\(8),
      Q => cmos_data_16b(8)
    );
\cmos_data_16b_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => cmos_data_16b0,
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => \p_0_in__0\(9),
      Q => cmos_data_16b(9)
    );
\cmos_data_r_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => '1',
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_data(0),
      Q => \p_0_in__0\(8)
    );
\cmos_data_r_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => '1',
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_data(1),
      Q => \p_0_in__0\(9)
    );
\cmos_data_r_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => '1',
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_data(2),
      Q => \p_0_in__0\(10)
    );
\cmos_data_r_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => '1',
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_data(3),
      Q => \p_0_in__0\(11)
    );
\cmos_data_r_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => '1',
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_data(4),
      Q => \p_0_in__0\(12)
    );
\cmos_data_r_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => '1',
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_data(5),
      Q => \p_0_in__0\(13)
    );
\cmos_data_r_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => '1',
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_data(6),
      Q => \p_0_in__0\(14)
    );
\cmos_data_r_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => '1',
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_data(7),
      Q => \p_0_in__0\(15)
    );
\cmos_frame_data[10]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => cmos_data_16b(5),
      O => cmos_frame_data(5)
    );
\cmos_frame_data[11]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => cmos_data_16b(6),
      O => cmos_frame_data(6)
    );
\cmos_frame_data[12]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => cmos_data_16b(7),
      O => cmos_frame_data(7)
    );
\cmos_frame_data[13]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => cmos_data_16b(8),
      O => cmos_frame_data(8)
    );
\cmos_frame_data[14]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => cmos_data_16b(9),
      O => cmos_frame_data(9)
    );
\cmos_frame_data[15]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => cmos_data_16b(10),
      O => cmos_frame_data(10)
    );
\cmos_frame_data[19]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => cmos_data_16b(11),
      O => cmos_frame_data(11)
    );
\cmos_frame_data[20]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => cmos_data_16b(12),
      O => cmos_frame_data(12)
    );
\cmos_frame_data[21]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => cmos_data_16b(13),
      O => cmos_frame_data(13)
    );
\cmos_frame_data[22]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => cmos_data_16b(14),
      O => cmos_frame_data(14)
    );
\cmos_frame_data[23]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => cmos_data_16b(15),
      O => cmos_frame_data(15)
    );
\cmos_frame_data[3]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => cmos_data_16b(0),
      O => cmos_frame_data(0)
    );
\cmos_frame_data[4]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => cmos_data_16b(1),
      O => cmos_frame_data(1)
    );
\cmos_frame_data[5]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => cmos_data_16b(2),
      O => cmos_frame_data(2)
    );
\cmos_frame_data[6]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => cmos_data_16b(3),
      O => cmos_frame_data(3)
    );
\cmos_frame_data[7]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => cmos_data_16b(4),
      O => cmos_frame_data(4)
    );
cmos_frame_valid_INST_0: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => p_0_in0_in,
      O => cmos_frame_herf
    );
cmos_frame_vsync_INST_0: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cmos_cfg_done,
      I1 => p_0_in_0,
      O => cmos_frame_vsync
    );
\cmos_herf_r[1]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => rst_n,
      O => \cmos_herf_r[1]_i_1_n_0\
    );
\cmos_herf_r_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => '1',
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_herf,
      Q => p_0_in(1)
    );
\cmos_herf_r_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => '1',
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => p_0_in(1),
      Q => p_0_in0_in
    );
cmos_valid_d_reg: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => '1',
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_valid_r_reg_n_0,
      Q => cmos_valid_d
    );
cmos_valid_r_reg: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => '1',
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_valid_r,
      Q => cmos_valid_r_reg_n_0
    );
\cmos_vsync_r_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => '1',
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => cmos_vsync,
      Q => \cmos_vsync_r_reg_n_0_[0]\
    );
\cmos_vsync_r_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => '1',
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => \cmos_vsync_r_reg_n_0_[0]\,
      Q => p_0_in_0
    );
rst_n_reg: unisim.vcomponents.FDRE
     port map (
      C => cmos_pclk,
      CE => '1',
      D => sys_rst_n_d,
      Q => rst_n,
      R => '0'
    );
sys_rst_n_d_reg: unisim.vcomponents.FDRE
     port map (
      C => cmos_pclk,
      CE => '1',
      D => sys_rst_n,
      Q => sys_rst_n_d,
      R => '0'
    );
wait_cnt0: unisim.vcomponents.LUT3
    generic map(
      INIT => X"04"
    )
        port map (
      I0 => p_0_in_0,
      I1 => \cmos_vsync_r_reg_n_0_[0]\,
      I2 => wait_cnt_reg(1),
      O => \wait_cnt0__0\
    );
\wait_cnt[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => wait_cnt_reg(0),
      O => \p_0_in__1\(0)
    );
\wait_cnt_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => \wait_cnt0__0\,
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => \p_0_in__1\(0),
      Q => wait_cnt_reg(0)
    );
\wait_cnt_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => cmos_pclk,
      CE => \wait_cnt0__0\,
      CLR => \cmos_herf_r[1]_i_1_n_0\,
      D => wait_cnt_reg(0),
      Q => wait_cnt_reg(1)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity zynq_cmos_capture_0_0 is
  port (
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
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of zynq_cmos_capture_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of zynq_cmos_capture_0_0 : entity is "zynq_cmos_capture_0_0,cmos_capture,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of zynq_cmos_capture_0_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of zynq_cmos_capture_0_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of zynq_cmos_capture_0_0 : entity is "cmos_capture,Vivado 2018.3";
end zynq_cmos_capture_0_0;

architecture STRUCTURE of zynq_cmos_capture_0_0 is
  signal \<const0>\ : STD_LOGIC;
  signal \^cmos_frame_data\ : STD_LOGIC_VECTOR ( 23 downto 3 );
  signal \^cmos_frame_herf\ : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of sys_rst_n : signal is "xilinx.com:signal:reset:1.0 sys_rst_n RST";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of sys_rst_n : signal is "XIL_INTERFACENAME sys_rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0";
begin
  cmos_frame_data(23 downto 19) <= \^cmos_frame_data\(23 downto 19);
  cmos_frame_data(18) <= \<const0>\;
  cmos_frame_data(17) <= \<const0>\;
  cmos_frame_data(16) <= \<const0>\;
  cmos_frame_data(15 downto 10) <= \^cmos_frame_data\(15 downto 10);
  cmos_frame_data(9) <= \<const0>\;
  cmos_frame_data(8) <= \<const0>\;
  cmos_frame_data(7 downto 3) <= \^cmos_frame_data\(7 downto 3);
  cmos_frame_data(2) <= \<const0>\;
  cmos_frame_data(1) <= \<const0>\;
  cmos_frame_data(0) <= \<const0>\;
  cmos_frame_herf <= \^cmos_frame_herf\;
  cmos_frame_valid <= \^cmos_frame_herf\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
inst: entity work.zynq_cmos_capture_0_0_cmos_capture
     port map (
      cmos_data(7 downto 0) => cmos_data(7 downto 0),
      cmos_frame_data(15 downto 11) => \^cmos_frame_data\(23 downto 19),
      cmos_frame_data(10 downto 5) => \^cmos_frame_data\(15 downto 10),
      cmos_frame_data(4 downto 0) => \^cmos_frame_data\(7 downto 3),
      cmos_frame_herf => \^cmos_frame_herf\,
      cmos_frame_vsync => cmos_frame_vsync,
      cmos_herf => cmos_herf,
      cmos_pclk => cmos_pclk,
      cmos_pclk_ce => cmos_pclk_ce,
      cmos_vsync => cmos_vsync,
      sys_rst_n => sys_rst_n
    );
end STRUCTURE;
