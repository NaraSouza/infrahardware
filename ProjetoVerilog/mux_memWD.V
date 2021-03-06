module mux_memWD(
	//TODO: Verificar se output est� correto
	input wire [1:0] selector,
	input wire [31:0] FullWord,//00. FullWord
	output wire [31:0] out
);
	wire[31:0] aux;
	wire[31:0] ExtHalf;
	wire[31:0] ExtByte;
	
	assign ExtHalf = ({ {16{1'b0}}, FullWord[15:0] });
	assign ExtByte = ({ {24{1'b0}}, FullWord[7:0] });
	
	assign aux = (selector[0]) ? ExtHalf : FullWord;
	assign out = (selector[1]) ? ExtByte : aux;
	
	endmodule