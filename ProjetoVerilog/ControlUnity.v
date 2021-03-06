import Memoria::*;
import Registrador::*;
import Instr_Reg::*;
import mux_iOrD::*;

module VCPU(
	input clock,
	input reset,
	
	output logic [5:0] ControlOp,
	
	output logic [31:0] PCout,
	output logic [31:0] EPCout,
	output logic [31:0] MDRout,
	
	output logic [4:0] rs,
    output logic [4:0] rt,
    
    output logic [15:0] inst15_0,
    
	output logic [6:0] CurState
);

logic ALUorMem;
logic [31:0] AorMemOut;
logic [3:0] IorD;
logic [31:0] IorDOut;

logic [25:0] IRConcExt;
logic [31:0] IRConctOut;
logic [25:0] IRShiftL2;
logic [27:0] IRShiftL2Out;
logic [31:0] IRPCConc;
// assign IRPCCont = {PCout[31:28]; IRShiftL2Out}; // NAO DA PRA TESTAR


logic MemWR;
logic [31:0] MemOut;

logic IRWrite;
logic WrMDR;

logic BWDSE;
logic [1:0] BWD;
logic [31:0] BWDOut;

logic WriteData;
logic [31:0] WriteDataOut;

logic MWDSE;
logic [1:0] MemWD;
logic [31:0] MemWDout;

logic RegWrite;
logic [1:0] RegDst;
logic [31:0] RegDstOut;

logic [31:0] RegAIn;
logic [31:0] RegAOut;
logic [31:0] RegBIn;
logic [31:0] RegBOut;

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

logic [2:0] ALUOp;
logic [31:0] ALUOut;
logic [31:0] ALURegOut;

logic EPCWrite;
logic [1:0] PCSource;
logic PCWriteCond;
logic PCWrite;
logic PCWCtrl; // controla se escreve ou n em PC; baseado nos bools anteriores
logic [31:0] PCSrcOut;

logic Greater;
logic Equal;
logic Zero;
logic Overflow;



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
logic [31:0] DesReg;

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
	.Load(WrMDR), //conferir se � isso(ta certo tbm. bois)
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


endmodule: VCPU