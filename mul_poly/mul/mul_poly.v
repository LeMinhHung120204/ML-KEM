`timescale 1ns/1ps
module mul_poly #(
    parameter WIDTH = 12
)(
    input   clk, rst_n,
    input   [WIDTH - 1:0] a0, a1, b0, b1,
    input   [WIDTH:0] zetas,
    output  [WIDTH - 1:0] res0, res1
);
    localparam num_reg_zeta = 9;
    localparam num_reg      = 9;

    wire [((WIDTH + 1) * 2) - 1:0]  a0_b0, a1_b1, a1_b0, a0_b1, a1_b1_zetas;
    wire [15:0]                     obarret1, obarret2, obarret3;
    wire [((WIDTH + 1) * 2) - 1:0]  add2, add1;

    reg [WIDTH - 1:0]                           reg_res0, reg_res1;
    reg [((WIDTH + 1) * num_reg_zeta) - 1:0]    reg_zeta;
    reg [((WIDTH + 1) * 2 * num_reg) - 1:0]     reg_a0_b0;
    reg [(WIDTH * num_reg) - 1:0]               reg_obarret3;

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            reg_res0        <= 12'b0;
            reg_res1        <= 12'b0;
            reg_zeta        <= {((WIDTH + 1) * num_reg_zeta){1'b0}};
            reg_a0_b0       <= {((WIDTH * 2) * num_reg){1'b0}};
            reg_obarret3    <= {(WIDTH * num_reg){1'b0}};
        end 
        else begin
            
            reg_zeta        <= {reg_zeta[((WIDTH + 1) * (num_reg - 1)) - 1:0], zetas};

            reg_a0_b0       <= {reg_a0_b0[(((WIDTH + 1) * 2) * (num_reg - 1)) - 1:0], a0_b0};
            reg_obarret3    <= {reg_obarret3[(WIDTH * (num_reg - 1)) - 1:0], obarret3[11:0]};
            
            reg_res0        <= obarret2[11:0];
            reg_res1        <= reg_obarret3[(WIDTH * num_reg) - 1: WIDTH * (num_reg - 1)];
        end 
    end 

    assign res0 = reg_res0;
    assign res1 = reg_res1;
    assign add1 = a1_b1_zetas   + reg_a0_b0[((WIDTH + 1) * 2 * num_reg) - 1: ((WIDTH + 1) * 2) * (num_reg - 1)];
    assign add2 = a1_b0         + a0_b1;

    barret barret_inst0(
        .clk(clk),
        .rst_n(rst_n),
        .C({6'b0, a1_b1}),
        .R(obarret1)
    );

    barret barret_inst1(
        .clk(clk),
        .rst_n(rst_n),
        .C({{6{add1[25]}}, add1}),
        .R(obarret2)
    );

    barret barret_inst2(
        .clk(clk),
        .rst_n(rst_n),
        .C({6'd0, add2}),
        .R(obarret3)
    );

    mul_12bit mul_inst0(
        .clk(clk),
        .rst_n(rst_n),
        .A({1'b0, a0}),
        .B({1'b0, b0}),
        .R(a0_b0)
    );

    mul_12bit mul_inst1(
        .clk(clk),
        .rst_n(rst_n),
        .A({1'b0, a1}),
        .B({1'b0, b1}),
        .R(a1_b1)
    );

    mul_12bit mul_inst2(
        .clk(clk),
        .rst_n(rst_n),
        .A({1'b0, a1}),
        .B({1'b0, b0}),
        .R(a1_b0)
    );

    mul_12bit mul_inst3(
        .clk(clk),
        .rst_n(rst_n),
        .A({1'b0, a0}),
        .B({1'b0, b1}),
        .R(a0_b1)
    );

    mul_12bit mul_inst4(
        .clk(clk),
        .rst_n(rst_n),
        .A(obarret1[12:0]),
        .B({reg_zeta[((WIDTH + 1) * num_reg_zeta) - 1: (WIDTH + 1) * (num_reg_zeta - 1)]}),
        .R(a1_b1_zetas)
    );
endmodule 