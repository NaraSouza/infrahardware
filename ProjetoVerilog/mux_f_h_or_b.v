module mux_f_h_or_b(
	input wire [1:0] selector, 
	input wire [31:0] inputFull,// 11 
	input wire [15:0] inputHalf,//01
	input wire [7:0] inputByte,//00
	output wire [31:0] out);
  
  wire[31:0] auxA;
  wire[31:0] auxhalf;
  wire[31:0] auxbyte;
  assign auxhalf = (inputHalf[15]) ? {{16{1'b1}},inputHalf} : {{16{1'b0}},inputHalf};
  assign auxbyte = (inputByte[7]) ? {{24{1'b1}},inputByte} :  {{24{1'b0}},inputByte};
  
  assign auxA = (selector[0]) ? auxhalf: auxbyte;
  assign out = (selector[1])? inputFull : auxA;
  
  endmodule