`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:04:47 12/10/2017 
// Design Name: 
// Module Name:    mips 
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
module cpu(
    input clk,
    input reset,
	 output [31:0] PrAddr,
	 output PrWE,
	 output [31:0] PrWD,
	 input [31:0] PrRD,
	 input [7:2] HWInt
    );
	
	 wire [31:0]InstrD,InstrE,InstrM,InstrW;
	 wire [4:0]A3_E,A3_M,A3_W;
	 wire [3:0]ALUOpE;
	 wire [2:0]ForwardRSD,ForwardRTD,LDselW,MDOpE;
	 wire [1:0]RFAselD,RFWDselW,ForwardRSE,ForwardRTE,SDselM;
	 wire RegWriteD,MemWriteD,BranchD,NPCselD,BranchselD,ALUaselE,ALUbselE,EXTOpD,Stall,ForwardRTM,StartE,Busy;
	 wire IgOpD, C0weM, C0useM, EXLClrD;
	 wire [2:0]LDselM;

	 controlunit u_controlunit(.InstrD(InstrD),
										.InstrE(InstrE),
										.InstrM(InstrM),
										.InstrW(InstrW),
										.A3_E(A3_E),
										.A3_M(A3_M),
										.A3_W(A3_W),
										.Busy(Busy),
										.RegWriteD(RegWriteD),
										.RFAselD(RFAselD),
										.RFWDselW(RFWDselW),
										.MemWriteD(MemWriteD),
										.BranchD(BranchD),
										.NPCselD(NPCselD),
										.BranchselD(BranchselD),
										.EXTOpD(EXTOpD),
										.IgOpD(IgOpD),
										.ALUaselE(ALUaselE),
										.ALUbselE(ALUbselE),
										.ALUOpE(ALUOpE),
										.LDselW(LDselW),
										.LDselM(LDselM),
										.SDselM(SDselM),
										.C0weM(C0weM),
										.C0useM(C0useM),
										.EXLClrD(EXLClrD),
										.StartE(StartE),
										.MDOpE(MDOpE),
										.Stall(Stall),
										.ForwardRSD(ForwardRSD),
										.ForwardRTD(ForwardRTD),
										.ForwardRSE(ForwardRSE),
										.ForwardRTE(ForwardRTE),
										.ForwardRTM(ForwardRTM)
										);
										

	 datapath u_datapath(.clk(clk),
								.reset(reset),					
								.RegWriteD(RegWriteD),
								.RFAselD(RFAselD),
								.RFWDselW(RFWDselW),
								.MemWriteD(MemWriteD),
								.BranchD(BranchD),
								.NPCselD(NPCselD),
								.BranchselD(BranchselD),
								.EXTOpD(EXTOpD),
								.IgOpD(IgOpD),
								.ALUaselE(ALUaselE),
								.ALUbselE(ALUbselE),
								.ALUOpE(ALUOpE),
								.LDselW(LDselW),
								.LDselM(LDselM),
								.SDselM(SDselM),
								.StartE(StartE),
								.MDOpE(MDOpE),
								.C0weM(C0weM),
								.C0useM(C0useM),
								.EXLClrD(EXLClrD),
								.Stall(Stall),
								.ForwardRSD(ForwardRSD),
								.ForwardRTD(ForwardRTD),
								.ForwardRSE(ForwardRSE),
								.ForwardRTE(ForwardRTE),
								.ForwardRTM(ForwardRTM),
								.IR_D(InstrD),
								.IR_E(InstrE),
								.IR_M(InstrM),
								.IR_W(InstrW),
								.A3_E(A3_E),
								.A3_M(A3_M),
								.A3_W(A3_W),
								.Busy(Busy),
								.PrAddr(PrAddr),
								.PrWE(PrWE),
								.PrWD(PrWD),
								.PrRD(PrRD),
								.HWInt(HWInt)
								);

endmodule
