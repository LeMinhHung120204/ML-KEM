`timescale 1ns/1ps
module mul_cel #(
    parameter WIDTH = 12,
    parameter num   = 16
)(
    input  clk, rst_n, valid_data,
    input  [2:0] k, // 2, 3, 4
    input  [(WIDTH*num)-1:0] a, b,    // 16 số 12-bit
    output [(WIDTH*num)-1:0] res,
    output reg valid_output
);
    localparam num_flag = 24;

    reg [((WIDTH + 2)*num)-1:0]     tmp_res;
    reg [num_flag - 1:0]            reg_done_flag;
    reg [num_flag - 1:0]            reg_valid_flag;
    reg [3:0]                       count_addr;
    reg [2:0]                       count_k;
    reg                             done_flag;

    wire [((WIDTH + 2)*num)-1:0]    add_tmp;
    wire [(WIDTH*num)-1:0]          tmp;

    // -------------------------------------------- count k, addr, done_flag --------------------------------------------
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count_k         <= 3'd0;
            count_addr      <= 4'd0;
            done_flag       <= 1'b0;
            valid_sum       <= 1'b0;
            reg_done_flag   <= {num_flag{1'b0}};
            reg_valid_flag  <= {num_flag{1'b0}};
        end 
        else begin 
            if (valid_data) begin
                if (count_k < k - 1'b1) begin
                    count_k <= count_k + 1'b1;
                end
                else begin
                    count_k     <= 3'd0;
                    count_addr  <= count_addr + 1'b1;
                end
            end 
            if (count_k == 1'b1) begin
                done_flag   <= 1'b1;
            end 
            else begin
                done_flag   <= 1'b0;
            end 
            reg_done_flag   <= {reg_done_flag[num_flag-2:0], done_flag};
            reg_valid_flag  <= {reg_done_flag[num_flag-2:0], valid_data};
        end
    end

    // -------------------------------------------- cong don --------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            tmp_res <= {((WIDTH + 2)*num){1'b0}};
        end 
        else begin 
            if (reg_done_flag[17]) begin
                tmp_res <= {((WIDTH + 2)*num){1'b0}};
            end 
            else begin
                if (reg_valid_flag[16]) begin
                    tmp_res <= add_tmp;
                end 
            end 
        end
    end 

    add_cell add_cell_inst (
        .clk(clk),
        .rst_n(rst_n),
        .a(tmp),        // 12bit * 16
        .b(tmp_res),    // 14bit * 16
        .res(add_tmp)   // 14bit * 16
    );

    // -------------------------------------------- mod barret --------------------------------------------
    genvar gi;
    generate
        for (gi = 0; gi < num; gi = gi + 1) begin : gen_res
            wire [WIDTH + 1:0] resi = add_tmp[((gi+1)*(WIDTH + 2))-1 : gi*(WIDTH + 2)]; // 14 bit
            wire [15:0] out_barret;

            barret barret_inst (
                .clk  (clk),
                .rst_n(rst_n),
                .C    ({18'd0, resi}),
                .R    (out_barret)
            );

            assign res[((gi+1)*WIDTH)-1 : gi*WIDTH] = out_barret[11:0];
        end
    endgenerate

    // -------------------------------------------- mul poly matrix --------------------------------------------

    mul_poly_matrix mul_poly_matrix_inst (
        .clk(clk),
        .rst_n(rst_n),
        .addr(count_addr),
        .a(a),
        .b(b),
        .res(tmp)
    );

    // -------------------------------------------- debug --------------------------------------------
    wire [11:0] test_a [3:0];
    wire [11:0] test_b [3:0];
    wire [11:0] test_tmp [3:0];
    wire [14:0] test_add_tmp[3:0];
    wire [14:0] test_res_tmp[3:0];
    genvar gj;
    generate
        for (gj = 0; gj < 4; gj = gj + 1) begin : gen_test
            assign test_a[gj]   = a[((gj+13)*WIDTH)-1 : (gj +12)*WIDTH];
            assign test_b[gj]   = b[((gj+13)*WIDTH)-1 : (gj + 12)*WIDTH];
            assign test_tmp[gj] = tmp[((gj+13)*WIDTH)-1 : (gj+ 12)*WIDTH];
            assign test_add_tmp[gj] = add_tmp[((gj+13)*(WIDTH + 2))-1 : (gj+ 12)*(WIDTH + 2)];
            assign test_res_tmp[gj] = tmp_res[((gj+13)*(WIDTH + 2))-1 : (gj+ 12)*(WIDTH + 2)];
        end
    endgenerate

    // -------------------------------------------- valid output --------------------------------------------
    always @(*) begin
        case(k)
            3'd2: valid_output = reg_done_flag[21];
            3'd3: valid_output = reg_done_flag[22];
            3'd4: valid_output = reg_done_flag[23];
            default: valid_output = 1'b0;
        endcase
    end 
endmodule