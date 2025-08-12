module mul_poly #(
    parameter WIDTH = 16
)(
    input clk, rst_n,
    input [WIDTH - 1:0] a0, a1, b0, b1, zetas,
    output [WIDTH - 1:0] res0, res1
);
    localparam num_reg = 35;

    wire [(WIDTH * 2) - 1:0] a0_b0, a1_b1, a1_b0, a0_b1, a1_b1_zetas;
    wire [WIDTH - 1:0] obarret1, obarret2, obarret3;

    reg [WIDTH - 1:0] reg_res0, reg_res1;
    reg [WIDTH - 1:0] regx [0:num_reg - 1];

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            reg_res0 <= 16'b0;
            reg_res1 <= 16'b0;
            for (i = 0; i < num_reg; i = i + 1'b1) begin
                regx[i] <= 16'b0;
            end 
        end 
        else begin
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
            regx[10]    <= regx[9];

            regx[11]    <= a0_b0;
            regx[12]    <= regx[11];
            regx[13]    <= regx[12];
            regx[14]    <= regx[13];
            regx[15]    <= regx[14];
            regx[16]    <= regx[15];
            regx[17]    <= regx[16];
            regx[18]    <= regx[17];
            regx[19]    <= regx[18];
            regx[20]    <= regx[19];
            regx[21]    <= regx[20];
            regx[22]    <= regx[21];

            regx[23]    <= obarret3;
            regx[24]    <= regx[23];
            regx[25]    <= regx[24];
            regx[26]    <= regx[25];
            regx[27]    <= regx[26];
            regx[28]    <= regx[27];
            regx[29]    <= regx[28];
            regx[30]    <= regx[29];
            regx[31]    <= regx[30];
            regx[32]    <= regx[31];
            regx[33]    <= regx[32];
            regx[34]    <= regx[33];
            
            reg_res0    <= obarret2;
            reg_res1    <= regx[34];
        end 
    end 

    assign res0 = reg_res0;
    assign res1 = reg_res1;

    barret barret_inst0(
        .clk(clk),
        .rst_n(rst_n),
        .C(a1_b1),
        .R(obarret1)
    );

    barret barret_inst1(
        .clk(clk),
        .rst_n(rst_n),
        .C(a1_b1_zetas + regx[22]),
        .R(obarret2)
    );

    barret barret_inst2(
        .clk(clk),
        .rst_n(rst_n),
        .C(a1_b0 + a0_b1),
        .R(obarret3)
    );

    mul mul_inst0(
        .clk(clk),
        .rst_n(rst_n),
        .A(a0),
        .B(b0),
        .R(a0_b0)
    );

    mul mul_inst1(
        .clk(clk),
        .rst_n(rst_n),
        .A(a1),
        .B(b1),
        .R(a1_b1)
    );

    mul mul_inst2(
        .clk(clk),
        .rst_n(rst_n),
        .A(a1),
        .B(b0),
        .R(a1_b0)
    );

    mul mul_inst3(
        .clk(clk),
        .rst_n(rst_n),
        .A(a0),
        .B(b1),
        .R(a0_b1)
    );

    mul mul_inst4(
        .clk(clk),
        .rst_n(rst_n),
        .A(obarret1),
        .B(regx[10]),
        .R(a1_b1_zetas)
    );
endmodule 