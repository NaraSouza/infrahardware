module mux_store_f_h_or_b(
	input wire [1:0] selector, 
	input wire [31:0] inputFull,// 11 
	input wire [15:0] inputHalf,//01
	input wire [7:0] inputByte,//00
	input wire[31:0] memory,
	output wire [31:0] out);
  
  wire[31:0] auxA;
  wire[31:0] auxhalf;
  wire[31:0] auxbyte;
  assign auxhalf = {memory[31:16],inputHalf};
  assign auxbyte = {memory[31:8],inputByte};
  
  assign auxA = (selector[0]) ? auxhalf: auxbyte;
  assign out = (selector[1])? inputFull : auxA;
  
  endmodule