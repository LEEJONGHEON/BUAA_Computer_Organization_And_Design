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

`define NW  2'b00
`define ALU 2'b01
`define DM  2'b10
`define PC  2'b11
`define rs  25:21
`define rd	15:11
`define rt	20:16

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:17:46 12/07/2017 
// Design Name: 
// Module Name:    decoder 
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
module decoder(
	 input [31:0]Instr,
	 output Tuse_rs0,
	 output Tuse_rs1,
	 output Tuse_rt0,
	 output Tuse_rt1,
	 output Tuse_rt2,
	 output reg [1:0]res,
	 output [4:0]A1,
	 output [4:0]A2
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
	 
	 assign Tuse_rs0= Beq || Jr || Jalr || Bgezal || Movz || Bltz;
	 assign Tuse_rs1= Addu || Subu || Ori || Lw || Sw || Slt || Lb || Sb;
	 
	 assign Tuse_rt0= Beq || Movz || Bltz;
	 assign Tuse_rt1= Addu || Subu || Sll || Slt;
	 assign Tuse_rt2= Sw || Sb;
	 
	 assign A1=Instr[`rs];
	 assign A2=Instr[`rt];
	
	 always @(*) begin
		 case(Op)
			`special: begin
				case(Func)
					`addu: res <= `ALU;
					`subu: res <= `ALU;
					`sll: res <= `ALU;
					`jalr: res <= `PC;
					`movz: res <= `PC;
					`slt: res <= `ALU;
					default: res <= `NW;
				endcase
			end
			`regimm: begin
				case(Instr[`rt])
					`bgezal: res <= `PC;
					default: res <= `NW;
				endcase
			end
			`ori: res <= `ALU;
			`lw: res <= `DM;
			`jal: res <= `PC;
			`lui: res <= `ALU;
			`lb: res <= `DM;
			default: res <= `NW;
		 endcase
	 end

endmodule
