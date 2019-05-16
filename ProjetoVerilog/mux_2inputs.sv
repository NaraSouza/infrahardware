module mux_2inputs(
	//TODO: Verificar se output está correto
	input wire [1:0] selector,
	input wire [31:0] inputA,//00
	input wire [31:0] inputB,//00
	output wire [31:0] outputA);
	
	
always
	case(selector)
		1'b0: outputA = inputA;
		1'b1: outputA = inputB;
endcase
	
endmodule: mux_2inputs