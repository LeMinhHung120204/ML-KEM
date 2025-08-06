module top #(
    parameter WIDTH_ADDR_BUTTERFLY = 8,
    parameter WIDTH_ADDR_ZETAS = 7,
    parameter WIDTH = 32
)(
    input clk, rst_n, start,
    input is_ntt,
    output done_compute, done_store,

    // debug
    output [WIDTH_ADDR_BUTTERFLY - 1:0] addr_j, addr_jl,
    output [WIDTH_ADDR_ZETAS - 1:0] addr_zetas, 
    output [WIDTH - 1:0] out_j_ntt, out_j_intt, out_jl_ntt, out_jl_intt, zetas,
    output valid_addr, done_addr, valid,
    output [WIDTH - 1:0] A, B, 
    output [2:0] check_state
);
    localparam IDLE = 3'd0, INIT = 3'd1, RUN = 3'd2, NORMALIZE = 3'd3, DONE = 3'd4;
    localparam num_reg = 29;

    reg [2:0] state, next_state;
    reg [5:0] counter;
    reg [WIDTH_ADDR_BUTTERFLY - 1:0] regx [0:num_reg-1];
    reg [WIDTH_ADDR_BUTTERFLY - 1:0] regy [0:num_reg-1];    
    reg write_en, done_store_reg, done_compute_reg, start_gen_addr;

    // wire [WIDTH_ADDR_BUTTERFLY - 1:0] addr_j, addr_jl;
    // wire [WIDTH_ADDR_ZETAS - 1:0] addr_zetas;
    // wire [WIDTH - 1:0] out_j_ntt, out_j_intt, out_jl_ntt, out_jl_intt, zetas;
    // wire [WIDTH - 1:0] A, B;
    wire [WIDTH - 1:0] A_Out_mux, B_Out_mux;
    // wire valid_addr, done_addr, valid;

    assign check_state = state;

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
            RUN: next_state     = (done_store_reg) ? ((is_ntt == 1'b1) ? DONE : NORMALIZE) : RUN;
            NORMALIZE: next_state = DONE;
            DONE: next_state    = IDLE;
            default: next_state = IDLE;
        endcase
    end 

    always @(*) begin
        case(state)
            INIT: begin
                start_gen_addr      = 1'b1;
                write_en            = 1'b0;
                done_store_reg      = 1'b0;
                done_compute_reg    = 1'b0;
            end  
            RUN: begin
                start_gen_addr      = 1'b0;
                done_compute_reg    = 1'b0;
                if ((counter > 6'd27) & (counter <= 6'd58)) begin
                    write_en        = 1'b1;
                    done_store_reg  = 1'b0;
                end
                else if(counter > 6'd58) begin
                    write_en        = 1'b0;
                    done_store_reg  = 1'b1;
                end
                else begin
                    write_en        = 1'b0;
                    done_store_reg  = 1'b0;
                end 
                
            end 
            DONE: begin
                start_gen_addr      = 1'b0;
                write_en            = 1'b0;
                done_store_reg      = 1'b1;
                done_compute_reg    = 1'b1;
            end 
            default: begin
                start_gen_addr      = 1'b0;
                write_en            = 1'b0;
                done_store_reg      = 1'b0;
                done_compute_reg    = 1'b0;
            end 
        endcase
    end 

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            counter <= 6'd0;
            for (i = 0; i < num_reg; i = i + 1'b1) begin
                regx[i] <= 8'b0;
                regy[i] <= 8'b0;
            end 
        end
        else begin
            if (state == RUN) begin
                if (counter < 6'd31) begin
                    counter <= counter + 1'b1;
                end 
                else begin
                    if (counter < 6'd59) begin
                        if ((done_addr == 1'b1) | (counter > 6'd31)) begin
                            counter <= counter + 1'b1;    
                        end 
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

            regx[19] <= regx[18];
            regy[19] <= regy[18];

            regx[20] <= regx[19];
            regy[20] <= regy[19];

            regx[21] <= regx[20];
            regy[21] <= regy[20];

            regx[22] <= regx[21];
            regy[22] <= regy[21];

            regx[23] <= regx[22];
            regy[23] <= regy[22];

            regx[24] <= regx[23];
            regy[24] <= regy[23];

            regx[25] <= regx[24];
            regy[25] <= regy[24];

            regx[26] <= regx[25];
            regy[26] <= regy[25];

            regx[27] <= regx[26];
            regy[27] <= regy[26];

            regx[28] <= regx[27];
            regy[28] <= regy[27];
        end 
    end 

    MyBootROM rom_inst(
        .clk(clk),
        .rst_n(rst_n),
        .oe(valid),
        .me(valid_addr),
        .address(addr_zetas),
        .q(zetas)
    );

    bram bram_inst(
        .clk(clk),
        .rst_n(rst_n),
        .en_a(valid),
        .we_a(write_en),
        .raddr_a(addr_j),
        .waddr_a(regx[num_reg - 1]),
        .din_a(A_Out_mux),
        .dout_a(A),
        .en_b(valid),
        .we_b(write_en),
        .raddr_b(addr_jl),
        .waddr_b(regy[num_reg - 1]),
        .din_b(B_Out_mux),
        .dout_b(B)
        // .bus_data(bus_data)
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
        .C(),
        .R()
    );

    assign done_compute = done_compute_reg;
    assign done_store   = done_store_reg;
    assign A_Out_mux    = is_ntt ? out_j_ntt : out_j_intt;
    assign B_Out_mux    = is_ntt ? out_jl_ntt : out_jl_intt;
    assign valid        = (state == RUN);
endmodule