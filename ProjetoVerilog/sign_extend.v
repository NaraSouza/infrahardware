module sign_extend(input wire [15:0] wireIn, input wire sign, output wire [31:0] wireOut);

	wire [31:0] withSign;
	wire [31:0] Data_out;
	
	assign withSign  = (wireIn[15]) ? {{16{1'b1}},wireIn} : {{16{1'b0}},wireIn};// com sinal  checa se o maior bit é um ou zero, se for um preenche com 1, se for zero preenche com zero
	assign wireOut = (sign) ? withSign : {{16{1'b0}},wireIn};// sign checa se a entrada é com ou sem sinal, se for com, a resposta é withSign, se não apenas completa com zeros
		
endmodule