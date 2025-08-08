module bram #(
    parameter DEPTH = 256,
    parameter ADDR_WIDTH = $clog2(DEPTH),   //8
    parameter WIDTH = 32
)(
    input clk, rst_n,
    // port A
    input                   en_a,
    input                   we_a,
    input [ADDR_WIDTH-1:0]  waddr_a,
    input [ADDR_WIDTH-1:0]  raddr_a,
    input [WIDTH-1:0]       din_a,
    output reg [WIDTH-1:0]  dout_a,

    // port B 
    input                   en_b,
    input                   we_b,
    input [ADDR_WIDTH-1:0]  waddr_b,
    input [ADDR_WIDTH-1:0]  raddr_b,
    input [WIDTH-1:0]       din_b,
    output reg [WIDTH-1:0]  dout_b,

    // dubug
    output [(WIDTH) * (DEPTH) - 1:0] bus_data
);
    // Memory
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Flatten mem -> bus_data
    // `ifdef SIM
    genvar k;
        generate
            for (k = 0; k < DEPTH; k = k + 1) begin : FLATTEN_MEM
                assign bus_data[(k+1)*WIDTH-1 -: WIDTH] = mem[k];
            end
        endgenerate
    // `else 
    //     localparam integer BUSW = WIDTH * DEPTH;
    //     assign bus_data = {BUSW{1'b0}};
    // `endif


    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mem[0]          <= 32'd16;
            mem[1]          <= 32'd20;
            dout_a          <= 32'd0;
            dout_b          <= 32'd0;
            for (i = 2; i < DEPTH; i = i + 1'b1)
                if(i == 128) 
                    mem[i] <= 32'd3;
                else if(i == 129)
                    mem[i] <= 32'd5;
                else 
                    mem[i] <= 32'd0;
        end 
        else begin
            if ((en_a == 1'b1) & (we_a == 1'b1)) begin
                mem[waddr_a] <= din_a;
            end
            if ((en_b == 1'b1) & (we_b == 1'b1)) begin
                mem[waddr_b] <= din_b;
            end 
            dout_a <= mem[raddr_a];
            dout_b <= mem[raddr_b];
        end 
    end 
endmodule