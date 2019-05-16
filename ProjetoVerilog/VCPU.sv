module VCPU(
	input clock,
	input reset,
	
	output logic [5:0] OPCode, //opcode
	
	output logic [31:0] PCOut,
	output logic [31:0] EPCOut,
	output logic [31:0] MDROut,
	
	output logic [4:0] rs,
    output logic [4:0] rt,
    
    output logic [15:0] inst15_0,
    
	output logic [6:0] CurState // ???? verificar o que eh. Provavelmente eh o estado atual da maquina de estados
);

// TODO: Criar mux para PCCond

logic [4:0] rd;
logic [4:0] shamt;
logic [5:0] funct;

logic ALUorMem;
logic [31:0] AorMemOut;

logic [3:0] IorD;
logic [31:0] IorDOut;

logic [25:0] inst25_0;
logic [31:0] SEinst25_0;
logic [31:0] SL2Jumpinst25_0Out;


logic MemWR;
logic [31:0] MemOut;

logic IRWrite;
logic WrMDR;

logic [1:0] BWD;
logic [31:0] BWDOut;

logic WriteData;
logic [31:0] WriteDataOut;

logic [1:0] MemWD;
logic [31:0] MemWDout;

logic RegWrite;
logic [1:0] RegDst;
logic [31:0] RegDstOut;

logic [31:0] RegAIn;
logic [31:0] RegAOut;
logic [31:0] RegBIn;
logic [31:0] RegBOut;
logic [15:0] RegBHalf;
logic [8:0]  RegBByte;

logic [1:0] AluSrcA;
logic RegAWrite;
logic [31:0] AluSrcAOut;

logic [2:0] AluSrcB;
logic RegBWrite;
logic [31:0] AluSrcBOut;


logic [3:0] MemToReg;
logic [31:0] MemToRegOut;

logic USExt;			// Flag de (un)sign extend p/ ALUSrcB
// Outputs que vão para ALUSrcB baseado no USExt
logic [31:0] USExtOut;
logic [31:0] SL16Out;
logic [31:0] SL2Out;

logic ALURegWrite;
logic [2:0] ALUOp;
logic [31:0] ALUOut; 	// ALU output
logic [31:0] ALURegOut; // Registrador que guarda ALU output

logic EPCWrite;
logic [1:0] PCSource;
logic PCWriteCond;
logic PCWrite;
logic PCWCtrl; // controla se escreve ou n em PC; baseado nos bools anteriores(resultado final, basicamente)
logic [31:0] PCSrcOut;
logic PCCond;
logic PCCondOut;

logic Overflow;
logic Negative;
logic Zero;
logic Equal;
logic GreaterThan;
logic LessThan;



logic StartDiv; // start div
logic DivZero;
logic DivEnd;
logic [31:0] DivHighOut;
logic [31:0] DivLowOut;

logic StartMult; //start mult
logic MultEnd;
logic [31:0] MultHighOut;
logic [31:0] MultLowOut;	

logic MuxHighSel;	// Seletor do mux que escolhe entre High de Div ou Mult
logic MuxLowSel;	// Seletor do mux que escolhe entre Low de Div ou Mult
logic [31:0] MuxHighOut;
logic [31:0] MuxLowOut;


logic WrLow;	// Flag pra escrever no LowReg
logic WrHigh;	// Flag pra escrever no HighReg
logic [31:0] RegHighOut;
logic [31:0] RegLowOut;


logic DR1;				// Seletor do mux DR1
logic [31:0] DR1Out;	
logic DR2;				// Seletor do mux DR2
logic [4:0] DR2Out;

logic [2:0] ShiftCtrl;
logic [31:0] DesRegOut;

// Ainda é a versão provisória!!
UnidadeControle CtrlUnit(
	//sinais de entrada
	.Clk(clock),
	.reset(reset),
	.funct(funct),
	.Opcode(OPCode),
	//sinais de saida
	.MemWR(MemWR),
	.USExt(USext),
	//Mux
	.IorD(IorD), 
	output reg [1:0] ALUSrcA(ALUSrcA),
	output reg [2:0] ALUSrcB(ALUSrcB),
	output reg [1:0] PCSource(PCSource),
	output reg ALUorMem(ALUorMem),
	output reg [1:0] RegDst(RegDst),
	output reg [3:0] MemToReg(MemToReg),
	//Escrita em Registradores
	output reg IRWrite(IRWrite),
	output reg [2:0] ALUOp(ALUOp),
	output reg PCWrite(PCWrite),
	output reg PCWriteCond(PCWriteCond),
	output reg RegWrite(RegWrite), 
	output reg AWrite(RegAWrite),
	output reg BWrite(RegBWrite),
	output reg ALUOutWrite(ALURegWrite),
	output reg [6:0] state(CurState)
);


