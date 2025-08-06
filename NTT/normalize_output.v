module normalize_output #(
    parameter WIDTH_DATA = 32;
)(
    input clk, rst_n,
    input [(WIDTH_DATA * 2) - 1:0] C,
    output [WIDTH_DATA - 1:0]R
);
    wire [(WIDTH_DATA * 2) - 1:0] tmp = (C << 23) - (C << 15) - (C << 13) + (C << 5) + C; // *NTT_F (8347681)

    barret barret_inst(
        .clk(clk),
        .rst_n(rst_n),
        .C(tmp),
        .R(R)
    );
endmodule