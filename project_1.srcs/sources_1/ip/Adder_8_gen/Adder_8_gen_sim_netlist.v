// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Sun Jun 25 22:04:25 2023
// Host        : DESKTOP-TLMK02R running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               g:/code/airmt/project_1.srcs/sources_1/ip/Adder_8_gen/Adder_8_gen_sim_netlist.v
// Design      : Adder_8_gen
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7vx690tffg1761-3
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "Adder_8_gen,c_addsub_v12_0_14,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_addsub_v12_0_14,Vivado 2020.1" *) 
(* NotValidForBitStream *)
module Adder_8_gen
   (A,
    B,
    CLK,
    S);
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [7:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [7:0]B;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF s_intf:c_out_intf:sinit_intf:sset_intf:bypass_intf:c_in_intf:add_intf:b_intf:a_intf, ASSOCIATED_RESET SCLR, ASSOCIATED_CLKEN CE, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:data:1.0 s_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME s_intf, LAYERED_METADATA undef" *) output [7:0]S;

  wire [7:0]A;
  wire [7:0]B;
  wire CLK;
  wire [7:0]S;
  wire NLW_U0_C_OUT_UNCONNECTED;

  (* C_AINIT_VAL = "0" *) 
  (* C_BORROW_LOW = "1" *) 
  (* C_CE_OVERRIDES_BYPASS = "1" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_IMPLEMENTATION = "0" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "virtex7" *) 
  (* KEEP_HIERARCHY = "soft" *) 
  (* c_a_type = "0" *) 
  (* c_a_width = "8" *) 
  (* c_add_mode = "0" *) 
  (* c_b_constant = "0" *) 
  (* c_b_type = "0" *) 
  (* c_b_value = "00000000" *) 
  (* c_b_width = "8" *) 
  (* c_bypass_low = "0" *) 
  (* c_has_bypass = "0" *) 
  (* c_has_c_in = "0" *) 
  (* c_has_c_out = "0" *) 
  (* c_latency = "1" *) 
  (* c_out_width = "8" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  Adder_8_gen_c_addsub_v12_0_14 U0
       (.A(A),
        .ADD(1'b1),
        .B(B),
        .BYPASS(1'b0),
        .CE(1'b1),
        .CLK(CLK),
        .C_IN(1'b0),
        .C_OUT(NLW_U0_C_OUT_UNCONNECTED),
        .S(S),
        .SCLR(1'b0),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule

(* C_ADD_MODE = "0" *) (* C_AINIT_VAL = "0" *) (* C_A_TYPE = "0" *) 
(* C_A_WIDTH = "8" *) (* C_BORROW_LOW = "1" *) (* C_BYPASS_LOW = "0" *) 
(* C_B_CONSTANT = "0" *) (* C_B_TYPE = "0" *) (* C_B_VALUE = "00000000" *) 
(* C_B_WIDTH = "8" *) (* C_CE_OVERRIDES_BYPASS = "1" *) (* C_CE_OVERRIDES_SCLR = "0" *) 
(* C_HAS_BYPASS = "0" *) (* C_HAS_CE = "0" *) (* C_HAS_C_IN = "0" *) 
(* C_HAS_C_OUT = "0" *) (* C_HAS_SCLR = "0" *) (* C_HAS_SINIT = "0" *) 
(* C_HAS_SSET = "0" *) (* C_IMPLEMENTATION = "0" *) (* C_LATENCY = "1" *) 
(* C_OUT_WIDTH = "8" *) (* C_SCLR_OVERRIDES_SSET = "1" *) (* C_SINIT_VAL = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "virtex7" *) (* ORIG_REF_NAME = "c_addsub_v12_0_14" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module Adder_8_gen_c_addsub_v12_0_14
   (A,
    B,
    CLK,
    ADD,
    C_IN,
    CE,
    BYPASS,
    SCLR,
    SSET,
    SINIT,
    C_OUT,
    S);
  input [7:0]A;
  input [7:0]B;
  input CLK;
  input ADD;
  input C_IN;
  input CE;
  input BYPASS;
  input SCLR;
  input SSET;
  input SINIT;
  output C_OUT;
  output [7:0]S;

  wire \<const0> ;
  wire [7:0]A;
  wire [7:0]B;
  wire CLK;
  wire [7:0]S;
  wire NLW_xst_addsub_C_OUT_UNCONNECTED;

  assign C_OUT = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_AINIT_VAL = "0" *) 
  (* C_BORROW_LOW = "1" *) 
  (* C_CE_OVERRIDES_BYPASS = "1" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_IMPLEMENTATION = "0" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "virtex7" *) 
  (* KEEP_HIERARCHY = "soft" *) 
  (* c_a_type = "0" *) 
  (* c_a_width = "8" *) 
  (* c_add_mode = "0" *) 
  (* c_b_constant = "0" *) 
  (* c_b_type = "0" *) 
  (* c_b_value = "00000000" *) 
  (* c_b_width = "8" *) 
  (* c_bypass_low = "0" *) 
  (* c_has_bypass = "0" *) 
  (* c_has_c_in = "0" *) 
  (* c_has_c_out = "0" *) 
  (* c_latency = "1" *) 
  (* c_out_width = "8" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  Adder_8_gen_c_addsub_v12_0_14_viv xst_addsub
       (.A(A),
        .ADD(1'b0),
        .B(B),
        .BYPASS(1'b0),
        .CE(1'b0),
        .CLK(CLK),
        .C_IN(1'b0),
        .C_OUT(NLW_xst_addsub_C_OUT_UNCONNECTED),
        .S(S),
        .SCLR(1'b0),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2020.1"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
EJFZwtxl4g9/OL6+bopUV8BP4e67HNukCIy7Ih3E75y7soa6GhqEucPXMiOy+mJrcrNwD+HjZ0/I
BwEKIiA4mA==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
rZCGWdmPJXoOuANoS8fyUXk7SyF+uTNJL18BfeKc+fxcyRrCB++WrM02adxoUdICz4/92yY8TQgj
xyPC0eaHZcjSLepbnHHgSReIQ1PL0hmufLbye7QTD0ygUXC4MvFVY8s3KeW9cPCqOxkyCSziJQzs
J5OT9XLQno1e9rIBr9M=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
I7Zo4frj3tO6FFzeDhpSENS0yd34dQZBtiyIrI/GMASFBUeny6muOD2l0HK69ImRJIOyobvK1+9O
DhxptAc4NzRpY4xUZvr4ix1AhM1Kars1OkrQCWz4a7ciGU/XDblidF3IL0Fa7c41gHIZR9c/Usa6
XL7UEu3aSPQYbZLSDOzeao4VtSSn+dCcjsH4X8zVjSqXg8dcN3fd5C15JaMYg00F2yOFtxwWwZWq
Yvwe1q1PG/wcA1cKAOscANbj4o3O4LjfylNIB6L+Mssxosh+e0+oobWNk/ouBa4k1c3/IzXGSCAs
hEvbI+iqkWJJKZrSb9PZk7S7XSJcScrJO/DGkQ==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
DDRecdVJcCPEpbUqhuwKtKWXteF7XhGc5d+lQn2uiREzbHyuZvQ1wDwAGGrPwE75gjqc7CdHPMOY
8+3nqcEwR4Q5USgQcou3Cyc6C0TnzzDD/dLKPHDWA1s52x8Rx+LBH9WCvBpD5BKkE4o1s3rN1tL2
wTdCqzzKD8YlryKQ4U0lr2bX6Mlf4/nIt2K1eyPKbIrHIvKDThmaIF/qLnLnkE04pksWJ9Af1OVB
46iqBssrR5p6wZc241D4CqSRCRamfP/s1JrTi8bBNCcXhC0f0Aa35UAoG8vnFngHlFd3G2J88cas
Fo7UH4k1BTTfgbQ35ec0XfSbS/qQWS+EgAF+wA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
L11p2bsABDhO9HvT3IM+HulCClFvs/UPexuAVExicKtzrLN7tNvUjSouZSn9KwAjR2hg5ZIJ23uy
1elB+eyEl65vQnoH4+s6Q5K4EIcMo5WVKfIKwgu5Q3Sg/jYW+aWT/kGuc7CazRsTxJ7XPFndpMIM
cxYWx2DLps320t+Be0c=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Uublhc2r9VmPPq1tMATsd3XJltn9QRg1/PdCtSlxgFBDDAk13md52Fz+h+DOWptR3Q4i+Sx5IhIP
QIONVNTf1DnoK/wa1lkbd1dROJam8/cZQFiIxnsnSPGXzOGoc0c04xDSCJCCDxiDMF1YTtAqt6nw
yZh1RwOhPpgwUKjeJ4o4TY6/i0xuYAYVc83O6KwI9Ywk9UsfyIQQS8UXFo8zA9eniU2n2NcyAVNj
Y8xZ9PYJfzfDo6dHWsj4Ik588uhfO/bmsf2/ZuY5HCAMQpnda9XzPkVomNjRfsUghko7KipIl2ur
aHh+4i2kI/+cHaihhw3z14aGidBkuYKaopasbA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
VYqlyQSuRywWcSrUprXX2UzoaWsJXTTbptzDY9ycgFR91H2uYfY43f80gn0E87Gvj90Qmn0Dl6ck
2VjO2Zn9yATmqtuzi/Etuf29dkl3uyKtk02OitZJEhD1CDyUJHDXKHkPMXOZCBU5CfkrIWw2SsSq
YuQKmvxp4BrhcwXypr+vRSsYd1liMxxuXOdBN5AIyzibGfcR4YUeOokIoP05xZoQOfPQkotMC1B6
SHVKEaBxe37YkyKAkQ0f9eKfnPPLG/G5qeLrFPAiIar0HHpOvdCOO69vi3RG1XqoxtTm/wGwRb5J
ZqzZyTn1Fm55PXyKhlElzXXAv1xPOTbkJXRZNQ==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_11", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
EktM4icAEVQRmfzXBBFeRr7d3ZTOU9f+J40sQAiff114nDU+fxlewcv+twlytUk9LMSR67RJlLt4
+ZBTwcuSPZ2Cvrommkp++7rNze0VCD8pSAdj4uo1ZnYWVWmPMQaRIqI88lnAzc5+T/LxEiXKn4ji
AYGs9fja4ME8C0CHbBsg+jfUryleVk1D8jEMCetM7qDx64s/7AGfwzDqMiW2DPCPLKNUsdlOlBYT
JAOnfy6deN7/o7BYxBsE1P4Pib1x1hvR8RwEm38pBOLKGade6KL/1SHmz5N1KGLPSXQXlK53RLTI
Exc4wN04Kg72tf503oGq6Vp90c5pksQ9cc0M+w==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
qzYsaSn6YzxyfrxIwv3eyowRK7ZyzZmQHzUmV2AITf6g43c7IV/fwNBDik+XFhLScW2SxsyaGGI7
5n6kAt9uM3GerkCXA+LJQrqshcEyjuvm17vWVovBURqxhTARgZaTs5OtXdhc/wLi5e6lsdyyLtQo
bt66ubjErMgf5+tD8rpn0HkjUYmGv/MBZ0i4bGui735H12aK+wTfhGVOOiuWHCk2zCJJSx3vH4sl
dKtlpg4W0hPEM3TBPHaLnOpIDkrIUaGGN5fm6NJL6US59+Lr8/3mplbD8ld21OKzgLH+5YPRMoo4
1Pbjxkawu5Kk60AsuaR/OxngawaRMd9N4niRfQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
ol+CCQiNwaE8SNsUbKbA9cqfZz62XND6d+O5cRLnMf8r4k2QEtH0yc82q2o7J3zhNpEE7YrP8X7k
TUR8eH13fbZ4mZOEbfJcsVamyFfTltWMI1IXiykLWxNyFNo7K/Gf6ISyiY/QlXV0ZoAP6oG6d/vC
6Ho1l3EsXJkVDgxbiiIKNKKAVPDX/Rr3PdmCn6tQqV+dYAR9jAyTEordzR5c7xSoUcLkzcM5bFCs
nn4fAmoiWN4Hes9LpHMu+QukoYRXF+n+KWh1zoXwBKbH4Z/WTQLBLScLA37MDClHQ9AM2MbVY63O
RbVw1uOUJOfhEU7vCFDNwjffukSDnTHqZ2sebw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rdsxNUw1+FPGsuaJo5E90mnmnlT//1kjCMSuFYu/R5tvC8PZguJCoPZVpvgKOha88HkrvNvnYHzK
LpznYf6F1hrZwtgbvkE9IDmc9S/OUdbNLJVbOod4ReLGDsOeSPG5e3J0uqFQMT0EsYou0J8ohiXR
4K24sZ5++9x2TuZHtfu63QicYUaC0J5J4RXnpZnYIFSa3Iw2Kd3V+CSSQ30k3KFqLWzepofBUDDg
wSZxXNMp7MGQdLQqjpEp9I26CYpxDZPF1Cx/rnVu0X4TsIEHxikBlGsGOQzPXGhWmopIHNA+d8g2
j26CWQhv0Yvo0JuwC0e3XIQeALDjbEI4/+kamw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 7536)
`pragma protect data_block
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
JqOWqX9QACApvVa8
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
