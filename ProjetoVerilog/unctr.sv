module unctr(

//sinais de entrada
input logic clock,
input logic reset,
input logic [5:0] funct,
input logic [5:0] ControlOp,
input logic Z,
input logic O,
input logic GT,
input logic LT,
//sinais de saida
output logic MemWR,
output logic USExt,
//Mux
output logic [2:0] IorD, 
output logic [1:0] ALUSrcA,
output logic [2:0] ALUSrcB,
output logic [1:0] PCSource,
output logic ALUorMem,
output logic [1:0] RegDst,
output logic [3:0] MemToReg,
output logic [1:0] MemWD,
output logic [1:0] BWD,
output logic DR1,
output logic DR2,
output logic Low,
output logic High,
output logic [1:0] PCCond,
output logic PCWriteCond,
//Escrita em Registradores
output logic IRWrite,
output logic [2:0] ALUOp,
output logic PCWrite,
output logic RegWrite, 
output logic AWrite,
output logic BWrite,
output logic ALUOutWrite,
output logic MDRWrite,
output logic [6:0] state,
output logic LowReg,
output logic HighReg,
output logic EPCWrite,
output logic WriteData,
output logic [2:0] ShiftCtrl
);

enum logic [6:0] {
inicial_1 = 7'd1,
inicial_2 = 7'd2,
add = 7'd3,
sub = 7'd4,
And = 7'd5,
slt = 7'd6,
slti = 7'd7,
addi = 7'd8,
addiu = 7'd9,
write_1 = 7'd10,
write_i = 7'd11,
mult = 7'd12,
div = 7'd13,
cory_1 = 7'd14,
mult_finish = 7'd15,
div_finish = 7'd16,
mflo = 7'd17,
mfhi = 7'd18,
inc = 7'd19,
inc_2 = 7'd20,
cory_4 = 7'd21,
inc_3= 7'd22,
dec = 7'd23,
dec_2 = 7'd24,
cory_5 = 7'd25,
dec_3 = 7'd26,
cory_6 = 7'd27,
writeMem = 7'd28,
jump = 7'd29,
jal = 7'd30,
jal_2 = 7'd31,
jr = 7'd32,
beq = 7'd33,
branch_1 = 7'd34,
ble = 7'd35,
branch_2 = 7'd36,
bne = 7'd37,
branch_3 = 7'd38,
bgt = 7'd39,
branch_4 = 7'd40,
lui = 7'd41,
decode = 7'd42,
lw_1 = 7'd43,
lh_1 = 7'd44,
lb_1 = 7'd45,
sw_1 = 7'd46,
sh_1 = 7'd47,
sb_1 = 7'd48,
Break = 7'd49,
rte = 7'd50,
sll = 7'd51,
sllv = 7'd52,
sra = 7'd53,
srav = 7'd54,
srl = 7'd55,
OPcodeIN = 7'd56,
Reset = 7'd57,
inicial = 7'd58,
inicial_0 = 7'd59,
write_lt0 = 7'd60,
write_lt1 = 7'd61,
write_lt00 = 7'd62,
write_lt11 = 7'd63,
writemdr_1 = 7'd64,
writemdr_2 = 7'd65,
writemdr_3 = 7'd66,
lw_2 = 7'd67,
lw_3 = 7'd68,
cory_2 = 7'd69,
cory_3 = 7'd70,
lh_2 = 7'd71,
lh_3 = 7'd72,
lb_2 = 7'd73,
lb_3 = 7'd74,
cory_0 = 7'd75,
sw_2 = 7'd76,
sw_3 = 7'd77,
sw_4 = 7'd78,
cory_7 = 7'd79,
cory_8 = 7'd80,
sh_2 = 7'd81,
sh_3 = 7'd82,
sh_4 = 7'd83,
sb_2 = 7'd84,
sb_3 = 7'd85,
sb_4 = 7'd86,
overflow = 7'd87,
OPcodeIN_2 = 7'd88,
OPcodeIN_3 = 7'd89,
cory_9 = 7'd90,
overflow_2 = 7'd91,
overflow_3 = 7'd92,
cory_10 = 7'd93,
cory_11 = 7'd94,
sl = 7'd95,
sr = 7'd96,
sr_a = 7'd97,
write_2 = 7'd98,
wait_1 = 7'd99,
wait_2 = 7'd100,
wait_3 = 7'd101,

}

