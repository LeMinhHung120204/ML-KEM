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
    localparam num_flag = 29;

    reg [2:0] count_k;
    reg [3:0] count_addr;
    reg [((WIDTH + 2)*num)-1:0] tmp_res;
    reg done_flag [num_flag - 1:0];

    // -------------------------------------------- count k, addr, done_flag --------------------------------------------
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count_k     <= 3'd0;
            count_addr  <= 4'd0;
            for (i = 0; i < num_flag; i = i + 1) begin
                done_flag[i] <= 1'b0;
            end
        end 
        else begin 
            if (valid_data) begin
                if (count_k < k) begin
                    count_k <= count_k + 1'b1;
                end
                else begin
                    count_k     <= 3'd1;
                    // if (done_flag[20]) begin
                    //     count_addr <= 4'd0;
                    // end 
                    count_addr  <= count_addr + 1'b1;
                end 
                if (count_k == 1'b1) begin
                    done_flag[0] <= 1'b1;
                end 
                else begin
                    done_flag[0] <= 1'b0;
                end 
            end 
            
            done_flag[1]    <= done_flag[0];
            done_flag[2]    <= done_flag[1];
            done_flag[3]    <= done_flag[2];
            done_flag[4]    <= done_flag[3];
            done_flag[5]    <= done_flag[4];
            done_flag[6]    <= done_flag[5];
            done_flag[7]    <= done_flag[6];
            done_flag[8]    <= done_flag[7];
            done_flag[9]    <= done_flag[8];
            done_flag[10]   <= done_flag[9];
            done_flag[11]   <= done_flag[10];
            done_flag[12]   <= done_flag[11];
            done_flag[13]   <= done_flag[12];
            done_flag[14]   <= done_flag[13];
            done_flag[15]   <= done_flag[14];
            done_flag[16]   <= done_flag[15];
            done_flag[17]   <= done_flag[16];
            done_flag[18]   <= done_flag[17];
            done_flag[19]   <= done_flag[18];
            done_flag[20]   <= done_flag[19];
            done_flag[21]   <= done_flag[20];
            done_flag[22]   <= done_flag[21];
            done_flag[23]   <= done_flag[22];
            done_flag[24]   <= done_flag[23];
            done_flag[25]   <= done_flag[24];
            done_flag[26]   <= done_flag[25];
            done_flag[27]   <= done_flag[26];
            done_flag[28]   <= done_flag[27];
        end
    end

    wire [((WIDTH + 2)*num)-1:0] add_tmp, tmp;

    // -------------------------------------------- cong don --------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            tmp_res <= {((WIDTH + 2)*num){1'b0}};
        end 
        else begin 
            if (done_flag[20]) begin
                tmp_res <= {((WIDTH + 2)*num){1'b0}};
            end 
            else begin
                tmp_res <= add_tmp;
            end 
        end
    end 

    add_cell add_cell_inst (
        .clk(clk),
        .rst_n(rst_n),
        .a(tmp_res),
        .b(tmp),
        .res(add_tmp)
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
    wire [11:0] test_res [3:0];
    genvar gj;
    generate
        for (gj = 0; gj < 4; gj = gj + 1) begin : gen_test
            assign test_a[gj]   = a[((gj+1)*WIDTH)-1 : gj*WIDTH];
            assign test_b[gj]   = b[((gj+1)*WIDTH)-1 : gj*WIDTH];
            assign test_res[gj] = res[((gj+1)*WIDTH)-1 : gj*WIDTH];
        end
    endgenerate

    // -------------------------------------------- valid output --------------------------------------------
    always @(*) begin
        case(k)
            3'd2: valid_output = done_flag[26];
            3'd3: valid_output = done_flag[27];
            3'd4: valid_output = done_flag[28];
            default: valid_output = 1'b0;
        endcase
    end 
endmodule