`timescale 1ns/1ps
module add_cell #(
    parameter POLY_N = 16,
    parameter WIDTH = 14
)(
    input clk, rst_n,
    input [(WIDTH * POLY_N) - 1:0] a, b,    // 16 phần tử, mỗi phần tử WIDTH bit
    output [(WIDTH * POLY_N) - 1:0] res     // a[i][j] + b[i][j]
);

    genvar i;
    generate
      for (i = 0; i < POLY_N; i = i + 1) begin : gen_add_barret
        wire [WIDTH-1:0] ai = a[((i+1)*WIDTH)-1 : i*WIDTH];
        wire [WIDTH-1:0] bi = b[((i+1)*WIDTH)-1 : i*WIDTH];

        wire [WIDTH-1:0] sum = ai + bi;

        // barret barret_inst (
        //   .clk  (clk),
        //   .rst_n(rst_n),
        //   .C    (c_in),
        //   .R    (r_i)
        // );

        assign res[(i+1)*WIDTH-1 : i*WIDTH] = sum;
      end
    endgenerate
endmodule