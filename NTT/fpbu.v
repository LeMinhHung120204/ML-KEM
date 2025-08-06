module fpbu #(
    parameter WIDTH = 32
)(
    input clk, rst_n,
    input Sel_In, // 1: NTT, 0: INTT
    input [WIDTH - 1:0] A_In, B_In, W_In,
    output [WIDTH - 1:0] U_Out, V_Out,  // NTT
    output [WIDTH - 1:0] D_Out, T_Out,  // INTT
    output done
);
    localparam num_reg = 8;
    localparam num_tmp = 21;
    localparam num_tmpy = 24;

    reg [(WIDTH * 2) - 1:0] mul_buf;
    reg [WIDTH - 1:0] regx [0:num_reg - 1];
    reg [WIDTH - 1:0] tmpx [0:num_tmp - 1];
    reg [WIDTH - 1:0] tmpy [0:num_tmpy - 1];


    reg [WIDTH - 1:0] U_Outreg, V_Outreg, D_Outreg, T_Outreg;
    reg [5:0] counter;
    reg start_reduce;
    reg done_reg;
    reg is_warmup;
    
    
    wire [WIDTH - 1:0] barrett_out, Mo_reduce_out;
    wire [(WIDTH * 2) - 1:0] mul_out;
    wire barrett_done, Mo_reduce_done;

    always @(posedge clk) begin
        if (~rst_n) begin
            is_warmup <= 1'b1; // Đánh dấu lần đầu
            done_reg <= 1'b0;
            counter <= 6'b0;
        end 
        else begin
            if (counter == 6'd26) begin
                done_reg  <= 1'b1;
            end
            else counter <= counter + 1'b1;
        end
    end

    integer i, j;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            U_Outreg <= 32'b0;
            V_Outreg <= 32'b0;  
            D_Outreg <= 32'b0;
            T_Outreg <= 32'b0;
            for (i = 0; i < num_reg; i = i + 1'b1)
                regx[i] <= 32'b0;

            for (j = 0; j < num_tmp; j = j + 1'b1)
                tmpx[j]  <= 32'b0;

            for (j = 0; j < num_tmpy; j = j + 1'b1)
                tmpy[j]  <= 32'b0;
        end 
        else begin
            // stage 1
            regx[0] <= Sel_In;
            regx[1] <= A_In;
            regx[2] <= B_In;
            regx[3] <= W_In;

            tmpx[0] <= barrett_out;
            tmpy[0] <= regx[1];
            for (i = 1; i < num_tmp; i = i + 1'b1)
                tmpx[i] <= tmpx[i - 1'b1];

            for (i = 1; i < num_tmpy; i = i + 1'b1)
                tmpy[i] <= tmpy[i - 1'b1];

            // stage n
            regx[4] <= tmpy[23];
            regx[5] <= tmpx[20];
            regx[6] <= (regx[0] == 1'b0) ? regx[1] - regx[2] : regx[2];
            regx[7] <= regx[3];

            // stage n + 1
            D_Outreg <= regx[5];
            U_Outreg <= regx[4] + Mo_reduce_out;
            V_Outreg <= regx[4] - Mo_reduce_out;
            T_Outreg <= Mo_reduce_out;
        end
    end 

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            start_reduce <= 1'b0;
        else if (mul_done)
            start_reduce <= 1'b1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            mul_buf <= 64'b0;
        else 
            mul_buf <= mul_out;
    end

    barret barret_inst(
        .clk(clk), 
        .rst_n(rst_n), 
        .C(regx[1] + regx[2]), 
        .R(barrett_out),
        .done(barrett_done)
    );

    mul mul_inst(
        .clk(clk), 
        .rst_n(rst_n),
        .A(regx[6]), 
        .B(regx[7]), 
        .R(mul_out),
        .done(mul_done)
    );

    Mo_reduce Mo_reduce_inst(
        .clk(clk), 
        .rst_n(rst_n), 
        .C(mul_buf << 23), 
        .enable(1'b1),
        .R(Mo_reduce_out),
        .done(Mo_reduce_done)
    );

    assign done = done_reg;
    assign U_Out = U_Outreg;
    assign V_Out = V_Outreg;
    assign D_Out = D_Outreg;
    assign T_Out = T_Outreg;
endmodule