module shift_leftJump( input wire [25:0] entry, input wire [31:0] pc, output wire [31:0] out);

wire [3:0] pc_bits;
assign pc_bits = pc[31:28];

assign out = {pc_bits,entry,2'b0};

endmodule