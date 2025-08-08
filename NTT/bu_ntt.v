module bu_ntt #(
    parameter WIDTH = 16
)(
    input clk, rst_n,
    input [WIDTH - 1:0] A_In, B_In, W_In,
    output [WIDTH - 1:0] A_Out, B_Out  // NTT
);
    localparam num_reg = 17;
    localparam Qmod = 16'd3329;

    reg [WIDTH - 1:0] regx [0:num_reg - 1];
    reg [WIDTH - 1:0] A_Outreg, B_Outreg;
    
    wire [WIDTH - 1:0] barrett_out1, barrett_out2, barrett_out3, sub_tmp;
    wire [(WIDTH * 2) - 1:0] mul_out;

    assign sub_tmp = regx[num_reg - 1] - barrett_out3;

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
            regx[1]     <= W_In;
            regx[4]     <= A_In;
            // for (i = 5; i < num_reg; i = i + 1'b1)
            //     regx[i] <= regx[i - 1];

            regx[5]  <= regx[4];
            regx[6]  <= regx[5];
            regx[7]  <= regx[6];
            regx[8]  <= regx[7];
            regx[9]  <= regx[8];
            regx[10] <= regx[9];
            regx[11] <= regx[10];
            regx[12] <= regx[11];
            regx[13] <= regx[12];
            regx[14] <= regx[13];
            regx[15] <= regx[14];
            regx[16] <= regx[15];

            regx[3]     <= regx[num_reg - 1] + barrett_out3;
            regx[2]     <= (sub_tmp[WIDTH - 1] == 1'b1) ? sub_tmp + Qmod : sub_tmp;

            A_Outreg    <= barrett_out1;
            B_Outreg    <= barrett_out2;
        end
    end

    barret barret_inst1(
        .clk(clk), 
        .rst_n(rst_n), 
        .C({16'b0, regx[3]}), 
        .R(barrett_out1)
    );

    barret barret_inst2(
        .clk(clk), 
        .rst_n(rst_n), 
        .C({16'b0, regx[2]}), 
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
        .A(regx[0]), 
        .B(regx[1]), 
        .R(mul_out)
    );

    assign A_Out = A_Outreg;
    assign B_Out = B_Outreg;
endmodule