// `timescale 1ns/1ps

// module mul_12bit#(
//     parameter WIDTH = 12
// )(
//     input clk, rst_n,
//     input [WIDTH - 1:0] A, B,
//     output wire [(WIDTH * 2) - 1:0] R
// );
//     localparam num_reg = WIDTH / 2;

//     reg     [WIDTH:0]           y_ext   [0:num_reg-1];
//     reg     [(WIDTH * 2) - 1:0] result  [0:num_reg-1];
//     reg     [(WIDTH * 2) - 1:0] regA    [0:num_reg-1];
//     wire    [(WIDTH * 2) - 1:0] res     [0:num_reg-1];

//     integer i;
//     // always @(posedge clk or negedge rst_n) begin
//     always @(posedge clk) begin
//         if (~rst_n) begin
//             for (i = 0; i < num_reg; i = i + 1'b1) begin
//                 y_ext[i]    <= 13'd0;
//                 regA[i]     <= 24'd0;
//                 result[i]   <= 24'd0;
//             end
//         end 
//         else begin
//             y_ext[0] <= {B, 1'b0};
//             regA[0]  <= {16'b0, A};         // khong dau

//             y_ext[1] <= {2'b00, y_ext[0][WIDTH:2]};
//             regA[1]  <= regA[0] << 2;

//             y_ext[2] <= {2'b00, y_ext[1][WIDTH:2]};
//             regA[2]  <= regA[1] << 2;

//             y_ext[3] <= {2'b00, y_ext[2][WIDTH:2]};
//             regA[3]  <= regA[2] << 2;

//             y_ext[4] <= {2'b00, y_ext[3][WIDTH:2]};
//             regA[4]  <= regA[3] << 2;

//             y_ext[5] <= {2'b00, y_ext[4][WIDTH:2]};
//             regA[5]  <= regA[4] << 2;

//             // save partial results
//             result[0] <= res[0];
//             result[1] <= res[1];
//             result[2] <= res[2];
//             result[3] <= res[3];
//             result[4] <= res[4];
//             result[5] <= res[5];
//         end
//     end 

//     // BoothDecode for stage 0 (first stage doesn't depend on result[-1])
//     BoothDecode booth0 (
//         .R(24'd0),
//         .A(regA[0]),
//         .sel(y_ext[0][2:0]),
//         .res(res[0])
//     );

//     // Generate BoothDecode for stage 1 to 8
//     genvar gi;
//     generate
//         for (gi = 1; gi < num_reg; gi = gi + 1) begin: booth_gen
//             BoothDecode booth_inst (
//                 .R(result[gi-1]),
//                 .A(regA[gi]),
//                 .sel(y_ext[gi][2:0]),
//                 .res(res[gi])
//             );
//         end
//     endgenerate
//     assign R = result[num_reg-1];
// endmodule

module mul_12bit#(
    parameter WIDTH = 13
)(
    input clk, rst_n,
    input [WIDTH - 1:0] A, B,
    output wire [(WIDTH * 2) - 1:0] R
);
    localparam num_reg = 11;
    wire    [WIDTH:0]       tmp [0:6];
    wire    [(WIDTH*2)-1:0] tmp_sum [0:3];
    wire    [(WIDTH*2)-1:0] tmp_carry [0:3];

    reg     [WIDTH + 1:0]   B_ex;
    reg     [WIDTH - 1:0]   regA;
    reg     [(WIDTH * 2) - 1:0] regx [0:10];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (i = 0 ; i< num_reg ; i = i + 1) begin
                regx[i] <= {(WIDTH * 2){1'b0}};
            end 
            regA    <= {WIDTH{1'b0}};
            B_ex    <= {(WIDTH + 2){1'b0}};
        end 
        else begin
            // stage 1
            regA        <= A;
            B_ex        <= {B[WIDTH -1], B, 1'b0};

            // stage 2
            regx[0]     <= tmp_sum[0];
            regx[1]     <= tmp_sum[1];
            regx[2]     <= tmp_carry[0];
            regx[3]     <= tmp_carry[1];
            regx[4]     <= tmp[6] << 12;

            // stage 3
            regx[5]     <= tmp_sum[2];
            regx[6]     <= tmp_carry[2];
            regx[7]     <= regx[3] + regx[4];

            // stage 4
            regx[8]     <= tmp_sum[3];
            regx[9]     <= tmp_carry[3];

            // stage 5
            regx[10]    <= regx[8] + regx[9];

        end 
    end 

    assign R = regx[10];

    csa #(.WIDTH(2*WIDTH)) cas_ins0 (
        .x({{(WIDTH - 1){tmp[0][WIDTH]}}, tmp[0]}),
        .y({{(WIDTH - 3){tmp[1][WIDTH]}}, tmp[1], 2'd0}),
        .z({{(WIDTH - 5){tmp[2][WIDTH]}}, tmp[2], 4'd0}),
        .sum(tmp_sum[0]),
        .carry(tmp_carry[0])
    );

    csa #(.WIDTH(2*WIDTH)) cas_ins1 (
        .x({{(WIDTH - 7){tmp[3][WIDTH]}}, tmp[3], 6'd0}),
        .y({{(WIDTH - 9){tmp[4][WIDTH]}}, tmp[4], 8'd0}),
        .z({{(WIDTH - 11){tmp[5][WIDTH]}}, tmp[5], 10'd0}),
        .sum(tmp_sum[1]),
        .carry(tmp_carry[1])
    );

    csa #(.WIDTH(2*WIDTH)) cas_ins2 (
        .x(regx[0]),
        .y(regx[1]),
        .z(regx[2]),
        .sum(tmp_sum[2]),
        .carry(tmp_carry[2])
    );

    csa #(.WIDTH(2*WIDTH)) cas_ins3 (
        .x(regx[5]),
        .y(regx[6]),
        .z(regx[7]),
        .sum(tmp_sum[3]),
        .carry(tmp_carry[3])
    );

    BoothDecode booth0 (
        .A(regA),
        .sel(B_ex[2:0]),
        .res(tmp[0])
    );

    BoothDecode booth1 (
        .A(regA),
        .sel(B_ex[4:2]),
        .res(tmp[1])
    );

    BoothDecode booth2 (
        .A(regA),
        .sel(B_ex[6:4]),
        .res(tmp[2])
    );

    BoothDecode booth3 (
        .A(regA),
        .sel(B_ex[8:6]),
        .res(tmp[3])
    );

    BoothDecode booth4 (
        .A(regA),
        .sel(B_ex[10:8]),
        .res(tmp[4])
    );

    BoothDecode booth5 (
        .A(regA),
        .sel(B_ex[12:10]),
        .res(tmp[5])
    );

    BoothDecode booth6 (
        .A(regA),
        .sel(B_ex[14:12]),
        .res(tmp[6])
    );
endmodule