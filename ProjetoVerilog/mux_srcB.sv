module mux_srcB(
	//TODO: Verificar se output est� correto
	input wire [3:0] selector,
	input wire [31:0] inputA,//00
	input wire [31:0] inputB,//00 SL2
	input wire [31:0] inputC,//00 SL16
	output wire [31:0] out);
	
	
always
	case(selector)
		3'b000: out = inputA;
		3'b001: out = 3'd1;
		3'b010: out = 3'd4;
		3'b011: out = inputB;
		3'b100: out = inputC;
endcase
	
endmodule: mux_srcB