// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1_AR72614 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Mon Nov 21 15:20:34 2022
// Host        : littleoakhorn.dhcp.lbl.gov running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub /home/loic/YARR-FW/ip-cores/kintex7/fifo_32x32/fifo_32x32_stub.v
// Design      : fifo_32x32
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tfbg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_4,Vivado 2019.1_AR72614" *)
module fifo_32x32(clk, srst, din, wr_en, rd_en, dout, full, empty, 
  almost_empty)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[31:0],wr_en,rd_en,dout[31:0],full,empty,almost_empty" */;
  input clk;
  input srst;
  input [31:0]din;
  input wr_en;
  input rd_en;
  output [31:0]dout;
  output full;
  output empty;
  output almost_empty;
endmodule
