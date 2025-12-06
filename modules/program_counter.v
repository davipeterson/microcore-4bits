module program_counter (
    input  wire        clk,
    input  wire        rst,
    input  wire        en,
    output reg  [7:0]  pc_out,
    output reg         ack      // novo sinal de handshaking
);

    always @(negedge clk or posedge rst) begin
        if (rst) begin
            pc_out <= 8'b0;
            ack    <= 1'b0;
        end else if (en) begin
            pc_out <= pc_out + 1;
            ack    <= 1'b1;     // sobe quando o PC atualiza
        end else begin
            ack    <= 1'b0;     // ack desativado nos outros ciclos
        end
    end

endmodule
