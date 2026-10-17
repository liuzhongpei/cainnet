// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Sun Jun 25 22:07:12 2023
// Host        : DESKTOP-TLMK02R running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               g:/code/airmt/project_1.srcs/sources_1/ip/Mul_8_gen/Mul_8_gen_sim_netlist.v
// Design      : Mul_8_gen
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7vx690tffg1761-3
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "Mul_8_gen,mult_gen_v12_0_16,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_16,Vivado 2020.1" *) 
(* NotValidForBitStream *)
module Mul_8_gen
   (CLK,
    A,
    B,
    P);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF p_intf:b_intf:a_intf, ASSOCIATED_RESET sclr, ASSOCIATED_CLKEN ce, FREQ_HZ 10000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [7:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [7:0]B;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [7:0]P;

  wire [7:0]A;
  wire [7:0]B;
  wire CLK;
  wire [7:0]P;
  wire [47:0]NLW_U0_PCASC_UNCONNECTED;
  wire [1:0]NLW_U0_ZERO_DETECT_UNCONNECTED;

  (* C_A_TYPE = "0" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "1" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "0" *) 
  (* C_OPTIMIZE_GOAL = "0" *) 
  (* C_OUT_HIGH = "7" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "virtex7" *) 
  (* KEEP_HIERARCHY = "soft" *) 
  (* c_a_width = "8" *) 
  (* c_b_width = "8" *) 
  (* c_has_ce = "0" *) 
  (* c_has_sclr = "0" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  Mul_8_gen_mult_gen_v12_0_16 U0
       (.A(A),
        .B(B),
        .CE(1'b1),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule

(* C_A_TYPE = "0" *) (* C_A_WIDTH = "8" *) (* C_B_TYPE = "0" *) 
(* C_B_VALUE = "10000001" *) (* C_B_WIDTH = "8" *) (* C_CCM_IMP = "0" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_HAS_CE = "0" *) (* C_HAS_SCLR = "0" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_LATENCY = "1" *) (* C_MODEL_TYPE = "0" *) 
(* C_MULT_TYPE = "0" *) (* C_OPTIMIZE_GOAL = "0" *) (* C_OUT_HIGH = "7" *) 
(* C_OUT_LOW = "0" *) (* C_ROUND_OUTPUT = "0" *) (* C_ROUND_PT = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "virtex7" *) (* ORIG_REF_NAME = "mult_gen_v12_0_16" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module Mul_8_gen_mult_gen_v12_0_16
   (CLK,
    A,
    B,
    CE,
    SCLR,
    ZERO_DETECT,
    P,
    PCASC);
  input CLK;
  input [7:0]A;
  input [7:0]B;
  input CE;
  input SCLR;
  output [1:0]ZERO_DETECT;
  output [7:0]P;
  output [47:0]PCASC;

  wire \<const0> ;
  wire [7:0]A;
  wire [7:0]B;
  wire CLK;
  wire [7:0]P;
  wire [47:0]NLW_i_mult_PCASC_UNCONNECTED;
  wire [1:0]NLW_i_mult_ZERO_DETECT_UNCONNECTED;

  assign PCASC[47] = \<const0> ;
  assign PCASC[46] = \<const0> ;
  assign PCASC[45] = \<const0> ;
  assign PCASC[44] = \<const0> ;
  assign PCASC[43] = \<const0> ;
  assign PCASC[42] = \<const0> ;
  assign PCASC[41] = \<const0> ;
  assign PCASC[40] = \<const0> ;
  assign PCASC[39] = \<const0> ;
  assign PCASC[38] = \<const0> ;
  assign PCASC[37] = \<const0> ;
  assign PCASC[36] = \<const0> ;
  assign PCASC[35] = \<const0> ;
  assign PCASC[34] = \<const0> ;
  assign PCASC[33] = \<const0> ;
  assign PCASC[32] = \<const0> ;
  assign PCASC[31] = \<const0> ;
  assign PCASC[30] = \<const0> ;
  assign PCASC[29] = \<const0> ;
  assign PCASC[28] = \<const0> ;
  assign PCASC[27] = \<const0> ;
  assign PCASC[26] = \<const0> ;
  assign PCASC[25] = \<const0> ;
  assign PCASC[24] = \<const0> ;
  assign PCASC[23] = \<const0> ;
  assign PCASC[22] = \<const0> ;
  assign PCASC[21] = \<const0> ;
  assign PCASC[20] = \<const0> ;
  assign PCASC[19] = \<const0> ;
  assign PCASC[18] = \<const0> ;
  assign PCASC[17] = \<const0> ;
  assign PCASC[16] = \<const0> ;
  assign PCASC[15] = \<const0> ;
  assign PCASC[14] = \<const0> ;
  assign PCASC[13] = \<const0> ;
  assign PCASC[12] = \<const0> ;
  assign PCASC[11] = \<const0> ;
  assign PCASC[10] = \<const0> ;
  assign PCASC[9] = \<const0> ;
  assign PCASC[8] = \<const0> ;
  assign PCASC[7] = \<const0> ;
  assign PCASC[6] = \<const0> ;
  assign PCASC[5] = \<const0> ;
  assign PCASC[4] = \<const0> ;
  assign PCASC[3] = \<const0> ;
  assign PCASC[2] = \<const0> ;
  assign PCASC[1] = \<const0> ;
  assign PCASC[0] = \<const0> ;
  assign ZERO_DETECT[1] = \<const0> ;
  assign ZERO_DETECT[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_A_TYPE = "0" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "1" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "0" *) 
  (* C_OPTIMIZE_GOAL = "0" *) 
  (* C_OUT_HIGH = "7" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "virtex7" *) 
  (* KEEP_HIERARCHY = "soft" *) 
  (* c_a_width = "8" *) 
  (* c_b_width = "8" *) 
  (* c_has_ce = "0" *) 
  (* c_has_sclr = "0" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  Mul_8_gen_mult_gen_v12_0_16_viv i_mult
       (.A(A),
        .B(B),
        .CE(1'b0),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_i_mult_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_i_mult_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2020.1"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
ZqI7Lq/aGyAcoaejBEIk07VX9jYIkvdeTPQu9dSbDEADopcPNa+0k8THWemULZmXocovtHBV2sQ+
UG9Mr3L0hg==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
R4vPs+jPUBq40hDi8U6b9avbUk2Eb50U4A+mDDli/Y0olyqpMjS2bHK8VDjTVAFuQ+H3qih0cQYm
+ik1m47VLNMfNDfRLbftE2okRK8Kx81MRcEafr+7z29VxyL2KSwmOKbcDCEkIT1VX5y+96x7q9/g
O5zX1cVuj6hrFncQjBI=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
RHGRLed4zRtfx3HaMZFysMR3Ua1JohlSUQn/uIq0QNaCK2P96ztDgqQoqe6ZQ11betfsHTRFzq/1
66ClFz6QxXME/fh2KrrXSgUZxYxwfstEZlyOThrSfu+qzCsdk0R654q7wyvVT8+Lni3RuXc5nFXx
raCVZl6qLm50r3EadUq562wDBW7iVkrMp3OgccKyJyw39sT1Jc+0IkzHuHqjKA44tfGTOOSTHNUj
YgsyeZCJS72pabS90ZfprHyjsELB7Bxw/M9/XLEV7l1LP+SCDJFvOP5dNLZDBmwYIJ5OoU7247Tk
wYu3m6ZFZNnTwWGI9SAZJyiXILRa8hVZPL9TSA==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
OU7rNiePgxinwm/ruLBNeniAmTTLdwPhOZ1i35IGtDWXtaPoMnsPLRF6vnJo1xeYUES1MIlBqaG4
FUeyfrnBl3ofk5rfTbxL16dBcEtA8Z/duJARcLCIBD/J+xf2VlSqIo8dG9Ww8/L9pBTHpNAObSOU
o17xArTTrLfHWXZRGfRwuRpGlTLTYOMvS1AGhQcPbXjHrlijOoz3XigDVsnyGbHfkSgOlGBCnyDS
TPebi8IC8YIl88ieW+lqTL6jl+3DZ55iTfCJKbFt/HrE1Uou1l+60xI/9h9XhrNzE5ANic5eFmyC
tdncsHEBtx+UfZhyFrHV8z72yZoLCX2rOJ+IJA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
GUoHfgebfwQKNkw122kR1rRfB4ZFf7/0xjFIvV3auOQ9RcZO2jgecvvtUAn3nocoMNPW1jFFZW0u
xgkVDSrwVJrMR/obpu7gqo1n1FD2E5BpOJV2Gwso9aZGhgTdfd0mINfCxPi4lxUYuTw1vd+iNkBH
peC7j2xzDHSu6o2S58c=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
lW3oa+bS7VSdBch0q4Lk4kIel2MxeXNlqo+JkBKYCThE5vtBv3Mob32tRj6s2h8BAos9XGsKRu0r
zWpu3cgAnv8lYIL4/UPBP9T+caGqWHHoGULrLn4zuybUvPzfGPj+ANXGfPXBomTO48UgPFWBnBA2
3vlOjCiOyKLMQAUrg8RqpfdYfcnwHxk8ebrE+lZJf6NCQtrqGu/EnH7PYFH/8MSQa6yey02fLQ2J
HenzdGNam7fu3z20gETHgePuewowRrJu5bEZOzlor2RrSnb0hcSbcO4/KSA9EcbmjzBMjE5uRYAM
1y+0t4rNGr+0XAjpp8m6B8lGF+m1jIGYMJ55eQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
AYjoOGO5c2rCxRUY5RbgjfKwpMKJQrCDGPu9wzqv2ZhoT9Trod7xJlCnzNNU4kNJPTgmDf05Bkoo
EvR1hgWeTmTgCGdy7Qci0Z0L3pdxnOg9i69qsJO1qAW46sOYPeZHpvATo3irsreTIyOEcblYRdLh
Raj2T02eEhljrx1UdWXHwIq6kJGwbPaiMRXRJewJ75w53lF3nNUwTYgttUbm/hKuK4MTBvyDWlHF
UReBw5kEbERTaRF91+HNJUeoBgfLIgVhtPzX3Yzqy4fl1PxZ0BzAGNRQWfLI4TBSyl64znmxdzaS
+wcpSJ3OHZL4sBSIwGqpZ8UuNr53DWWwkd5lqw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_11", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
F93W5rP9wRsskpVAtvm9VhlFJY5TOuivcFKT2bVYmeqxn925TMU0N0nDRJZmC+O7NbtC0kbL9Hfv
iPaQAjkvtWKCEafU216A83pjNwYVINq3GbStXAtCrvf3KbYJMQPnr6FzKWLa0RlmEqf2z1LRIJMY
cR3LKzziLGgP+oQLz6W3siXeoyqxsbDm+dasSbu2YxzGAvkTos4kX2slGrQzxYSQogS6j/MzVgIk
Vhsm3BYDbtVT5TsiHGfRfi137tS2Q9o11KN44GT+JYigwORe+GyKi5xjI6kGPl1N1DK12TlRGsgC
Wq2YWMn2ABYXE2F8mkwPOJqSaaAR0S5MMCjkaQ==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
EO2KlFB8vWgjeXvua8SEZL2APl0WfdPtqoF/0VTjBDZhkKh8T7GBS9tSSrCin7kHRBUGF6hOUPK2
V0JQtp4yW7c3oVbMN2ePIV7UdtkAszA2lMqOqeKJbWn0TfxRWL5adG+jGlhhYEbaT6tkCGPbbtbk
y5Kew5kT3RyGP8Rb0tim3cGvqi2BdBxqdc5Sb+Vyj0havZUyZo1AsjuLnNukDIYIrPCtqOY22MTp
VlNOr/u23OIMx+xx7Z4aOvZacPCxfg662ljyHetf5a0wu31WI6zf/69lkXq1iWJtHgEJn2iDpIWs
bSWDEtGgKAFHGKVAoc0vIGP3aPG6DIsqRyQ90Q==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
eKo9FxpMWYR3M8t2xhfJpRJvT6oH2vAraXh4pteMAGzoCMyNd11yDeBE13fNsHaZngwJxEBBSCYX
Z7Wsa7UmG/g+eYlNnBV9Y8TPee2iMOBoVPo49JbwFri9VXN2a4s1tQa/6fDEC3KduxFZRl7qcewn
o3Q9UxvW1Y63TuFIMVJ5RsPo89Bn9Pfqxv1l8pTGlLOFCjEPYpjFkR+q4eK/G3nirQld/N+ufMEM
SfBHJW0QFTnI2YoyoxNAbPK9XdLrnKi5TtorGdBfYd8yw44NibL0qqbh8dGpIOOJN76On9ataa0D
No7OQspQsVWv+ceTDSZ9RXEWE6BpQH9L9aWrAg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
02yWz2T4UDZD2gkKYgNANwzRxznGeHysZzKOVU7R+GAasQdbfHJwKK7P9Qf8+axh0Z1Up9q84hwf
LXs9c8NpKk+2JymZ5ZwkzU4wf2EZZbKb7V9rNi38mjZ4fEWcaR+P+SsbzWYKSaCblyse5QbE/DA/
O/IPLE2P9H4YoyTfqeqOPMXvOUuC3zMoLLrqyM5w+RBKsxzbTrHLtoVs54sxWjkKQZblCNm4dLhW
1IqVKh1d0hiP8QzW6y+zbyR+0e6i2owzTqzTxhfMBStIxf8xvmj0FP7ZKzBNPAag18p97AN6klDI
cWFuue3BOStqzG+AfV3Cgu+ZACuIFHsk/5ogfg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 23680)
`pragma protect data_block
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
WN6poTzzcWHWINOgnPIXPb8oK+6ScVwyxw==
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
