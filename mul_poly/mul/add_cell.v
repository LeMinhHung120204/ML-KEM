`timescale 1ns/1ps
module add_cell #(
    parameter POLY_N = 16,
    parameter WIDTH = 12
)(
    input clk, rst_n,
    input   [(WIDTH * POLY_N) - 1:0]        a,  // 16 phần tử, mỗi phần tử WIDTH bit
    input   [((WIDTH + 2) * POLY_N) - 1:0]  b,  // 16 phần tử, mỗi phần tử (WIDTH+2) bit
    output  [((WIDTH + 2) * POLY_N) - 1:0]  res // a[i][j] + b[i][j]
);

    genvar i;
    generate
      for (i = 0; i < POLY_N; i = i + 1) begin : gen_add_barret
        wire [WIDTH-1:0]    ai  = a[((i+1)*WIDTH)-1 : i*WIDTH];
        wire [WIDTH + 1:0]  bi  = b[((i+1)*(WIDTH + 2))-1 : i*(WIDTH + 2)];
        wire [WIDTH + 1:0]  sum = {2'b0, ai} + bi;

        assign res[(i+1)*(WIDTH + 2)-1 : i*(WIDTH + 2)] = sum;
      end
    endgenerate
endmodule