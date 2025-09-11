`timescale 1ns/1ps

module barret #(
    parameter WIDTH = 16
) (
    input  clk, rst_n,
    input  signed [(WIDTH*2)-1:0] C,   // 32-bit signed khi WIDTH=16
    output [WIDTH-1:0]            R
);
    localparam [15:0] Qmod = 16'd3329;

    wire [44:0] Q45 = {{29{1'b0}}, Qmod};

    wire signed [44:0] C45 = {{13{C[31]}}, C};  // 45 = 32 + 13

    // ===== Pipeline regs =====
    reg  signed [44:0] s0, s1, s2, s3, s4, s5;
    reg  signed [44:0] C_hold0, C_hold1, C_hold2;

    wire [44:0] tmp;
    assign tmp = s2 >>> 26;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            s0      <= 45'd0; 
            s1      <= 45'd0; 
            s2      <= 45'd0;
            s3      <= 45'd0;
            s4      <= 45'd0;
            s5      <= 45'd0;
            C_hold0 <= 45'd0;
            C_hold1 <= 45'd0;
            C_hold2 <= 45'd0;
        end else begin
            // s0       <= (C45 <<< 14) + (C45 <<< 12) - (C45 <<< 8) - (C45 <<< 6) - C45;
            s0      <= (C45 <<< 14) + (C45 <<< 12);
            s1      <= (C45 <<< 8)  + (C45 <<< 6);
            C_hold0 <= C45;

            s2      <= s0 - s1 - C_hold0;
            C_hold1 <= C_hold0;

            // s1      <= C_hold - ((tmp <<< 11) + (tmp <<< 10) + (tmp <<< 8) + tmp);      
            s3      <= (tmp << 11)  + (tmp << 10);
            s4      <= (tmp << 8)   + tmp;
            C_hold2 <= C_hold1;

            s5      <= C_hold2 - s3 - s4;
        end
    end

    assign R = (s5[44] == 1'b1) ? s5 + Qmod : s5;
endmodule
