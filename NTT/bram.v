`timescale 1ns/1ps

module bram #(
    parameter DEPTH = 256,
    parameter ADDR_WIDTH = $clog2(DEPTH),   //8
    parameter WIDTH = 32
)(
    input clk, rst_n,
    // port A
    // input                   en_a,
    input                   we,
    input [ADDR_WIDTH-1:0]  waddr_a,
    input [ADDR_WIDTH-1:0]  raddr_a,
    input [WIDTH-1:0]       din_a,
    output reg [WIDTH-1:0]  dout_a,

    // port B 
    // input                   en_b,
    input [ADDR_WIDTH-1:0]  waddr_b,
    input [ADDR_WIDTH-1:0]  raddr_b,
    input [WIDTH-1:0]       din_b,
    output reg [WIDTH-1:0]  dout_b

    // dubug
    // output [(WIDTH) * (DEPTH) - 1:0] bus_data
);
    // Memory
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            dout_a          <= 32'd0;
            dout_b          <= 32'd0;
            for (i = 0; i < DEPTH; i = i + 1'b1)
                mem[i] <= 32'd0;
        end 
        else begin
            if (we) begin
                if (waddr_a == waddr_b) begin
                    mem[waddr_a] <= din_a;
                end 
                else begin
                    mem[waddr_a] <= din_a;
                    mem[waddr_b] <= din_b;
                end 
            end 
            else begin
                dout_a <= mem[raddr_a];
                dout_b <= mem[raddr_b];
            end 

            // if (en_a == 1'b1) begin
            //     if (we_a == 1'b1) begin
            //         mem[waddr_a] <= din_a;
            //     end 
            //     else begin
            //         dout_a <= mem[raddr_a];
            //     end 
            // end
            // if (en_b == 1'b1) begin
            //     if (we_b == 1'b1) begin
            //         mem[waddr_b] <= din_b;
            //     end 
            //     else begin
            //         mem[waddr_b] <= din_b;
            //     end 
            // end 
        end 
    end 
endmodule