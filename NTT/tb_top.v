`timescale 1ns/1ps

module tb_top;
  // Tham số
  localparam WIDTH_ADDR_BUTTERFLY = 8;
  localparam WIDTH_ADDR_ZETAS = 7;
  localparam WIDTH = 16;
  localparam WIDTH_BUS_DATA = 256 * 32;

  // I/O DUT
  reg  clk, rst_n, start, is_ntt, valid_input;
  reg  [WIDTH-1:0] in0, in1;

  wire [WIDTH_ADDR_BUTTERFLY - 1:0] addr0, addr1;
  wire [WIDTH-1:0] out0, out1;
  wire done_compute, load_done, valid_output;
  // wire [WIDTH_ADDR_BUTTERFLY - 1:0] addr_j, addr_jl;
  wire [WIDTH_ADDR_BUTTERFLY - 1:0] owaddr_a, owaddr_b;
  wire [WIDTH_ADDR_ZETAS - 1:0] addr_zetas;
  // wire [WIDTH - 1:0] out_j_ntt, out_j_intt, out_jl_ntt, out_jl_intt;
  wire [WIDTH - 1:0] zetas;
  wire [WIDTH - 1:0] barret1, barret2, barret3;
  wire [WIDTH - 1:0] Bin_a, Bin_b, Bo_a, Bo_b;
  wire [(WIDTH * 2) - 1:0] mul_out, sub_out, add_out;
  // wire [1:0] check_state;
  // wire valid_addr, done_addr, valid, owrite_en;
  // wire [7:0] check_count_addr, check_count_load;

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
    .done_compute(done_compute),
    .load_done(load_done),
    .valid_output(valid_output),
    .out0(out0),
    .out1(out1),
    .addr0(addr0),
    .addr1(addr1),
    .output_valid(valid_output)

    // debug
    // .addr_j(addr_j),
    // .addr_jl(addr_jl),
    // .owaddr_a(owaddr_a),
    // .owaddr_b(owaddr_b),
    // .oaddr_zetas(addr_zetas),
    // .out_j_ntt(out_j_ntt),
    // .out_j_intt(out_j_intt),
    // .out_jl_ntt(out_jl_ntt),
    // .out_jl_intt(out_jl_intt),
    // .zetas(zetas),
    // .Bin_a(Bin_a),
    // .Bin_b(Bin_b),
    // .Bo_a(Bo_a),
    // .Bo_b(Bo_b),
    // .check_state(check_state),
    // .barret1(barret1),
    // .barret2(barret2),
    // .barret3(barret3),
    // .mul_out(mul_out),
    // .sub_out(sub_out),
    // .add_out(add_out)
    // .valid_addr(valid_addr),
    // .done_addr(done_addr),
    // .valid(valid),
    // .owrite_en(owrite_en)
    // .check_count_addr(check_count_addr),
    // .check_count_load(check_count_load)

  );


  integer k;

  initial begin
    // Khởi tạo
    
    
    clk = 0;
    rst_n = 0;
    start = 0;
    is_ntt = 1'b1;
    valid_input = 0;
    in0 = 16'd0; 
    in1 = 16'd0;

    // Reset
    #400 rst_n = 1;

    // Bắt đầu
    start = 1;
    #50; start = 0;

    // Nạp 128 lần dữ liệu
    for (k = 1; k <= 128; k = k + 1) begin
        @(posedge clk);
        valid_input <= 1'b1;
        in0 <= k;                // giá trị in0
        in1 <= 16'd145 + k * 2;     // giá trị in1
    end

    // Ngắt valid_input
    @(posedge clk);
    valid_input <= 1'b0;
    in0 <= 16'd0;
    in1 <= 16'd0;

    // Ch�? xử lý xong
    wait (done_compute);
    $display("[%0t] DONE_STORE!", $time);

    #80;
    $finish;
  end

  // Timeout phòng treo
  initial begin
    #200000;
    $display("TIMEOUT");
    $finish;
  end

endmodule
