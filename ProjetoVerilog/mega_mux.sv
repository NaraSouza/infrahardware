module mega_mux(
	input wire[3:0] selector,
	input wire[31:0] inputA,//0000
	input wire[31:0] inputB,//0001
	input wire[31:0] inputC,//0010
	input wire[31:0] inputD,//0011
	input wire[31:0] inputE,//0100
	input wire[31:0] inputF,//0101
	input wire[31:0] inputG,//0110
	input wire[31:0] inputH,//0111
					//227 =   1000
					//0   =   1001
					//1   =   1010
	output wire [31:0] out);
	
always
	case(selector)
		4'b0000: out = inputA;
		4'b0001: out = inputB;
		4'b0010: out = inputC;
		4'b0011: out = inputD;
		4'b0100: out = inputE;
		4'b0101: out = inputF;
		4'b0110: out = inputG;
		4'b0111: out = inputH;
		4'b1000: out = 31'd227;
		4'b1001: out = 31'd0;
		4'b1010: out = 31'd1;
endcase


endmodule:mega_mux