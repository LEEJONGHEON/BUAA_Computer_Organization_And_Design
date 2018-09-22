`timescale 1ns / 1ps
`define rs  25:21
`define rt  20:16
`define rd	15:11 
`define immed16 15:0
`define shamt 10:6
`define cp0     6'b010000
`define mtc0    5'b00100
`define mfc0    5'b00000
`define eret    6'b011000
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
	 input IgOpD,//新添加
	 input ALUaselE,
	 input ALUbselE,
	 input [3:0]ALUOpE,
	 input [2:0]LDselW,
	 input [2:0]LDselM,
	 input [1:0]SDselM,
	 input StartE,///新添加
	 input [2:0]MDOpE,
	 input C0weM,
	 input C0useM,
	 input EXLClrD,
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
	 output [4:0] A3_W,
	 output Busy,
	 output [31:0] PrAddr,//get
	 output PrWE,//
	 output [31:0] PrWD,
	 input [31:0] PrRD,
	 input [7:2] HWInt
    );

	 wire CMPout;
	 wire [31:0]IR_D_in,ADD4,nextPC,PC4_D,PC8_D;
	 wire [31:0]PC4_E,PC8_E,RS_E,RT_E,EXT_E,HI,LO;
	 wire [31:0]PC4_M,PC8_M,AO_M,RT_M,DMdata;
	 wire [31:0]PC4_W,PC8_W,AO_W,DM_W,DM_EXT;
	 wire [31:0]WD,RF_RD1,RF_RD2,EXTout,NPCout,ALUout;
	 wire [31:0]RFWD,ALUb,ALUa;
	 wire [31:0]MFRSD,MFRTD,MFRSE,MFRTE,MFRTM;
	 wire [4:0]RFA;
	 wire RegWrite_E,RegWrite_M,RegWrite_W;
	 wire MemWrite_E,MemWrite_M;
	 
	 //异常部分
	 wire [31:0]DMout,CP0Data,DM_W_in,EPC;
	 wire [4:0]ExcCode_D,ExcCode_E,ExcCode_M,ExcCodeOut_D,ExcCodeOut_E,ExcCodeOut_M,DAExcCode;
	 wire PCExc,Overflow,DataAddrExc;
	 wire EXL_D,EXL_E,EXL_M;
	 wire BD_D,BD_E,BD_M;
	 wire HitDM,IntReq,EXLSet;
	
	 /*F级部件*/
	 //对nextPC进行多选	 
	 mux2_32 u_mux2_32_Branchsel(.In1(NPCout),
										  .In2(MFRSD),
										  .Op(BranchselD),
										  .Out(nextPC)
										  );
	 
	 ifu u_ifu(.clk(clk), 
				  .reset(reset), 
				  .Branch(BranchD), 
				  .nextPC(nextPC), //需要根据Branchsel对nextPC进行选择mux,get
				  .Stall(Stall),
				  .NPCsel(NPCselD),
				  .CMPout(CMPout),
				  .EXLClr(EXLClrD),
				  .EPC(EPC),
				  .IntReq(IntReq | EXLSet),//中断异常???
				  .PCExc(PCExc),
				  .Instr(IR_D_in), 
				  .ADD4(ADD4)
				  );
	 
	 /*D级寄存器*/
	 D_pipe u_D_pipe(.clk(clk), 
						  .reset(reset | IntReq | EXLSet),//EXLClrD为eret的nop延迟槽
						  .Instr(IR_D_in),
						  .ADD4(ADD4),
						  .Stall(Stall),
						  .EXLClrD(EXLClrD),
						  .IR_D(IR_D),
						  .PC4_D(PC4_D),
						  .PC8_D(PC8_D)
						  );
						  
	 /*D_exc*/
	 D_exc_reg u_D_exc_reg(.clk(clk),
								  .reset(reset| EXLClrD | IntReq | EXLSet),
								  .ExcCodeIn(5'd4),
								  .EXLIn(PCExc),
								  .Branch(BranchD),
								  .ExcCode_D(ExcCode_D),
								  .EXL_D(EXL_D),
								  .BD_D(BD_D)
								  );
	
	 /*D级部件*/
	 grf u_grf(.clk(clk),
				  .reset(reset),
				  .PrePC(PC4_W-4),
				  .busW(RFWD),//W级产生，需要进行mux,get
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
				  .Data1(MFRSD), //来源于转发,get
				  .Data2(MFRTD), //来源于转发,get
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
		 
	
	 /*E级寄存器*/
	 E_pipe u_E_pipe(.clk(clk),
						  .reset(reset | IntReq | EXLSet),
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
						  
	 /*E_exc*/
	 mux2_5 u_mux2_5_E_exc(.In1(ExcCode_D),
									.In2(5'd10),
									.Op(!EXL_D & IgOpD),
									.Out(ExcCodeOut_D)
									);
	 
	 E_exc_reg u_E_exc_reg(.clk(clk),
								  .reset(reset | IntReq | EXLSet),
								  .ExcCodeIn(ExcCodeOut_D),
								  .EXLIn(EXL_D|IgOpD),
								  .BD_D(BD_D),
								  .ExcCode_E(ExcCode_E),
								  .EXL_E(EXL_E),
								  .BD_E(BD_E)
								  );
	 
	 /*E级部件*/
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
										 
	 mux2_32 u_mux2_32_ALUasel(.In1(MFRSE),
										.In2({{27'b0},IR_E[`shamt]}),
										.Op(ALUaselE),
										.Out(ALUa)
										);
	 
	 mux2_32 u_mux2_32_ALUbsel(.In1(MFRTE),//////////需要改
										.In2(EXT_E),
										.Op(ALUbselE),
										.Out(ALUb)
										);
	 
	 alu u_alu(.A(ALUa),//来源于转发mux,get
				  .B(ALUb),//来源于转发mux和选择信号,get
				  .ALUOp(ALUOpE),
				  .C(ALUout),
				  .Overflow(Overflow)
				  );
		
	 mdpart u_mdpart(.clk(clk),
						  .reset(reset),
						  .A(MFRSE),//来源于转发的值
						  .B(MFRTE),
						  .Start(StartE),//在此处应该加上中断异常
						  .IntReq(IntReq| EXLSet),
						  .IR_M(IR_M),
						  .MDOp(MDOpE),
			           .Busy(Busy),
						  .hi(HI),
						  .lo(LO)
						  );

	 /*M级寄存器*/
	 M_pipe u_M_pipe(.clk(clk),
						  .reset(reset| IntReq | EXLSet),
						  .IR_E(IR_E),
						  .PC4_E(PC4_E),
						  .PC8_E(PC8_E),
						  .A3_E(A3_E),
						  .AO(ALUout),
						  .HI(HI),
						  .LO(LO),
						  .RT_E(MFRTE),
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
						  
	 /*M_exc*/
	 mux2_5 u_mux2_5_M_exc(.In1(ExcCode_E),
									.In2(5'd12),
									.Op(!EXL_E & Overflow),
									.Out(ExcCodeOut_E)
									);
	 
	 M_exc_reg u_M_exc_reg(.clk(clk),
								  .reset(reset| IntReq | EXLSet),
								  .ExcCodeIn(ExcCodeOut_E),
								  .EXLIn(Overflow | EXL_E),
								  .BD_E(BD_E),
								  .ExcCode_M(ExcCode_M),
								  .EXL_M(EXL_M),
								  .BD_M(BD_M)
								  );
						  
	 /*M级部件*/
	 mux2_32 u_mux2_32_ForwardRTM(.In1(RT_M),
											.In2(RFWD),
											.Op(ForwardRTM),
											.Out(MFRTM)
											);
											
	 assign HitDM= AO_M >= 32'b0 && AO_M <= 32'h2fff;
	 
	 dm u_dm(.clk(clk),
				.reset(reset),
				.PrePC(PC4_M - 4),
				.MemWrite(MemWrite_M && HitDM && !EXLSet && !IntReq),//修改了使能信号，中断或者异常的时候都不能写
				.SDsel(SDselM),
				.Address(AO_M),
				.Din(MFRTM),//来源于转发get
				.Dout(DMdata)
				);
	 
	 assign PrAddr=AO_M;
	 assign PrWE= MemWrite_M && !HitDM && !EXLSet && !IntReq;
	 assign PrWD=MFRTM;
	 
	 mux2_32 u_mux2_32_DMsel(.In1(PrRD),//对dm和外部设备进行选择,
									 .In2(DMdata),
									 .Op(HitDM),
									 .Out(DMout)
									 );
				 
	 addr_check u_addr_check(.MemWrite(MemWrite_M),//
									 .SDsel(SDselM),
									 .LDsel(LDselM),
									 .Addr(AO_M),
									 .DAExcCode(DAExcCode),
									 .DataAddrExc(DataAddrExc)
									 );
									 
	 mux2_5 u_mux2_5_W_exc(.In1(ExcCode_M),
								  .In2(DAExcCode),
								  .Op(!EXL_M | DataAddrExc),//前级优先
								  .Out(ExcCodeOut_M)
								  );
	 
	 
	 assign EXLSet=EXL_M | DataAddrExc;
	 
	 cp0 u_cp0(.clk(clk),
				  .reset(reset),
				  .A1(IR_M[`rd]),
				  .A3(A3_M),
				  .Din(MFRTM),
				  .PC(PC4_M-32'h4),
				  .ExcCode(ExcCodeOut_M),
				  .BD(BD_M),
				  .HWInt(HWInt),
				  .WE(C0weM),//mtc0
				  .EXLSet(EXLSet),
				  .EXLClr(IR_W[31:26]==`cp0 && IR_W[5:0]==`eret),//EXLCLRW
				  .IntReq(IntReq),//
				  .EPC(EPC),//eret
				  .Dout(CP0Data)//mfc0
				  );	  
			
			
	 mux2_32 u_mux2_32_DM_Wsel(.In1(DMout),//对(dm+外部设备)和CP0进行选择
									 .In2(CP0Data),
									 .Op(C0useM),
									 .Out(DM_W_in)
									 );
	 
	 
	 /*W级寄存器*/
	 W_pipe u_W_pipe(.clk(clk),
						  .reset(reset| IntReq | EXLSet),
						  .IR_M(IR_M),
						  .PC4_M(PC4_M),
						  .PC8_M(PC8_M),
						  .A3_M(A3_M),
						  .AO_M(AO_M),
						  .DM(DM_W_in),//来源需要进行选择？？？进行了两次选择
						  .RegWrite_M(RegWrite_M),
						  .IR_W(IR_W),
						  .PC4_W(PC4_W),
						  .PC8_W(PC8_W),
						  .A3_W(A3_W),
						  .AO_W(AO_W),
						  .DM_W(DM_W),
						  .RegWrite_W(RegWrite_W)
						  );

	 /*W级部件*/ 
	 ext_dm u_ext_dm(.Addrlow(AO_W[1:0]),
						  .Din(DM_W),
						  .LDsel(LDselW),
						  .Dout(DM_EXT)
						  );
	 
	 mux3_32 u_mux3_32_RFWDsel(.In1(AO_W),
										.In2(DM_EXT),
										.In3(PC8_W),
										.Op(RFWDselW),
										.Out(RFWD)
										);
										
endmodule