mux_2inputs ALUorMemMux(
	// TODO: Verificar se tá ok
	.selector(ALUorMem),
	.inputA(PCSrcOut),//0
	.inputB(MDROut),//1
	.outputA(AorMemOut)
);

Registrador PC(
	.Clk(clock),
	.Reset(reset),
	.Load(PCWCtrl),
	.Entrada(AorMemOut),
	.Saida(PCOut)
);

mux_iOrD IorDMux(
	// 253, 254 e 255
	// escolhidos dentro da un.
	//253 = 010
	//254 = 011
	//255 = 100
	.selector(IorD),
	.inputA(IRConcExt), //000
	.inputB(PCOut), //001
	.inputC(ALURegOut), //101
	.out(IorDOut)
);

mux_2inputs WriteDataMux(
	// TODO: Verificar se tá ok
	.selector( WriteData ),
	.inputA( ALURegOut ),//0
	.inputB( BWDOut ),//1
	.outputA( WriteDataOut ) // Realmente escreve em MemOut?
);

mux_BWD BWDMux(
	.selector(BWD),
	.MDRVal(MDROut),
	.FullWord( RegBOut ),//00. FullWord
	.HalfWord( RegBHalf ),//01
	.Byte( RegBByte ),//10
	.out( BWDOut )
);

Memoria Mem(
	// Datain é MemOut ou IorDOut?
	// Dataout é IorDOut ou MemOut?
	.Address( IorDOut ), //PCOut?
	.Clock(clock),
	.Wr( MemWR ),
	.Datain( WriteDataOut ),
	.Dataout( MemOut )
);

mux_memWD memWDMux(
	.selector( MemWD ),
	.FullWord( MDROut ),//00. FullWord
	.out(MemWDout)
);

Registrador MDR(
	.Clk(clock),
	.Reset(reset),
	.Load(WrMDR), //conferir se é isso(ta certo tbm. bois)
	.Entrada( MemOut ),
	.Saida( MDROut )
);

Instr_Reg IR(
	.Clk(clock),
	.Reset(reset),
	.Load_ir(IRWrite),
	.Entrada(MemOut),
	.Instr31_26(OPCode),
	.Instr25_21(rs),
	.Instr20_16(rt),
	.Instr15_0(inst15_0)
);

mux_regDst RegDSTMux(
	.selector(RegDst),
	.inputA( rt ), // rd?
	.inputB( rd ),  // rt?
	.out(RegDstOut)
);

mux_memToReg MemToRegMux(
	// 227, 0 e 1 estão sendo usados dentro da caixa magica
	.selector(MemToReg),
	.inputA(ALURegOut),//0000
	.inputB(MemWDout),//0001
	.inputC(RegLowOut),//0010
	.inputD(RegHighOut),//0011
	.inputE(DesRegOut),//0100
	.inputF(PCSrcOut),//0101
	.inputG(SL16Out),//0110
	.inputH(PCOut),//0111
	.out(MemToRegOut)
	
);

Banco_Reg registers(
	.Clk(clock),
	.Reset(reset),
	.RegWrite(RegWrite),
	.ReadReg1(rs),
	.ReadReg2(rt),
	.writeReg(RegDstOut),
	.WriteData(MemToRegOut),
	.ReadData1(RegAIn),
	.ReadData2(RegBIn)
);

Registrador A(
	.Clk(clock),
	.Reset(reset),
	.Load(RegAWrite),
	.Entrada(RegAIn),
	.Saida(RegAOut)
);

Registrador B(
	.Clk(clock),
	.Reset(reset),
	.Load(RegBWrite),
	.Entrada(RegBIn),
	.Saida(RegBOut)
);

