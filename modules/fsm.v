module fsm (
    input wire [1:0] mnm_in,
    input wire clk,
    input wire rst,
    input wire ula_ack,
    input wire wr_ack,
    input wire pc_ack,
    input wire ri_ack,
    output reg ena_pc,
    output reg ena_ri,
    output reg ena_wr,
    output reg sel_r0_rd,
    output reg sel_addr_data,
    output reg sel_ldr_ula,
    output reg ena_ula,
    output wire [2:0] out
);

    localparam [2:0] PC = 3'd0, 
							FETCH = 3'd1, 
							LDR = 3'd2, 
							ARIT = 3'd3, 
							WB_RD = 3'd4, 
							LOGICA = 3'd5, 
							WB_R0 = 3'd6;

    reg [2:0] state;
    assign out = state;

    always @(posedge clk or negedge rst) begin
        if (!rst)
            state <= FETCH;
        else
            case (state)
                PC: state <= (pc_ack) ? FETCH : PC;
                FETCH:
                    if (ri_ack)
                        case (mnm_in)
                            2'b00: state <= LDR;
                            2'b01: state <= LOGICA;
                            2'b10: state <= ARIT;
                            2'b11: state <= ARIT;
                            default: state <= FETCH;
                        endcase
                    else
                        state <= FETCH;
                LDR: state <= (wr_ack) ? PC : LDR;
                ARIT: state <= (ula_ack) ? WB_RD : ARIT;
                WB_RD: state <= (wr_ack) ? PC : WB_RD;
                LOGICA: state <= (ula_ack) ? WB_R0 : LOGICA;
                WB_R0: state <= (wr_ack) ? PC : WB_R0;
                default: state <= FETCH;
            endcase
    end

    always @(*) begin
        ena_pc = 1'b0;
        ena_ri = 1'b0;
        ena_wr = 1'b0;
        sel_r0_rd = 1'b0;
        sel_addr_data = 1'b0;
        sel_ldr_ula = 1'b0;
        ena_ula = 1'b0;

        case (state)
            PC: ena_pc = 1'b1;
            FETCH: ena_ri = 1'b1;
            LDR: begin
                ena_wr = 1'b1;
                sel_r0_rd = 1'b1;
                sel_ldr_ula = 1'b1;
            end
            ARIT: begin
                sel_addr_data = 1'b1;
                ena_ula = 1'b1;
            end
            WB_RD: begin
                ena_wr = 1'b1;
                sel_r0_rd = 1'b1;
            end
            LOGICA: begin
                sel_addr_data = 1'b1;
                ena_ula = 1'b1;
            end
            WB_R0: ena_wr = 1'b1;
        endcase
    end

endmodule
