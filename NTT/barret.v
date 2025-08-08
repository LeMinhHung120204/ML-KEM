module barret #(
    parameter WIDTH = 16
)(
    input clk, rst_n, 
    input [(WIDTH * 2) - 1:0] C,
    output [WIDTH - 1:0] R
);

    localparam Qmod = 16'd3329;
    localparam num_reg = 3;

    reg [(2 * WIDTH) + 13:0] regx [0 : num_reg - 1];
    reg [(2 * WIDTH) + 13:0] tmp1, tmp2, tmp3;

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (i = 0; i < num_reg; i = i + 1'b1)
                regx[i] <= 45'b0;
            tmp1        <= 45'b0;
            tmp2        <= 45'b0;
        end 
        else begin
            // stage 1
            regx[0] <= (C << 14) +  (C << 12) - (C << 8) - (C << 6) - C;
            tmp1    <= C; 

            // stage 2
            regx[1] <= regx[0] >> 26;
            tmp2    <= tmp1;
            
            // stage 3
            regx[2] <= tmp2 - (regx[1] << 12) + (regx[1] << 10) - (regx[1] << 8) - regx[1];
        end
    end

    wire [WIDTH-1:0] regx2_reduced = regx[2][WIDTH - 1:0];
    wire negative = (regx[2][(2 * WIDTH) + 13] == 1'b1) ? 1'b1 : 1'b0;
    assign R = (negative == 1'b1) ? regx2_reduced + Qmod : 
            (regx2_reduced >= Qmod ? regx2_reduced - Qmod : regx2_reduced);

endmodule