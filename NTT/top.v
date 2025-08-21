`timescale 1ns/1ps

module top #(
    parameter WIDTH_ADDR_BUTTERFLY = 8,
    parameter WIDTH_ADDR_ZETAS = 7,
    parameter WIDTH = 16,
    parameter WIDTH_BUS_DATA = 256 * 32
)(
    input clk, rst_n, start, is_ntt, valid_input,
    input   [WIDTH - 1:0]                   in0, in1,
    output  [WIDTH - 1:0]                   out0, out1,
    output  [WIDTH_ADDR_BUTTERFLY - 1:0]    addr0, addr1,
    output  done_compute, load_done, valid_output, output_valid
);
    localparam IDLE = 2'd0, INIT = 2'd1, RUN = 2'd2, DONE = 2'd3;
    localparam num_reg = 17;

    wire [WIDTH_ADDR_BUTTERFLY - 1:0]   addr_a, addr_b, mux_addr_a, mux_addr_b;
    wire [WIDTH_ADDR_ZETAS - 1:0]       addr_tw;
    wire [WIDTH - 1:0]                  A, B, out_rom, zetas;
    wire [WIDTH - 1:0]                  din_a, din_b, out_j_intt, out_jl_intt, out_j_ntt, out_jl_ntt;
    wire valid_addr, gen_addr_done;

    reg [WIDTH_ADDR_BUTTERFLY - 1:0]    hold_addra [0:num_reg - 1];
    reg [WIDTH_ADDR_BUTTERFLY - 1:0]    hold_addrb [0:num_reg - 1];
    reg [WIDTH - 1:0]                   hold_j_intt, hold_jl_intt;
    reg [1:0]                           state, next_state;
    reg toggle;

    //----------------------------------- conter -----------------------------------
    reg [6:0]   count_load;
    reg [11:0]  counter;
    reg [7:0]   count_addr;

    wire [7:0]  sub = mux_addr_a - mux_addr_b;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count_load  <= 7'd0;
            count_addr  <= 8'd0;
            counter     <= 12'd0;
            toggle      <= 1'b0;
        end 
        else begin
            case(state)
                IDLE: begin
                    count_load  <= 7'd0;
                    count_addr  <= 8'd0;
                    counter     <= 12'd0;
                    toggle      <= 1'b0;
                end 
                INIT: begin
                    if (valid_input) begin
                        count_load <= count_load + 1'b1;
                    end
                end 
                RUN: begin
                    toggle <= ~toggle;
                    if (load_done) begin
                        counter <= counter + 1'b1;
                    end  
                    if ((counter >= 12'd1557) & toggle & (count_addr < 8'd128)) begin
                        count_addr <= count_addr + 1'b1;
                    end
                end 
                DONE: begin
                    count_load  <= 7'd0;
                    count_addr  <= 8'd0;
                    counter     <= 12'd0;
                    toggle      <= 1'b0;
                end 
            endcase
        end 
    end 

    //----------------------------------- In / Out Bram -----------------------------------
    assign din_a        = (state == INIT) ? in0                     : ((is_ntt) ? out_j_ntt         : hold_j_intt);
    assign din_b        = (state == INIT) ? in1                     : ((is_ntt) ? out_jl_ntt        : hold_jl_intt);
    assign mux_addr_a   = (state == INIT) ? count_load << 1         : ((toggle) ? hold_addra[16]    : addr_a);
    assign mux_addr_b   = (state == INIT) ? (count_load << 1) + 1   : ((toggle) ? hold_addrb[16]    : addr_b);
    //----------------------------------- holdaddr -----------------------------------
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (i = 0; i < num_reg; i = i + 1'b1) begin
                hold_addra[i]   <= 8'd0;
                hold_addrb[i]   <= 8'd0;
            end
            hold_j_intt         <= 16'd0;
            hold_jl_intt        <= 16'd0;  
        end 
        else begin
            hold_j_intt     <= out_j_intt;
            hold_jl_intt    <= out_jl_intt;

            hold_addra[0]   <= addr_a;
            hold_addrb[0]   <= addr_b;

            hold_addra[1]   <= hold_addra[0];
            hold_addrb[1]   <= hold_addrb[0];
            
            hold_addra[2]   <= hold_addra[1];
            hold_addrb[2]   <= hold_addrb[1];

            hold_addra[3]   <= hold_addra[2];
            hold_addrb[3]   <= hold_addrb[2];

            hold_addra[4]   <= hold_addra[3];
            hold_addrb[4]   <= hold_addrb[3];

            hold_addra[5]   <= hold_addra[4];
            hold_addrb[5]   <= hold_addrb[4];

            hold_addra[6]   <= hold_addra[5];
            hold_addrb[6]   <= hold_addrb[5];

            hold_addra[7]   <= hold_addra[6];
            hold_addrb[7]   <= hold_addrb[6];

            hold_addra[8]   <= hold_addra[7];
            hold_addrb[8]   <= hold_addrb[7];

            hold_addra[9]   <= hold_addra[8];
            hold_addrb[9]   <= hold_addrb[8];

            hold_addra[10]  <= hold_addra[9];
            hold_addrb[10]  <= hold_addrb[9];

            hold_addra[11]  <= hold_addra[10];
            hold_addrb[11]  <= hold_addrb[10];

            hold_addra[12]  <= hold_addra[11];
            hold_addrb[12]  <= hold_addrb[11];

            hold_addra[13]  <= hold_addra[12];
            hold_addrb[13]  <= hold_addrb[12];

            hold_addra[14]  <= hold_addra[13];
            hold_addrb[14]  <= hold_addrb[13];

            hold_addra[15]  <= hold_addra[14];
            hold_addrb[15]  <= hold_addrb[14];

            hold_addra[16]  <= hold_addra[15];
            hold_addrb[16]  <= hold_addrb[15];
        end 
    end 

    //----------------------------------- output normalize -----------------------------------
    wire [WIDTH - 1:0] oA_normal, oB_normal;
    wire start_normalize, oe_normalize;

    assign start_normalize = (counter >= 12'd1554);
    assign oe_normalize = start_normalize;
    //----------------------------------- FSM -----------------------------------

    // tin hieu dieu khien
    wire start_gen_addr, we;

    assign we           = (state == INIT) | (toggle & (counter >= 12'd19) & (counter < 12'd1555));
    assign output_valid = (state == RUN) & (((counter >= 12'd1556) & (~is_ntt) & (~toggle)) | ((counter >= 12'd1554) & is_ntt & toggle));
    assign out0         = (output_valid) ? ((is_ntt) ? out_j_ntt    : oA_normal)            : 16'd0;
    assign out1         = (output_valid) ? ((is_ntt) ? out_jl_ntt   : oB_normal)            : 16'd0;
    assign addr0        = (output_valid) ? ((is_ntt) ? mux_addr_a   : count_addr)           : 8'd0;
    assign addr1        = (output_valid) ? ((is_ntt) ? mux_addr_b   : count_addr + 8'd128)  : 8'd0;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
        end 
        else begin
            state <= next_state;
        end 
    end 

    always @(*) begin
        case(state)
            IDLE:       next_state = (start)                ? INIT  : IDLE;
            INIT:       next_state = (count_load == 8'd127) ? RUN   : INIT;
            RUN:        next_state = (count_addr == 8'd127) ? DONE  : RUN;
            DONE:       next_state = IDLE;
            default:    next_state = IDLE;
        endcase
    end 
    assign done_compute     = (state == DONE);
    assign start_gen_addr   = (state == RUN);
    assign load_done        = (state == RUN);
    
    //----------------------------------- module con -----------------------------------
    assign zetas = out_rom[WIDTH - 1:0];
    MyBootROM rom_inst(
        .clk(clk),
        .rst_n(rst_n),
        .oe(1'b1),
        .me(1'b1),
        .address(addr_tw),
        .q(out_rom)
    ); 

    blk_mem_gen_0 bram_inst(
        .addra(mux_addr_a),
        .clka(clk),
        .dina(din_a),
        .douta(A),
        .ena(1'b1),
        .wea(we),
        
        .addrb(mux_addr_b),
        .clkb(clk),
        .dinb(din_b),
        .doutb(B),
        .enb(1'b1),
        .web(we)
    );

    AddressGenerator AddrGend(
        .clk(clk),
        .rst_n(rst_n),
        .is_ntt(is_ntt),
        .start(start_gen_addr),
        .addr0(addr_a),            // [j]
        .addr1(addr_b),            // [j + l]
        .addr_tw(addr_tw),
        .valid(valid_addr),
        .ntt_finished(gen_addr_done)
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

    normalize_output normalize_inst(
        .clk(clk),
        .rst_n(rst_n),
        .A({16'b0, out_j_intt}),
        .B({16'b0, out_jl_intt}),
        .start(start_normalize),
        .oe(oe_normalize),
        .oA(oA_normal),
        .oB(oB_normal)
    );
endmodule