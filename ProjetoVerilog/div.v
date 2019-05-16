module div (
		Dividendo, 
		Divisor, 
		DivStart, 
		Clk, 
		Reset, 
		DivFim, 
		DivisaoPorZero, 
		Hi, 
		Lo);
		
	input wire[31:0] Dividendo;
	input wire[31:0] Divisor;
	input wire DivStart;
	input wire Clk; 
	input wire Reset; 
	output reg DivFim;
	output reg DivisaoPorZero;
	output reg[31:0] Hi; 
	output reg[31:0] Lo;	
	
	reg [31:0] QUOCIENTE;
	reg [63:0] B;
	reg [63:0] RESTO;	
	reg [5:0] contador;
	
	initial 
	begin
		contador = 0;
		DivFim = 0;			
		DivisaoPorZero = 0;
		B = 0;		
		QUOCIENTE = 0;
		RESTO = 0;
		Hi = 0;
		Lo = 0;
	end
	
	always@(negedge Clk)
	
	begin
		if(Reset == 0)		
		begin
			if(DivStart == 1)
			begin
				if(Divisor == 0)
				begin
					DivisaoPorZero = 1;//Exceção
					DivFim = 1;
				end
				else
				begin	
					if (contador == 0) 
					begin				
						DivFim = 0;
						if (Dividendo < 0) 
						begin 
							RESTO = {{32{1'b0}}, -Dividendo};
						end 
						else 
						begin
							RESTO = {{32{1'b0}}, Dividendo}; 
						end
					
						if(Divisor < 0) 
						begin
							B = {-Divisor, {32{1'b0}}};
						end 
						else 
						begin
							B = {Divisor, {32{1'b0}}};
						end						   
					end 			
				
					if(contador < 33)
					begin
						contador = contador + 1;
						QUOCIENTE = QUOCIENTE << 1;
						if (B <= RESTO) begin
							QUOCIENTE[0] = 1;
							RESTO = RESTO - B;
						end
						B = B >>> 1;														
					end		
	
					if (contador == 33) 
					begin
						if (DivFim == 0) 
						begin
							Hi = RESTO[31:0];						
							Lo = QUOCIENTE[31:0];						
							if (Dividendo < 0) 
							begin
								Hi = -Hi;
							end
							if (Dividendo[31] != Divisor[31]) 
							begin
								Lo = -Lo;
							end
						end		
						contador = contador + 1;						
						DivFim = 1;
						
					end 
					else if(contador == 34)
					begin
						contador = 0;
						DivFim = 0;	
						DivisaoPorZero = 0;
					end
				end									
				end			
			end		
		end			
endmodule