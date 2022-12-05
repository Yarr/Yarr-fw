-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1_AR72614 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
-- Date        : Mon Nov 21 15:20:34 2022
-- Host        : littleoakhorn.dhcp.lbl.gov running 64-bit unknown
-- Command     : write_vhdl -force -mode synth_stub /home/loic/YARR-FW/ip-cores/kintex7/fifo_32x32/fifo_32x32_stub.vhdl
-- Design      : fifo_32x32
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k160tfbg676-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fifo_32x32 is
  Port ( 
    clk : in STD_LOGIC;
    srst : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
    full : out STD_LOGIC;
    empty : out STD_LOGIC;
    almost_empty : out STD_LOGIC
  );

end fifo_32x32;

architecture stub of fifo_32x32 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,srst,din[31:0],wr_en,rd_en,dout[31:0],full,empty,almost_empty";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "fifo_generator_v13_2_4,Vivado 2019.1_AR72614";
begin
end;
