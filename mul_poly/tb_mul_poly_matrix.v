`timescale 1ns/1ps
module tb_mul_poly_matrix;
    localparam integer WIDTH = 12;
    localparam integer NUM   = 16;  
    reg                         clk;
    reg                         rst_n;
    reg  [2:0]                  k;
    reg                         valid_data;
    reg  [(WIDTH*NUM)-1:0]      a, b;
    wire [(WIDTH*NUM)-1:0]      res;   
    wire                        valid_output; 
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

    reg [9:0] count_clock;
    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count_clock <= 10'd0;
        end 
        else begin
            count_clock <= count_clock + 1'b1;
        end
    end 
    
    always #2.5 clk = ~clk;
    initial begin
        clk = 1'b0;
    end

    // ---- Task in bus theo từng hệ số 12-bit  ----
    task automatic print_bus12(
        input [(WIDTH*NUM)-1:0] v,
        input [127:0]           tag
    );
        integer j;
        reg [WIDTH-1:0] coeff;
        begin
            $write("%s:", tag);
            for (j = 0; j < NUM; j = j + 1) begin
                // lấy hệ số thứ j: dịch phải j*WIDTH rồi mask 12 bit thấp
                coeff = (v >> (j*WIDTH)) & {{(WIDTH-12){1'b0}}, 12'hFFF};
                $write(" %0d", coeff);
            end
            $write("\n");
        end
    endtask

    // ---- Stimulus ----
    integer t;
    initial begin
        $display("=== Start tb_mul_poly_matrix ===");
        // dump waveform (xsim vẫn đ�?c được)
        $dumpfile("tb_mul_poly_matrix.vcd");
        $dumpvars(0, tb_mul_poly_matrix);

        // Reset
        rst_n      <= 1'b0;
        k          <= 1'b0;
        valid_data <= 1'b0;
        a          <= { (WIDTH*NUM){1'b0} };
        b          <= { (WIDTH*NUM){1'b0} };
        
        #250; rst_n <= 1'b1;

        // --------- Bộ dữ liệu 1 ----------
        // Lưu ý: bit thấp [11:0] là a0/b0
        #5;
        k <= 3'd2; 
        valid_data <= 1'b1;
        a = {
            12'd16,12'd15,12'd14,12'd13,12'd12,12'd11,12'd10,12'd9,
            12'd8, 12'd7, 12'd6, 12'd5, 12'd4, 12'd3, 12'd2, 12'd1
        };
        b = {
            12'd116,12'd115,12'd114,12'd113,12'd112,12'd111,12'd110,12'd109,
            12'd108,12'd107,12'd106,12'd105,12'd104,12'd103,12'd102,12'd101
        };
        
//        #10; 
//        a = {
//            12'd1, 12'd3, 12'd5, 12'd7, 12'd9, 12'd11,12'd13,12'd15,
//            12'd2, 12'd4, 12'd6, 12'd8, 12'd10,12'd12,12'd14,12'd16
//        };
//        b = {
//            12'd20,12'd19,12'd18,12'd17,12'd16,12'd15,12'd14,12'd13,
//            12'd12,12'd11,12'd10,12'd9, 12'd8, 12'd7, 12'd6, 12'd5
//        };
        
        #25; valid_data <= 1'b0;
        
        print_bus12(a, "a (set 1)");
        print_bus12(b, "b (set 1)");

        
//        $display("zeta1=%0d zeta2=%0d zeta3=%0d zeta4=%0d  (counter=%0d)",
//                 dut.zeta1, dut.zeta2, dut.zeta3, dut.zeta4, dut.counter);

//        // --------- Bộ dữ liệu 2 ----------
//        a = {
//            12'd1, 12'd3, 12'd5, 12'd7, 12'd9, 12'd11,12'd13,12'd15,
//            12'd2, 12'd4, 12'd6, 12'd8, 12'd10,12'd12,12'd14,12'd16
//        };
//        b = {
//            12'd20,12'd19,12'd18,12'd17,12'd16,12'd15,12'd14,12'd13,
//            12'd12,12'd11,12'd10,12'd9, 12'd8, 12'd7, 12'd6, 12'd5
//        };
//            print_bus12(a, "a (set 2)");
//            print_bus12(b, "b (set 2)");

//        for (t = 0; t < 16; t = t + 1) begin
//            @(posedge clk); valid_data <= 1'b1;
//            @(posedge clk); valid_data <= 1'b0;
//            @(posedge clk);
////            print_bus12(res, $sformatf("res2 (addr=%0d)", t));
//        end

        $display("=== Finished ===");
        #200;
        $finish;
  end

endmodule
