module mux_IorD(
	//TODO: Verificar se output est� correto
	input wire [2:0] selector,
	input wire [25:0] InputA,
	input wire [31:0] InputB,
	input wire [31:0] InputC,
	output wire [31:0] out);
	
	
always
	case(selector)
		3'b000: out = ({ 6'b000000, InputA});
		3'b001: out = InputB;
		3'b010: out = 31'd253;
		3'b011: out = 31'd254;
		3'b100: out = 31'd255;
		3'b101: out = InputC;
endcase
	
endmodule: mux_IorD