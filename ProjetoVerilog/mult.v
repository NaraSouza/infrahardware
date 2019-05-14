module mult(a, b, hi, lo, done, multCtrl, clock, reset);
	
	input [31:0]a, b;
	input multCtrl, clock, reset;
	
	output reg[31:0]hi, lo;
	output reg done;
	reg [31:0] multiplicand, multiplier; 
	
	reg [1:0] op;
	
	reg [1:0] doing;
	initial doing = 2'b00;
	
	reg first;
	reg Qm;
	reg [63:0] operation;
	reg [31:0] aCalc;
	reg [15:0] check;
	
	parameter
		DN = 2'b00,
		DN2 = 2'b11,
		SUM = 2'b01,
		SUB = 2'b10;
	
	always@(posedge clock)begin
		
		if(reset)begin
			hi = 32'd0;
			lo = 32'd0;
			operation = 64'd0;
			Qm = 1'b0;
			doing = 2'b00;
		end
		else if(multCtrl) begin
			
			if(doing == 2'b00)begin
				
				multiplicand = b;
				multiplier = a;
				
				check = 16'd32;
				aCalc = 32'd0;
				
				doing = 2'b01;
				
				Qm = 1'b0;
				
				operation = {aCalc ,multiplier};
				op = {operation[0] , Qm};
				
			end
			else if(doing == 2'b01) begin
				
				if(op == 2'b01) begin
					aCalc = aCalc + multiplicand;
					operation = { aCalc , operation[31:0]};
				end	
				 else if(op == 2'b10) 
					begin
					aCalc = aCalc - multiplicand;
					operation = { aCalc , operation[31:0]};
				end
				
				first = operation[63];
				Qm = operation[0];
				
				operation = operation >> 1;
				operation[63] = first;
				
				op = {operation[0] , Qm};
				aCalc = operation[63:32];
				
				check = check - 16'd1;
				
				
				
				if(check == 16'd0) doing = 2'b10;
				
			end
			else if(doing == 2'b10)begin
				hi <= operation[63:32];
				lo <= operation[31:0];
				done <= 1;
			end
			
		
		end	
	end
endmodule 