mux_aluSrcA ALUSrcA(
	.selector(AluSrcA),
	.inputA(PCOut),
	.inputB(MDROut),
	.inputC(RegAOut),
	.out(AluSrcAOut)
);

mux_aluSrcB ALUSrcB(
	// 1 e 4 sao retornados pela caixa magica
	.selector(AluSrcB),
	.inputA(RegBOut), //000
	.inputB(SL2Out),  //011
	.inputC(USExtOut),//100
	.out(AluSrcBOut)
);

ula32 ALU(
	.A(AluSrcAOut),
	.B(AluSrcBOut),
	.Seletor(ALUOp),
	.S(ALUOut),
	.Overflow(Overflow),
	.Negativo(Negative),
	.z(Zero),
	.Igual(Equal),
	.Maior(GreaterThan),
	.Menor(LessThan)
);

Registrador ALUOutReg(
	.Clk(clock),
	.Reset(reset),
	.Load(ALURegWrite),
	.Entrada(ALUOut),
	.Saida(ALURegOut)
);

mux_pcSrc pcSrcMux(
	.selector(PCSource),
	.inputA(SL2Jumpinst25_0Out),
	.inputB(ALUOut),
	.inputC(EPCOut),
	.inputD(ALURegOut),
	.out(PCSrcOut)	
);

sign_extend26_32 SE26_32(
	.inst(inst25_0), 
	.out(SEinst25_0)
);

shift_leftJump SLJump(
	.entry(inst25_0), 
	.pc(PCOut), 
	.out(SL2Jumpinst25_0Out)
);

mux_2inputs DR1Mux(
	.selector(DR1),
	.inputA(RegAOut),//0
	.inputB(RegBOut),//1
	.outputA(DR1Out)
);

mux_dr2 DR2Mux(
	.selector(DR2),
	.shamt(shamt), //0
	.b(RegBOut),   //1
	.out(DR2Out)
);

RegDesloc DesReg( //reg desloc
	.Clk(clock),
	.Reset(reset),
	.Shift(ShiftCtrl),	
	.N(DR2Out),		
	.Entrada(DR1Out),	
	.Saida(DesRegOut)
);

sign_extend USExtMux(
	.wireIn(inst15_0), 
	.sign(USExt), 
	.wireOut(USExtOut)
);

shift_left2 SL2(
	.in(USExtOut), 
	.out(SL2Out)
);

shift_left16 SL16(
	.in(USExtOut), 
	.out(SL16Out)
);	

div DIVOp(
	.Dividendo(RegAOut),
	.Divisor(RegBOut),
	.DivStart(StartDiv),
	.Clk(clock),
	.Reset(reset), 
	.DivFim(DivEnd),
	.DivisaoPorZero(DivZero),
	.Hi(DivHighOut),
	.Lo(DivLowOut),
);

mult MULTOp(
	.a(RegAOut), 
	.b(RegBOut),
	.multCtrl(StartMult), 
	.Clk(clock), 
	.reset(reset),
	.hi(MultHighOut),
	.lo(MultLowOut),
	.done(MultEnd),
);

mux_2inputs LOWMux(
	.selector(MuxLowSel),
	.inputA(MultLowOut),//0
	.inputB(DivLowOut),//1
	.outputA(MuxLowOut)
);

mux_2inputs HIGHMux(
	.selector(MuxHighSel),
	.inputA(MultHighOut),//0
	.inputB(DivLowOut),//1
	.outputA(MuxHighOut)
);

Registrador HIGH(
	.Clk(clock),
	.Reset(reset),
	.Load(WrLow),
	.Entrada(MuxHightOut),
	.Saida(RegHighOut)
);

Registrador LOW(
	.Clk(clock),
	.Reset(reset),
	.Load(WrHigh),
	.Entrada(MuxLowOut),
	.Saida(RegLowOut)
);

assign inst25_0 [25:21] = rs;
assign inst25_0 [20:16] = rt;
assign inst25_0 [15:0] = inst15_0;


assign RegBHalf = RegBOut[15:0];
assign RegBByte = RegBOut[8:0];

assign rd = inst15_0 [15:11];
assign shamt = inst15_0 [10:6];
assign funct = inst15_0 [5:0];

assign PCWCtrl = (PCWriteCond && PCCondOut) || PCWrite;

endmodule: VCPU