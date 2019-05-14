import "Memoria.vhd";
import "Registrador.vhd";
import "Instr_Reg.vhd";
import "mux_iOrD.v";

module CPU(
	input clock,
	input reset,
	
	output wire [5:0] ControlOp,
	
	output wire [31:0] PCout,
	output wire [31:0] EPCout,
	output wire [31:0] MDRout,
	
	output wire [4:0] rs,
    output wire [4:0] rt,
    
    output wire [15:0] inst15_0,
    
	output wire [6:0] CurState
);

wire ALUorMem;
wire [31:0] AorMemOut;
wire [3:0] IorD;
wire [31:0] IorDOut;

wire [25:0] IRConcExt;
wire [31:0] IRConctOut;
wire [25:0] IRShiftL2;
wire [27:0] IRShiftL2Out;
wire [31:0] IRPCConc;
// assign IRPCCont = {PCout[31:28]; IRShiftL2Out}; // NAO DA PRA TESTAR


wire MemWR;
wire [31:0] MemOut;

wire IRWrite;
wire WrMDR;

wire BWDSE;
wire [1:0] BWD;
wire [31:0] BWDOut;

wire WriteData;
wire [31:0] WriteDataOut;

wire MWDSE;
wire [1:0] MemWD;
wire [31:0] MemWDout;

wire RegWrite;
wire [1:0] RegDst;
wire [31:0] RegDstOut;

wire [31:0] RegAIn;
wire [31:0] RegAOut;
wire [31:0] RegBIn;
wire [31:0] RegBOut;

wire [1:0] AluSrcA;
wire RegAWrite;
wire [31:0] AluSrcAOut;

wire [2:0] AluSrcB;
wire RegBWrite;
wire [31:0] AluSrcBOut;


wire [3:0] MemToReg;
wire [31:0] MemToRegOut;

wire USExt;
wire [31:0] USExtOut;
wire [31:0] SL16Out;
wire [31:0] SL2Out;

wire [2:0] ALUOp;
wire [31:0] ALUOut;
wire [31:0] ALURegOut;

wire EPCWrite;
wire [1:0] PCSource;
wire PCWriteCond;
wire PCWrite;
wire PCWCtrl; // controla se escreve ou n em PC; baseado nos bools anteriores
wire [31:0] PCSrcOut;

wire Greater;
wire Equal;
wire Zero;
wire Overflow;



wire StartDiv; // start div
wire DivZero;
wire DivEnd;
wire [31:0] DivHightOut;
wire [31:0] DivLowOut;

wire StartMult; //start mult
wire MultEnd;
wire [31:0] MultHightOut;
wire [31:0] MultLowOut;	

wire [31:0] MuxHightOut;
wire [31:0] MuxLowOut;


wire WrLow;
wire WrHigh;
wire [31:0] RegHighOut;
wire [31:0] RegLowOut;


wire DR1;
wire [31:0] DR1Out;
wire DR2;
wire [31:0] DR2Out;

wire [3:0] ShiftCtrl;
wire [31:0] DesReg;

Registrador PC(
	.Clk(clock),
	.Reset(reset),
	.Load(PCWCtrl),
	.Entrada(AorMemOut),
	.Saida(PCout)
);

Memoria mem(
	.Address(PCOut), //PCOut?
	.Clock(clock),
	.Wr(MemWR),
	.Datain(IorDOut),
	.Dataout(MemOut)
);


Registrador MDR(
	.Clk(clock),
	.Reset(reset),
	.Load(WrMDR), //conferir se é isso(ta certo tbm. bois)
	.Entrada(MemOut),
	.Saida(MDRout)
);

Instr_Reg IR(
	.Clk(clock),
	.Reset(reset),
	.Load_ir(IRWrite),
	.Entrada(MemOut),
	.Instr31_26(op),
	.Instr25_21(rs),
	.Instr20_16(rt),
	.Instr15_0(inst15_0)
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


endmodule