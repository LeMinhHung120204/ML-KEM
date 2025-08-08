`timescale 1ns / 1ps

module tb_top;

    // Parameters
    localparam WIDTH_ADDR_BUTTERFLY = 8;
    localparam WIDTH_ADDR_ZETAS     = 7;
    localparam WIDTH                = 16;
    localparam DEPTH = 256;
    localparam WORDW = 32;   // mỗi phần tử trong BRAM
    localparam WIDTH_BUS_DATA       = DEPTH * WORDW;

    // Signals
    reg clk, rst_n, start, is_ntt;
    wire done_compute, done_store;


    wire [WIDTH_ADDR_BUTTERFLY - 1:0] addr_j, addr_jl, waddr_a, waddr_b;
    wire [WIDTH_ADDR_ZETAS - 1:0] addr_zetas;
    wire [WIDTH - 1:0] out_j_ntt, out_j_intt, out_jl_ntt, out_jl_intt, zetas;
    wire [WIDTH - 1:0] Bin_a, Bin_b, Bo_a, Bo_b;
    wire valid_addr, done_addr, valid, owrite_en;
    wire [1:0] check_state;
    wire [WIDTH_BUS_DATA - 1:0] data_bram;

    // Mảng để xem cho dễ trên waveform
    reg [WORDW-1:0] mem_tb [0:DEPTH-1]; 
    integer i;
    // Unpack data_bram -> mem_tb[i]
    always @* begin
    for (i = 0; i < DEPTH; i = i + 1)
        mem_tb[i] = data_bram[(i+1)*WORDW-1 -: WORDW]; // khớp công thức bạn dùng khi pack
    end

    // Instantiate DUT
    top #(
        .WIDTH_ADDR_BUTTERFLY(WIDTH_ADDR_BUTTERFLY),
        .WIDTH_ADDR_ZETAS(WIDTH_ADDR_ZETAS),
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .is_ntt(is_ntt),
        .done_compute(done_compute),
        .done_store(done_store),
        .addr_j(addr_j),
        .addr_jl(addr_jl),
        .addr_zetas(addr_zetas),
        .out_j_ntt(out_j_ntt),
        .out_jl_ntt(out_jl_ntt),
        .out_j_intt(out_j_intt),
        .out_jl_intt(out_jl_intt),
        .valid_addr(valid_addr),
        .done_addr(done_addr),
        .valid(valid),
        .zetas(zetas),
        .Bin_a(Bin_a),
        .Bin_b(Bin_b),
        .Bo_a(Bo_a),
        .Bo_b(Bo_b),
        .waddr_a(waddr_a),
        .waddr_b(waddr_b),
        .check_state(check_state),
        .owrite_en(owrite_en),
        .data_bram(data_bram)
    );

    // Clock generator: 10ns period
    always #5 clk = ~clk;

    // Cycle counter
    integer cycle_count;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            cycle_count <= 0;
        else
            cycle_count <= cycle_count + 1;
    end

    // Main stimulus
    initial begin
        // Initialize signals
        clk     = 0;
        rst_n   = 0;
        start   = 0;
        is_ntt  = 1;

        // Apply reset
        #10;
        rst_n = 1;

        // Wait a bit, then start
//        #400;
        start = 1;

        #20;
        start = 0;

        // Wait for done_store = 1
        wait(done_store);
        $display("? done_store = 1 at cycle = %0d", cycle_count);

        #50;
        $finish;
    end
    initial begin
        #10000
        $finish;
    end
endmodule
