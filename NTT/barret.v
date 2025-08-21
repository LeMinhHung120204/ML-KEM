`timescale 1ns/1ps

module barret #(
    parameter WIDTH = 16
) (
    input  clk, rst_n,
    input  signed [(WIDTH*2)-1:0] C,   // 32-bit signed khi WIDTH=16
    output [WIDTH-1:0]            R
);
    localparam [15:0] Qmod = 16'd3329;

    // Zero-extend Q len 45-bit
    wire [44:0] Q45 = {{29{1'b0}}, Qmod};

    // Sign-extend C len 45-bit truoc khi shift/cong
    wire signed [44:0] C45 = {{13{C[31]}}, C};  // 45 = 32 + 13

    // ===== Pipeline regs =====
    reg  signed [44:0] s0, s1;   // cac stage
    reg  signed [44:0] C_hold;

    wire [44:0] tmp;
    assign tmp = s0 >>> 26; // t ~ (C*μ)>>26, giu dau cho C neu C am

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            s0      <= 45'd0; 
            s1      <= 45'd0; 
            C_hold  <= 45'd0;
        end else begin
            // ---- Stage 1: u = C * μ ----
            // chon 1 trong 2:
            // (a) μ = floor(2^26/q) = 20158: 2^14 + 2^12 - 2^8 - 2^6 - 2
            // s0 <= (C45<<<14) + (C45<<<12) - (C45<<<8) - (C45<<<6) - (C45<<<1);

            // (b) μ = round(2^26/q) = 20159 :            
            s0       <= (C45 <<< 14) + (C45 <<< 12) - (C45 <<< 8) - (C45 <<< 6) - C45;
            C_hold   <= C45;

            // ---- Stage 2: r = C - t*q  (q = 2^12 - 2^10 + 2^8 + 1) ----
            // t*q = (t<<<12) - (t<<<10) + (t<<<8) + t
            s1      <= C_hold - ((tmp <<< 12) - (tmp <<< 10) + (tmp <<< 8) + tmp);      
        end
    end

    assign R = (s1[44] == 1'b1) ? s1 + Qmod : s1;
endmodule
