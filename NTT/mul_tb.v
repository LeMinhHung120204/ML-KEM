`timescale 1ns/1ps

module mul_tb;

    // Tín hiệu kết nối
    reg         clk;
    reg         rst_n;
    reg  [15:0] A, B;
    wire [31:0] R;

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
        A = 16'd13001;
        B = 16'd2154;
        
        #10
        // Test case 1: 6 * -3 = -18
        A = 16'd0;
        B = 16'd0;  // signed negative number

        // Test case 2: -5 * -7 = 35
        #10
        A = 16'd5;
        B = 16'd7;
        
        #10
        A = 16'd2;
        B = 16'd3;
        
        #10
        A = -16'd6;
        B = 16'd10;

        #170 $finish;
    end

endmodule
