`timescale 1ns / 1ps
`define rs  25:21
`define rt  20:16
`define rd	15:11 
`define immed16 15:0
`define shamt 10:6
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:56:13 12/10/2017 
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
	 input RegWriteD,
	 input [1:0] RFAselD,
	 input [1:0] RFWDselW,
	 input MemWriteD,
	 input BranchD,
	 input NPCselD,
	 input BranchselD,
	 input EXTOpD,
	 input ALUbselE,
	 input [3:0]ALUOpE,
	 input [1:0]LDselM,
	 input [1:0]SDselM,
	 input Stall,
	 input [2:0] ForwardRSD,
	 input [2:0] ForwardRTD,
	 input [1:0] ForwardRSE,
	 input [1:0] ForwardRTE,
	 input ForwardRTM,
	 output [31:0] IR_D,
	 output [31:0] IR_E,
	 output [31:0] IR_M,
	 output [31:0] IR_W,
	 output [4:0] A3_M,
	 output [4:0] A3_E,
	 output [4:0] A3_W
    );

	 wire CMPout;
	 wire [31:0]IR_D_in,ADD4,nextPC,PC4_D,PC8_D;
	 wire [31:0]PC4_E,PC8_E,RS_E,RT_E,EXT_E;
	 wire [31:0]PC4_M,PC8_M,AO_M,RT_M,DMdata;
	 wire [31:0]PC4_W,PC8_W,AO_W,DM_W;
	 wire [31:0]WD,RF_RD1,RF_RD2,EXTout,NPCout,ALUout;
	 wire [31:0]RFWD,ALUb;
	 wire [31:0]MFRSD,MFRTD,MFRSE,MFRTE,MFRTM;
	 wire [4:0]RFA;
	 wire RegWrite_E,RegWrite_M,RegWrite_W;
	 wire MemWrite_E,MemWrite_M;
	
	
	 /*F������*/
	 //��nextPC���ж�ѡ	 
	 mux2_32 u_mux2_32_Branchsel(.In1(NPCout),
										  .In2(MFRSD),
										  .Op(BranchselD),
										  .Out(nextPC)
										  );
	 
	 ifu u_ifu(.clk(clk), 
				  .reset(reset), 
				  .Branch(BranchD), 
				  .nextPC(nextPC), //��Ҫ����Branchsel��nextPC����ѡ��mux,get
				  .Stall(Stall),
				  .NPCsel(NPCselD),
				  .CMPout(CMPout),
				  .Instr(IR_D_in), 
				  .ADD4(ADD4)
				  );
	 
	 /*D���Ĵ���*/
	 D_pipe u_D_pipe(.clk(clk), 
						  .reset(reset),
						  .Instr(IR_D_in),
						  .ADD4(ADD4),
						  .Stall(Stall),
						  .IR_D(IR_D),
						  .PC4_D(PC4_D),
						  .PC8_D(PC8_D)
						  );
	 /*D������*/
	 grf u_grf(.clk(clk),
				  .reset(reset),
				  .PrePC(PC4_W-4),
				  .busW(RFWD),//W����������Ҫ����mux,get
				  .WE(RegWrite_W),
				  .RA(IR_D[`rs]),
				  .RB(IR_D[`rt]),
				  .RW(A3_W),
				  .busA(RF_RD1),
				  .busB(RF_RD2)
				  );
	 
	 ext u_ext(.In(IR_D[`immed16]),
				  .SignOp(EXTOpD),
				  .Out(EXTout)
				  );
	 
	 
	 mux5_32 u_mux5_32_ForwardRSD(.In1(RF_RD1),
										 .In2(RFWD),
										 .In3(AO_M),
										 .In4(PC8_M),
										 .In5(PC8_E),
										 .Op(ForwardRSD),
										 .Out(MFRSD)
										 );
										 
	 mux5_32 u_mux5_32_ForwardRTD(.In1(RF_RD2),
										 .In2(RFWD),
										 .In3(AO_M),
										 .In4(PC8_M),
										 .In5(PC8_E),
										 .Op(ForwardRTD),
										 .Out(MFRTD)
										 );
	 cmp u_cmp(.Instr(IR_D),
				  .Data1(MFRSD), //��Դ��ת��,get
				  .Data2(MFRTD), //��Դ��ת��,get
				  .cmpout(CMPout)
				  );
	 
	 npc u_npc(.Instr(IR_D),
				  .PC4(PC4_D),
				  .NPCsel(NPCselD),
				  .cmpout(CMPout),
				  .npcout(NPCout)
				  );
				  
	 mux3_5 u_mux3_5_RFAsel(.In1(IR_D[`rt]),
									.In2(IR_D[`rd]),
									.In3(5'b11111),
									.Op(RFAselD),
									.Out(RFA)
									);
		 
	
	 /*E���Ĵ���*/
	 E_pipe u_E_pipe(.clk(clk),
						  .reset(reset),
						  .IR_D(IR_D),
						  .PC4_D(PC4_D),
						  .PC8_D(PC8_D),
						  .A3_D(RFA),
						  .RF_RD1(MFRSD),
						  .RF_RD2(MFRTD),
						  .EXT(EXTout),
						  .RegWrite_D(RegWriteD),
						  .MemWrite_D(MemWriteD),
						  .cmpout(CMPout),
						  .Stall(Stall),
						  .IR_E(IR_E),
						  .PC4_E(PC4_E),
						  .PC8_E(PC8_E),
						  .A3_E(A3_E),
						  .RS_E(RS_E),
						  .RT_E(RT_E),
						  .EXT_E(EXT_E),
						  .RegWrite_E(RegWrite_E),
						  .MemWrite_E(MemWrite_E)
						  );
	 
	 /*E������*/
	 
	 mux4_32 u_mux4_32_ForwardRSE(.In1(RS_E),
										 .In2(RFWD),
										 .In3(AO_M),
										 .In4(PC8_M),
										 .Op(ForwardRSE),
										 .Out(MFRSE)
										 ); 
	 
	 mux4_32 u_mux4_32_ForwardRTE(.In1(RT_E),
										 .In2(RFWD),
										 .In3(AO_M),
										 .In4(PC8_M),
										 .Op(ForwardRTE),
										 .Out(MFRTE)
										 ); 
	 
	 mux2_32 u_mux2_32_ALUbsel(.In1(MFRTE),
										.In2(EXT_E),
										.Op(ALUbselE),
										.Out(ALUb)
										);
	 
	 alu u_alu(.A(MFRSE),//��Դ��ת��mux,get
				  .B(ALUb),//��Դ��ת��mux��ѡ���ź�,get
				  .ALUOp(ALUOpE),
				  .Shamt(IR_E[`shamt]),
				  .C(ALUout)
				  );

	 /*M���Ĵ���*/
	 M_pipe u_M_pipe(.clk(clk),
						  .reset(reset),
						  .IR_E(IR_E),
						  .PC4_E(PC4_E),
						  .PC8_E(PC8_E),
						  .A3_E(A3_E),
						  .AO(ALUout),
						  .RT_E(MFRTE),///////���bug��Ȼ������ô�ã�
						  .RegWrite_E(RegWrite_E),
						  .MemWrite_E(MemWrite_E),
						  .IR_M(IR_M),
						  .PC4_M(PC4_M),
						  .PC8_M(PC8_M),
						  .A3_M(A3_M),
						  .AO_M(AO_M),
						  .RT_M(RT_M),
						  .RegWrite_M(RegWrite_M),
						  .MemWrite_M(MemWrite_M)
						  );
						  
	 /*M������*/
	 
	 mux2_32 u_mux2_32_ForwardRTM(.In1(RT_M),
											.In2(RFWD),
											.Op(ForwardRTM),
											.Out(MFRTM)
											);
	 
	 dm u_dm(.clk(clk),
				.reset(reset),
				.PrePC(PC4_M - 4),
				.MemWrite(MemWrite_M),
				.LDsel(LDselM),
				.SDsel(SDselM),
				.Address(AO_M),
				.Din(MFRTM),//��Դ��ת��get
				.Dout(DMdata)
				);
	 
	 /*W���Ĵ���*/
	 W_pipe u_W_pipe(.clk(clk),
						  .reset(reset),
						  .IR_M(IR_M),
						  .PC4_M(PC4_M),
						  .PC8_M(PC8_M),
						  .A3_M(A3_M),
						  .AO_M(AO_M),
						  .DM(DMdata),
						  .RegWrite_M(RegWrite_M),
						  .IR_W(IR_W),
						  .PC4_W(PC4_W),
						  .PC8_W(PC8_W),
						  .A3_W(A3_W),
						  .AO_W(AO_W),
						  .DM_W(DM_W),
						  .RegWrite_W(RegWrite_W)
						  );

	 /*W������*/ 
	 mux3_32 u_mux3_32_RFWDsel(.In1(AO_W),
										.In2(DM_W),
										.In3(PC8_W),
										.Op(RFWDselW),
										.Out(RFWD)
										);
										
endmodule
