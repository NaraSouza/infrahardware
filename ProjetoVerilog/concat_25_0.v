module concat_25_0 (input wire [4:0] rs, input wire [4:0] rt, input wire [15:0] rest, output wire [25:0] out);

assign out = {rs,rt,rest};

endmodule