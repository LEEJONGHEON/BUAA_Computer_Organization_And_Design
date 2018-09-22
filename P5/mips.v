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
module mips(
    input clk,
    input reset
    );
	 
	 wire [31:0]InstrD,InstrE,InstrM,InstrW;
	 wire [4:0]A3_E,A3_M,A3_W;
	 wire [3:0]ALUOpE;
	 wire [2:0]ForwardRSD,ForwardRTD;
	 wire [1:0]RFAselD,RFWDselW,ForwardRSE,ForwardRTE,LDselM,SDselM;
	 wire RegWriteD,MemWriteD,BranchD,NPCselD,BranchselD,EXTOpD,ALUbselE,Stall,ForwardRTM;

	 controlunit u_controlunit(.InstrD(InstrD),
										.InstrE(InstrE),
										.InstrM(InstrM),
										.InstrW(InstrW),
										.A3_E(A3_E),
										.A3_M(A3_M),
										.A3_W(A3_W),
										.RegWriteD(RegWriteD),
										.RFAselD(RFAselD),
										.RFWDselW(RFWDselW),
										.MemWriteD(MemWriteD),
										.BranchD(BranchD),
										.NPCselD(NPCselD),
										.BranchselD(BranchselD),
										.EXTOpD(EXTOpD),
										.ALUbselE(ALUbselE),
										.ALUOpE(ALUOpE),
										.LDselM(LDselM),
										.SDselM(SDselM),
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
								.ALUbselE(ALUbselE),
								.ALUOpE(ALUOpE),
								.LDselM(LDselM),
								.SDselM(SDselM),
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
								.A3_W(A3_W)
								);


endmodule
