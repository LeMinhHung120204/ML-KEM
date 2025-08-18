`timescale 1ns/1ps

module bu_intt #(
    parameter WIDTH = 16
)(
    input clk, rst_n,
    input [WIDTH - 1:0] A_In, B_In, W_In,
    output [WIDTH - 1:0] A_Out, B_Out,

    // debug
    output [WIDTH - 1:0] barret1, barret2, barret3,
    output [(WIDTH * 2) - 1:0] o_mul, sub_out, add_out
);
    localparam num_reg = 20;
    localparam Qmod = 16'd3329;

    reg [WIDTH - 1:0] regx [0:num_reg - 1];
    reg [WIDTH - 1:0] A_Outreg, B_Outreg;

    wire [WIDTH - 1:0] barrett_out1, barrett_out2, barrett_out3, subb_tmp, add_tmp;
    wire [(WIDTH * 2) - 1:0] mul_out, subb_ex;

    // debug
    assign barret1 = barrett_out1;
    assign barret2 = barrett_out2;
    assign barret3 = barrett_out3;
    assign o_mul = mul_out;
    assign sub_out = subb_ex;
    assign add_out = {{16{add_tmp[15]}}, add_tmp};


    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            A_Outreg    <= 16'b0;
            B_Outreg    <= 16'b0;  
            for (i = 0; i < num_reg; i = i + 1'b1)
                regx[i] <= 16'b0;
        end 
        else begin

            regx[0]     <= B_In;
            regx[1]     <= A_In;

            regx[2]     <= barrett_out1;    // B + A

            regx[3]     <= W_In;

            regx[4] <= regx[3];
            regx[5] <= regx[4];
            regx[6] <= regx[5];
            regx[7] <= regx[6];

            regx[8]  <= regx[2];
            regx[9] <= regx[8];
            regx[10] <= regx[9];
            regx[11] <= regx[10];
            regx[12] <= regx[11];
            regx[13] <= regx[12];
            regx[14] <= regx[13];
            regx[15] <= regx[14];
            regx[16] <= regx[15];
            regx[17] <= regx[16];
            regx[18] <= regx[17];
            regx[19] <= regx[18];

            B_Outreg    <= barrett_out3;
            A_Outreg    <= regx[17];
            
        end
    end

    assign subb_tmp = ~(regx[1]) + 1'b1 + regx[0]; // B - A
    assign add_tmp = regx[0] + regx[1];
    assign subb_ex = {{16{subb_tmp[15]}}, subb_tmp};

    barret barret_inst1(
        .clk(clk), 
        .rst_n(rst_n), 
        .C({{16{add_tmp[15]}}, add_tmp}), 
        .R(barrett_out1)
    );

    barret barret_inst2(
        .clk(clk), 
        .rst_n(rst_n), 
        .C((subb_ex[31] == 1'b1) ? subb_ex + Qmod : subb_ex), 
        .R(barrett_out2)
    );

    barret barret_inst3(
        .clk(clk), 
        .rst_n(rst_n), 
        .C(mul_out), 
        .R(barrett_out3)
    );

    mul mul_inst(
        .clk(clk), 
        .rst_n(rst_n),
        .A(regx[5]), 
        .B(barrett_out2), 
        .R(mul_out)
    );

    assign A_Out = A_Outreg;
    assign B_Out = B_Outreg;
endmodule