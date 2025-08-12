module add_cell #(
    parameter POLY_N = 256,
    parameter WIDTH = 16
)(
    input clk, rst_n,
    input [(WIDTH * POLY_N) - 1:0] a, b,    // 256 phần tử, mỗi phần tử WIDTH bit
    output [(WIDTH * POLY_N) - 1:0] res     // a[i][j] + b[i][j]
);

    genvar i;
    generate
      for (i = 0; i < POLY_N; i = i + 1) begin : gen_add_barret
        wire [WIDTH-1:0] ai = a[((i+1)*WIDTH)-1 : i*WIDTH];
        wire [WIDTH-1:0] bi = b[((i+1)*WIDTH)-1 : i*WIDTH];

        // Cộng (thêm 1 bit để giữ carry)
        wire [WIDTH:0] sum = ai + bi;

        // Zero-extend
        wire [(2*WIDTH)-1:0] c_in = { {(WIDTH-1){1'b0}}, sum };
        wire [WIDTH-1:0] r_i;

        barret barret_inst (
          .clk  (clk),
          .rst_n(rst_n),
          .C    (c_in),
          .R    (r_i)
        );

        assign res[(i+1)*WIDTH-1 : i*WIDTH] = r_i;
      end
    endgenerate
endmodule