// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Sun Jun 25 21:56:21 2023
// Host        : DESKTOP-TLMK02R running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               g:/code/airmt/project_1.srcs/sources_1/ip/fifo_generator_804b/fifo_generator_804b_stub.v
// Design      : fifo_generator_804b
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx690tffg1761-3
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_5,Vivado 2020.1" *)
module fifo_generator_804b(clk, srst, din, wr_en, rd_en, dout, full, empty)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[803:0],wr_en,rd_en,dout[803:0],full,empty" */;
  input clk;
  input srst;
  input [803:0]din;
  input wr_en;
  input rd_en;
  output [803:0]dout;
  output full;
  output empty;
endmodule
