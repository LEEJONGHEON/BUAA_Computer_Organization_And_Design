`timescale 1ns / 1ps
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define sa 10:6
`define immed 15:0
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:47:50 11/26/2017 
// Design Name: 
// Module Name:    datapath 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module datapath(
	 input clk,
	 input reset,
	 input RegDst,
    input ALUSrc,
    input MemtoReg,
    input RegWrite,
    input MemWrite,
	 input nPC_sel,
    input ExtOp,
    input [2:0] ALUOp,
    input Jump,
    input RegRa,
    input JReg,
	 input Jalr,
	 input Lb,
	 output [31:0]InstrOut
    );
	 
	 wire [31:0]ExtResult,Instr,PrePC,RFIn,RFOutA,RFOutB,DMIn,DMOut,ALUInA,ALUInB,ALUResult,MemtoRegOut;
	 wire [4:0]RW,RegDstOut;
	 reg [4:0]ra;
	 wire ComResult;
	 
	 initial begin 
		ra=5'b11111;
	 end
	 
	 assign InstrOut=Instr;
	 assign MemAddr=ALUResult[11:2];//??能这样赋值？好像就是可以X
	 assign ALUInA=RFOutA;
	 assign DMIn=RFOutB;
	 ifu u_ifu(.clk(clk),
				  .reset(reset),
				  .Sign_ext(ExtResult),//extresult
				  .IfBeq(nPC_sel),
				  .ComResult(ComResult),
				  .Address(Instr[25:0]),
				  .Jump(Jump),
				  .RegData(RFOutA),//？？？rs出来的data
				  .JReg(JReg),
				  .Instr(Instr),
				  .PrePC(PrePC)
				  );
				  
	 grf u_grf(.clk(clk),
				  .reset(reset),
				  .PrePC(PrePC),
				  .busW(RFIn),
				  .WE(RegWrite),
				  .RA(Instr[`rs]),
				  .RB(Instr[`rt]),
				  .RW(RW),//Rw为写入寄存器的地址
				  .busA(RFOutA),//从grf中出来的两个数据
				  .busB(RFOutB)
				  );
	 
	 dm u_dm(.clk(clk),
				.reset(reset),
				.PrePC(PrePC),
				.MemWrite(MemWrite),
				.Address(ALUResult),
				.Lb(Lb),
				.Din(DMIn),
				.Dout(DMOut)
				);
				
	 ext u_ext(.In(Instr[`immed]),
				  .SignOp(ExtOp),
				  .Out(ExtResult)
				  );

	 alu u_alu(.A(ALUInA),
				  .B(ALUInB),
				  .ALUOp(ALUOp),
				  .Shamt(Instr[`sa]),
				  .C(ALUResult),
				  .ComResult(ComResult)
				  );
				  
	
  
	 mux2_32 u_mux2_32_ALUSrc(.A(RFOutB),
									  .B(ExtResult),
									  .Op(ALUSrc),
									  .C(ALUInB)
									  );
									  
	 mux2_5 u_mux2_5_RegDst(.A(Instr[`rt]),
									.B(Instr[`rd]),
									.Op(RegDst),
									.C(RegDstOut)//嵌套mux无奈之举
									);
									
	 mux2_5 u_mux2_5_RegRa(.A(RegDstOut),
								  .B(ra),//能这样赋值？？？
								  .Op(RegRa),
								  .C(RW)
								  );
	 mux2_32 u_mux2_32_MemtoReg(.A(ALUResult),
										 .B(DMOut),
										 .Op(MemtoReg),
										 .C(MemtoRegOut)//无奈+1
										 );
	 mux2_32 u_mux2_32_RegRa(.A(MemtoRegOut),
									 .B(PrePC+4),
									 .Op(RegRa|Jalr),
									 .C(RFIn)
									 );

endmodule
