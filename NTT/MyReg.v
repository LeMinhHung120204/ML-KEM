module MyReg #(
    parameter WIDTH = 16,
    parameter DEPTH = 256,
    parameter ADDR_WIDTH = 8
)(
    input clk, rst_n,
    input we,
    input [ADDR_WIDTH - 1:0]    raddr1, raddr2, waddr1, waddr2,
    input [WIDTH - 1:0]         din1, din2,
    output [WIDTH - 1:0]        dout1, dout2
);
    integer i;
    reg [WIDTH - 1:0] mem [0:DEPTH - 1];
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            
            for (i = 0; i < DEPTH; i = i + 1'b1)
                mem[i] <= {WIDTH{1'b0}};
        end
        else begin
            if (we) begin
                if (waddr1 == waddr2) begin
                    mem[waddr1] <= din1;
                end 
                else begin
                    mem[waddr1] <= din1;
                    mem[waddr2] <= din2;
                end 
            end
        end
    end
    assign dout1 = mem[raddr1];
    assign dout2 = mem[raddr2];
endmodule