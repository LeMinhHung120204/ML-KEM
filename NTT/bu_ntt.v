`timescale 1ns/1ps

module bu_ntt #(
    parameter WIDTH = 16
)(
    input clk, rst_n,
    input [WIDTH - 1:0] A_In, B_In, W_In,
    output [WIDTH - 1:0] A_Out, B_Out  // NTT

//    // debug
//    output [31:0] check_mul,
//    output [12:0] barret1, barret2, barret3
);
    localparam num_reg      = 2;
    localparam num_reg_A    = 10;
    localparam Qmod         = 3329;

    wire [WIDTH - 1:0]          barrett_out1, barrett_out2;
    wire [(WIDTH * 2) - 1:0]    mul_out, sub_tmp, add_tmp;
    
    assign barret1 = barrett_out1;
    assign barret2 = barrett_out2;
    assign check_mul = mul_out;

    reg [(WIDTH * num_reg_A) - 1:0] regA;
    reg [WIDTH - 1:0]               regx [0:num_reg - 1];
    reg [WIDTH - 1:0]               A_Outreg, B_Outreg;

    wire [WIDTH - 1:0] check = regA[(WIDTH * num_reg_A) - 1: WIDTH *(num_reg_A - 1)];
    
    assign sub_tmp = regA[(WIDTH * num_reg_A) - 1: WIDTH *(num_reg_A - 1)] - mul_out;
    assign add_tmp = regA[(WIDTH * num_reg_A) - 1: WIDTH *(num_reg_A - 1)] + mul_out;

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            A_Outreg    <= 16'b0;
            B_Outreg    <= 16'b0;  
            regA        <= {(WIDTH * num_reg_A){1'b0}};
            for (i = 0; i < num_reg; i = i + 1'b1)
                regx[i] <= 16'b0;
        end 
        else begin
            regx[0]     <= B_In;
            regx[1]     <= W_In;
            regA        <= {regA[(WIDTH * (num_reg_A - 1)) - 1:0], A_In};
            A_Outreg    <= barrett_out1;
            B_Outreg    <= barrett_out2;
        end
    end

    wire in_barret1, in_barret2;

    barret barret_inst1(
        .clk(clk), 
        .rst_n(rst_n), 
        .C(add_tmp), 
        .R(barrett_out1)
    );

    barret barret_inst2(
        .clk(clk), 
        .rst_n(rst_n), 
        .C(sub_tmp), 
        .R(barrett_out2)
    );

    mul mul_inst(
        .clk(clk), 
        .rst_n(rst_n),
        .A(regx[0]), 
        .B(regx[1]), 
        .R(mul_out)
    );

    assign A_Out = A_Outreg;
    assign B_Out = B_Outreg;
endmodule