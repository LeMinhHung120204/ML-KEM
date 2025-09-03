module tb_mul_12bit;
    reg clk;
    reg rst_n;
    reg [11:0] a, b;
    wire [23:0] res;

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

    initial begin
        $display("Start 12-bit Multiplier Testbench");
        clk = 0;
        rst_n = 0;
        a = 12'd0;
        b = 12'd0;

        // Reset
        #20;
        rst_n = 1;
        a = 12'd1;
        b = 12'd2;

        #10;
        a = 12'd3000;
        b = 12'd2;
        #500;
        $display("Finished");
        $finish;
    end
endmodule