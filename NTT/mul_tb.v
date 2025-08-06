`timescale 1ns/1ps

module mul_tb;

    // Tín hiệu kết nối
    reg         clk;
    reg         rst_n;
    reg  [31:0] A, B;
    wire [63:0] R;

    // Khởi tạo DUT
    mul dut (
        .clk(clk),
        .rst_n(rst_n),
        .A(A),
        .B(B),
        .R(R)
    );

    // Tạo clock 10ns
    always #5 clk = ~clk;

    initial begin
        $display("Start Booth Multiplier TB");
        // Init
        clk   = 0;
        rst_n = 0;
        A     = 0;
        B     = 0;

        #10 rst_n = 1;
        A = 32'd8380401;
        B = 32'd2154;
        
//        #10
//        // Test case 1: 6 * -3 = -18
//        A = 32'd0;
//        B = 32'd0;  // signed negative number

//        // Test case 2: -5 * -7 = 35
//        #10
//        A = 32'd5;
//        B = 32'd7;
        
//        #10
//        A = 32'd2;
//        B = 32'd3;
        
//        #10
//        A = -32'd6;
//        B = 32'd10;

        #170 $finish;
    end

endmodule
