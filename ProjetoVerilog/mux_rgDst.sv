module mux_rgDst(
	//TODO: Verificar se output está correto
	input wire [1:0] selector,
	input wire [31:0] inputA,//00
	input wire [31:0] inputB,//00
	output wire [31:0] out);
	
	
always
	case(selector)
		2'b00: out = inputA;
		2'b01: out = inputB;
		2'b10: out = 5'd29;
		2'b11: out = 5'd31;
endcase
	
endmodule: mux_rgDst