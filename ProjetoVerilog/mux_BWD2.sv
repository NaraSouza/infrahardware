module mux_BWD2(
	//TODO: Verificar se output está correto
	input wire [1:0] selector,
	input wire [31:0] MDRVal,
	input wire [31:0] FullWord,//00. FullWord
	input wire [15:0] HalfWord,//01
	input wire [7:0] Byte,//10
	input wire [31:0] ALUResult,//11
	output wire [31:0] out);
	
	
always
	case(selector)
		2'b00: out = FullWord;
		2'b01: out = ({ MDRVal[31:16], HalfWord });
		2'b10: out = ({ MDRVal[31:8], Byte });
		2'b11: out = ALUResult;
endcase
	
endmodule: mux_BWD2