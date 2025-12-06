module rom_8x256 (
    input wire [7:0] addr,// Barramento de endereços de 8 bits
    output reg [7:0] data // Barramento de dados de 8 bits
);
    // Define o conteúdo da ROM
    reg [7:0] rom [0:255];
    initial begin
        // Exemplo: carregar alguns dados
        //rom[0] = 8'hAA;
        //rom[1] = 8'hBB;
       // rom[2] = 8'hCC; // O restante será 0 por padrão
        $readmemh("rom.txt", rom);
    end
    // Lê os dados da ROM na borda sensível
    always @(*) begin
        data = rom[addr];
    end
endmodule

