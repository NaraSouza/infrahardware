module shift_leftJump( input wire [25:0] entry, input wire [3:0] pc, output wire [31:0] out);

assign out = {pc,entry,2'b0};

endmodule