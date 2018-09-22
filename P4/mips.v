`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:56:31 11/25/2017 
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
	  
	 wire RegDst,ALUSrc,MemtoReg,RegWrite,MemWrite,nPC_sel,ExtOp,Jump,RegRa,JReg,Jalr,Lb;
	 wire [2:0]ALUOp;
	 wire [31:0]Instr;
	controller u_ctrl(.Op(Instr[31:26]),
							 .Func(Instr[5:0]),
							 .RegDst(RegDst),
							 .ALUSrc(ALUSrc),
							 .MemtoReg(MemtoReg),
							 .RegWrite(RegWrite),
							 .MemWrite(MemWrite),
							 .nPC_sel(nPC_sel),
							 .ExtOp(ExtOp),
							 .ALUOp(ALUOp),
							 .Jump(Jump),
							 .RegRa(RegRa),
							 .JReg(JReg),
							 .Jalr(Jalr),
							 .Lb(Lb)
							);

	 datapath u_dp(.clk(clk), 
						 .reset(reset),
						 .RegDst(RegDst),
						 .ALUSrc(ALUSrc),
						 .MemtoReg(MemtoReg), 
						 .RegWrite(RegWrite),
						 .MemWrite(MemWrite),
						 .nPC_sel(nPC_sel),
						 .ExtOp(ExtOp),
						 .ALUOp(ALUOp),
						 .Jump(Jump),
						 .RegRa(RegRa),
						 .JReg(JReg),
						 .Jalr(Jalr),
						 .Lb(Lb),
						 .InstrOut(Instr)
						 );
	 
endmodule
