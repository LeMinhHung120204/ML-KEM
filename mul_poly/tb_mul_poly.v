`timescale 1ns/1ps

module tb_mul_poly;

    reg clk;
    reg rst_n;
    reg [15:0] a0, a1, b0, b1, zetas;
    wire [15:0] res0, res1;

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
        a0 = 16'd0;
        a1 = 16'd0;
        b0 = 16'd0;
        b1 = 16'd0;
        zetas = 16'd0;

        // Reset
        #20;
        rst_n = 1;
        a0 = 16'd1;
        a1 = 16'd2;
        b0 = 16'd3;
        b1 = 16'd4;
        zetas = 16'd5;

        #10;
        a0 = 16'd13;
        a1 = 16'd16;
        b0 = 16'd432;
        b1 = 16'd978;
        zetas = 16'd35;
        #500;
        $display("Finished");
        $finish;
    end

endmodule
