// Copyright 1986-2023 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2.2 (win64) Build 3788238 Tue Feb 21 20:00:34 MST 2023
// Date        : Tue Aug 19 15:57:22 2025
// Host        : DESKTOP-DA5EM0P running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu9eg-ffvb1156-2-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2022.2.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta,
    clkb,
    enb,
    web,
    addrb,
    dinb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [7:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [15:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [15:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [7:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [15:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [15:0]doutb;

  wire [7:0]addra;
  wire [7:0]addrb;
  wire clka;
  wire [15:0]dina;
  wire [15:0]dinb;
  wire [15:0]douta;
  wire [15:0]doutb;
  wire ena;
  wire enb;
  wire [0:0]wea;
  wire [0:0]web;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [7:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [15:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "8" *) 
  (* C_ADDRB_WIDTH = "8" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "1" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.29156 mW" *) 
  (* C_FAMILY = "zynquplus" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_0.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "256" *) 
  (* C_READ_DEPTH_B = "256" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "16" *) 
  (* C_READ_WIDTH_B = "16" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "256" *) 
  (* C_WRITE_DEPTH_B = "256" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "16" *) 
  (* C_WRITE_WIDTH_B = "16" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[7:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[7:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[15:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(web));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2022.2.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
Lg5F1Zfiau3QeByGU2d8iLyq6c0Ay54VBRkPDiennEnh7TDqlDHQ30ugh+dQhv2UbRSQ4p1Rw5u0
jZgZUZmy1Br6WeCfAfENro2z0tYpE6huap6VYu8VXMMViOdpLZhd3Joz8MWf9Vkpz9O8GsaXV6w1
FT3lzzRx4ZlWqSymP/Y=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
k67ldAp8HxMr9nrczAiQCAT2rtecidPnBUTDua4bP0PhBLrvQbOxphm7BiFhkHdGPiDgK6MdINUG
D//GaYQsWWpVUpGZfs8KXRKikvei6OQ4trNDIgpYU9T+zsDYIrvScWpep4H0Kh3R+s45gq7RnJ5m
vdUnaWHtpnFw5f3ARp9akA4O1XBR1BgUKzTCIe0UPAGCpWS1hK4aBQcxKu2PkOA+tPNAh3UV3BiZ
vZru2ov5N6bbEX7XHtyrDx4JovVQLfEIY+57bKNfzEEYKSjLOo5b7ftblU7gLeFmR30a6dQOMMgx
KzeWIzCpQemUcnoi/VEHbHGDt4HRBpIGifDODg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
i+RRRWsjfOwMRpKMUFh0IBcShI8yHuzdR43aSUy7WlXp2lerQDV/hI6ANfHItxdA5uJrEIK5wJiU
VgB5oYlKbVJ1BvZbui5wQoJkmW7IbzfMYtuEI22QXBHs019oGwhANUpCO9BetK/0TTzFxVnHtNOu
/LHdKkMBA0VUUUKT6VU=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
tFYGPovVzEoIrKrjTzB6ZqQ6KnkrcjUP1OIG5V7ru9HH8w5P8AlgATXl1Xl3Dc0sTv5AhUl86uI/
Te6q6PxhMPJoRhRB1vXyGzAjrWjA4CWJdMmVu8MWo5zod7cvpkzdrQp18aQTcCDQwlU1DmNGiEOo
zimuLuAUKe6AyAorB43/1QRQQqCxNB7BHRnOJAQDnoyMFVNrG12rKOA/sAyZpMLD4B6xJ7gH7QXT
AZuGXKyILGNZ45qXUr2Hw1p0w3wXMgy/YvUW8HbaHN4jAYcIe/ECoyXyKCAWdzANlF2rT2PeCMqV
QEbigoyqGX27Rm4To5kqLVbmwgAs2ChKUhPckA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
lR8YLkP+Cq0MiT1XckSgPvE9wroyAiBbeHMaKlLiOTx7yegD3rCMk4uetnkA7xdOCG95C0Od5pVH
e2YrEW06xFSOsWdDnQqKOKFYhTwAs147Ze0j25zjomr5m7CmawjMolxykzS96zChWImangU+6Dpu
mE/MKg5/kaC+7gqdMqPmK5P2lIX+ouok9XKxOokJuqD87QwEzDlFFh/qV9pd923yFRNG1c5yQCAY
jC0bWlxJRQo6nbEwBgMn8rC/mMABPH8uD2sMe1yaJv5P7sFeOf3cmAdUGQBGVHRKdpZ59LnHTu1K
InNoIfz9Mx01CNUYdTBr3X0w6fmS/h2C4MO1mA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_07", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
qqgM6XiDSmuIOj2QmFL4f6puTJICjYjWzQLoNxU1gzCcXd5+ng75tjwe5w6urE45Df59LYjXr90N
xoD+v0GnCLOppWUn4S+1ojqBqn0qMLsvms3D9/dYenWKxpbEiFxbArUoCPmld0c++8yPVQ73qapG
1gDmjbWJO8ByYC0/tiugtOK/vE3jYVzEtxehN3MCFPsHGsspvaF3CdRsMas3tebV/SuH2XSAP8j+
fZhSi0u301RRmZ6mSAEqJK3He0Y91Z5ZQOd80417UBeLHaQiA9kHY2RWaBMXWHjx36IJNuIr/7jr
pqPYRD+g+IOGSYqYr2U+oVSWF/J6FaLGEFORSw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
SLY1z3pfrH+89d+aYr8ZYKuGi1pV2B4YTh8mk4uHOGs4LKQ1igmeyM9GJBaMAmt5JcC96WDDnBw4
nB1kIjnCrjVv02nSbiHz+gz/GD9SP86nLzS9QkwUHgiEudWJ/8Fkv+fRer0hLWhtpFMq+QCQAqbX
Dy+Em4RhLOM5CQyRCxiExuROQRkGjH1tQtyz+peAX147pqTEtR9LrFRYUYEPXhtD9b7MSp46zgf4
lSI4aGfqhp6fXq48O+If4NBHVZAh8gHdbneSQhe7VWYJyFRn5NXB16YXAJLa4JQatsMczE+AmO09
k2OEByw2UvUNKGEaf4tNqeBnQNu8yAJKmMaRpQ==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
rHgksH8uRTUXMqfrbR/KpR7K/BN7+l1GGoZ5uBkIVJQ9E1b2f3VZJPrQ7S7VUrJ9W3clOpFEhjAM
Oc8jJzlnUOrbHfYO51LCZ66FccJgE3OjLaM/OzA3c72JbMeF05jEDKf4QdMRaIQwV0vXvFMXFbcg
CD7AuUhMJ/GWQx0JJmueM8RLvNdUcIDBkWoZcPsRFynLr8IfIXTFpVIdlFrvWDV9M+csfXnQIq6k
Y3z8TRciA00/EiKvOp6Eo50/kD4QjKDFCqzWcw9vpMR1S+mAW8D3yQQ3Mw+7TRW5DTmB7qmmS/LD
xKznKyYDNP9KJ8z4NfSZgy9kCEKF/AEOrpIJqnNaoA6HXh9YFegFhy9SpTPldFTNyW6JDzyY5DW1
hVFcYJFPmlT/ZDM7HC/yiWmfTZamjNjr6j6r4fX5ptKg03NOZ6yoiMqKwnvLDnRIQe9/S7fEOqdV
LqZswQByjnvoCBsrGYw6cNNfz5CW00eecKgkExyDTb2F/xuv6oGtNaRS

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
oDWKuMa0YoA/U/QPkQrlE/kjfj1li0yqCn8MeJ3rAm2Z/2YKghA9gsxWs8xB4fe/adKSQ4aHEt1i
tUAxBkQYlT8XiaSFJIAVhNmuXgiEPZ20R+VwppLUjekdT7PC18dHecsi59XlgVJPcddzakFIoqXD
rk8iU8PsQ4WRTiUl44mpMR93K+emGu1nkBJznWpM1pH3aBODRmMjU7IigwOfmOnDjrCzVULW4z7V
2AuUO8AJxPTXjBkt8QkS+Lo97MZG0bItGmjC+mkr0BAz/l2ADPjOsfpKHAN3Qk4Crlkhpfgt7XT0
5KHCyECHiPkWrJah55lp7roA13m4EgPMJeM69w==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rabaiFoR9bIj5CFcJ70CIsYI2myG5mevbxKcSzOpgQHZ4FX874h3Mvv4oNhB5aIwoXefnyix4Pas
3xk2ZBOqreX1vuZUYS7Nk3rT6wqN+/JYXGO7E9xfmFF/iTdL9heWc8JHcLe4e6B8B9QYhGlkRIbN
3etlFTSqKlO5nfA6dKX6Cd+yV3PZZfJXT4jlaY1rpqMPaBtlHWQ7D4o1gO+mHgP0sOQ4bpowU+7Q
jMr0tYghyxsfIddTxrVE0fwZeg1qWlo+iSU1PAJGRVMKIAn7NZ4i8f+ed6NJKt2vGjDFfZXLXClO
nyA+xb6K3aWY3lMR6qP8qDkKAJJZe9Y36MRGng==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
hpnCRmSw3bCoDXuz4ACuAPPPaMheVpOmUjnTbTAMOWU5UsZtyDXZeGV8/oIsADVazSxLQZSBGgiy
SKvVnFKfYB7AgQDUMZFw0rVRtHiVMwSzKWeKD6RAhsC0bPj9SvO7LAbMlPup0Bqp/B+25di0U3gR
HcJdPJAve7xMFNBSYWEA8qxoNxWNshmZSjI/bZ357HlFVPisa6jUUqfB1NL8is8ZUS6S+cNLQyEf
tij0AWwPrqG8naFrpTzHWE6VrXYG5oNftxQbYOQR6HjuL4cx/R64+btFaWdnBHup1adCO/sGxhdd
Dd1b6OQ/2YtZTyp2K8aDHbceCM5X1/8CZdRU5g==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 21472)
`pragma protect data_block
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
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
