`timescale 1ns/1ps

module tb_mul_poly_matrix;

    reg clk;
    reg rst_n;
    reg [15:0] a0, a1, a2, a3, b0, b1, b2, b3;
    reg valid_data;
    wire [15:0] res0, res1, res2, res3;

    // Instantiate DUT
    mul_poly_matrix uut (
        .clk(clk),
        .rst_n(rst_n),
        .a0(a0),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .b0(b0),
        .b1(b1),
        .b2(b2),
        .b3(b3),
        .valid_data(valid_data),
        .res0(res0),
        .res1(res1),
        .res2(res2),
        .res3(res3)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        $display("Start Barrett Testbench");
        clk = 0;
        rst_n = 0;
        a0 = 16'd0;
        a1 = 16'd0;
        a2 = 16'd0;
        a3 = 16'd0;
        b0 = 16'd0;
        b1 = 16'd0;
        b2 = 16'd0;
        b3 = 16'd0;

        #20;
        rst_n = 1;
        valid_data = 1;
        a0 = 16'd1;
        a1 = 16'd2;
        a2 = 16'd3;
        a3 = 16'd4;
        b0 = 16'd3;
        b1 = 16'd4;
        b2 = 16'd5;
        b3 = 16'd6;
        
        #10;
        valid_data = 1;
        a0 = 16'd135;
        a1 = 16'd23;
        a2 = 16'd35;
        a3 = 16'd46;
        b0 = 16'd386;
        b1 = 16'd43;
        b2 = 16'd513;
        b3 = 16'd64;

        #10;
        valid_data = 0;
        a0 = 16'd0;
        a1 = 16'd0;
        a2 = 16'd0;
        a3 = 16'd0;
        b0 = 16'd0;
        b1 = 16'd0;
        b2 = 16'd0;
        b3 = 16'd0;
        #500;
        $display("Finished");
        $finish;
    end

endmodule
