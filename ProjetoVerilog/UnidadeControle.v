module UnidadeControle(

//sinais de entrada
input clock,
input reset,
input [5:0] funct,
input [5:0] Opcode,
//sinais de saida
output reg MemWR,
output reg USExt,
//Mux
output reg [2:0] IorD, 
output reg [1:0] ALUSrcA,
output reg [1:0] ALUSrcB,
output reg [1:0] PCSource,
output reg ALUorMem,
output reg [1:0] RegDst,
output reg [3:0] MemToReg,
//Escrita em Registradores
output reg IRWrite,
output reg [2:0] ALUOp,
output reg PCWrite,
output reg RegWrite, 
output reg AWrite,
output reg BWrite,
output reg ALUOutWrite,
output reg [6:0] state
);

parameter [6:0] Reset = 7'd1;
parameter [6:0] PC4 = 7'd2;
parameter [6:0] Decode = 7'd6;
parameter [6:0] Write_Reg = 7'd7;
parameter [6:0]	Add = 7'd11;
parameter [6:0] PC0 = 7'd63;

parameter [6:0] Wait_Decode = 7'd5;
parameter [6:0] Wait_Decode_2 = 7'd60;
parameter [6:0] Wait_Decode_3 = 7'd61;

parameter [5:0] Opcode_R = 6'h00;
parameter [6:0] Opcode_Inexistente = 7'd59;

parameter [5:0] funct_add = 6'h20;

always@ (posedge clock) begin
	if(reset == 1) begin
		state = Reset;
	end
	else if(reset == 0) begin
		case(state)
		Reset: begin
			state = PC0;
		end
		PC0: begin
			IorD = 3'b001;
			MemWR = 0;
			IRWrite = 1;
			RegWrite = 1;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b10;
			ALUOp = 3'b000;
			PCSource = 2'b01;
			ALUorMem = 2'b00;
			PCWrite = 1;
			// state = 
			// RegDst = 2'b10; // inicializando R29 com 227 ?
			// MemToReg = 4'b1001;
			// state = Wait_Decode;
		end
		PC4: begin
			IorD = 3'b001;
			MemWR = 0;
			IRWrite = 1;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b10;
			ALUOp = 3'b000;
			PCSource = 2'b10;
			ALUorMem = 2'b00;
			PCWrite = 1;
			state = Wait_Decode;
		end
		Wait_Decode: begin
			PCWrite = 0;
			ALUOp = 3'b000;
			state = Decode;
		end
		Wait_Decode_2: begin
			state = Decode;
		end
		Decode: begin
			AWrite = 1;
			BWrite = 1;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b11;
			ALUOp = 3'b000;
			state = Wait_Decode_2;
		end
		Wait_Decode_3: begin
			case(Opcode)
				Opcode_R: begin
					case(funct)
						funct_add: state = Add;
					endcase
				end
				//default: state = Opcode_inexistente;
			endcase
		end
		Add: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 2'b00;
			ALUOp = 3'b000;
			ALUOutWrite = 1;
			state = Write_Reg;
		end
		Write_Reg: begin
			//TODO verificar overflow
			MemToReg = 4'b0010;
			RegDst = 2'b11;
			RegWrite = 1;
			ALUOutWrite = 0;
			state = PC4;
		end		
	endcase
	end
end

endmodule
