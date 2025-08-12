`timescale 1ns/1ps

module tb_top;
  // Tham số
  localparam WIDTH = 16;

  // I/O DUT
  reg  clk, rst_n, start, is_ntt, valid_input;
  reg  [WIDTH-1:0] in0, in1;
  wire done_compute, done_store, load_done;

  // Clock 10ns
  always #5 clk = ~clk;

  // DUT
  top #(
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
    .done_store(done_store),
    .load_done(load_done)
  );

  integer k;

  initial begin
    // Khởi tạo
    clk = 0;
    rst_n = 0;
    start = 0;
    is_ntt = 1'b1;        // chạy NTT
    valid_input = 0;
    in0 = 16'd0; 
    in1 = 16'd0;

    // Reset
    #10 rst_n = 1;

    // Bắt đầu
    @(posedge clk); start = 1;
    @(posedge clk); start = 0;

    // Nạp 128 lần dữ liệu
    for (k = 0; k < 128; k = k + 1) begin
        @(posedge clk);
        valid_input <= 1'b1;
        in0 <= k;                // giá trị in0
        in1 <= 16'd1000 + k;     // giá trị in1
    end

    // Ngắt valid_input
    @(posedge clk);
    valid_input <= 1'b0;
    in0 <= 0;
    in1 <= 0;

    // Chờ xử lý xong
    wait (done_store);
    $display("[%0t] DONE_STORE!", $time);

    #20;
    $finish;
  end

  // Timeout phòng treo
  initial begin
    #200000;
    $display("TIMEOUT");
    $finish;
  end

endmodule
