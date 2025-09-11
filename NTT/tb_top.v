`timescale 1ns/1ps

module tb_top;
  // Tham số
  localparam WIDTH_ADDR_BUTTERFLY = 8;
  localparam WIDTH_ADDR_ZETAS     = 7;
  localparam WIDTH                = 16;

  localparam NWORDS  = 256;
  localparam NPAIRS  = NWORDS/2;

  // I/O DUT
  reg  clk, rst_n, start, is_ntt, valid_input;
  reg  [WIDTH-1:0] in0, in1;

  wire [1:0] ostate;
  wire [WIDTH-1:0] out0, out1;
  wire done_compute;
  wire [WIDTH_ADDR_BUTTERFLY-1:0] addr0, addr1;

  // Clock 5ns (200 MHz)
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
    .out0(out0),
    .out1(out1),
    .addr0(addr0),
    .addr1(addr1),
    .ostate(ostate)
  );

  // Bộ nhớ dữ liệu đầu vào
  reg [15:0] data_mem [0:NWORDS-1];

  integer i;

  initial begin
    // Init
    clk = 0;
    rst_n = 0;
    start = 0;
    is_ntt = 1'b1;
    valid_input = 0;
    in0 = 16'd0;
    in1 = 16'd0;

    // Nạp dữ liệu từ file hex (mỗi token = 16-bit, base16)
    $readmemh("C:/Hung/Viettel/Stage2/ML-KEM/NTT/input.hex", data_mem);

    // Reset
    #200  rst_n = 1;   // bạn đang để #400; nếu cần giữ dài thì chỉnh lại
    #10;

    start = 1;
    #5;  start = 0;

    valid_input <= 1'b1;
    for (i = 0; i < NPAIRS; i = i + 1) begin
      @(negedge clk);
      in0 <= data_mem[2*i];
      in1 <= data_mem[2*i + 1];
    end

    // Hạ valid, clear input
    @(negedge clk);
    valid_input <= 1'b0;
    in0 <= 16'd0;
    in1 <= 16'd0;

    wait (done_compute);
    $display("[%0t] DONE_STORE!", $time);

    #80;
    $finish;
  end

  // Timeout
  initial begin
    #20000;
    $display("TIMEOUT");
    $finish;
  end
endmodule
