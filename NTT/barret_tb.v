`timescale 1ns/1ps

module barret_tb;

    reg clk;
    reg rst_n;
    reg [63:0] C;
    wire [31:0] R;
    wire done;

    // Instantiate DUT
    barret uut (
        .clk(clk),
        .rst_n(rst_n),
        .C(C),
        .R(R)
//        .done(done)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        $display("Start Barrett Testbench");
        clk = 0;
        rst_n = 0;
        C = 64'd0;

        // Reset
        #20;
        rst_n = 1;

        // Test case 1
        #10; C = 64'haFFFFFFFFFFF;

        // Test case 2
        #10; C = 64'd8380417;   // same as q in Kyber

        // Test case 3
        #10; C = 64'd10;

        // Test case 4
        #10; C = 64'd8380418;

        // Test case 5
        #10; C = 64'd1;  // max 16-bit

        // Wait and finish
        #100;
        $display("Finished");
        $finish;
    end

endmodule
