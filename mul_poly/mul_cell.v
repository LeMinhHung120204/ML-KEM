module mul_cell #(
    parameter POLY_N = 256,
    parameter WIDTH = 16
)(
    input clk, rst_n,
    input [(WIDTH * POLY_N) - 1:0] a, b,    // a[i][j], b[i][j]: co 256 hang so
    output [(WIDTH * POLY_N) - 1:0] res     // a[i][j] * b[i][j]
);
    localparam integer GROUPS = POLY_N/4;
    localparam integer CW     = $clog2(GROUPS);           // width của counter 6bit
    localparam integer EW     = $clog2(POLY_N);           // width chỉ số hệ số 8bit
    localparam integer BW     = $clog2(WIDTH*POLY_N);     // width chỉ số bit   12bit

    reg [CW - 1:0] counter;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            counter <= 6'd0;
        end 
        else begin
            counter <= counter + 1'b1;
        end 
    end

    wire [EW - 1:0] base_idx = {counter, 2'b00};        // counter * 4
    wire [BW - 1:0] bit_base = {base_idx, 4'd0};        // * WIDTH = 16
    wire [BW - 1:0] bit0, bit1, bit2, bit3;
    
    wire [WIDTH-1:0] a0 = a[bit0 +: WIDTH];
    wire [WIDTH-1:0] a1 = a[bit1 +: WIDTH];
    wire [WIDTH-1:0] a2 = a[bit2 +: WIDTH];
    wire [WIDTH-1:0] a3 = a[bit3 +: WIDTH];

    wire [WIDTH-1:0] b0 = b[bit0 +: WIDTH];
    wire [WIDTH-1:0] b1 = b[bit1 +: WIDTH];
    wire [WIDTH-1:0] b2 = b[bit2 +: WIDTH];
    wire [WIDTH-1:0] b3 = b[bit3 +: WIDTH];

    wire [WIDTH-1:0] r0, r1, r2, r3;
    reg [(WIDTH*POLY_N)-1:0] reg_res;

    assign bit0 = bit_base;                         // bit_base
    assign bit1 = bit_base + WIDTH;                 // bit_base + WIDTH 
    assign bit2 = bit_base + (WIDTH << 1);          // bit_base + WIDTH * 2
    assign bit3 = bit_base + (WIDTH << 1) + WIDTH;  // bit_base + WIDTH * 3

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg_res <= {(WIDTH * POLY_N){1'b0}};
        end 
        else begin
            reg_res[bit0 +: WIDTH] <= r0;
            reg_res[bit1 +: WIDTH] <= r1;
            reg_res[bit2 +: WIDTH] <= r2;
            reg_res[bit3 +: WIDTH] <= r3;
        end
    end

    assign res = reg_res;

    mul_poly_matrix mul_poly_mtr_inst0 (
        .clk(clk),
        .rst_n(rst_n),
        .a0(a0), .a1(a1), .a2(a2), .a3(a3),
        .b0(b0), .b1(b1), .b2(b2), .b3(b3),
        .res0(r0), .res1(r1), .res2(r2), .res3(r3)
    );
endmodule