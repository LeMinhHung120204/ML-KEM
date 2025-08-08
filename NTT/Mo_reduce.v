module Mo_reduce #(
    parameter WIDTH = 32
)(
    input clk, rst_n,
    input [(WIDTH * 2) - 1:0] C,
    output [WIDTH - 1:0] R
);
    // R = 8388608 = 2^23
    // q = 8380417
    // q' = -q^{-1} mod R = 32'd8380415
    localparam Qmod = 32'd8380417;

    reg [(WIDTH * 2) + 22:0] regx[0:12];
    reg [2:0] count;

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (i = 0; i < 4'd13; i = i + 1'b1) begin
                regx[i] <= 86'b0;
            end
        end 
        else begin
            // stage 1
            regx[0] <= C;
            regx[1] <= C << 23;
            regx[2] <= C << 13;

            // stage 2
            regx[3] <= (regx[1] - (regx[0] + regx[2])); // regx[3] = C * q'
            regx[4] <= regx[0];

            // stage 3
            regx[5] <= (regx[3][22:0]);
            regx[6] <= (regx[3][22:0]) << 13;
            regx[7] <= (regx[3][22:0]) << 23;
            regx[8] <= regx[4];

            // stage 4
            regx[9] <= regx[7] - (regx[6] - regx[5]);
            regx[10] <= regx[8];

            // stage 5
            regx[11] <= (regx[9] + regx[10]) >> 23;

            // stage 6
            regx[12] <= (regx[11] >= Qmod) ? (regx[11] - Qmod) : regx[11];

        end
    end

    assign R = regx[12];
endmodule