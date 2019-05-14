module mux_2inputs(
	input wire [0:0] selector,
	input wire [31:0] inputA,//0
	input wire [31:0] inputB,//1
	 output wire [31:0] outputA);

assign outputA = (selector[0])? inputB : inputA;
endmodule 