module mul#(
    parameter WIDTH = 32
)(
    input clk, rst_n,
    input [WIDTH - 1:0] A, B,
    output [(WIDTH * 2) - 1:0] R
);

    reg [32:0] y_ext [0:15];
    reg [(WIDTH * 2) - 1:0] result [0:15];
    reg [(WIDTH * 2) - 1:0] regA   [0:15];
    wire [(WIDTH * 2) - 1:0] res   [0:15];

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (i = 0; i < 16; i = i + 1'b1) begin
                y_ext[i] <= 33'd0;
                regA[i]  <= 62'd0;
                result[i] <= 64'd0;
            end
        end 
        else begin
            y_ext[0] <= {B, 1'b0};
            regA[0]  <= {{32{A[31]}}, A};

            // for (i = 1; i < 16; i = i + 1) begin
            //     y_ext[i] <= {2'b00, y_ext[i-1][32:2]};   // shift right by 2, keep 33 bits
            //     regA[i]  <= regA[i-1] << 2;
            // end

            y_ext[1] <= {2'b00, y_ext[0][32:2]};
            regA[1]  <= regA[0] << 2;

            y_ext[2] <= {2'b00, y_ext[1][32:2]};
            regA[2]  <= regA[1] << 2;

            y_ext[3] <= {2'b00, y_ext[2][32:2]};
            regA[3]  <= regA[2] << 2;

            y_ext[4] <= {2'b00, y_ext[3][32:2]};
            regA[4]  <= regA[3] << 2;

            y_ext[5] <= {2'b00, y_ext[4][32:2]};
            regA[5]  <= regA[4] << 2;

            y_ext[6] <= {2'b00, y_ext[5][32:2]};
            regA[6]  <= regA[5] << 2;

            y_ext[7] <= {2'b00, y_ext[6][32:2]};
            regA[7]  <= regA[6] << 2;

            y_ext[8] <= {2'b00, y_ext[7][32:2]};
            regA[8]  <= regA[7] << 2;

            y_ext[9] <= {2'b00, y_ext[8][32:2]};
            regA[9]  <= regA[8] << 2;

            y_ext[10] <= {2'b00, y_ext[9][32:2]};
            regA[10]  <= regA[9] << 2;

            y_ext[11] <= {2'b00, y_ext[10][32:2]};
            regA[11]  <= regA[10] << 2;

            y_ext[12] <= {2'b00, y_ext[11][32:2]};
            regA[12]  <= regA[11] << 2;

            y_ext[13] <= {2'b00, y_ext[12][32:2]};
            regA[13]  <= regA[12] << 2;

            y_ext[14] <= {2'b00, y_ext[13][32:2]};
            regA[14]  <= regA[13] << 2;

            y_ext[15] <= {2'b00, y_ext[14][32:2]};
            regA[15]  <= regA[14] << 2;

            // save partial results
            result[0] <= res[0];
            result[1] <= res[1];
            result[2] <= res[2];
            result[3] <= res[3];
            result[4] <= res[4];
            result[5] <= res[5];
            result[6] <= res[6];
            result[7] <= res[7];
            result[8] <= res[8];
            result[9] <= res[9];
            result[10] <= res[10];
            result[11] <= res[11];
            result[12] <= res[12];
            result[13] <= res[13];
            result[14] <= res[14];
            result[15] <= res[15];
            // for (i = 0; i < 16; i = i + 1)
            //     result[i] <= res[i];
        end
    end 

    // BoothDecode for stage 0 (first stage doesn't depend on result[-1])
    BoothDecode booth0 (
        .R(64'd0),
        .A(regA[0]),
        .sel(y_ext[0][2:0]),
        .res(res[0])
    );

    // Generate BoothDecode for stage 1 to 15
    genvar gi;
    generate
        for (gi = 1; gi < 16; gi = gi + 1) begin: booth_gen
            BoothDecode booth_inst (
                .R(result[gi-1]),
                .A(regA[gi]),
                .sel(y_ext[gi][2:0]),
                .res(res[gi])
            );
        end
    endgenerate
    assign R = result[15];
endmodule