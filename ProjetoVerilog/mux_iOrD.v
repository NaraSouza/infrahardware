module mux_iOrD (
	input wire [2:0] selector,
	input wire [31:0] inputA, //000
	input wire [31:0] inputB, //001
						//253 = 010
						//254 = 011
						//255 = 100
	input wire [31:0] inputC, //101
	output wire [31:0] out);
	
wire [31:0] auxA;
wire [31:0] auxB;
wire [31:0] auxC;
wire [31:0] auxD;

assign auxA = (selector[0]) ? inputB : inputA;
assign auxB = (selector[0]) ? {32'd254} : {32'd253};
assign auxC = (selector[0]) ? inputC : {32'd255};
assign auxD = (selector[1]) ? auxB : auxA;
assign out = (selector[2]) ?  auxC : auxD;

endmodule 