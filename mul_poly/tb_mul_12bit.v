`timescale 1ns/1ps
module tb_mul_12bit;
    reg clk;
    reg rst_n;
    reg [9:0] count_clock;
    reg [12:0] a, b;
    wire [25:0] res;

    // Instantiate DUT
    mul_12bit uut (
        .clk(clk),
        .rst_n(rst_n),
        .A(a),
        .B(b),
        .R(res)
    );
    // Clock generation: 10ns period
    always #5 clk = ~clk;
    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count_clock <= 10'd0;
        end 
        else begin
            count_clock <= count_clock + 1'b1;
        end 
    end

    initial begin
        $display("Start 12-bit Multiplier Testbench");
        clk = 0;
        rst_n = 0;
        a = 13'd10;
        b = 13'd0;

        // Reset
        #20;
        rst_n = 1;
        a = 13'd1884;
        b = 13'd2649;

        #10;
        a = 13'd3000;
        b = 13'd2;
        #500;
        $display("Finished");
        $finish;
    end
endmodule