`timescale 1ns/1ps

module mul_12bit#(
    parameter WIDTH = 12
)(
    input clk, rst_n,
    input [WIDTH - 1:0] A, B,
    output wire [(WIDTH * 2) - 1:0] R
);
    localparam num_reg = WIDTH / 2;

    reg     [WIDTH:0]           y_ext   [0:num_reg-1];
    reg     [(WIDTH * 2) - 1:0] result  [0:num_reg-1];
    reg     [(WIDTH * 2) - 1:0] regA    [0:num_reg-1];
    wire    [(WIDTH * 2) - 1:0] res     [0:num_reg-1];

    integer i;
    // always @(posedge clk or negedge rst_n) begin
    always @(posedge clk) begin
        if (~rst_n) begin
            for (i = 0; i < num_reg; i = i + 1'b1) begin
                y_ext[i]    <= 13'd0;
                regA[i]     <= 24'd0;
                result[i]   <= 24'd0;
            end
        end 
        else begin
            y_ext[0] <= {B, 1'b0};
            // regA[0]  <= {{16{A[11]}}, A};   // co dau
            regA[0]  <= {16'b0, A};         // khong dau

            y_ext[1] <= {2'b00, y_ext[0][WIDTH:2]};
            regA[1]  <= regA[0] << 2;

            y_ext[2] <= {2'b00, y_ext[1][WIDTH:2]};
            regA[2]  <= regA[1] << 2;

            y_ext[3] <= {2'b00, y_ext[2][WIDTH:2]};
            regA[3]  <= regA[2] << 2;

            y_ext[4] <= {2'b00, y_ext[3][WIDTH:2]};
            regA[4]  <= regA[3] << 2;

            y_ext[5] <= {2'b00, y_ext[4][WIDTH:2]};
            regA[5]  <= regA[4] << 2;

            // y_ext[6] <= {2'b00, y_ext[5][WIDTH:2]};
            // regA[6]  <= regA[5] << 2;

            // y_ext[7] <= {2'b00, y_ext[6][WIDTH:2]};
            // regA[7]  <= regA[6] << 2;

            // save partial results
            result[0] <= res[0];
            result[1] <= res[1];
            result[2] <= res[2];
            result[3] <= res[3];
            result[4] <= res[4];
            result[5] <= res[5];
            // result[6] <= res[6];
            // result[7] <= res[7];
        end
    end 

    // BoothDecode for stage 0 (first stage doesn't depend on result[-1])
    BoothDecode booth0 (
        .R(24'd0),
        .A(regA[0]),
        .sel(y_ext[0][2:0]),
        .res(res[0])
    );

    // Generate BoothDecode for stage 1 to 8
    genvar gi;
    generate
        for (gi = 1; gi < num_reg; gi = gi + 1) begin: booth_gen
            BoothDecode booth_inst (
                .R(result[gi-1]),
                .A(regA[gi]),
                .sel(y_ext[gi][2:0]),
                .res(res[gi])
            );
        end
    endgenerate
    assign R = result[num_reg-1];
endmodule