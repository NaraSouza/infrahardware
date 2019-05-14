module mux_dr2(input wire [0:0] selector, input wire[4:0] shamt, input wire[31:0] b, output wire [4:0] out);

assign out = (selector[0]) ? b[4:0] : shamt;

endmodule