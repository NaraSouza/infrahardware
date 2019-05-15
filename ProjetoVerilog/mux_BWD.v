module mux_BWD(
	//TODO: Verificar se output está correto
	input wire [1:0] selector,
	input wire [31:0] MDRVal,
	input wire [31:0] FullWord,//00. FullWord
	input wire [15:0] HalfWord,//01
	input wire [7:0] Byte,//10
	output wire [31:0] out
);
	wire[31:0] aux;
	
	wire[31:0] ConcHalf;
	wire[31:0] ConcByte;
	
	assign ConcHalf = ({ MDRVal[31:16], HalfWord });
	assign ConcByte = ({ MDRVal[31:8], Byte });
	
	assign aux = (selector[0]) ? ConcHalf : FullWord;
	assign out = (selector[1]) ? ConcByte : aux;
	
	endmodule