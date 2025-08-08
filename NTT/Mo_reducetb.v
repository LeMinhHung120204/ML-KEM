`timescale 1ns / 1ps

module tb_Mo_reduce;

    reg clk, rst_n;
    reg [63:0] C;
    wire [31:0] R;
    wire done;
    reg enable;

    // Instantiate DUT (Device Under Test)
    Mo_reduce uut (
        .clk(clk),
        .rst_n(rst_n),
        .C(C),
        .R(R)
    );

    // Clock generation: 10ns period (100 MHz)
    always #5 clk = ~clk;

    initial begin
        $display("Time\tC\t\t\t\tR");
        $monitor("%0dns\t0x%08h\t%0d", $time, C, R);

        // Initialize
        clk = 0;
        rst_n = 0;
        C = 0;
        enable = 0;

        // Hold reset for 2 cycles
        #10;
        rst_n = 1;
        enable = 1;

        // Test case 1
//        C = 64'h2A240E426A2;
        C = 64'd491298456862720;      
        #10;

//        // Test case 2
//        C = 64'd851;  // Montgomery representation of 1234 with q=3329
//        #10;

//        // Test case 3
//        C = 64'd0;
//        #10;

//        // Test case 4
//        C = 64'hFFFFFFFF;
        #100;
        $finish;
    end

endmodule
