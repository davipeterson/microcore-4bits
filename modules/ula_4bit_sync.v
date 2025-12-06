module ula_4bit_sync (
    input  wire        clk,         // clock
    input  wire        enable,      // habilitação da operação
    input  wire [3:0]  a,           // operando A
    input  wire [3:0]  b,           // operando B
    input  wire [3:0]  sel,         // seleção da operação
    output reg  [3:0]  result,      // resultado da ULA
    output reg         ula_ack      // handshake: sobe por 1 ciclo
);

    always @(posedge clk) begin
        if (enable) begin
            casex (sel)
                4'b0100: result <= a | b;
                4'b0101: result <= a & b;
                4'b0110: result <= a ^ b;
                4'b0111: result <= ~(a & b);
                4'b10xx: result <= a + b;
                4'b11xx: result <= a - b;
                default: result <= 4'b0000;
            endcase
            ula_ack <= 1'b1;  // operação finalizada
        end else begin
            ula_ack <= 1'b0;  // não houve operação
        end
    end

endmodule
