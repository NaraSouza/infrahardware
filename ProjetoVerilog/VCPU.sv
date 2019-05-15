module VCPU(
	input clock,
	input reset,
	
	output logic [5:0] ControlOp,
	
	output logic [31:0] PCOut,
	output logic [31:0] EPCOut,
	output logic [31:0] MDROut,
	
	output logic [4:0] rs,
    output logic [4:0] rt,
    
    output logic [15:0] inst15_0,
    
	output logic [6:0] CurState // ???? verificar o que eh. Provavelmente eh o estado atual da maquina de estados
);

logic [4:0] rd;
logic [25:0] inst25_0;
logic [4:0] shamt;
logic [5:0] funct;

logic ALUorMem;
logic [31:0] AorMemOut;

logic [3:0] IorD;
logic [31:0] IorDOut;

logic [25:0] IRConcExt;
logic [31:0] IRConctOut;
logic [25:0] IRShiftL2;
logic [27:0] IRShiftL2Out;
logic [31:0] IRPCConc;
// assign IRPCCont = {PCOut[31:28]; IRShiftL2Out}; // NAO DA PRA TESTAR


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

logic USExt;
logic [31:0] USExtOut;
logic [31:0] SL16Out;
logic [31:0] SL2Out;

logic ALURegWrite;
logic [2:0] ALUOp;
logic [31:0] ALUOut; // ALU output
logic [31:0] ALURegOut; // Registrador que guarda ALU output

logic EPCWrite;
logic [1:0] PCSource;
logic PCWriteCond;
logic PCWrite;
logic PCWCtrl; // controla se escreve ou n em PC; baseado nos bools anteriores(resultado final, basicamente)
logic [31:0] PCSrcOut;

logic Overflow;
logic Negative;
logic Zero;
logic Equal;
logic GreaterThan;
logic LessThan;



logic StartDiv; // start div
logic DivZero;
logic DivEnd;
logic [31:0] DivHightOut;
logic [31:0] DivLowOut;

logic StartMult; //start mult
logic MultEnd;
logic [31:0] MultHightOut;
logic [31:0] MultLowOut;	

logic [31:0] MuxHightOut;
logic [31:0] MuxLowOut;


logic WrLow;
logic WrHigh;
logic [31:0] RegHighOut;
logic [31:0] RegLowOut;


logic DR1;
logic [31:0] DR1Out;
logic DR2;
logic [31:0] DR2Out;

logic [3:0] ShiftCtrl;
logic [31:0] DesRegOut;

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
	.Instr31_26(ControlOp),
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
	.Negativo(Negative), // nao tem!
	.z(Zero),
	.Igual(Equal),
	.Maior(GreaterThan),
	.Menor(LessThan)
);

Registrador ALUOutReg(
	.Clk(clock),
	.Reset(reset),
	.Load(ALURegWrite), //conferir se é isso(ok. bois)
	.Entrada(ALUOut),
	.Saida(ALURegOut)
);

mux_pcSrc pcSrcMux(
	.selector(PCSource),
	.inputA(IRPCConc),
	.inputB(ALUOut),
	.inputC(EPCOut),
	.inputD(ALURegOut),
	.out(PCSrcOut)	
);

RegDesloc RegD( //reg desloc
	.Clk(clock),
	.Reset(reset),
	.Shift(shiftop),	// fix
	.N(shiftsout),		// fix
	.Entrada(reginout),	// fix
	.Saida(DesRegOut)// fix
);

Registrador high(
	.Clk(clock),
	.Reset(reset),
	.Load(WrLow),
	.Entrada(MuxHightOut),
	.Saida(RegHighOut)
);

Registrador low(
	.Clk(clock),
	.Reset(reset),
	.Load(WrHigh),
	.Entrada(MuxLowOut),
	.Saida(RegLowOut)
);

// TODO: Verificar como setar e inst15_0 rs e rt direito neste projeto

assign inst25_0 [25:21] = rs;
assign inst25_0 [20:16] = rt;
assign inst25_0 [15:0] = inst15_0;

// TODO: 15:0 e 8:0 ou 31:16 e 31:24?
assign RegBHalf = RegBOut[15:0];
assign RegBByte = RegBOut[8:0];

assign rd = inst15_0 [15:11];
assign shamt = inst15_0 [10:6];
assign funct = inst15_0 [5:0];


endmodule: VCPU