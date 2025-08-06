`timescale 1ns/1ps

module AddressGeneratortb;

    reg clk;
    reg rst_n;
    reg start;
    reg is_ntt;
    wire done, valid;
    wire [7:0] addr0, addr1;
    wire [6:0] addr_tw;

    // Instantiate DUT
    AddressGenerator uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .valid(valid),
        .addr0(addr0),
        .addr1(addr1),
        .addr_tw(addr_tw),
        .is_ntt(is_ntt),
        .ntt_finished(done)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;

        // Reset
        #20;
        rst_n = 1;
        start = 1;
        is_ntt = 1;

        #18000
        $display("Finished");
        $finish;
    end

endmodule
