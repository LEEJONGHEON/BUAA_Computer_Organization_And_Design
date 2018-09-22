`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:59:06 12/10/2017 
// Design Name: 
// Module Name:    controlunit 
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
module controlunit(
	 input [31:0]InstrD,
	 input [31:0]InstrE,
	 input [31:0]InstrM,
	 input [31:0]InstrW,
	 input [4:0] A3_M,
	 input [4:0] A3_E,
	 input [4:0] A3_W,
	 input Busy,
	 output RegWriteD,
	 output [1:0] RFAselD,
	 output [1:0] RFWDselW,
	 output MemWriteD,
	 output BranchD,
	 output NPCselD,
	 output BranchselD,
	 output EXTOpD,
	 output ALUaselE,
	 output ALUbselE,
	 output [3:0] ALUOpE,
	 output [2:0] LDselW,
	 output [1:0] SDselM,
	 output StartE,
	 output [2:0] MDOpE,
	 output Stall,
	 output [2:0] ForwardRSD,
	 output [2:0] ForwardRTD,
	 output [1:0] ForwardRSE,
	 output [1:0] ForwardRTE,
	 output ForwardRTM
    );
	 
	 controller u_controller_D(.Instr(InstrD),
										.RegWrite(RegWriteD),
										.RFAsel(RFAselD),
										.MemWrite(MemWriteD),
										.Branch(BranchD),
										.NPCsel(NPCselD),
										.Branchsel(BranchselD),
										.EXTOp(EXTOpD)
										);
										
	 controller u_controller_E(.Instr(InstrE),
										.ALUasel(ALUaselE),
										.ALUbsel(ALUbselE),
										.ALUOp(ALUOpE),
										.Start(StartE),
										.MDOp(MDOpE)
										);
										
	 controller u_controller_M(.Instr(InstrM),
										.SDsel(SDselM)
										);
	
	 controller u_controller_W(.Instr(InstrW),
										.RFWDsel(RFWDselW),
										.LDsel(LDselW)
										);
	 
	 hazardunit u_hazardunit(.InstrD(InstrD),
									 .InstrE(InstrE),
									 .InstrM(InstrM),
									 .InstrW(InstrW),
									 .A3_E(A3_E),
									 .A3_M(A3_M),
									 .A3_W(A3_W),
									 .StartE(StartE),
									 .Busy(Busy),
									 .Stall(Stall),
									 .ForwardRSD(ForwardRSD),
									 .ForwardRTD(ForwardRTD),
									 .ForwardRSE(ForwardRSE),
									 .ForwardRTE(ForwardRTE),
									 .ForwardRTM(ForwardRTM)
									 );
									

endmodule
