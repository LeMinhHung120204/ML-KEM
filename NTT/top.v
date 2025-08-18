`timescale 1ns/1ps

module top #(
    parameter WIDTH_ADDR_BUTTERFLY = 8,
    parameter WIDTH_ADDR_ZETAS = 7,
    parameter WIDTH = 16,
    parameter WIDTH_BUS_DATA = 256 * 32
)(
    input clk, rst_n, start, is_ntt, valid_input,
    input [WIDTH - 1:0] in0, in1,
    output [WIDTH - 1:0] out0, out1,
    output [WIDTH_ADDR_BUTTERFLY - 1:0] addr0, addr1,
    output done_compute, load_done, valid_output

    // debug
    // output [WIDTH_ADDR_BUTTERFLY - 1:0]     owaddr_a, owaddr_b,
    // output [WIDTH_ADDR_ZETAS - 1:0]         oaddr_zetas, 
    // output [WIDTH - 1:0]                    /*out_j_ntt, out_j_intt, out_jl_ntt, out_jl_intt, */zetas,
    // output [WIDTH - 1:0]                    Bin_a, Bin_b, Bo_a, Bo_b, 
    // output [1:0]                            check_state,
    // output                                  owrite_en,
    // output [WIDTH - 1:0]                    barret1, barret2, barret3,
    // output [(WIDTH * 2) - 1:0]              mul_out, sub_out, add_out
    // output [7:0]                            check_count_addr, check_count_load,
    // output                                  valid_addr, done_addr, valid, owrite_en
);
    localparam IDLE = 2'd0, INIT = 2'd1, RUN = 2'd2, DONE = 2'd3;
    localparam num_reg = 16;

    reg [1:0] state, next_state;
    reg [5:0] counter;
    reg [7:0] count_addr, count_load;
    reg [WIDTH_ADDR_BUTTERFLY - 1:0] regx [0:num_reg-1];
    reg [WIDTH_ADDR_BUTTERFLY - 1:0] regy [0:num_reg-1];   
    reg load_done_reg;

    wire [WIDTH - 1:0] out_j_ntt, out_j_intt, out_jl_ntt, out_jl_intt, zetas;
    wire [WIDTH - 1:0] A, B;
    wire [WIDTH - 1:0] A_Out_mux, B_Out_mux, oA_normal, oB_normal;
    wire [31:0] out_rom;
    wire start_normalize, oe_normalize;
    wire start_gen_addr, valid_load;
    wire done_add;
    wire [WIDTH - 1:0] sub_tmp  = regy[15] - regx[15];

    //----------------------------------- cac phase tinh toan -----------------------------------
    wire phase1                 = (counter >= 6'd19) & (sub_tmp > 2'd2);
    wire phase2                 = (counter >= 6'd18) & (counter <= 6'd20) & (~start_normalize);
    wire phase3                 = (count_addr >= 8'd2) & (count_addr <= 8'd129);
    
    //----------------------------------- tin hieu dieu khien cac module con -----------------------------------
    assign start_normalize      = ((sub_tmp == 8'd128) & (~is_ntt));
    assign start_gen_addr       = (state == INIT) & load_done_reg;
    assign valid_load           = (state == INIT) & valid_input;
    assign oe_normalize         = (state == RUN) & phase3;
    // assign valid_mem            = (state == RUN) | done_compute | valid_load;
    // assign done_compute         = (state == RUN) & ((is_ntt & (counter > 6'd37)) | (count_addr >= 8'd131));

    //----------------------------------- tin hieu dieu khien bram -----------------------------------
    wire we_next, vl_mem_next;
    wire [31:0] ob_a, ob_b, din_a_next, din_b_next;
    wire [WIDTH_ADDR_BUTTERFLY-1:0] waddr_a_next, waddr_b_next, raddr_a_next, raddr_b_next, next_valid_addr; 
    
    reg valid_mem, write_en_reg, valid_addr;
    reg [31:0] din_a, din_b;
    reg [WIDTH_ADDR_BUTTERFLY - 1:0] waddr_a, waddr_b, raddr_a, raddr_b; 
    
    assign we_next          = valid_load | ((state == RUN) & ((is_ntt & phase1) | ((~is_ntt) & phase2)));
    assign vl_mem_next      = (state == RUN) | done_compute | valid_load;
    assign waddr_a_next     = (state == INIT) ? (count_load << 1)           : ((phase3 == 1'b1) ? 8'd0 : regx[15]);
    assign waddr_b_next     = (state == INIT) ? (count_load << 1) + 1'b1    : ((phase3 == 1'b1) ? 8'd0 : regy[15]);
    assign din_a_next       = {{16{A_Out_mux[15]}}, A_Out_mux};
    assign din_b_next       = {{16{B_Out_mux[15]}}, B_Out_mux};

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            din_a           <= 32'd0;
            din_b           <= 32'd0;
            raddr_a         <= {WIDTH_ADDR_BUTTERFLY{1'b0}};
            raddr_b         <= {WIDTH_ADDR_BUTTERFLY{1'b0}};
            waddr_a         <= {WIDTH_ADDR_BUTTERFLY{1'b0}};
            waddr_b         <= {WIDTH_ADDR_BUTTERFLY{1'b0}};
            write_en_reg    <= 1'b0;
            valid_mem       <= 1'b0;
            valid_addr      <= 1'b0;
        end 
        else begin
            din_a           <= din_a_next;
            din_b           <= din_b_next;
            raddr_a         <= raddr_a_next;
            raddr_b         <= raddr_b_next;
            waddr_a         <= waddr_a_next;
            waddr_b         <= waddr_b_next;
            write_en_reg    <= we_next;
            valid_mem       <= vl_mem_next;
            valid_addr      <= next_valid_addr;
        end 
    end 

    //----------------------------------- Tin hieu dieu khien ROM -----------------------------------
    reg [WIDTH_ADDR_ZETAS - 1:0] addr_zetas;

    wire [WIDTH_ADDR_ZETAS - 1:0] addr_zetas_next;

    assign oaddr_zetas = addr_zetas;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            addr_zetas <= 7'b0;
        end 
        else begin
            addr_zetas <= addr_zetas_next;
        end 
    end 

    //----------------------------------- Chon du lieu dau vao -----------------------------------
    assign A_Out_mux            = (state == INIT) ? in0 : ((is_ntt == 1'b1) ? out_j_ntt  : oA_normal);
    assign B_Out_mux            = (state == INIT) ? in1 : ((is_ntt == 1'b1) ? out_jl_ntt : oB_normal);
    assign A                    = ob_a[WIDTH - 1:0];
    assign B                    = ob_b[WIDTH - 1:0];

    //----------------------------------- output -----------------------------------
    reg valid_output_reg;
    // assign valid_output         = (is_ntt & (sub_tmp == 2'd2)) | phase3;

    wire valid_output_next;
    assign out0                 = (valid_output == 1'b1) ? A_Out_mux    : 8'd0;
    assign out1                 = (valid_output == 1'b1) ? B_Out_mux    : 8'd0;
    assign addr0                = (valid_output == 1'b1) ? ((is_ntt) ? waddr_a : count_addr - 2'd2)    : 8'd0;
    assign addr1                = (valid_output == 1'b1) ? ((is_ntt) ? waddr_b : count_addr + 8'd126)  : 8'd0;
    assign valid_output_next    = (state == RUN) & (is_ntt & (sub_tmp == 2'd2)) | ((count_addr > 1'b0) & (count_addr < 8'd129));
    assign valid_output         = valid_output_reg;
    assign done_compute         = (state == DONE);
    assign load_done            = load_done_reg;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            valid_output_reg <= 1'b0;
        end 
        else begin
            valid_output_reg <= valid_output_next;
            
        end 
    end 

    //----------------------------------- debug -----------------------------------
    // assign check_state  = state;
    // assign Bin_a        = din_a;
    // assign Bin_b        = din_b;
    // assign Bo_a         = A;
    // assign Bo_b         = B;
    // assign owrite_en    = write_en_reg;
    // assign owaddr_a     = waddr_a;
    // assign owaddr_b     = waddr_b;
    // assign valid        = valid_mem;
    // assign check_count_addr = count_addr;
    // assign check_count_load = count_load;

    //----------------------------------- FSM -----------------------------------
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
            IDLE: next_state    = (start)           ? INIT  : IDLE;
            INIT: next_state    = (load_done_reg)   ? RUN   : INIT;
            RUN: next_state     = ((is_ntt & (counter > 6'd35)) | (count_addr >= 8'd129))  ? DONE  : RUN;
            DONE: next_state    = IDLE;
            default: next_state = IDLE;
        endcase
    end 

    // output fsm
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            counter         <= 6'd0;
            count_addr      <= 8'd0;
            count_load      <= 8'd0;
            load_done_reg   <= 1'b0;
        end 
        else begin
            case(state)
                IDLE: begin
                    counter         <= 6'd0;
                    count_addr      <= 8'd0;
                    count_load      <= 8'd0;
                    load_done_reg   <= 1'b0;
                end 
                INIT: begin
                    if (valid_input) begin
                        count_load      <= count_load + 1'b1;                
                    end
                    if (count_load >= 8'd128) begin
                        load_done_reg <= 1'b1;
                    end
                end 
                RUN: begin
                    if (start_normalize | ((count_addr > 8'd0) & (count_addr < 8'd129))) begin
                        count_addr <= count_addr + 1'b1;
                    end
                    if (counter < 6'd20) begin
                        counter <= counter + 1'b1;
                    end 
                    else begin
                        if ((counter < 6'd38) & ((done_addr == 1'b1) | (counter > 6'd20))) begin
                            counter <= counter + 1'b1;    
                        end 
                    end 
                end 
            endcase
        end 
    end 

    //----------------------------------- regx/regy ----------------------------------- 
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (i = 0; i < num_reg; i = i + 1'b1) begin
                regx[i] <= {WIDTH_ADDR_BUTTERFLY{1'b0}};
                regy[i] <= {WIDTH_ADDR_BUTTERFLY{1'b0}};
            end 
        end
        else begin
            regx[0] <= raddr_a;
            regy[0] <= raddr_b;
            regx[1] <= regx[0];
            regy[1] <= regy[0];

            regx[2] <= regx[1];
            regy[2] <= regy[1];

            regx[3] <= regx[2];
            regy[3] <= regy[2];

            regx[4] <= regx[3];
            regy[4] <= regy[3];

            regx[5] <= regx[4];
            regy[5] <= regy[4];

            regx[6] <= regx[5];
            regy[6] <= regy[5];

            regx[7] <= regx[6];
            regy[7] <= regy[6];

            regx[8] <= regx[7];
            regy[8] <= regy[7];

            regx[9] <= regx[8];
            regy[9] <= regy[8];

            regx[10] <= regx[9];
            regy[10] <= regy[9];

            regx[11] <= regx[10];
            regy[11] <= regy[10];

            regx[12] <= regx[11];
            regy[12] <= regy[11];

            regx[13] <= regx[12];
            regy[13] <= regy[12];

            regx[14] <= regx[13];
            regy[14] <= regy[13];

            regx[15] <= regx[14];
            regy[15] <= regy[14];
        end 
    end 

    //----------------------------------- module con -----------------------------------
    assign zetas = out_rom[WIDTH - 1:0];
    MyBootROM rom_inst(
        .clk(clk),
        .rst_n(rst_n),
        .oe(valid_mem),
        .me(valid_addr),
        .address(addr_zetas),
        .q(out_rom)
    );

    bram bram_inst(
        .clk(clk),
        .rst_n(rst_n),
        .en_a(valid_mem),
        .we_a(write_en_reg),
        .raddr_a(raddr_a),
        .waddr_a(waddr_a),
        .din_a(din_a),
        .dout_a(ob_a),
        .en_b(valid_mem),
        .we_b(write_en_reg),
        .raddr_b(raddr_b),
        .waddr_b(waddr_b),
        .din_b(din_b),
        .dout_b(ob_b)
        // .bus_data(data_bram)
    );

    AddressGenerator AddrGend(
        .clk(clk),
        .rst_n(rst_n),
        .is_ntt(is_ntt),
        .start(start_gen_addr),
        .addr0(raddr_a_next),            // [j]
        .addr1(raddr_b_next),            // [j + l]
        .addr_tw(addr_zetas_next),
        .valid(next_valid_addr),
        .ntt_finished(done_addr)
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
        .B_Out(out_jl_intt),

        // debug
        .barret1(barret1),
        .barret2(barret2),
        .barret3(barret3),
        .o_mul(mul_out),
        .add_out(add_out),
        .sub_out(sub_out)
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