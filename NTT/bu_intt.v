module bu_intt #(
    parameter WIDTH = 32
)(
    input clk, rst_n,
    input [WIDTH - 1:0] A_In, B_In, W_In,
    output [WIDTH - 1:0] A_Out, B_Out
);
    localparam num_reg = 31;
    localparam Qmod = 32'd8380417;

    reg [WIDTH - 1:0] regx [0:num_reg - 1];
    reg [WIDTH - 1:0] A_Outreg, B_Outreg;

    wire [WIDTH - 1:0] barrett_out1, barrett_out2, barrett_out3, subb_tmp, add_tmp;
    wire [(WIDTH * 2) - 1:0] mul_out, subb_ex;
    wire barrett_done, Mo_reduce_done;

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            A_Outreg    <= 32'b0;
            B_Outreg    <= 32'b0;  
            for (i = 0; i < num_reg; i = i + 1'b1)
                regx[i] <= 32'b0;
        end 
        else begin

            regx[0]     <= B_In;
            regx[1]     <= A_In;

            regx[2]     <= barrett_out1;    // B + A
            regx[3]     <= barrett_out2;    // B - A

            regx[4]     <= W_In;
            // for (i = 5; i < 10; i = i + 1'b1) begin
            //     regx[i] <= regx[i-1];
            // end

            regx[5] <= regx[4];
            regx[6] <= regx[5];
            regx[7] <= regx[6];
            regx[8] <= regx[7];
            regx[9] <= regx[8];
            regx[10]     <= regx[2];
            // for (i = 11 ; i < num_reg; i = i + 1'b1) begin
            //     regx[i] <= regx[i - 1];
            // end 

            regx[11] <= regx[10];
            regx[12] <= regx[11];
            regx[13] <= regx[12];
            regx[14] <= regx[13];
            regx[15] <= regx[14];
            regx[16] <= regx[15];
            regx[17] <= regx[16];
            regx[18] <= regx[17];
            regx[19] <= regx[18];
            regx[20] <= regx[19];
            regx[21] <= regx[20];
            regx[22] <= regx[21];
            regx[23] <= regx[22];
            regx[24] <= regx[23];
            regx[25] <= regx[24];
            regx[26] <= regx[25];
            regx[27] <= regx[26];
            regx[28] <= regx[27];
            regx[29] <= regx[28];
            regx[30] <= regx[29];

            B_Outreg    <= barrett_out3;
            A_Outreg    <= regx[num_reg - 1];
            
        end
    end

    assign subb_tmp = ~(regx[1]) + 1'b1 + regx[0]; // B - A
    assign add_tmp = regx[0] + regx[1];
    assign subb_ex = {{32{subb_tmp[31]}}, subb_tmp};

    barret barret_inst1(
        .clk(clk), 
        .rst_n(rst_n), 
        .C({32'b0, add_tmp}), 
        .R(barrett_out1)
    );

    barret barret_inst2(
        .clk(clk), 
        .rst_n(rst_n), 
        .C((subb_ex[63] == 1'b1) ? subb_ex + Qmod : subb_ex), 
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
        .A(regx[9]), 
        .B(regx[3]), 
        .R(mul_out)
    );

    assign A_Out = A_Outreg;
    assign B_Out = B_Outreg;
endmodule