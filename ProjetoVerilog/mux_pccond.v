module mux_pccond(
	//TODO: Verificar se output está correto
	input wire [1:0] selector,
	input wire equal,//00
	input wire greater,//01
	output wire out);
	
	
	input wire notgreater;
	input wire notequal;
	
	assign notgreater = !greater;
	assign notequal = !equal;
	
always
	case(selector)
		2'b00: out = equal;
		2'b01: out = notequal;
		2'b10: out = notgreater;
		2'b11: out = greater;
endcase
	
endmodule