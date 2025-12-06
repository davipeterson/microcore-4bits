module instruction_register (
	input [7:0] data_in, //!instrução do barramento de dados
	input clk, //!sinal de clock
	input ena, //!habilitação
	input rst, //!reset global
	output reg [1:0] mnm, //!campo mnemônico msb
	output reg [1:0] wr_addr_mnm, //!mnemônico lsb ou endereço de escrita
	output reg [3:0] rd_addr_wr_data, //! endereços de leitura ou dados para escrita
	output reg ack //!handshaking de fim de operação
);
   
always@(posedge clk or posedge rst) begin
	if(rst) 
		begin
			mnm <= 2'b00;
			wr_addr_mnm <= 2'b00;
			rd_addr_wr_data <= 4'b0000;
		end
	
	else if(ena) 
		begin
			mnm <= data_in[7:6];
			wr_addr_mnm <= data_in[5:4];
			rd_addr_wr_data <= data_in[3:0];
			if(data_in == {mnm,wr_addr_mnm,rd_addr_wr_data})
				ack <= 1'b1;
		end
		else
			ack <= 1'b0;
end     
endmodule
