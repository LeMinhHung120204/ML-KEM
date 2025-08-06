    module AddressGenerator#(
        parameter WIDTH_ADDR_BUTTERFLY = 8,      // ???a ch? butterfly
        parameter WIDTH_ADDR_ZETAS = 7          // ???a ch? ?
    )(
        input clk, rst_n, start,
        input is_ntt,
        output [WIDTH_ADDR_BUTTERFLY - 1: 0] addr0, addr1,  // ????c input butterfly
        output [WIDTH_ADDR_ZETAS - 1: 0] addr_tw,            // ???a ch? ?
        output valid,                           // address valid
        output ntt_finished
    );
        localparam POLY_N = 255;
        localparam IDLE = 2'b00, INIT = 2'b01, RUN = 2'b10, DONE = 2'b11;
        reg [1:0] state, next_state;
        
        reg [WIDTH_ADDR_ZETAS - 1:0] zetas, next_zetas;
        reg [WIDTH_ADDR_BUTTERFLY:0] j, first_p, l, next_j, next_l, next_first_p;
        reg done;

        wire [WIDTH_ADDR_BUTTERFLY : 0] tmp = first_p + (l << 1);

        // current state
        always @(posedge clk or negedge rst_n) begin
            if (~rst_n) begin
                state <= IDLE;
            end 
            else begin
                state <= next_state;
            end 
        end 

        // next state
        always @(*) begin
            case(state)
                IDLE: next_state = (start == 1'b1) ? INIT: IDLE;
                INIT: next_state = RUN;
                RUN: next_state = (valid) ? RUN : DONE;
                DONE: next_state = IDLE;
                default: next_state = IDLE;
            endcase
        end 

        // output logic
        always @(*) begin
            case(state)
                IDLE: begin
                    next_zetas      = 7'd0;
                    next_l          = 9'd0;
                    next_first_p    = 9'd0; 
                    next_j          = 9'd0;
                end 
                INIT: begin
                    next_zetas      = (is_ntt == 1'b1) ? 7'd1 : 7'd127;
                    next_l          = (is_ntt == 1'b1) ? 9'd128 : 9'd2;
                    next_first_p    = 9'd0; 
                    next_j          = 9'd0;
                end 
                RUN: begin
                        if (j < first_p + l - 1'b1) begin
                            next_zetas      = zetas;
                            next_l          = l;
                            next_j          = j + 1'b1;
                            next_first_p    = first_p; 
                        end
                        else if (tmp < POLY_N) begin
                            next_j          = tmp;
                            next_first_p    = tmp;
                            next_l          = l;
                            next_zetas      = (is_ntt == 1'b1) ? zetas + 1'b1 : zetas - 1'b1;

                        end 
                        else begin
                            next_first_p    = 8'd0;
                            next_j          = 8'd0;
                            next_zetas      = (is_ntt == 1'b1) ? zetas + 1'b1 : zetas - 1'b1;
                            next_l          = (is_ntt == 1'b1) ? l >> 1 : l << 1;
                        end 
                end 
                default: begin
                    next_zetas      = zetas;
                    next_l          = l;
                    next_first_p    = first_p; 
                    next_j          = j;
                end 
            endcase    
        end  

        always @(posedge clk or negedge rst_n) begin
            if (~rst_n) begin
                zetas   <= 7'd0;
                j       <= 9'b0;
                l       <= 9'd0;
                first_p <= 9'd0;
            end 
            else begin
                zetas   <= next_zetas;
                j       <= next_j;
                l       <= next_l;
                first_p <= next_first_p;
            end 
        end 

        assign addr0 = j;
        assign addr1 = j + l;
        assign addr_tw = zetas;
        assign valid = ((is_ntt) & (l >= 2'd2)) | ((~is_ntt) & (l <= 9'd128));
        assign ntt_finished = (state == DONE);
    endmodule