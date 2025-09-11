`timescale 1ns/1ps

module top #(
    parameter WIDTH_ADDR_BUTTERFLY = 8,
    parameter WIDTH_ADDR_ZETAS = 7,
    parameter WIDTH = 16
)(
    input clk, rst_n, start, is_ntt, valid_input,
    input   [WIDTH - 1:0]                   in0, in1,
    output  [WIDTH - 1:0]                   out0, out1,
    output  [WIDTH_ADDR_BUTTERFLY - 1:0]    addr0, addr1,
    output  done_compute, output_valid,

    // debug
    output [1:0] ostate
);
    localparam IDLE = 2'd0, INIT = 2'd1, RUN = 2'd2, DONE = 2'd3;
    localparam num_reg = 16;

    wire [WIDTH - 1:0]                  A, B, zetas;
    wire [WIDTH - 1:0]                  out_j_intt, out_jl_intt, out_j_ntt, out_jl_ntt;
    wire valid_addr, gen_addr_done;


    reg [(WIDTH_ADDR_BUTTERFLY * num_reg) - 1:0]    hold_addra, hold_addrb;
    reg [1:0]                                       state, next_state;

    //----------------------------------- conter -----------------------------------
    reg [7:0]   count_load;
    reg [10:0]  counter;
    wire [7:0]  sub;
//    assign sub = mux_addr_a - mux_addr_b;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count_load  <= 8'd0;
            counter     <= 11'd0;
        end 
        else begin
            case(state)
                IDLE: begin
                    count_load  <= 8'd0;
                    counter     <= 11'd0;
                end 
                INIT: begin
                    if (valid_input & count_load < 8'd127) begin
                        count_load <= count_load + 1'b1;
                    end
                end 
                RUN: begin
                    counter <= counter + 1'b1;
                end 
                DONE: begin
                    count_load  <= 8'd0;
                    counter     <= 11'd0;
                end 
            endcase
        end 
    end 

    //----------------------------------- FSM -----------------------------------

    // tin hieu dieu khien
    reg reg_done_compute;
    wire start_gen_addr;
    wire done_run, load_done;

    assign done_run     = counter >= 11'd914;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
        end 
        else begin
            state <= next_state;
        end 
    end 

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg_done_compute <= 1'b0;
        end 
        else begin
            case(state)
                DONE: begin
                    reg_done_compute <= 1'b1;
                end 
                default: begin
                    reg_done_compute <= 1'b0;
                end 
            endcase
            // if (state == DONE)
            //     reg_done_compute <= 1'b1;
        end 
    end 

    always @(*) begin
        case(state)
            IDLE:       next_state = (start)        ? INIT  : IDLE;
            INIT:       next_state = (load_done)    ? RUN   : INIT;
            RUN:        next_state = (done_run)     ? DONE  : RUN;
            DONE:       next_state = IDLE;
            default:    next_state = IDLE;
        endcase
    end 
    assign done_compute     = reg_done_compute;
    assign start_gen_addr   = (state == RUN);
    assign load_done        = (count_load == 8'd127);
    
    //----------------------------------- debug -----------------------------------

    assign ostate = state;

    //----------------------------------- In/Out Mem -----------------------------------

    reg [WIDTH_ADDR_BUTTERFLY - 1:0]    waddr1, waddr2, raddr1, raddr2;
    reg [WIDTH_ADDR_ZETAS - 1:0]        addr_tw;
    reg [WIDTH - 1:0]                   din_a, din_b;
    reg we;

    wire [WIDTH_ADDR_BUTTERFLY - 1:0]   addr_a, addr_b;
    wire [WIDTH_ADDR_BUTTERFLY - 1:0]   waddr1_next, waddr2_next, raddr1_next, raddr2_next;
    wire [WIDTH_ADDR_BUTTERFLY - 1:0]   check_a, check_b;
    wire [WIDTH_ADDR_ZETAS - 1:0]       addr_tw_next;
    wire [WIDTH - 1:0]                  din_a_next, din_b_next;
    wire we_next;

    assign waddr1_next  = (state == INIT) ? count_load << 1          : check_a;
    assign waddr2_next  = (state == INIT) ? (count_load << 1) + 1'b1 : check_b;
    assign raddr1_next  = addr_a;
    assign raddr2_next  = addr_b;

    
    assign check_a      = hold_addra[(WIDTH_ADDR_BUTTERFLY * num_reg) - 1: (WIDTH_ADDR_BUTTERFLY * (num_reg - 1))];
    assign check_b      = hold_addrb[(WIDTH_ADDR_BUTTERFLY * num_reg) - 1: (WIDTH_ADDR_BUTTERFLY * (num_reg - 1))];

    assign din_a_next   = (state == INIT) ? in0 : (is_ntt) ? out_j_ntt  : out_j_intt;
    assign din_b_next   = (state == INIT) ? in1 : (is_ntt) ? out_jl_ntt : out_jl_intt;
    assign we_next      = valid_input | (counter >= 11'd18) & (counter <= 11'd785);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            waddr1  <= {WIDTH_ADDR_BUTTERFLY{1'b0}};
            waddr2  <= {WIDTH_ADDR_BUTTERFLY{1'b0}};
            raddr1  <= {WIDTH_ADDR_BUTTERFLY{1'b0}};
            raddr2  <= {WIDTH_ADDR_BUTTERFLY{1'b0}};
            addr_tw <= {WIDTH_ADDR_ZETAS{1'b0}};
            din_a   <= {WIDTH{1'd0}};
            din_b   <= {WIDTH{1'd0}};
            we      <= 1'b0;
        end 
        else begin
            waddr1  <= waddr1_next;
            waddr2  <= waddr2_next;
            raddr1  <= raddr1_next;
            raddr2  <= raddr2_next;
            addr_tw <= addr_tw_next;
            din_a   <= din_a_next;
            din_b   <= din_b_next;
            we      <= we_next;
        end 
    end 

    //----------------------------------- holdaddr -----------------------------------

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            hold_addra <= {(WIDTH_ADDR_BUTTERFLY * num_reg){1'b0}};
            hold_addrb <= {(WIDTH_ADDR_BUTTERFLY * num_reg){1'b0}};
        end 
        else begin
            hold_addra <= {hold_addra[(WIDTH_ADDR_BUTTERFLY * (num_reg - 1)) - 1:0], addr_a};
            hold_addrb <= {hold_addrb[(WIDTH_ADDR_BUTTERFLY * (num_reg - 1)) - 1:0], addr_b};
        end 
    end 

    //----------------------------------- output -----------------------------------

    assign output_valid = (counter >= 11'd787) & (state == RUN);
    assign out0         = (output_valid) ? din_a    : 16'd0;
    assign out1         = (output_valid) ? din_b    : 16'd0;
    assign addr0        = (output_valid) ? waddr1   : 8'd0;
    assign addr1        = (output_valid) ? waddr2   : 8'd0;

    //----------------------------------- module con -----------------------------------
    MyBootROM rom_inst(
        .clk(clk),
        .rst_n(rst_n),
        .address(addr_tw),
        .q(zetas)
    ); 

    AddressGenerator AddrGend(
        .clk(clk),
        .rst_n(rst_n),
        .is_ntt(is_ntt),
        .start(start_gen_addr),
        .addr0(addr_a),            // [j]
        .addr1(addr_b),            // [j + l]
        .addr_tw(addr_tw_next),
        .valid(valid_addr),
        .ntt_finished(gen_addr_done)
    );

    MyReg MyReg_inst(
        .clk(clk), 
        .rst_n(rst_n), 
        .we(we), 
        .raddr1(raddr1), 
        .raddr2(raddr2), 
        .waddr1(waddr1), 
        .waddr2(waddr2), 
        .din1(din_a), 
        .din2(din_b), 
        .dout1(A), 
        .dout2(B)
    );

    bu_ntt bu_ntt0(
        .clk(clk),
        .rst_n(rst_n),
        .A_In(A),
        .B_In(B),
        .W_In(zetas),
        .A_Out(out_j_ntt),
        .B_Out(out_jl_ntt)
    );

    bu_intt bu_intt0(
        .clk(clk),
        .rst_n(rst_n),
        .A_In(A),
        .B_In(B),
        .W_In(zetas),
        .A_Out(out_j_intt),
        .B_Out(out_jl_intt)
    );
endmodule