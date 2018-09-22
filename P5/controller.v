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
`define sb      6'b101000
`define regimm  6'b000001
`define bgezal  5'b10001
`define bltz    5'b00000
`define movz    6'b001010
`define slt     6'b101010

`define ALU_ADD  4'b0000
`define ALU_SUB  4'b0001
`define ALU_OR   4'b0010
`define ALU_LUI  4'b0011
`define ALU_SLL  4'b0100
`define ALU_SIGNCOM 4'b0101
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:09:06 12/07/2017 
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
	 input [31:0] Instr,
	 output RegWrite,
	 output [1:0] RFAsel,
	 output [1:0] RFWDsel,
	 output MemWrite,
	 output Branch,
	 output NPCsel,
	 output Branchsel,
	 output EXTOp,
	 output ALUbsel,
	 output reg [3:0] ALUOp,
	 output [1:0] LDsel,
	 output [1:0] SDsel
    );
	 
	 wire [5:0]Op;
	 wire [5:0]Func;
	 wire Addu,Subu,Ori,Lw,Sw,Beq,Lui,Nop,J,Jal,Jr,Sll,Jalr,Lb,Sb,Bgezal,Movz,Slt,Bltz;
	 
	 assign Op=Instr[31:26];
	 assign Func=Instr[5:0];
	 
	 assign Addu= Op==`special && Func==`addu;
	 assign Subu= Op==`special && Func==`subu;
	 assign Ori= Op==`ori;
	 assign Slt= Op==`special && Func==`slt;

	 assign Lui= Op==`lui;
	 assign Nop= Op==`special && Op==`nop;
	 
	 assign Beq= Op==`beq;
	 assign Bgezal= Op==`regimm && Instr[20:16]==`bgezal;
	 assign Bltz= Op==`regimm && Instr[20:16]==`bltz;
	 
	 assign J= Op==`j;
	 assign Jal= Op==`jal;
	 assign Jr= Op==`special && Func==`jr;
	 assign Jalr= Op==`special && Func==`jalr;
	 
	 assign Sll= Op==`special && Func==`sll;
	 
	 assign Lw= Op==`lw;
	 assign Sw= Op==`sw;
	 assign Lb= Op==`lb;
	 assign Sb= Op==`sb;
	 
	 assign Movz= Op==`special && Func==`movz;
	 
	 assign RegWrite= Addu || Subu || Ori || Lw || Lui || Jal || Sll || Jalr || Bgezal || Movz || Slt || Lb;
	 
	 assign RFAsel= (Jal | Bgezal) ? 2'b10 ://ra
						 (Addu | Subu | Sll | Jalr | Movz | Slt) ? 2'b01 ://rd
						 2'b00;//rt
						 
	 assign RFWDsel= (Jal | Jalr | Bgezal) ? 2'b10 ://PC8
						  (Lw | Lb) ? 2'b01://Dm
						  2'b00;//AO
						  
	 assign MemWrite= Sw || Sb;
	 assign Branch= Beq || J || Jal || Jr || Jalr || Bgezal || Bltz;
	 
	 //0为B类,1为J类
	 assign NPCsel= J || Jal || Jr || Jalr;
	 
	 //0为跳转到立即数
	 assign Branchsel= Jr || Jalr;
						
	 assign EXTOp= Lw || Sw || Beq || Bgezal || Lb || Sb || Bltz;
	 assign ALUbsel= Ori || Lw || Sw || Lui || Lb || Sb;
	 
	 assign LDsel= Lb ? 2'b01 ://lb
						2'b00;//lw
	 assign SDsel= Sb ? 2'b01 ://sb
						2'b00;//sw
						
	 always @(*) begin
		 case(Op)
			`special: begin
				case(Func)
					`addu: ALUOp <=`ALU_ADD;
					`subu: ALUOp <=`ALU_SUB;
					`jr: ALUOp <=`ALU_ADD;
					`sll: ALUOp <= `ALU_SLL;
					`slt: ALUOp <= `ALU_SIGNCOM;
					default: ALUOp <=`ALU_ADD;
				endcase
			end
			`ori: ALUOp <=`ALU_OR;
			`lui: ALUOp <=`ALU_LUI;
			default: ALUOp <=`ALU_ADD;
		 endcase
	 end
endmodule
