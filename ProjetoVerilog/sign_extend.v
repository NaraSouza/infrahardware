module sign_extend(input wire [15:0] wireIn, input wire sign, output wire [31:0] wireOut);

	wire [31:0] withSign;
	
	assign withSign  = (wireIn[15]) ? {{16{1'b1}},wireIn} : {{16{1'b0}},wireIn};// com sinal  checa se o maior bit � um ou zero, se for um preenche com 1, se for zero preenche com zero
	assign Data_out = (sign) ? withSign : {{16{1'b0}},wireIn};// sign checa se a entrada � com ou sem sinal, se for com, a resposta � withSign, se n�o apenas completa com zeros
		
endmodule