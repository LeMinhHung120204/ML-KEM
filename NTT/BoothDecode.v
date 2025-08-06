module BoothDecode #(
    parameter WIDTH = 64
)(
    input [WIDTH - 1:0] R,
    input [WIDTH - 1:0] A,
    input [2:0] sel,
    output [63:0] res
);
    reg [WIDTH - 1:0] pp;
    always @(*) begin
        case(sel)
            3'b000, 3'b111: pp = 64'd0;         // no operation
            3'b001, 3'b010: pp = A;             // +A
            3'b011: pp = A << 1;                // +2A
            3'b100: pp = ~(A << 1) + 1'b1;      // -2A
            3'b101, 3'b110: pp = ~(A) + 1'b1;   // -A
            default: pp = pp;
        endcase
    end 

    assign res = R + pp;
endmodule