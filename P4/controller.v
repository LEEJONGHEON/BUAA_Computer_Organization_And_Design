`timescale 1ns / 1ps
`define special 6'b000000
`define addu 	 6'b100001
`define subu    6'b100011
`define ori     6'b001101
`define lw      6'b100011
`define sw      6'b101011
`define beq     6'b000100
`define lui     6'b001111
`define nop     6'b000000
`define j       6'b000010
`define jal     6'b000011
`define jr      6'b001000
`define sll     6'b000000
`define jalr    6'b001001
`define lb      6'b100000
`define ALU_ADD 3'b000
`define ALU_SUB 3'b001
`define ALU_OR   3'b010
`define ALU_BEQ  3'b011
`define ALU_LUI  3'b100
`define ALU_SLL  3'b101
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:38:00 11/26/2017 
// Design Name: 
// Module Name:    controller 
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
module controller(
    input [5:0] Op,
    input [5:0] Func,
    output RegDst,
    output ALUSrc,
    output MemtoReg,
    output RegWrite,
    output MemWrite,
    output nPC_sel,
    output ExtOp,
    output reg[2:0] ALUOp,
    output Jump,
    output RegRa,
    output JReg,
	 output Jalr,
	 output Lb
    );
	 
	 assign RegDst= (Op==`special && Func==`addu) ||(Op==`special && Func==`subu) || (Op==`special && Func==`sll)||(Op==`special && Func==`jalr);
	 assign ALUSrc= Op==`ori || Op==`lw || Op==`sw || Op==`lui ||Op==`lb;
	 assign MemtoReg= Op==`lw|| Op==`lb;
	 assign RegWrite= (Op==`special && Func==`addu) || (Op==`special && Func==`subu) || Op==`ori || Op==`lw || Op==`lui || Op==`jal||(Op==`special && Func==`sll)||(Op==`special && Func==`jalr)||Op==`lb;
	 assign MemWrite= Op==`sw;
	 assign nPC_sel= Op==`beq;
	 assign ExtOp= Op==`lw || Op==`sw || Op==`beq||Op==`lb;
	 assign Jump= Op==`j || Op==`jal;
	 assign RegRa= Op==`jal;
	 assign JReg= (Op==`special && Func==`jr)||(Op==`special && Func==`jalr);
	 assign Jalr= Op==`special && Func==`jalr;
	 assign Lb= Op==`lb;
	 
	 always @(*) begin
		 case(Op)
			`special: begin
				case(Func)
					`addu: ALUOp=`ALU_ADD;
					`subu: ALUOp=`ALU_SUB;
					`jr: ALUOp=`ALU_ADD;
					`sll:ALUOp=`ALU_SLL;
					`jalr:ALUOp=`ALU_ADD;
					default: ALUOp=`ALU_ADD;
				endcase
			end
			`ori: ALUOp=`ALU_OR;
			`beq: ALUOp=`ALU_BEQ;
			`lui: ALUOp=`ALU_LUI;
			`lb: ALUOp=`ALU_ADD;
			default: ALUOp=`ALU_ADD;
		 endcase
	 end
	 

endmodule
