`timescale 1ns / 1ps

module tb_bootrom;
    reg clock;
    reg oe;
    reg me;
    reg [11:0] address;
    wire [31:0] q;

    // Instantiate the ROM
    MyBootROM uut (
        .clk(clock),
        .oe(oe),
        .me(me),
        .address(address),
        .q(q)
    );

    // Clock generation: 10ns period
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    initial begin
        $display("----- Start ROM Test -----");
        // Init
        oe = 0;
        me = 0;
        address = 12'd0;

        // Wait for ROM to load
        #20;

        // Enable ROM and test a few addresses
        me = 1;
        oe = 1;

        // Test 5 values (addresses 0 to 4)
        repeat (5) begin
            $display("ROM[%0d] = %h", address, q);
            #10;
            address = address + 1;
        end

        // Finish
        #20;
        $display("----- End ROM Test -----");
        $finish;
    end
endmodule
