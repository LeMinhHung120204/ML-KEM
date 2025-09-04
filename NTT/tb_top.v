`timescale 1ns/1ps

module tb_top;
  // Tham s?
  localparam WIDTH_ADDR_BUTTERFLY = 8;
  localparam WIDTH_ADDR_ZETAS = 7;
  localparam WIDTH = 16;
  localparam WIDTH_BUS_DATA = 256 * 32;

  // I/O DUT
  reg  clk, rst_n, start, is_ntt, valid_input, load_done;
  reg  [WIDTH-1:0] in0, in1;

  wire [WIDTH_ADDR_BUTTERFLY - 1:0] addr0, addr1, oaddr0, oaddr1, addr_in1, addr_in2;
  wire [12:0] bin0, bin1, bout0, bout1, ozeta, out_j, out_jl, barret1, barret2, barret3;
  wire [11:0] check_counter;
  wire [31:0] check_mul;
  wire [1:0] ostate, o_next_state;
  wire [WIDTH-1:0] out0, out1;
  wire done_compute, valid_output, check_write, check_toggle, o_start_gen_addr;

  // Clock 10ns
  always #2.5 clk = ~clk;

  // DUT
  top #(
    .WIDTH_ADDR_BUTTERFLY(WIDTH_ADDR_BUTTERFLY),
    .WIDTH_ADDR_ZETAS(WIDTH_ADDR_ZETAS),
    .WIDTH(WIDTH)
  ) dut (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .is_ntt(is_ntt),
    .valid_input(valid_input),
    .in0(in0),
    .in1(in1),
    // .addr_in1(addr_in1),
    // .addr_in2(addr_in2),
    .done_compute(done_compute),
//     .load_done(load_done),
     .out0(out0),
     .out1(out1),
     .addr0(addr0),
     .addr1(addr1),
    // .output_valid(valid_output),
    // .oaddr0(oaddr0),
    // .oaddr1(oaddr1),
    // .bin0(bin0),
    // .bin1(bin1),
    // .bout0(bout0),
    // .bout1(bout1),
    // .ozeta(ozeta),
    // .out_j(out_j),
    // .out_jl(out_jl),
    // .barret1(barret1),
    // .barret2(barret2),
    // .barret3(barret3),
    // .check_mul(check_mul),
    // .check_counter(check_counter),
    // .check_write(check_write),
    // .check_toggle(check_toggle),
     .ostate(ostate)
    // .o_next_state(o_next_state),
    // .o_start_gen_addr(o_start_gen_addr)
  );


  integer k;

  initial begin
    // Kh?i t?o
    
    
    clk = 0;
    rst_n = 0;
    start = 0;
    is_ntt = 1'b0;
    valid_input = 0;
    in0 = 16'd0; 
    in1 = 16'd0;
    load_done = 1'b0;

    // Reset
    #400 rst_n = 1;

    // B?t ??u
    start = 1;
    #50; start = 0;
    // N?p 128 l?n d? li?u
    valid_input <= 1'b1;
    for (k = 1; k <= 128; k = k + 1) begin
        @(negedge clk);
//        valid_input <= 1'b1;
        in0 <= k;                // gi� tr? in0
        in1 <= 16'd145 + k * 2;     // gi� tr? in1
    end
    
    // Ng?t valid_input
//    @(negedge clk);
    #5; valid_input <= 1'b0;
 
    #2.5;
    
    load_done <= 1'b1;
    
    in0 <= 16'd0;
    in1 <= 16'd0;

    // Ch?? x? l� xong
    wait (done_compute);
    $display("[%0t] DONE_STORE!", $time);

    #80;
    $finish;
  end

  // Timeout ph�ng treo
  initial begin
    #20000;
    $display("TIMEOUT");
    $finish;
  end

endmodule
