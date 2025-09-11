`timescale 1ns/1ps
module tb_mul_poly_matrix;

  localparam integer WIDTH = 12;
  localparam integer NUM   = 16;

  reg                      clk;
  reg                      rst_n;
  reg  [2:0]               k;
  reg                      valid_data;
  reg  [(WIDTH*NUM)-1:0]   a, b;
  reg [9:0] count_clock;
  reg [11:0] r12, r13, r14, r15;
  wire [(WIDTH*NUM)-1:0]   res;
  wire                     valid_output;

  mul_cel dut (
    .clk(clk),
    .rst_n(rst_n),
    .valid_data(valid_data),
    .k(k),
    .a(a),
    .b(b),
    .res(res),
    .valid_output(valid_output)
  );

  initial clk = 1'b0;
  always #2.5 clk = ~clk;
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count_clock <= 10'd0;
    end 
    else begin
        count_clock <= count_clock + 1'b1;
    end 
  end 

  task automatic print_bus12_hex(
    input [(WIDTH*NUM)-1:0] v,
    input [127:0] tag
  );
    integer j;
    reg [WIDTH-1:0] coeff;
    begin
      $write("%s:", tag);
      for (j = 0; j < NUM; j = j + 1) begin
        coeff = (v >> (j*WIDTH)) & 12'hFFF;
        $write(" %03h", coeff[11:0]);
      end
      $write("\n");
    end
  endtask

  initial begin
    $dumpfile("tb_mul_poly_matrix.vcd");
    $dumpvars(0, tb_mul_poly_matrix);

    rst_n      = 1'b0;
    k          = 3'd0;
    valid_data = 1'b0;
    a          = { (WIDTH*NUM){1'b0} };
    b          = { (WIDTH*NUM){1'b0} };

    #10
    rst_n = 1'b1;
    @(posedge clk);
    k = 3'd2;

    #2.5;
    valid_data <= 1'b1;
    a = {
      12'h403, 12'hb18, 12'hb50, 12'h331,
      12'hb31, 12'h43f, 12'h459, 12'ha56,
      12'ha64, 12'h4c9, 12'hb64, 12'ha58,
      12'h819, 12'h0df, 12'h00b, 12'hae1
    };

    b = {
      12'h47f, 12'h20e, 12'h66f, 12'hbe2,
      12'h4db, 12'hc16, 12'h0ed, 12'h090,
      12'h261, 12'h455, 12'h8dc, 12'h489,
      12'h63f, 12'h3a6, 12'h1cc, 12'h7e6
    };
    
    #5;
    a = {
      12'h87a, 12'h893, 12'h661, 12'h8cb,
      12'hbe7, 12'h10f, 12'h544, 12'h10c,
      12'h33e, 12'haf7, 12'h8a1, 12'h963,
      12'h1d6, 12'h36f, 12'h2ce, 12'hc0a
    };

    b = {
      12'h75a, 12'h056, 12'h311, 12'hcc2,
      12'h3d1, 12'h765, 12'hc4d, 12'h99e,
      12'h3d5, 12'h525, 12'h390, 12'hc35,
      12'h5da, 12'h0b5, 12'h3ce, 12'haca
    };

    #5;
    a = 192'h2a604366892e1cd65735fbe8c49047547247a3b3ca764cb2;

    b = 192'h9658d8a598864369fcbbd4a37845995aa4618bd35a1ca75f;
    
    #5;
    a = 192'h59e44b0af5930bf33980f44e40c48a32aa0711778b59032a;

    b = 192'h3546a162676aad284b62170066838ca1c6227a7c920332e7;

    #5;
    valid_data <= 1'b0;
    #40
    valid_data <= 1'b1;
    a = 192'h6017e19fd5f544327973103c29aafdbd1c7908fbda355b10;

    b = 192'hc642828289207a78c88c3bc1bc783524c9fb3df6059d782f;
    
    #5;
    a = 192'hc6f6f444f86572bb02a204b72bb4c30a829d79d4a315879d;

    b = 192'h0e54a8a3186c55a58478f4db2e722e83dc08a60168cbf4fe;

    #5;
    a = 192'hac9a6b34a3cbae5aea4a20d5aea9cd37a8105020e85453bc;

    b = 192'hca58821ae4d92bfb50b8b8be7a8ae8b8f5ea7b73185c6787;
    
    #5;
    a = 192'h12495e9e5a8a917a9c4bac6b9432b917615660e1cb883781;

    b = 192'h7ad5266dbb4588b7286bfba2a2f0cf5ed34e83b14e936268;

    #5;
    valid_data <= 1'b0;
    print_bus12_hex(a, "a");
    print_bus12_hex(b, "b");

    @(posedge valid_output);
    print_bus12_hex(res, "res");

    r12 = (res >> (12*12)) & 12'hFFF;
    r13 = (res >> (13*12)) & 12'hFFF;
    r14 = (res >> (14*12)) & 12'hFFF;
    r15 = (res >> (15*12)) & 12'hFFF;

    $display("expect r12..r15 = {b65, 967, c71, 6a7}");
    $display("got    r12..r15 = {%03h, %03h, %03h, %03h}", r12, r13, r14, r15);

    if (r12==12'hb65 && r13==12'h967 && r14==12'hc71 && r15==12'h6a7)
      $display("PASS");
    else
      $display("FAIL");

//    repeat (10) @(posedge clk);
    #100
    $finish;
  end

endmodule
