`timescale 1ns/1ps

module tb_mul_poly;

    reg clk;
    reg rst_n;
    reg [11:0] a0, a1, b0, b1;
    reg [12:0] zetas;
    wire [11:0] res0, res1;
    reg [8:0] counter;
   

    // Instantiate DUT
    mul_poly uut (
        .clk(clk),
        .rst_n(rst_n),
        .a0(a0),
        .a1(a1),
        .b0(b0),
        .b1(b1),
        .zetas(zetas),
        .res0(res0),
        .res1(res1)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        $display("Start Barrett Testbench");
        clk = 0;
        rst_n = 0;
        a0 = 12'd0;
        a1 = 12'd0;
        b0 = 12'd0;
        b1 = 12'd0;
        zetas = 13'd0;

        // Reset
        #20;
        rst_n = 1;
        a0 = 12'd1;
        a1 = 12'd2;
        b0 = 12'd3;
        b1 = 12'd4;
        zetas = -13'd5;

        #10;
        a0 = 12'd13;
        a1 = 12'd3328;
        b0 = 12'd432;
        b1 = 12'd978;
        zetas = 13'd3000;
        #500;
        $display("Finished");
        $finish;
        
        
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)      counter <= 9'd0;     // reset khi rst_n=0
        else             counter <= counter + 1'b1;
    end



endmodule
