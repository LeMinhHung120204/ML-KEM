`timescale 1ns/1ps

module bu_intt #(
    parameter WIDTH = 16
)(
    input clk, rst_n,
    input [WIDTH - 1:0] A_In, B_In, W_In,
    output [WIDTH - 1:0] A_Out, B_Out

    // // debug
    // output [WIDTH - 1:0] barret1, barret2, barret3,
    // output [(WIDTH * 2) - 1:0] o_mul, sub_out, add_out
);
    localparam num_reg = 2;
    localparam num_reg_barret1 = 9;
    localparam Qmod = 16'd3329;
    localparam div2 = 1665;

    reg [WIDTH - 1:0]                       regx [0:num_reg - 1];
    reg [WIDTH - 1:0]                       A_Outreg, B_Outreg;
    reg [WIDTH - 1:0]                       reg_zeta;
    reg [(WIDTH * num_reg_barret1) - 1:0]   reg_barret1;

    wire [(WIDTH * 2) - 1:0]    mul_out, in_barret2;
    wire [WIDTH - 1:0]          barrett_out1, barrett_out2, subb_tmp, oA, oB;
    wire [WIDTH - 1:0]          in_barret1, tmp;

    
    assign tmp  = reg_barret1[(WIDTH * num_reg_barret1) - 1:(WIDTH * (num_reg_barret1 - 1))];
    assign oB   = (barrett_out2[0]) ? (barrett_out2 >> 1) + div2    : barrett_out2 >> 1;
    assign oA   = (tmp[0])          ? (tmp >> 1) + div2             : tmp >> 1;

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            A_Outreg    <= 16'b0;
            B_Outreg    <= 16'b0;  
            reg_zeta    <= 16'b0;
            reg_barret1 <= {(WIDTH * num_reg_barret1){1'b0}};
            for (i = 0; i < num_reg; i = i + 1'b1)
                regx[i] <= 16'b0;
        end 
        else begin
            regx[0]     <= B_In;
            regx[1]     <= A_In;
            reg_zeta    <= W_In;
            reg_barret1 <= {reg_barret1[(WIDTH * (num_reg_barret1 - 1)) - 1:0]  , barrett_out1};
            // B_Outreg    <= barrett_out2;
            // A_Outreg    <= reg_barret1[(WIDTH * num_reg_barret1) - 1:(WIDTH * (num_reg_barret1 - 1))];
            B_Outreg    <= oB;
            A_Outreg    <= oA;
            
        end
    end



    assign subb_tmp     = ~(regx[1]) + 1'b1 + regx[0]; // B - A    
    assign in_barret1   = regx[0] + regx[1];
    assign in_barret2   = mul_out;

    barret barret_inst1(
        .clk(clk), 
        .rst_n(rst_n), 
        .C({16'd0, in_barret1}), 
        .R(barrett_out1)
    );

    barret barret_inst2(
        .clk(clk), 
        .rst_n(rst_n), 
        .C(in_barret2), 
        .R(barrett_out2)
    );

    mul mul_inst(
        .clk(clk), 
        .rst_n(rst_n),
        .A(reg_zeta),
        .B(subb_tmp), 
        .R(mul_out)
    );

    assign A_Out = A_Outreg;
    assign B_Out = B_Outreg;
endmodule