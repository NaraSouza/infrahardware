module shif_left16(input wire [15:0] offset, output wire [31:0] out);

assign out = {offset, 16'd0};

endmodule