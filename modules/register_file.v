module register_file #(
    parameter DATA_WIDTH = 4,
    parameter ADDR_WIDTH = 2,// 4 registros, 2 bits de endereço
    parameter REG_COUNT  = 4
)(
    input  wire                     clk,
    input  wire                     wr_en,
    input  wire [ADDR_WIDTH-1:0]    wr_addr,
    input  wire [DATA_WIDTH-1:0]    wr_data,
    input  wire [ADDR_WIDTH-1:0]    rd_addr1,
    input  wire [ADDR_WIDTH-1:0]    rd_addr2,
    output wire [DATA_WIDTH-1:0]    rd_data1,
    output wire [DATA_WIDTH-1:0]    rd_data2,
    output reg wr_ack
);
    // Banco de registradores
    reg [DATA_WIDTH-1:0] registers [0:REG_COUNT-1];
    // Escrita síncrona
    always @(posedge clk) begin
        if (wr_en) begin
            registers[wr_addr] <= wr_data;
            if(registers[wr_addr]==wr_data)
                wr_ack <=1'b1;
        end
        else
            wr_ack <=1'b0;
    end
    // Leitura combinacional (assíncrona)
    assign rd_data1 = registers[rd_addr1];
    assign rd_data2 = registers[rd_addr2];
endmodule
