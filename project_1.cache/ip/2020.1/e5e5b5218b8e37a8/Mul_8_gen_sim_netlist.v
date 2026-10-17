// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Sun Jun 25 22:07:10 2023
// Host        : DESKTOP-TLMK02R running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ Mul_8_gen_sim_netlist.v
// Design      : Mul_8_gen
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7vx690tffg1761-3
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "Mul_8_gen,mult_gen_v12_0_16,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_16,Vivado 2020.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_mult_gen_v12_0_16 U0
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
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "virtex7" *) (* downgradeipidentifiedwarnings = "yes" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_mult_gen_v12_0_16
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_mult_gen_v12_0_16_viv i_mult
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
MTny541zwWaNQH/IWSgfz4VM77zLxOTASsdArpr5kec2dVua19ROvymYmnDg5mTjvG6zvakejbXT
Qtu5wqg0VBRYKdb3ytCsj25fP1Eo5Iabz9FXoeeH8LH1oVpZ/WsQH0Hi388b46U9NWrH7FGHu+UB
Cxz5IL3ZJSutl3YAszoFT9ZxWkakG2eTTNXZHCa0VM7MoC0jdt0xTH7AKVq2n9f1Vb+i283L2JBJ
05mKakWrLM88/271FhKLpYH02bZ8uYdLzb4GDONZPFjirOrFATNn8ZMKBdBIRSXpLaQ6R3ZO1cQU
1896ezb67VGvMYUFIVklk50uq665gCt659pCUg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
S1P/PxD+Z/26zDTepxVtuWel2O4YNi/QulTdfN4ZfXxSI94r6ZTWHyDh0UnfgsJmaFULwbEcVkeV
UFW+OJJ2TRBltS7ldfirxhO6ZiMDIF0HpsVWGkCnEXpRsfNkc+10BkcUnTMeYndq8P2E3D18TiWP
SJ/DLp05BRYgdV8YmNKwLEI9QK9jWoNjmJvkxWXbin6DO2uc4BvHNCTlmvrNSYOaS0Y07Po8vZIJ
E1BGShLv+BnIXRyv/Cj+OQQsaepCx1v/279uCuXSU6KKkAuQ4R0TjiXZATXSaywKgAf7HNhU63+S
r8mAip2HgoO80BaPhhQIzmfbMOuwrgy/F8+q5A==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 23840)
`pragma protect data_block
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
O2i4Ka5jYy4dDtIJj7A=
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
