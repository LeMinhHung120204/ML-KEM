module barret #(
    parameter WIDTH = 32
)(
    input clk, rst_n, 
    input [(WIDTH * 2) - 1:0] C,
    output [WIDTH - 1:0] R
);

    localparam Qmod = 32'd8380417;
    localparam num_reg = 4;

    reg [(2 * WIDTH) + 23:0] regx [0:num_reg - 1];
    reg [(2 * WIDTH) + 23:0] tmp1, tmp2, tmp3;

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (i = 0; i < num_reg; i = i + 1'b1)
                regx[i] <= 88'b0;
            tmp1        <= 88'b0;
            tmp2        <= 88'b0;
            tmp3        <= 88'b0;
        end 
        else begin
            // stage 1
            regx[0] <= ({24'b0, C}) >> 23;
            tmp1    <= {24'b0, C}; 

            // stage 2
            regx[1] <= (regx[0] << 23) + (regx[0] << 13) + (regx[0] << 3) - regx[0];
            tmp2    <= tmp1;
            
            // stage 3
            regx[2] <= regx[1] >> 23;
            tmp3    <= tmp2;

            // stage4
            regx[3] <= tmp3 - (regx[2] << 23) + (regx[2] << 13) - regx[2];
        end
    end

    wire [WIDTH-1:0] regx3_reduced = regx[3][WIDTH-1:0];
    assign R = regx3_reduced[WIDTH - 1] ? regx3_reduced + Qmod : 
            (regx3_reduced >= Qmod ? regx3_reduced - Qmod : regx3_reduced);

endmodule