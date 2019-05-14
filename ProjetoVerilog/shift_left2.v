module shif_left2(
	input wire [31:0] entry,
	output wire [31:0] out);
	
assign out = entry <<2;

endmodule