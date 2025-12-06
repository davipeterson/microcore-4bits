module top_module(
    input  wire [1:0] KEY,      // KEY[0] = clk, KEY[1] = rst
    output wire [6:0] HEX0,     // Resultado ULA
    output wire [6:0] HEX1,     // Operando B
    output wire [6:0] HEX2,     // Operando A
    output wire [6:0] HEX3,     // Estado FSM
    output wire [6:0] HEX4,     // Data Bus (LSB)
    output wire [6:0] HEX5      // Data Bus (MSB)
);

    // Sinais internos
    wire clk = KEY[0];  
    wire rst = !KEY[1]; // Reset ativo em nível alto

    // Fios de interconexão
    wire pc_ack;
    wire ena_pc;
    wire ena_ri;
    wire ri_ack;
    wire [7:0] addr_bus;
    wire [7:0] data_bus;
    wire [1:0] mnm;
    wire [1:0] wr_addr_mnm;
    wire [3:0] rd_addr_wr_data;
    wire sel_r0_rd;
    wire [1:0] wr_addr;
    wire [3:0] wr_data_ula;
    wire sel_addr_data;
    wire [3:0] wr_data;
    wire sel_ldr_ula;
    wire [3:0] wr_data_ldr;
    wire [3:0] rd_addr;
    wire ena_wr;
    wire wr_ack;
    wire [3:0] operando_A;
    wire [3:0] operando_B;
    wire ena_ula;
    wire ula_ack;
    wire [2:0] state;

    // Instanciação dos Módulos

    program_counter pc(
        .clk(clk),
        .rst(rst),
        .en(ena_pc),
        .ack(pc_ack),
        .pc_out(addr_bus)
    );

    rom_8x256 rom(
        .addr(addr_bus),
        .data(data_bus)
    );

    instruction_register insreg(
        .clk(clk),
        .rst(rst),
        .data_in(data_bus),
        .ena(ena_ri),
        .mnm(mnm),
        .wr_addr_mnm(wr_addr_mnm),
        .rd_addr_wr_data(rd_addr_wr_data),
        .ack(ri_ack)
    );

    mux2x1_2bit mux1(
        .in0(2'b00),
        .in1(wr_addr_mnm),
        .sel(sel_r0_rd),
        .out(wr_addr)
    );
    
    mux2x1_4bit mux2(
        .in0(wr_data_ula),
        .in1(wr_data_ldr),
        .sel(sel_ldr_ula),
        .out(wr_data)
    );
    
    demux1x2_4bit demux(
        .in(rd_addr_wr_data),
        .sel(sel_addr_data),
        .out0(wr_data_ldr),
        .out1(rd_addr)
    );

    register_file regfile(
        .clk(clk),
        .wr_en(ena_wr),
        .wr_data(wr_data),
        .wr_addr(wr_addr),
        .rd_addr1(rd_addr[3:2]),
        .rd_addr2(rd_addr[1:0]),
        .wr_ack(wr_ack),
        .rd_data1(operando_A),
        .rd_data2(operando_B)
    );
    
    ula_4bit_sync ula(
        .clk(clk),
        .enable(ena_ula),
        .a(operando_A),
        .b(operando_B),
        .sel({mnm, wr_addr_mnm}),
        .result(wr_data_ula),
        .ula_ack(ula_ack)
    );

    fsm fsm_inst(
        .mnm_in(mnm),
        .clk(clk), 
        .rst(rst), 
        .ula_ack(ula_ack), 
        .wr_ack(wr_ack), 
        .pc_ack(pc_ack), 
        .ri_ack(ri_ack),
        .ena_pc(ena_pc), 
        .ena_ri(ena_ri), 
        .ena_wr(ena_wr), 
        .sel_r0_rd(sel_r0_rd), 
        .sel_addr_data(sel_addr_data), 
        .sel_ldr_ula(sel_ldr_ula), 
        .ena_ula(ena_ula),
        .out(state)
    );

    // Visualização nos Displays de 7 Segmentos

    // HEX5 e HEX4: Barramento de Dados (Data Bus)
    bcd_to_7seg disp_db_msb(
        .in(data_bus[7:4]),
        .disp(HEX5)
    );
    bcd_to_7seg disp_db_lsb(
        .in(data_bus[3:0]),
        .disp(HEX4)
    );

    // HEX3: Estado Atual da FSM
    bcd_to_7seg disp_state(
        .in({1'b0, state}), // Preenche com 0 pois state é 3 bits
        .disp(HEX3)
    );
    
    // HEX2: Operando A
    bcd_to_7seg disp_opA(
        .in(operando_A),
        .disp(HEX2)
    );
    
    // HEX1: Operando B
    bcd_to_7seg disp_opB(
        .in(operando_B),
        .disp(HEX1)
    );

    // HEX0: Resultado da ULA
    bcd_to_7seg disp_res(
        .in(wr_data_ula),
        .disp(HEX0)
    );

endmodule
