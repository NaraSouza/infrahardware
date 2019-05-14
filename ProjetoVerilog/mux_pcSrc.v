module mux_pcSrc(
	input wire [1:0] selector,
	input wire [31:0] inputA,
	input wire [31:0] inputB,
	input wire [31:0] inputC,
	input wire [31:0] inputD,
	output wire [31:0] out);
	
wire [31:0] auxA;
wire [31:0] auxB;

assign auxA = (selector[0]) ? inputB : inputA;
assign auxB = (selector[0]) ? inputD : inputC;
assign out = (selector[1]) ? auxB : auxA;

endmodule