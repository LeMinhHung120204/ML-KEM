`timescale 1ns/1ps

module Rom_mul #(
    parameter WIDTH_ADDR = 4,   // 16 địa chỉ
    parameter WIDTH_DATA = 48   // 4 * 12-bit
)(
    input  clk,
    input  rst_n,
    input  [WIDTH_ADDR - 1:0] address,
    output [WIDTH_DATA - 1:0] q
);
    reg [WIDTH_DATA - 1:0] rom [0:15];
    // reg [WIDTH_DATA - 1:0] out;

    // Khoi tao ROM 16 x 48-bit: moi o 4 so 12-bit lien tiep
    // q[47:36]=v0, q[35:24]=v1, q[23:12]=v2, q[11:0]=v3

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            rom[0]  <= {12'd17,      12'd2761,   12'd583,    12'd2649};
            rom[1]  <= {12'd1637,    12'd723,    12'd2288,   12'd1100};
            rom[2]  <= {12'd1409,    12'd2662,   12'd3281,   12'd233 };
            rom[3]  <= {12'd756,     12'd2156,   12'd3015,   12'd3050};
            rom[4]  <= {12'd1703,    12'd1651,   12'd2789,   12'd1789};
            rom[5]  <= {12'd1847,    12'd952,    12'd1461,   12'd2687};
            rom[6]  <= {12'd939,     12'd2308,   12'd2437,   12'd2388};
            rom[7]  <= {12'd733,     12'd2337,   12'd268,    12'd641 };
            rom[8]  <= {12'd1584,    12'd2298,   12'd2037,   12'd3220};
            rom[9]  <= {12'd375,     12'd2549,   12'd2090,   12'd1645};
            rom[10] <= {12'd1063,    12'd319,    12'd2773,   12'd757 };
            rom[11] <= {12'd2099,    12'd561,    12'd2466,   12'd2594};
            rom[12] <= {12'd2804,    12'd1092,   12'd403,    12'd1026};
            rom[13] <= {12'd1143,    12'd2150,   12'd2775,   12'd886 };
            rom[14] <= {12'd1722,    12'd1212,   12'd1874,   12'd1029};
            rom[15] <= {12'd2110,    12'd2935,   12'd885,    12'd2154};
            // out     <= {WIDTH_DATA{1'b0}};
        end 
        // else begin       
        //     out <= rom[address];
        // end
    end

    // assign q = out;
    assign q = rom[address];
endmodule
