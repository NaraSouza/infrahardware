module sign_extend26_32(input wire [25:00] inst, output wire[31:0] out);

assign out = {4'b0, inst};

endmodule