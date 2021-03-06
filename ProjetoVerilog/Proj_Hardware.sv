module VCPU(input clock,
	input reset,
	output logic [31:0] pcout,
	output logic [31:0] epcout,
	output logic [31:0] mdrout,
	output logic [5:0] op,
	output logic [4:0] rs,
    output logic [4:0] rt,
    output logic [15:0] inst15_0,
	output logic [6:0] stateout
);

//fios grandoes:
logic pccontrol;
logic [31:0] wmwritedata;
logic [31:0] alusrcaout;
logic [31:0] alusrcbout;
logic [31:0] regaluout;
logic [31:0] memtoregout;
logic [2:0] aluop;
logic [31:0] regdeslocout;
logic memwrite;
logic regwritesignal;
logic irwrite;
logic [31:0] regaout;
logic [31:0] regbout;
logic [4:0] shamt;
logic [2:0] shiftop;
logic [4:0] regdstout;
logic [1:0] readdstmux;
logic readsmux;
logic [31:0] regain;
logic [4:0] shiftsout;
logic [31:0] reginout;
logic [31:0] aluresult;
logic [31:0] highout;
logic [31:0] lowout;	
logic [31:0] iordout;



logic pcond1;
logic ltflag;
logic equalflag;
logic gtflag;
logic pccond2;
logic [5:0] funct;
logic [31:0] memout;
logic [31:0] pcin;
logic [31:0] wmregout;
logic [25:0] inst25_0; //facilita ter s� ele porque no 

endmodule: VCPU