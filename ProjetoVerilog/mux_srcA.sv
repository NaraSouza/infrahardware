module mux_srcA(
	input wire [1:0] selector,
	input wire [31:0] inputA,//00
	input wire [31:0] inputB,//01
	input wire [31:0] inputC,//11
	output wire [31:0] out); 
	
	
always
	case(selector)
		2'b00: out = inputA;
		2'b01: out = inputB;
		2'b10: out = inputC;
endcase
	
endmodule: mux_srcA