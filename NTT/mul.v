module mul#(
    parameter WIDTH = 16
)(
    input clk, rst_n,
    input [WIDTH - 1:0] A, B,
    output [(WIDTH * 2) - 1:0] R
);

    reg [WIDTH:0] y_ext [0:7];
    reg [(WIDTH * 2) - 1:0] result [0:7];
    reg [(WIDTH * 2) - 1:0] regA   [0:7];
    
    wire [(WIDTH * 2) - 1:0] res   [0:7];

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (i = 0; i < 8; i = i + 1'b1) begin
                y_ext[i] <= 17'd0;
                regA[i]  <= 32'd0;
                result[i] <= 32'd0;
            end
        end 
        else begin
            y_ext[0] <= {B, 1'b0};
            regA[0]  <= {{16{A[15]}}, A};

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

            y_ext[6] <= {2'b00, y_ext[5][WIDTH:2]};
            regA[6]  <= regA[5] << 2;

            y_ext[7] <= {2'b00, y_ext[6][WIDTH:2]};
            regA[7]  <= regA[6] << 2;

            // y_ext[8] <= {2'b00, y_ext[7][WIDTH:2]};
            // regA[8]  <= regA[7] << 2;

            // y_ext[9] <= {2'b00, y_ext[8][WIDTH:2]};
            // regA[9]  <= regA[8] << 2;

            // y_ext[10] <= {2'b00, y_ext[9][WIDTH:2]};
            // regA[10]  <= regA[9] << 2;

            // y_ext[11] <= {2'b00, y_ext[10][WIDTH:2]};
            // regA[11]  <= regA[10] << 2;

            // y_ext[12] <= {2'b00, y_ext[11][WIDTH:2]};
            // regA[12]  <= regA[11] << 2;

            // y_ext[13] <= {2'b00, y_ext[12][WIDTH:2]};
            // regA[13]  <= regA[12] << 2;

            // y_ext[14] <= {2'b00, y_ext[13][WIDTH:2]};
            // regA[14]  <= regA[13] << 2;

            // y_ext[15] <= {2'b00, y_ext[14][WIDTH:2]};
            // regA[15]  <= regA[14] << 2;

            // save partial results
            result[0] <= res[0];
            result[1] <= res[1];
            result[2] <= res[2];
            result[3] <= res[3];
            result[4] <= res[4];
            result[5] <= res[5];
            result[6] <= res[6];
            result[7] <= res[7];
            // result[8] <= res[8];
            // result[9] <= res[9];
            // result[10] <= res[10];
            // result[11] <= res[11];
            // result[12] <= res[12];
            // result[13] <= res[13];
            // result[14] <= res[14];
            // result[15] <= res[15];
        end
    end 

    // BoothDecode for stage 0 (first stage doesn't depend on result[-1])
    BoothDecode booth0 (
        .R(32'd0),
        .A(regA[0]),
        .sel(y_ext[0][2:0]),
        .res(res[0])
    );

    // Generate BoothDecode for stage 1 to 15
    genvar gi;
    generate
        for (gi = 1; gi < 8; gi = gi + 1) begin: booth_gen
            BoothDecode booth_inst (
                .R(result[gi-1]),
                .A(regA[gi]),
                .sel(y_ext[gi][2:0]),
                .res(res[gi])
            );
        end
    endgenerate
    assign R = result[7];
endmodule