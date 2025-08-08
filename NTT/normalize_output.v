module normalize_output #(
    parameter WIDTH_DATA = 16
)(
    input clk, rst_n, start, oe,
    input [(WIDTH_DATA * 2) - 1:0] A, B,
    output [WIDTH_DATA - 1:0] oA, oB
);
    wire [(WIDTH_DATA * 2) - 1:0] tmp1, tmp2;
    assign tmp1 = (A << 12) - (A << 10) + (A << 8) - (A << 5) + (A << 3) - A; // *NTT_F (3303)
    assign tmp2 = (B << 12) - (B << 10) + (B << 8) - (B << 5) + (B << 3) - B; // *NTT_F (3303)
    wire [WIDTH_DATA - 1:0] out1, out2;

    barret barret_inst1(
        .clk(clk),
        .rst_n(rst_n),
        .C((start == 1'b1) ? tmp1 : 32'd0),
        .R(out1)
    );

    barret barret_inst2(
        .clk(clk),
        .rst_n(rst_n),
        .C((start == 1'b1) ? tmp2 : 32'd0),
        .R(out2)
    );

    assign oA = (oe == 1'b1) ? out1 : A[31:0];
    assign oB = (oe == 1'b1) ? out2 : B[31:0];
endmodule