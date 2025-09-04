`timescale 1ns/1ps

module tb_fpbu;
    reg clk, rst_n;
    reg Sel_In;
    reg [15:0] A_In, B_In, W_In;
    reg [5:0] count_clock;
    wire [15:0] A_Out, B_Out;

    // Instantiate DUT
    bu_intt uut (
        .clk(clk),
        .rst_n(rst_n),
        .A_In(A_In),
        .B_In(B_In),
        .W_In(W_In),
        .A_Out(A_Out),
        .B_Out(B_Out)
    );

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            count_clock <= 6'd0;
        end 
        else begin
            count_clock <= count_clock + 1'b1;
        end     
    end 

    // Clock generation
    always #5 clk = ~clk;
    
    
    
    initial begin
        $display("Start simulation");
        $dumpfile("fpbu.vcd");
        $dumpvars(0, tb_fpbu);

        // Init
        clk = 0;
        rst_n = 0;
        Sel_In = 0;
        A_In = 0;
        B_In = 0;
        W_In = 0;

        // Reset
        #20;
        rst_n = 1;

        // Test NTT
        //Sel_In = 1;
        A_In = 16'd800;
        B_In = 16'd3;
        W_In = 16'd7;

        //Test INTT
        #10;
        //Sel_In = 1;
        A_In = 16'd16;
        B_In = 16'd20;
        W_In = 16'd3;

        #3800;

        $finish;
    end
endmodule
