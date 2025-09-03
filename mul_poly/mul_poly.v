`timescale 1ns/1ps
module mul_poly #(
    parameter WIDTH = 12
)(
    input   clk, rst_n,
    input   [WIDTH - 1:0] a0, a1, b0, b1, zetas,
    output  [WIDTH - 1:0] res0, res1
);
    localparam num_reg = 32;

    wire [(WIDTH * 2) - 1:0] a0_b0, a1_b1, a1_b0, a0_b1, a1_b1_zetas;
    wire [15:0] obarret1, obarret2, obarret3;

    reg [WIDTH - 1:0] reg_res0, reg_res1;
    reg [WIDTH - 1:0] regx [0:num_reg - 1];
    reg mod[0:18];

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            reg_res0 <= 12'b0;
            reg_res1 <= 12'b0;
            for (i = 0; i < num_reg; i = i + 1'b1) begin
                regx[i] <= 12'b0;
            end
            for (i = 0; i < 19; i = i + 1'b1) begin
                mod[i] <= 1'b0;
            end 
        end 
        else begin
            mod[0]     <= zetas[11];
            mod[1]     <= mod[0];
            mod[2]     <= mod[1];
            mod[3]     <= mod[2];
            mod[4]     <= mod[3];
            mod[5]     <= mod[4];
            mod[6]     <= mod[5];
            mod[7]     <= mod[6];
            mod[8]     <= mod[7];
            mod[9]     <= mod[8];
            mod[10]    <= mod[9];
            mod[11]    <= mod[10];
            mod[12]    <= mod[11];
            mod[13]    <= mod[12];
            mod[14]    <= mod[13];
            mod[15]    <= mod[14];
            mod[16]    <= mod[15];
            mod[17]    <= mod[16];
            mod[18]    <= mod[17];

            regx[0]     <= zetas;
            regx[1]     <= regx[0];
            regx[2]     <= regx[1];
            regx[3]     <= regx[2];
            regx[4]     <= regx[3];
            regx[5]     <= regx[4];
            regx[6]     <= regx[5];
            regx[7]     <= regx[6];
            regx[8]     <= regx[7];
            regx[9]     <= regx[8];

            regx[10]    <= a0_b0;
            regx[11]    <= regx[10];
            regx[12]    <= regx[11];
            regx[13]    <= regx[12];
            regx[14]    <= regx[13];
            regx[15]    <= regx[14];
            regx[16]    <= regx[15];
            regx[17]    <= regx[16];
            regx[18]    <= regx[17];
            regx[19]    <= regx[18];
            regx[20]    <= regx[19];

            regx[21]    <= obarret3[11:0];
            regx[22]    <= regx[21];
            regx[23]    <= regx[22];
            regx[24]    <= regx[23];
            regx[25]    <= regx[24];
            regx[26]    <= regx[25];
            regx[27]    <= regx[26];
            regx[28]    <= regx[27];
            regx[29]    <= regx[28];
            regx[30]    <= regx[29];
            regx[31]    <= regx[30];
            
            reg_res0    <= obarret2[11:0];
            reg_res1    <= regx[31];
        end 
    end 

    assign res0 = reg_res0;
    assign res1 = reg_res1;
    wire [31:0] add1, add2, tmp_add;

    assign tmp_add = (mod[18]) ? {{8{1'b1}}, a1_b1_zetas} : {8'b0, a1_b1_zetas};
    assign add1 = tmp_add           + {12'd0, regx[20]};
    assign add2 = {12'd0, a1_b0}    + {12'd0, a0_b1};

    barret barret_inst0(
        .clk(clk),
        .rst_n(rst_n),
        .C({8'b0, a1_b1}),
        .R(obarret1)
    );

    barret barret_inst1(
        .clk(clk),
        .rst_n(rst_n),
        .C(add1),
        .R(obarret2)
    );

    barret barret_inst2(
        .clk(clk),
        .rst_n(rst_n),
        .C(add2),
        .R(obarret3)
    );

    mul_12bit mul_inst0(
        .clk(clk),
        .rst_n(rst_n),
        .A(a0),
        .B(b0),
        .R(a0_b0)
    );

    mul_12bit mul_inst1(
        .clk(clk),
        .rst_n(rst_n),
        .A(a1),
        .B(b1),
        .R(a1_b1)
    );

    mul_12bit mul_inst2(
        .clk(clk),
        .rst_n(rst_n),
        .A(a1),
        .B(b0),
        .R(a1_b0)
    );

    mul_12bit mul_inst3(
        .clk(clk),
        .rst_n(rst_n),
        .A(a0),
        .B(b1),
        .R(a0_b1)
    );

    mul_12bit mul_inst4(
        .clk(clk),
        .rst_n(rst_n),
        .A(obarret1[11:0]),
        .B(regx[9]),
        .R(a1_b1_zetas)
    );
endmodule 