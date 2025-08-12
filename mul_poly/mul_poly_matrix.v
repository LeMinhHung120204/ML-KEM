module mul_poly_matrix #(
    parameter WIDTH_DATA = 16
)(
    input clk, rst_n, valid_data,
    input [WIDTH_DATA - 1:0] a0, a1, a2, a3, b0, b1, b2, b3,
    output [WIDTH_DATA - 1:0] res0, res1, res2, res3
);
    reg [5:0] counter;
    wire [WIDTH_DATA - 1:0] zetas;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            counter     <= 6'b0;
            valid_data  <= 1'b0;
        end 
        else begin
            if (valid_data) begin
                counter <= counter + 1'b1;
            end 
        end 
    end 

    mul_poly mul_poly_inst0(
        .clk(clk),
        .rst_n(rst_n),
        .a0(a0),
        .a1(a1),
        .b0(b0),
        .b1(b1),
        .zetas(zetas),
        .res0(res0),
        .res1(res1)
    );

    mul_poly mul_poly_inst1(
        .clk(clk),
        .rst_n(rst_n),
        .a0(a2),
        .a1(a3),
        .b0(b2),
        .b1(b3),
        .zetas((~zetas) + 1'b1),
        .res0(res2),
        .res1(res3)
    );

    MyBootROM ROM_inst0(
        .clk(clk),
        .rst_n(rst_n),
        .oe(1'b1),
        .me(valid_data),
        .address({1'b0, counter} + 7'd64),
        .q(zetas)
    );
endmodule 