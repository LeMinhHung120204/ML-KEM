module MyBootROM #(
    parameter WIDTH_ADDR = 7
)(
    input clk,
    input rst_n,
    input oe,               // output enable
    input me,               // memory enable 
    input [WIDTH_ADDR - 1:0] address,
    output [31:0] q
);
    reg [31:0] out;
    reg [31:0] rom [0:127];

//    initial begin: init_and_load
//        integer i;
//        // 256 is the maximum length of $readmemh filename supported by Verilator
//        reg [255*8-1:0] path;
//        path = "C:/Hung/Viettel/Stage2/MLKEM_RTL/rtl_code/NTT/zetas.txt";
//        $readmemh(path, rom);
//    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            rom[0] <= 32'h00000001;
            rom[1] <= 32'h000006C1;
            rom[2] <= 32'h00000A14;
            rom[3] <= 32'h00000CD9;
            rom[4] <= 32'h00000A52;
            rom[5] <= 32'h00000276;
            rom[6] <= 32'h00000769;
            rom[7] <= 32'h00000350;
            rom[8] <= 32'h00000426;
            rom[9] <= 32'h0000077F;
            rom[10] <= 32'h000000C1;
            rom[11] <= 32'h0000031D;
            rom[12] <= 32'h00000AE2;
            rom[13] <= 32'h00000CBC;
            rom[14] <= 32'h00000239;
            rom[15] <= 32'h000006D2;
            rom[16] <= 32'h00000128;
            rom[17] <= 32'h0000098F;
            rom[18] <= 32'h0000053B;
            rom[19] <= 32'h000005C4;
            rom[20] <= 32'h00000BE6;
            rom[21] <= 32'h00000038;
            rom[22] <= 32'h000008C0;
            rom[23] <= 32'h00000535;
            rom[24] <= 32'h00000592;
            rom[25] <= 32'h0000082E;
            rom[26] <= 32'h00000217;
            rom[27] <= 32'h00000B42;
            rom[28] <= 32'h00000959;
            rom[29] <= 32'h00000B3F;
            rom[30] <= 32'h000007B6;
            rom[31] <= 32'h00000335;
            rom[32] <= 32'h00000121;
            rom[33] <= 32'h0000014B;
            rom[34] <= 32'h00000CB5;
            rom[35] <= 32'h000006DC;
            rom[36] <= 32'h000004AD;
            rom[37] <= 32'h00000900;
            rom[38] <= 32'h000008E5;
            rom[39] <= 32'h00000807;
            rom[40] <= 32'h0000028A;
            rom[41] <= 32'h000007B9;
            rom[42] <= 32'h000009D1;
            rom[43] <= 32'h00000278;
            rom[44] <= 32'h00000B31;
            rom[45] <= 32'h00000021;
            rom[46] <= 32'h00000528;
            rom[47] <= 32'h0000077B;
            rom[48] <= 32'h0000090F;
            rom[49] <= 32'h0000059B;
            rom[50] <= 32'h00000327;
            rom[51] <= 32'h000001C4;
            rom[52] <= 32'h0000059E;
            rom[53] <= 32'h00000B34;
            rom[54] <= 32'h000005FE;
            rom[55] <= 32'h00000962;
            rom[56] <= 32'h00000A57;
            rom[57] <= 32'h00000A39;
            rom[58] <= 32'h000005C9;
            rom[59] <= 32'h00000288;
            rom[60] <= 32'h000009AA;
            rom[61] <= 32'h00000C26;
            rom[62] <= 32'h000004CB;
            rom[63] <= 32'h0000038E;
            rom[64] <= 32'h00000011;
            rom[65] <= 32'h00000AC9;
            rom[66] <= 32'h00000247;
            rom[67] <= 32'h00000A59;
            rom[68] <= 32'h00000665;
            rom[69] <= 32'h000002D3;
            rom[70] <= 32'h000008F0;
            rom[71] <= 32'h0000044C;
            rom[72] <= 32'h00000581;
            rom[73] <= 32'h00000A66;
            rom[74] <= 32'h00000CD1;
            rom[75] <= 32'h000000E9;
            rom[76] <= 32'h000002F4;
            rom[77] <= 32'h0000086C;
            rom[78] <= 32'h00000BC7;
            rom[79] <= 32'h00000BEA;
            rom[80] <= 32'h000006A7;
            rom[81] <= 32'h00000673;
            rom[82] <= 32'h00000AE5;
            rom[83] <= 32'h000006FD;
            rom[84] <= 32'h00000737;
            rom[85] <= 32'h000003B8;
            rom[86] <= 32'h000005B5;
            rom[87] <= 32'h00000A7F;
            rom[88] <= 32'h000003AB;
            rom[89] <= 32'h00000904;
            rom[90] <= 32'h00000985;
            rom[91] <= 32'h00000954;
            rom[92] <= 32'h000002DD;
            rom[93] <= 32'h00000921;
            rom[94] <= 32'h0000010C;
            rom[95] <= 32'h00000281;
            rom[96] <= 32'h00000630;
            rom[97] <= 32'h000008FA;
            rom[98] <= 32'h000007F5;
            rom[99] <= 32'h00000C94;
            rom[100] <= 32'h00000177;
            rom[101] <= 32'h000009F5;
            rom[102] <= 32'h0000082A;
            rom[103] <= 32'h0000066D;
            rom[104] <= 32'h00000427;
            rom[105] <= 32'h0000013F;
            rom[106] <= 32'h00000AD5;
            rom[107] <= 32'h000002F5;
            rom[108] <= 32'h00000833;
            rom[109] <= 32'h00000231;
            rom[110] <= 32'h000009A2;
            rom[111] <= 32'h00000A22;
            rom[112] <= 32'h00000AF4;
            rom[113] <= 32'h00000444;
            rom[114] <= 32'h00000193;
            rom[115] <= 32'h00000402;
            rom[116] <= 32'h00000477;
            rom[117] <= 32'h00000866;
            rom[118] <= 32'h00000AD7;
            rom[119] <= 32'h00000376;
            rom[120] <= 32'h000006BA;
            rom[121] <= 32'h000004BC;
            rom[122] <= 32'h00000752;
            rom[123] <= 32'h00000405;
            rom[124] <= 32'h0000083E;
            rom[125] <= 32'h00000B77;
            rom[126] <= 32'h00000375;
            rom[127] <= 32'h0000086A;
            out      <= 32'd0;
        end 
        else if (me) begin
            out <= rom[address];
        end
    end

    assign q = oe ? out : 32'b0;
endmodule

