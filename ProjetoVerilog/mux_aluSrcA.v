module mux_aluSrcA(
	//TODO: Verificar se output está correto
	input wire [1:0] selector,
	input wire [31:0] inputA,//00
	input wire [31:0] inputB,//01
	input wire [31:0] inputC,//11
	output wire [31:0] out);
	
	wire[31:0] aux;
	
	assign aux = (selector[0]) ? inputB : inputA;
	assign out = (selector[1]) ? inputC : aux;
	
	endmodule