enum logic [5:0] {
Opcode_R = 6'h00,

Opcode_addi = 6'h08,
Opcode_addiu = 6'h09,
Opcode_beq = 6'h04,
Opcode_bne = 6'h05,
Opcode_ble = 6'h06,
Opcode_bgt = 6'h07,
Opcode_lb = 6'h20,
Opcode_lh = 6'h21,
Opcode_lui = 6'hf,
Opcode_lw = 6'h23,
Opcode_sb = 6'h28,
Opcode_sh = 6'h29,
Opcode_slti = 6'ha,
Opcode_sw = 6'h2b,

Opcode_j = 6'h02,
Opcode_jal = 6'h03,
Opcode_inc = 6'h10,
Opcode_dec = 6'h11,

funct_add = 6'h20,
funct_and = 6'h24,
funct_div = 6'h1a,
funct_mult = 6'h18,
funct_jr = 6'h08,
funct_mfhi = 6'h10,
funct_mflo = 6'h12,
funct_sll = 6'h00,
funct_sllv = 6'h04,
funct_slt = 6'h2a,
funct_sra = 6'h03,
funct_srav = 6'h07,
funct_srl = 6'h02,
funct_sub = 6'h22,
funct_break = 6'h0d,
funct_rte = 6'h13,
}


always@ (posedge clock) begin
	if(reset == 1) begin
		state = Reset;
	end
	else if(reset == 0) begin
		case(state)
		Reset: begin
			RegDst = 2'b10;
			MemToReg = 4'b1000;
			state = inicial;
		end
		inicial: begin
			IorD = 3'b001;
			MemWR = 0;
			ALUSrcA = 2'b00;
			ALUSrcB = 3'b010;
			ALUOp = 3'b001;
			state = cory_0;
		end
		cory_0: begin
			state = inicial_0;
		end
		inicial_0:begin
			PCSource = 2'b01;
			ALUorMem = 0;
			PCWrite = 1;
			state = inicial_1;
		end
		inicial_1: begin
			IRWrite = 1;
			MDRWrite = 1;
			state = inicial_2;
		end
		inicial_2: begin
			RegWrite = 0;
			AWrite = 1;
			BWrite = 1;
			ALUSrcA = 2'b00;
			ALUSrcB = 3'b011;
			USExt = 1;
			ALUOp = 3'b001;
			PCWrite = 0;
			ALUOutWrite = 1;
			state = wait_1;
		end
		wait_1: begin
			state = wait_2;
		end
		wait_2: begin
			state = wait_3;
		end
		wait_3: begin
			state = decode;
		end
		decode: begin
			case (ControlOp)
				Opcode_R: begin
					case(funct)
						funct_add: state = add;
						funct_and: state = And;
						funct_div: state = div;
						funct_mult: state = mult;
						funct_jr: state = jr;
						funct_mfhi: state = mfhi;
						funct_mflo: state = mflo;
						funct_sll: state = sll;
						funct_sllv: state = sllv;
						funct_slt: state = slt;
						funct_sra: state = sra;
						funct_srav: state = srav;
						funct_srl: state = srl;
						funct_sub: state = sub;
						funct_break: state = Break;
						funct_rte: state = rte;
					endcase
				end
				Opcode_addi: state = addi;
				Opcode_addiu: state = addiu;
				Opcode_beq: state = beq;
				Opcode_bne: state = bne;
				Opcode_ble: state = ble;
				Opcode_bgt: state = bgt;
				Opcode_lb: state = lb_1;
				Opcode_lh: state = lh_1;
				Opcode_lui: state = lui;
				Opcode_lw: state = lw_1;
				Opcode_sb: state = sb_1;
				Opcode_sh: state = sh_1;
				Opcode_slti: state = slti;
				Opcode_sw: state = sw_1;
				Opcode_j: state = jump;
				Opcode_jal: state = jal;
				Opcode_inc: state = inc;
				Opcode_dec: state = dec;
				default: state = OPcodeIN;
			endcase
		end
		addiu: begin
			ALUSrcA = 2'b10;
			USExt = 1;
			ALUSrcB = 3'b100;
			ALUOp = 3'b001;
			ALUOutWrite = 1;
			state = write_i;
		end
		write_i: begin
			RegDst = 2'b00;
			MemToReg = 4'b0000;
			RegWrite = 1;
			state = inicial;
		end
		addi: begin
			ALUSrcA = 2'b10;
			USExt = 1;
			ALUSrcB = 3'b100;
			ALUOp = 3'b001;
			ALUOutWrite = 1;
			if (O == 1) begin
				state = overflow;
			end
			else if(O == 0) begin
				state = write_i;
			end
		end
		slti: begin
			ALUSrcA = 2'b10;
			USExt = 1;
			ALUSrcB = 3'b100;
			ALUOp = 3'b111;
			ALUOutWrite = 1;
			if (LT == 1) begin
				state = write_lt1;
			end
			else if (LT == 0) begin
				state = write_lt0;
			end
		end
		write_lt1: begin
			RegDst = 2'b00;
			MemToReg = 4'b1010;
			RegWrite = 1;
			state = inicial;
		end
		write_lt0: begin
			RegDst = 2'b00;
			MemToReg = 4'b1001;
			RegWrite = 1;
			state = inicial;
		end
		add: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 3'b000;
			ALUOp = 3'b001;
			ALUOutWrite = 1;
			if (O == 1) begin
				state = overflow;
			end
			else if(O == 0) begin
				state = write_1;
			end
		end
		write_1: begin
			RegDst = 2'b01;
			MemToReg = 4'b0000;
			RegWrite = 1;
			state = inicial;
		end
		sub: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 3'b000;
			ALUOp = 3'b010;
			ALUOutWrite = 1;
			if (O == 1) begin
				state = overflow;
			end
			else if(O == 0) begin
				state = write_1;
			end		
		end
		And: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 3'b000;
			ALUOp = 3'b011;
			ALUOutWrite = 1;
			state = write_1;			
		end
		slt: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 3'b000;
			ALUOp = 3'b111;
			ALUOutWrite = 1;
			if (LT == 1) begin
				state = write_lt11;
			end
			else if (LT == 0) begin
				state = write_lt00;
			end			
		end
		write_lt11: begin
			RegDst = 2'b01;
			MemToReg = 4'b1010;
			RegWrite = 1;
			state = inicial;
		end
		write_lt00: begin
			RegDst = 2'b01;
			MemToReg = 4'b1001;
			RegWrite = 1;
			state = inicial;
		end
		jr: begin
			ALUSrcA = 2'b10;
			ALUOp = 3'b000;
			PCSource = 2'b01;
			ALUorMem = 0;
			PCWrite = 1;	
			state = inicial;		
		end
		jump: begin
			PCSource = 2'b00;
			ALUorMem = 0;
			PCWrite = 1;
			state = inicial;
		end
		jal: begin
			MemToReg = 4'b101;
			RegDst = 2'b11;
			RegWrite = 1;
			state = jal_2;
		end
		jal_2: begin
			PCSource = 2'b00;
			ALUorMem = 0;
			PCWrite = 1;
			state = inicial;
		end
		lui: begin
			RegDst = 2'b00;
			USExt = 0;
			MemToReg = 4'b0110;
			RegWrite = 1;
			state = inicial;
		end
		Break: begin
			state = Break;
		end
		inc: begin
			ALUSrcA = 2'b10;
			USExt = 1;
			ALUSrcB = 3'b100;
			ALUOp = 3'b001;
			ALUOutWrite = 1;
			state = inc_2;
		end
		inc_2: begin
			IorD = 3'b101;
			MemWR = 0;
			state = cory_4;
		end
		cory_4: begin
			state = inc_3;
		end
		inc_3: begin
			ALUSrcA = 2'b01;
			ALUOp = 3'b100;
			state = writeMem;
		end
		dec: begin
			ALUSrcA = 2'b10;
			USExt = 1;
			ALUSrcB = 3'b100;
			ALUOp = 3'b001;
			ALUOutWrite = 1;
			state = inc_2;
		end
		dec_2: begin
			IorD = 3'b101;
			MemWR = 0;
			state = cory_5;
		end
		cory_5: begin
			state = inc_3;
		end
		dec_3: begin
			ALUSrcA = 2'b01;
			ALUSrcB = 3'b001;
			ALUOp = 3'b010;
			state = writeMem;
		end
		writeMem: begin
			IorD = 3'b101;
			BWD = 2'b11;
			WriteData = 1;
			MemWR = 1;
			state = inicial;
		end
		rte: begin
			PCSource = 2'b10;
			ALUorMem = 0;
			PCWrite = 1;
			state = inicial;
		end
		beq: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 3'b000;
			ALUOp = 3'b010;
			if (O == 1) begin
				state = overflow;
			end
			else if (O == 0) begin
				if (Z == 1) begin
					state = branch_1;
				end
				else if (Z == 0) begin
					state = inicial;
				end
			end
		end
		branch_1: begin
			PCWrite = 0;
			PCSource = 2'b11;
			PCCond = 2'b00;
			PCWriteCond = 1;
			ALUorMem = 0;
			state = inicial;
		end
		ble: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 3'b000;
			ALUOp = 3'b111;
			if (GT == 0) begin
				state = branch_2;
			end
			else if (GT == 1) begin
				state = inicial;
			end
		end
		branch_2: begin
			PCWrite = 0;
			PCSource = 2'b11;
			PCCond = 2'b10;
			PCWriteCond = 1;
			ALUorMem = 0;
			state = inicial;
		end
		bne: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 3'b000;
			ALUOp = 3'b010;
			if (O == 1) begin
				state = overflow;
			end
			else if (O == 0) begin
				if (Z == 0) begin
					state = branch_3;
				end
				else if (Z == 1) begin
					state = inicial;
				end
			end
		end
		branch_3: begin
			PCWrite = 0;
			PCSource = 2'b11;
			PCCond = 2'b01;
			PCWriteCond = 1;
			ALUorMem = 0;
			state = inicial;
		end
		bgt: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 3'b000;
			ALUOp = 3'b111;
			if (GT == 1) begin
				state = branch_4;
			end
			else if (GT == 0) begin
				state = inicial;
			end
		end
		branch_4: begin
			PCWrite = 0;
			PCSource = 2'b11;
			PCCond = 2'b11;
			PCWriteCond = 1;
			ALUorMem = 0;
			state = inicial;
		end
		lw_1: begin
			ALUSrcA = 2'b10;
			USExt = 1;
			ALUSrcB = 3'b100;
			ALUOp = 3'b001;
			ALUOutWrite = 1;
			state = lw_2;
		end
		lw_2: begin
			IorD = 3'b101;
			MemWR = 0;
			state = cory_1;
		end
		cory_1: begin
			state = writemdr_1;
		end
		writemdr_1: begin
			MDRWrite = 1;
			state = lw_3;
		end
		lw_3: begin
			MemWD = 2'b00;
			RegDst = 2'b00;
			MemToReg = 4'b0001;
			RegWrite = 1;
			state = inicial;
		end
		lh_1: begin
			ALUSrcA = 2'b10;
			USExt = 1;
			ALUSrcB = 3'b100;
			ALUOp = 3'b001;
			ALUOutWrite = 1;
			state = lh_2;
		end
		lh_2: begin
			IorD = 3'b101;
			MemWR = 0;
			state = cory_2;
		end
		cory_2: begin
			state = writemdr_2;
		end
		writemdr_2: begin
			MDRWrite = 1;
			state = lh_3;
		end
		lh_3: begin
			MemWD = 2'b01;
			RegDst = 2'b00;
			MemToReg = 4'b0001;
			RegWrite = 1;
			state = inicial;
		end
		lb_1: begin
			ALUSrcA = 2'b10;
			USExt = 1;
			ALUSrcB = 3'b100;
			ALUOp = 3'b001;
			ALUOutWrite = 1;
			state = lb_2;
		end
		lb_2: begin
			IorD = 3'b101;
			MemWR = 0;
			state = cory_3;
		end
		cory_3: begin
			state = writemdr_3;
		end
		writemdr_3: begin
			MDRWrite = 1;
			state = lb_3;
		end
		lb_3: begin
			MemWD = 2'b10;
			RegDst = 2'b00;
			MemToReg = 4'b0001;
			RegWrite = 1;
			state = inicial;
		end
		sw_1: begin
			ALUSrcA = 2'b10;
			USExt = 1;
			ALUSrcB = 3'b100;
			ALUOp = 3'b001;
			ALUOutWrite = 1;
			state = sw_2;
		end
		sw_2: begin
			IorD = 3'b101;
			MemWR = 0;
			state = cory_6;
		end
		cory_6: begin
			state = sw_3;
		end
		sw_3: begin
			MDRWrite = 1;
			state = sw_4;
		end
		sw_4: begin
			BWD = 2'b00;
			WriteData = 1;
			IorD = 3'b101;
			MemWR = 1;
			state = inicial;
		end
		sh_1: begin
			ALUSrcA = 2'b10;
			USExt = 1;
			ALUSrcB = 3'b100;
			ALUOp = 3'b001;
			ALUOutWrite = 1;
			state = sh_2;
		end
		sh_2: begin
			IorD = 3'b101;
			MemWR = 0;
			state = cory_7;
		end
		cory_7: begin
			state = sh_3;
		end
		sh_3: begin
			MDRWrite = 1;
			state = sh_4;
		end
		sh_4: begin
			BWD = 2'b01;
			WriteData = 1;
			IorD = 3'b101;
			MemWR = 1;
			state = inicial;
		end
		sb_1: begin
			ALUSrcA = 2'b10;
			USExt = 1;
			ALUSrcB = 3'b100;
			ALUOp = 3'b001;
			ALUOutWrite = 1;
			state = sb_2;
		end
		sb_2: begin
			IorD = 3'b101;
			MemWR = 0;
			state = cory_8;
		end
		cory_8: begin
			state = sb_3;
		end
		sb_3: begin
			MDRWrite = 1;
			state = sb_4;
		end
		sb_4: begin
			BWD = 2'b10;
			WriteData = 1;
			IorD = 3'b101;
			MemWR = 1;
			state = inicial;
		end
		OPcodeIN: begin
			ALUSrcA = 2'b00;
			ALUSrcB = 3'b010;
			ALUOp = 3'b010;
			EPCWrite = 1;
			IorD = 3'b010;
			MemWR = 0;
			state = cory_9;
		end
		cory_9: begin
			state = OPcodeIN_2;
		end
		OPcodeIN_2: begin;
			MDRWrite = 1;
			state = OPcodeIN_3;
		end
		OPcodeIN_3: begin
			ALUorMem = 1;
			PCWrite = 1;
			state = inicial;
		end
		overflow: begin
			ALUSrcA = 2'b00;
			ALUSrcB = 3'b010;
			ALUOp = 3'b010;
			EPCWrite = 1;
			IorD = 3'b011;
			MemWR = 0;
			state = cory_10;
		end
		cory_10: begin
			state = overflow_2;
		end
		overflow_2: begin;
			MDRWrite = 1;
			state = overflow_3;
		end
		overflow_3: begin
			ALUorMem = 1;
			PCWrite = 1;
			state = inicial;
		end
		sll: begin
			DR1 = 1;
			DR2 = 1;
			ShiftCtrl = 3'b001;
			state = sl;
		end
		sl: begin
			ShiftCtrl = 3'b010;
			state = cory_11;
		end
		cory_11: begin
			state = write_2;
		end
		write_2: begin
			RegDst = 2'b01;
			MemToReg = 4'b100;
			RegWrite = 1;
			state = inicial;
		end
		sllv: begin
			DR1 = 0;
			DR2 = 0;
			ShiftCtrl = 3'b001;
			state = sl;
		end
		sra: begin
			DR1 = 1;
			DR2 = 1;
			ShiftCtrl = 3'b001;
			state = sr_a;
		end
		sr_a: begin
			ShiftCtrl = 3'b100;
			state = cory_11;
		end
		srav: begin
			DR1 = 0;
			DR2 = 0;
			ShiftCtrl = 3'b001;
			state = sr_a;
		end
		srl: begin
			DR1 = 1;
			DR2 = 1;
			ShiftCtrl = 3'b001;
			state = sr;
		end
		sr: begin
			ShiftCtrl = 3'b011;
			state = cory_11;
		end
		/*Reset: begin
			state = PC0;
		end
		PC0: begin
			IorD = 3'b000;
			IRWrite = 1;
			RegWrite = 1;
			RegDst = 2'b10; // inicializando R29 com 227
			MemToReg = 4'b1000;
			state = Wait_Decode;
		end
		PC4: begin
			IorD = 3'b001;
			MemWR = 0;
			IRWrite = 1;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b10;
			ALUOp = 3'b001;
			PCSource = 2'b01;
			ALUorMem = 2'b00;
			PCWrite = 1;
			state = Wait_Decode;
		end
		Wait_Decode: begin
			PCWrite = 0;
			ALUOp = 3'b000; //?
			state = Decode;
		end
		Wait_Decode_2: begin
			state = Decode;
		end
		Decode: begin
			AWrite = 1;
			BWrite = 1;
			ALUSrcA = 2'b10;
			ALUSrcB = 2'b00;
			ALUOp = 3'b001;
			state = Wait_Decode_3;
		end
		Wait_Decode_3: begin
			state = Wait_Decode_4;
		end
		Wait_Decode_4: begin
			case(Opcode)
				Opcode_R: begin
					case(funct)
						func_add: state = Add;
						func_and: state = And;
						func_div: state = Div;
						func_mult: state = Mult;
						func_jr: state = Jr;
						func_mfhi: state = Mfhi;
						func_mflo: state = Mflo;
						func_sll: state = Sll_Sra_Srl;
						func_sllv: state = Sllv_Srav;
						func_slt: state = Slt;
						func_sra: state = Sll_Sra_Srl;
						func_srav: state = Sllv_Srav;
						func_srl: state = Sll_Sra_Srl;
						func_sub: state = Sub;
						func_break: state = Break;
						func_rte: state = Rte;
					endcase
				end
				Opcode_addi: state = Addi_Addiu;
				Opcode_addiu: state = Addi_Addiu;
				Opcode_beq: state = Beq;
				Opcode_bne: state = Bne;
				Opcode_ble: state = Ble;
				Opcode_bgt: state = Bgt;
				Opcode_lb: state = Lb_Lh_Lw;
				Opcode_lh: state = Lb_Lh_Lw;
				Opcode_lui: state = Lui;
				Opcode_lw: state = Lb_Lh_Lw;
				Opcode_sb: state = Sb_Sh;
				Opcode_sh: state = Sb_Sh;
				Opcode_slti: state = Slti;
				Opcode_sw: state = Sw;
				Opcode_j: state = J;
				Opcode_jal: state = Jal;
				Opcode_inc: state = Inc;
				Opcode_dec: state = Dec;
				default: state = Opcode_inexistente;
			endcase
		end
		Add: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 2'b00;
			ALUOp = 3'b001;
			//RorLT = 1;
			ALUOutWrite = 1;
			state = Write_1;
		end
		Sub: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 2'b00;
			ALUOp = 3'b010;
			//RorLT = 1;
			ALUOutWrite = 1;
			state = Write_1;
		end
		And: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 2'b00;
			ALUOp = 3'b011;
			//RorLT = 1;
			ALUOutWrite = 1;
			state = Write_1;
		end
		Write_1: begin
			if(O == 1) begin
				state = Overflow;
			end
			else begin
				MemToReg = 4'b0000;
				RegDst = 2'b01;
				RegWrite = 1;
				ALUOutWrite = 0;
				state = PC4;
			end
		end
		Mult: begin
			StartM = 1;
			state = Wait_Mult_Div;
		end
		Div: begin
			StartD = 1;
			state = Wait_Mult_Div;
		end
		Wait_Mult_Div: begin
			if(MultEnd == 1 || DivEnd == 1) begin
				if(DivZero == 1) begin
					StartD = 0;
					state = Div_zero;
				end
				else if(DivEnd == 0) begin
					MultOrDiv = 0;
					StartM = 0;
					state = Mult_2;
				end
				else if(MultEnd == 0) begin
					MultOrDiv = 1;
					StartD = 0;
					state = Div_2;
				end 
			end
			else if(MultEnd == 0 || DivEnd == 0) begin
				state = Wait_Mult_Div;
			end
		end
		Mult_2: begin
			HIWrite = 1;
			LOWrite = 1;
			state = PC4;
		end
		Div_2: begin
			HIWrite = 1;
			LOWrite = 1;
			state = PC4;
		end
		Mfhi: begin
			RegDst = 2'b11;
			MemToReg = 4'b0110;
			RegWrite = 1;
			state = PC4;
		end
		Mflo: begin
			RegDst = 2'b11;
			MemToReg = 4'b0111;
			RegWrite = 1;
			state = PC4;
		end
		Sllv_Srav: begin
			OpReg = 0;
			RegOrShamt = 0;
			Shift = 3'b001;
			case(funct)
				funct_sllv: state = Sll_Sllv;
				funct_srav: state = Sra_Srav;
			endcase
		end
		Sll_Sra_Srl: begin
			OpReg = 1;
			RegOrShamt = 1;
			Shift = 3'b001;
			case(funct)
				funct_sll: state = Sll_Sllv;
				funct_sra: state = Sra_Srav;
				funct_srl: state = Srl;
			endcase
		end
		Sll_Sllv: begin
			Shift = 3'b010;
			state = S_All;
		end
		Sra_Srav: begin
			Shift = 3'b100;
			state = S_All;
		end
		Srl: begin
			Shift = 3'b011;
			state = S_All;
		end
		S_All: begin
			MemToReg = 4'b0000;
			RegDst = 2'b11;
			RegWrite = 1;
			state = PC4;
		end
		Slt: begin
			ALUOp = 3'b111;
			ALUSrcA = 2'b10;
			ALUSrcB = 2'b00;
			ALUOutWrite = 1;
			RorLT = 0;
			state = Write_1;
		end
		Slti: begin
			ALUOp = 3'b111;
			ALUSrcA = 2'b10;
			ALUSrcB = 2'b10;
			RorLT = 0;
			state = Write_1;
		end
		Rte: begin
			PCSource = 3'b100;
			PCWrite = 1;
			state = PC4;
		end
		Break: begin
			state = Break;
		end
		Addi_Addiu: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 2'b10;
			ALUOp = 3'b001;
			RorLT = 1;
			ALUOutWrite = 1;
			case(Opcode)
				Opcode_addiu: state = Addiu;
				Opcode_addi: state = Addi;
			endcase
		end
		Addi: begin
			if(O == 1) begin
				state = Overflow;
			end
			else begin
				MemToReg = 4'b0010;
				RegDst = 2'b00;
				RegWrite = 1;
				ALUOutWrite = 0;
				state = PC4;
			end
		end
		Addiu: begin
			MemToReg = 4'b0010;
			RegDst = 2'b00;
			RegWrite = 1;
			ALUOutWrite = 0;
			state = PC4;
		end
		Beq: begin
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b11;
			ALUOp = 3'b001;
			ALUOutWrite = 1;
			PCSource = 3'b101;
			Comp = 2'b00;
			PCWriteCond = 1;
			RorLT = 1;
			state = Beq_2;
		end
		Beq_2: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 2'b00;
			ALUOp = 3'b010;
			ALUOutWrite = 0;
			state = PC4;
		end
		Bne: begin
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b11;
			ALUOp = 3'b001;
			ALUOutWrite = 1;
			PCSource = 3'b101;
			Comp = 2'b01;
			PCWriteCond = 1;
			RorLT = 1;
			state = Bne_2;
		end
		Bne_2: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 2'b00;
			ALUOp = 3'b010;
			ALUOutWrite = 0;
			state = PC4;
		end
		Ble: begin
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b11;
			ALUOp = 3'b001;
			ALUOutWrite = 1;
			PCSource = 3'b101;
			Comp = 2'b11;
			PCWriteCond = 1;
			RorLT = 1;
			state = Ble_2;
		end
		Ble_2: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 2'b00;
			ALUOp = 3'b111;
			ALUOutWrite = 0;
			state = PC4;
		end
		Bgt: begin
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b11;
			ALUOp = 3'b001;
			ALUOutWrite = 1;
			PCSource = 3'b101;
			Comp = 2'b10;
			PCWriteCond = 1;
			RorLT = 1;
			state = Bgt_2;
		end
		Bgt_2: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 2'b00;
			ALUOp = 3'b111;
			ALUOutWrite = 0;
			state = PC4;
		end
		Lb_Lh_
		: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 2'b10;
			ALUOp = 3'b001;
			RorLT = 1;
			ALUOutWrite = 1;
			state = Lb_Lh_Lw_2;
		end
		Lb_Lh_Lw_2: begin
			IorD = 3'b100;
			Wr = 0;
			IRWrite = 0;
			ALUOutWrite = 0;
			state = Wait_Lb_Lh_Lw;
		end
		Wait_Lb_Lh_Lw: begin
			case(Opcode)
				Opcode_lw: state = Lw;
				Opcode_lb: state = Lb;
				Opcode_lh: state = Lh;
			endcase
		end
		Lw : begin
			MDRWrite = 1;
			RegDst = 2'b00;
			MemToReg = 4'b0011;
			RegWrite = 1;
			state = Wait_Lb_Lh_Lw_2;
		end
		Lh : begin
			MDRWrite = 1;
			RegDst = 2'b00;
			MemToReg = 4'b0100;
			RegWrite = 1;
			state = Wait_Lb_Lh_Lw_2;
		end
		Lb : begin
			MDRWrite = 1;
			RegDst = 2'b00;
			MemToReg = 4'b0101;
			RegWrite = 1;
			state = Wait_Lb_Lh_Lw_2;
		end
		Wait_Lb_Lh_Lw_2 : begin
			state = Wait_Lb_Lh_Lw_3;
		end
		Wait_Lb_Lh_Lw_3: begin
			state = PC4;
		end
		Lui: begin
			MDRWrite = 1;
			RegDst = 2'b00;
			MemToReg = 4'b1000;
			RegWrite = 1;
			state = Wait_Lb_Lh_Lw_2;
		end
		Sw: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 2'b10;
			ALUOutWrite = 1;
			ALUOp = 3'b001;
			RorLT = 1;
			state = Sw_2;
		end
		Sw_2: begin
			IorD = 3'b100;
			StoreSel = 0;
			Wr = 1;
			state = PC4;
		end
		Sb_Sh: begin
			ALUSrcA = 2'b10;
			ALUSrcB = 2'b10;
			ALUOp = 3'b001;
			ALUOutWrite = 1;
			RorLT = 1;
			state = Sb_Sh_2;
		end
		Sb_Sh_2: begin
			IorD = 3'b100;
			Wr = 0;
			state = Wait_Sb_Sh;
		end
		Wait_Sb_Sh : begin
			case(Opcode)
				Opcode_sb: state = Sb;
				Opcode_sh: state = Sh;
			endcase
		end
		Sb: begin
			SbOrSh = 0;
			state = Sb_Sh_3;
		end
		Sh: begin
			SbOrSh = 1;
			state = Sb_Sh_3;
		end
		Sb_Sh_3 : begin
			StoreSel = 1;
			Wr = 1;
			state = PC4;
		end
		J : begin
			ALUSrcA = 2'd0; // PC
			ALUSrcB = 2'd1; // 4
			ALUOp = 3'b001; // adicao
			state = J_2;
		end
		J_2 : begin
			PCWrite = 1;
			PCSource = 3'b001;
			state = PC4;
		end
		Jal : begin
			ALUSrcA = 2'd0; // PC
			ALUSrcB = 2'd1; // 4
			ALUOp = 3'b001; // adicao
			RorLT = 1;
			ALUOutWrite = 1;
			state = Jal_2;
		end
		Jal_2 : begin
			RegDst = 2'b01;
			MemToReg = 4'b0010;
			RegWrite = 1;
			state = Jal_3;
		end
		Jal_3 : begin
			PCWrite = 1;
			PCSource = 3'b001;
			state = PC4;
		end
		Jr: begin
			ALUSrcA = 2'b10; // rs
			ALUSrcB = 2'b01; // 4
			ALUOp = 3'b010; // subtracao
			state = Jr_2;
		end
		Jr_2 : begin
			PCWrite = 1;
			PCSource = 3'b010;
			state = PC4;
		end
		Opcode_inexistente : begin
			EPCWrite = 1;
			state = Opcode_inexistente_2;
		end
		Opcode_inexistente_2 : begin
			Wr = 0;
			IorD = 3'd1;
			state = Excecao;
		end
		Overflow: begin
			EPCWrite = 1;
			state = Overflow_2;
		end
		Overflow_2 : begin
			Wr = 0;
			IorD = 3'd2;
			state = Excecao;
		end
		Div_zero : begin
			EPCWrite = 1;
			state = Div_zero_2;
		end
		Div_zero_2 : begin
			Wr = 0;
			IorD = 3'd3;
			state = Excecao;
		end
		Excecao : begin
			PCSource = 3'd3;
			state = Wait_Excecao;
		end
		Wait_Excecao : begin
			PCWrite = 1;
			state = PC4;
		end	*/
	endcase
	end
end

endmodule:unctr
