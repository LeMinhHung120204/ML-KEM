`timescale 1ns/1ps
module mul_poly_matrix #(
    parameter ADDR   = 16,
    parameter WIDTH = 12
)(
    input  clk, rst_n,
    input  [3:0] addr,
    input  [(WIDTH*ADDR)-1:0] a, b,    // 16 số 12-bit
    output [((WIDTH + 2)*ADDR)-1:0] res
);

    wire [WIDTH-1:0] zeta1, zeta2, zeta3, zeta4;

    Rom_mul Rom_mul_inst (
        .clk(clk),
        .rst_n(rst_n),
        .address(addr),
        .q({zeta1, zeta2, zeta3, zeta4})   // q[47:36]=z1, [35:24]=z2, [23:12]=z3, [11:0]=z4
    );

    wire [11:0] tmp [0:15]; // 8 kết quả con

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : G
            localparam integer L0    = i * 2 * WIDTH;

            // Nhóm zeta theo cặp: (0,1)->z1 ; (2,3)->z2 ; (4,5)->z3 ; (6,7)->z4
            localparam integer GROUP = (i >> 1);   // 0..3
            localparam integer ODD   = (i & 1);    // 0 chẵn, 1 lẻ

            wire [WIDTH-1:0] z_base = (GROUP == 0) ? zeta1 :
                                        (GROUP == 1) ? zeta2 : (GROUP == 2) ? zeta3 : zeta4;

            wire [WIDTH-1:0] z_eff  = (ODD==0) ? z_base : (~z_base + 1'b1);

            wire [WIDTH-1:0] a0_i = a[L0 + WIDTH-1       : L0];
            wire [WIDTH-1:0] a1_i = a[L0 + 2*WIDTH - 1   : L0 + WIDTH];
            wire [WIDTH-1:0] b0_i = b[L0 + WIDTH-1       : L0];
            wire [WIDTH-1:0] b1_i = b[L0 + 2*WIDTH - 1   : L0 + WIDTH];

            mul_poly u_mul (
                .clk(clk),
                .rst_n(rst_n),
                .a0(a0_i),
                .a1(a1_i),
                .b0(b0_i),
                .b1(b1_i),
                .zetas(z_eff),
                // .res0(res[L0 + WIDTH-1     : L0]),
                // .res1(res[L0 + 2*WIDTH - 1 : L0 + WIDTH])
                .res0(tmp[i*2]),
                .res1(tmp[i*2+1])
            );
        end
    endgenerate

    assign res = {{2'b0, tmp[15]}, {2'b0, tmp[14]}, {2'b0, tmp[13]}, {2'b0, tmp[12]}, {2'b0, tmp[11]}, {2'b0, tmp[10]}, {2'b0, tmp[9]}, {2'b0, tmp[8]},
                  {2'b0, tmp[7]},  {2'b0, tmp[6]},  {2'b0, tmp[5]},  {2'b0, tmp[4]},  {2'b0, tmp[3]},  {2'b0, tmp[2]},  {2'b0, tmp[1]},  {2'b0, tmp[0]}};
endmodule
