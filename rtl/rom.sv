module rom #(
    parameter MEM_DEPTH = 4096,
    parameter MEM_ADDR_WIDTH = 12
) (
    input                   i_clk,
    
    input           [31:0]  i_instr_addr,
    output  logic   [31:0]  o_instr_data,
    input                   i_instr_req,
    output  logic           o_instr_ack,
    
    input           [31:0]  i_data_addr,
    output  logic   [31:0]  o_data_rd_data,
    input           [31:0]  i_data_wr_data,
    input           [1:0]   i_data_size,
    input                   i_data_we,
    input                   i_data_req,
    output  logic           o_data_ack
);

    // 4K RAM
    dp_ram #(
        .MEM_DEPTH      (MEM_DEPTH),
        .MEM_ADDR_WIDTH (MEM_ADDR_WIDTH)
    ) dp_ram_0 (
        .i_clk          (i_clk),

        .i_addr_a       (i_instr_addr[MEM_ADDR_WIDTH-1:0]),
        .i_we_a         (),
        .i_size_a       (),
        .i_din_a        (),
        .o_dout_a       (o_instr_data),

        .i_addr_b       (i_data_addr[MEM_ADDR_WIDTH-1:0]),
        .i_we_b         (i_data_we),
        .i_size_b       (i_data_size),
        .i_din_b        (i_data_wr_data),
        .o_dout_b       (o_data_rd_data)
    );


    always_ff @(posedge i_clk) begin
        o_instr_ack <= i_instr_req;
        o_data_ack <= i_data_req;
    end

endmodule