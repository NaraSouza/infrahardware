module mux_regDst (
	input wire[1:0] selector,
	input wire[4:0] inputA,
	input wire[4:0] inputB,
	output wire [4:0] out);

wire[4:0] auxA;
wire[4:0] auxB;

assign auxA = (selector[0]) ? inputB : inputA;
assign auxB = (selector[0]) ? {5'd29} : {5'd31};
assign out = (selector[1]) ? auxB : auxA;

endmodule