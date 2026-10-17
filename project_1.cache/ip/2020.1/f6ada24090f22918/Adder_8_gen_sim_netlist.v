// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Sun Jun 25 22:04:23 2023
// Host        : DESKTOP-TLMK02R running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ Adder_8_gen_sim_netlist.v
// Design      : Adder_8_gen
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7vx690tffg1761-3
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "Adder_8_gen,c_addsub_v12_0_14,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_addsub_v12_0_14,Vivado 2020.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_c_addsub_v12_0_14 U0
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
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "virtex7" *) (* downgradeipidentifiedwarnings = "yes" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_c_addsub_v12_0_14
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_c_addsub_v12_0_14_viv xst_addsub
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
WwGkON+w+iIB4mc+PeyjN0018OffkPs94WauVhwoJ2FBliDnOtBhI7OTkNOgQtdPnA/13wG9ThuG
wMneNo6vccqTMRPcCzTIj02+Jgsz+LEbijiHg+SaM+DjR21yYvtCpyDTJbbHuyd5WZtXyV/8ReRT
LFv7ArxCKxKkdSpuZwXknyCK9ORn/qvc/byuHTFhP6wDZYtUT7JBJboOkX77/t03+NehcggLonQD
kCOO6J6oSoGCPcZrrFOsWotR3ooKvYsW0bZPso2oGLL3hoB0w1XwxMl31M4IwQcoIsX0wB4z77rf
HSjLg62aL6VZkBgkZhlY9z1MLC8kBiTtKDQDVA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
5UoB/eYiFW96YaBCp0h8WeigfHjsmeSOzJJi86QiedvOuzbGtt1z0ILW2TVGdqy4Sn5iKDo6dVp2
NUDU1F8zDLWVKZG/TYcRccuHjIhrVqlC1BjcsBS22+5aEVJIbRH61Td63KgqGlTweDIIjtusty6D
VKUpM0ERH9vrx10woyQPA2+woJ0srl0RLFJcdXdyuAjckrxa9pYPgacRy+fb3RF4+hDdt0Z0JdPL
a3r4yMaa7jqSyjey2/G4DEWPeCnXC6/ZoISxo4caV6GXllEZlOtsaG/QgflC6prFFrS0ThaWz664
+aJbJdpFrw5pn0wq8PynazFogK/X0KCpcmGBmQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 7552)
`pragma protect data_block
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
bpyH2doaiqstrirtJAGtPV28PiRxmqOZFwegxw==
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
