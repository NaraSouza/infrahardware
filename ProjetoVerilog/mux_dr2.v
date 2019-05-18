module mux_dr2(input wire [0:0] selector, input wire[4:0] shamt, input wire[31:0] b, output wire [4:0] out);

//TODO: Quais bits de b pra usar?
assign out = (selector[0]) ? shamt : b[4:0];

endmodule