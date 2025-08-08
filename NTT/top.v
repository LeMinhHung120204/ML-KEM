module top #(
    parameter WIDTH_ADDR_BUTTERFLY = 8,
    parameter WIDTH_ADDR_ZETAS = 7,
    parameter WIDTH = 16,
    parameter WIDTH_BUS_DATA = 256 * 32
)(
    input clk, rst_n, start, is_ntt,
    output done_compute, done_store,

    // debug
    output [WIDTH_ADDR_BUTTERFLY - 1:0]     addr_j, addr_jl, waddr_a, waddr_b,
    output [WIDTH_ADDR_ZETAS - 1:0]         addr_zetas, 
    output [WIDTH - 1:0]                    out_j_ntt, out_j_intt, out_jl_ntt, out_jl_intt, zetas,
    output [WIDTH - 1:0]                    Bin_a, Bin_b, Bo_a, Bo_b, 
    output [1:0]                            check_state,
    output [WIDTH_BUS_DATA - 1 : 0]         data_bram,
    output                                  valid_addr, done_addr, valid, owrite_en
);
    localparam IDLE = 2'd0, INIT = 2'd1, RUN = 2'd2, DONE = 2'd3;
    localparam num_reg = 19;

    reg [1:0] state, next_state;
    reg [5:0] counter;
    reg [7:0] count_addr;
    reg [WIDTH_ADDR_BUTTERFLY - 1:0] regx [0:num_reg-1];
    reg [WIDTH_ADDR_BUTTERFLY - 1:0] regy [0:num_reg-1];    

    // wire [WIDTH_ADDR_BUTTERFLY - 1:0] addr_j, addr_jl;
    // wire [WIDTH_ADDR_ZETAS - 1:0] addr_zetas;
    // wire [WIDTH - 1:0] out_j_ntt, out_j_intt, out_jl_ntt, out_jl_intt, zetas;
    wire [WIDTH - 1:0] A, B;
    wire [WIDTH - 1:0] A_Out_mux, B_Out_mux, oA_normal, oB_normal;
    wire [31:0] out_rom, ob_a, ob_b;
    wire start_normalize, oe_normalize, write_en;
    wire start_gen_addr, valid_mem;
    // wire valid_addr, done_addr, valid;
    wire phase1                 = (counter >= 6'd20) & (counter <= 6'd37);
    wire phase2                 = (counter >= 6'd20) & (counter <= 6'd40) & (~start_normalize);
    wire phase3                 = (count_addr >= 8'd3) & (count_addr <= 8'd130);
    wire [WIDTH - 1:0] sub_tmp  = regy[num_reg-1] - regx[num_reg-1];

    assign valid                = valid_mem;
    assign start_normalize      = ((sub_tmp == 8'd128) & (~is_ntt));
    assign oe_normalize         = (state == RUN) & phase3;
    assign write_en             = (state == RUN) & ((is_ntt & phase1) | ((~is_ntt) & phase2) | phase3);
    assign done_store           = (state == RUN) & ((is_ntt & (counter > 6'd37)) | (count_addr >= 8'd131));
    assign valid_mem            = (state == RUN) | done_compute;
    assign done_compute         = (state == DONE);
    assign start_gen_addr       = (state == INIT);
    assign A_Out_mux            = (is_ntt == 1'b1) ? out_j_ntt  : oA_normal;
    assign B_Out_mux            = (is_ntt == 1'b1) ? out_jl_ntt : oB_normal;

    // debug 
    assign check_state  = state;
    assign Bin_a        = A_Out_mux;
    assign Bin_b        = B_Out_mux;
    assign Bo_a         = A;
    assign Bo_b         = B;
    assign owrite_en    = write_en;
    assign waddr_a      = (phase3 == 1'b1) ? (count_addr - 3'd3)    : regx[num_reg - 1];
    assign waddr_b      = (phase3 == 1'b1) ? (count_addr + 7'd125)  : regy[num_reg - 1];
    assign A            = ob_a[WIDTH - 1:0];
    assign B            = ob_b[WIDTH - 1:0];

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
            IDLE: next_state    = (start == 1'b1) ? INIT: IDLE;
            INIT: next_state    = RUN;
            RUN: next_state     = (done_store) ? DONE : RUN;
            DONE: next_state    = IDLE;
            default: next_state = IDLE;
        endcase
    end 

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            counter     <= 6'd0;
            count_addr  <= 8'd0;
            for (i = 0; i < num_reg; i = i + 1'b1) begin
                regx[i] <= 8'b0;
                regy[i] <= 8'b0;
            end 
        end
        else begin
            if (state == RUN) begin
                if (start_normalize | ((count_addr > 8'd0) & (count_addr < 8'd131))) begin
                    count_addr <= count_addr + 1'b1;
                end
                if (counter < 6'd20) begin
                    counter <= counter + 1'b1;
                end 
                else begin
                    if ((counter < 6'd41) & ((done_addr == 1'b1) | (counter > 6'd20))) begin
                        counter <= counter + 1'b1;    
                    end 
                end 
            end 
            regx[0] <= addr_j;
            regy[0] <= addr_jl;
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

            regx[16] <= regx[15];
            regy[16] <= regy[15];

            regx[17] <= regx[16];
            regy[17] <= regy[16];

            regx[18] <= regx[17];
            regy[18] <= regy[17];

            // regx[19] <= regx[18];
            // regy[19] <= regy[18];

            // regx[20] <= regx[19];
            // regy[20] <= regy[19];

            // regx[21] <= regx[20];
            // regy[21] <= regy[20];

            // regx[22] <= regx[21];
            // regy[22] <= regy[21];

            // regx[23] <= regx[22];
            // regy[23] <= regy[22];

            // regx[24] <= regx[23];
            // regy[24] <= regy[23];

            // regx[25] <= regx[24];
            // regy[25] <= regy[24];

            // regx[26] <= regx[25];
            // regy[26] <= regy[25];

            // regx[27] <= regx[26];
            // regy[27] <= regy[26];

            // regx[28] <= regx[27];
            // regy[28] <= regy[27];
        end 
    end 
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
        .we_a(write_en),
        .raddr_a(addr_j),
        .waddr_a(waddr_a),
        .din_a({{16{A_Out_mux[15]}}, A_Out_mux}),
        .dout_a(ob_a),
        .en_b(valid_mem),
        .we_b(write_en),
        .raddr_b(addr_jl),
        .waddr_b(waddr_b),
        .din_b({{16{A_Out_mux[15]}}, B_Out_mux}),
        .dout_b(ob_b),
        .bus_data(data_bram)
    );

    AddressGenerator AddrGend(
        .clk(clk),
        .rst_n(rst_n),
        .is_ntt(is_ntt),
        .start(start_gen_addr),
        .addr0(addr_j),             // [j]
        .addr1(addr_jl),            // [j + l]
        .addr_tw(addr_zetas),
        .valid(valid_addr),
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