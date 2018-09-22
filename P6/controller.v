`timescale 1ns / 1ps
//R型
`define special 6'b000000
`define add 	 6'b100000
`define addu 	 6'b100001
`define sub		 6'b100010
`define subu    6'b100011
`define andr    6'b100100 //注意此处与预定义的冲突
`define orr		 6'b100101 //
`define xorr	 6'b100110 //
`define norr    6'b100111 //

`define mult    6'b011000
`define multu 	 6'b011001
`define div		 6'b011010
`define divu 	 6'b011011
`define mfhi    6'b010000
`define mflo    6'b010010
`define mthi    6'b010001
`define mtlo    6'b010011

`define special2 6'b011100
`define madd	 6'b000000

`define sll     6'b000000
`define srl   	 6'b000010
`define sra     6'b000011
`define sllv    6'b000100
`define srlv	 6'b000110
`define srav    6'b000111

`define slt     6'b101010
`define sltu    6'b101011

`define jr      6'b001000
`define jalr    6'b001001

`define movz    6'b001010
//I型
`define addi    6'b001000
`define addiu   6'b001001
`define andi    6'b001100
`define ori     6'b001101
`define xori    6'b001110
`define lui     6'b001111

`define slti	 6'b001010
`define sltiu   6'b001011

`define lw      6'b100011
`define lb      6'b100000
`define lbu     6'b100100
`define lh      6'b100001
`define lhu 	 6'b100101
`define sw      6'b101011
`define sb      6'b101000
`define sh 		 6'b101001

`define beq     6'b000100
`define bne     6'b000101
`define blez    6'b000110
`define bgtz    6'b000111

`define regimm  6'b000001
`define bgezal  5'b10001 //没有加功能
`define bltz    5'b00000
`define bgez	 5'b00001

//J型
`define j       6'b000010
`define jal     6'b000011

`define ALU_ADD  4'b0000
`define ALU_SUB  4'b0001
`define ALU_AND  4'b0010
`define ALU_OR   4'b0011
`define ALU_XOR  4'b0100
`define ALU_NOR  4'b0101
`define ALU_LUI  4'b0110
`define ALU_SLL  4'b0111
`define ALU_SRL  4'b1000
`define ALU_SRA  4'b1001
`define ALU_SLT  4'b1010
`define ALU_SLTU 4'b1011
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
	 output ALUasel,
	 output ALUbsel,
	 output reg [3:0] ALUOp,
	 output [2:0] LDsel,
	 output [1:0] SDsel,
	 output Start,
	 output [2:0] MDOp
    );
	 
	 wire [5:0]Op;
	 wire [5:0]Func;
	
	 wire Add,Addu,Sub,Subu,And,Or,Xor,Nor;
	 wire Mult,Multu,Div,Divu,Mfhi,Mflo,Mthi,Mtlo,Madd;
	 wire Sll,Srl,Sra,Sllv,Srlv,Srav;
	 wire Slt,Sltu;
	 wire Jr,Jalr;
	 wire Movz;
	 wire Addi,Addiu,Andi,Ori,Xori,Lui;
	 wire Slti,Sltiu;
	 wire Lw,Lb,Lbu,Lh,Lhu,Sw,Sb,Sh;
	 wire Beq,Bne,Blez,Bgtz;
	 wire Bgezal,Bltz,Bgez;
	 wire J,Jal;
	 
	 assign Op=Instr[31:26];
	 assign Func=Instr[5:0];
	 
	 assign Add= Op==`special && Func==`add;
	 assign Addu= Op==`special && Func==`addu;
	 assign Sub= Op==`special && Func==`sub;
	 assign Subu= Op==`special && Func==`subu;
	 assign And= Op==`special && Func==`andr;
	 assign Or= Op==`special && Func==`orr;
	 assign Xor= Op==`special && Func==`xorr;
	 assign Nor= Op==`special && Func==`norr;
	 
	 assign Mult= Op==`special && Func==`mult;
	 assign Multu= Op==`special && Func==`multu;
	 assign Div= Op==`special && Func==`div;
	 assign Divu= Op==`special && Func==`divu;
	 assign Mfhi= Op==`special && Func==`mfhi;
	 assign Mflo= Op==`special && Func==`mflo;
	 assign Mthi= Op==`special && Func==`mthi;
	 assign Mtlo= Op==`special && Func==`mtlo;
	 assign Madd= Op==`special2 && Func==`madd;

	 assign Sll= Op==`special && Func==`sll;
	 assign Srl= Op==`special && Func==`srl;
	 assign Sra= Op==`special && Func==`sra;
	 assign Sllv= Op==`special && Func==`sllv;
	 assign Srlv= Op==`special && Func==`srlv;
	 assign Srav= Op==`special && Func==`srav;
	 
	 assign Slt= Op==`special && Func==`slt;
	 assign Sltu= Op==`special && Func==`sltu;

	 assign Addi= Op==`addi;
	 assign Addiu= Op==`addiu;
	 assign Andi= Op==`andi;
	 assign Ori= Op==`ori;
	 assign Xori= Op==`xori;
	 assign Lui= Op==`lui;
	 
	 assign Slti= Op==`slti;
	 assign Sltiu= Op==`sltiu; 

	 assign Beq= Op==`beq;
	 assign Bne= Op==`bne;
	 assign Blez= Op==`blez;
	 assign Bgtz= Op==`bgtz;
	 assign Bgezal= Op==`regimm && Instr[20:16]==`bgezal;
	 assign Bgez= Op==`regimm && Instr[20:16]==`bgez;
	 assign Bltz= Op==`regimm && Instr[20:16]==`bltz;
	 
	 assign J= Op==`j;
	 assign Jal= Op==`jal;
	 assign Jr= Op==`special && Func==`jr;
	 assign Jalr= Op==`special && Func==`jalr;
	 
	 assign Lw= Op==`lw;
	 assign Lb= Op==`lb;
	 assign Lbu= Op==`lbu;
	 assign Lh= Op==`lh;
	 assign Lhu= Op==`lhu;
	 assign Sw= Op==`sw;
	 assign Sb= Op==`sb;
	 assign Sh= Op==`sh;
	 
	 assign Movz= Op==`special && Func==`movz;
	 
	 assign RegWrite= Addu || Subu || Ori || Lw || Lui || Jal || Jalr || Bgezal || Movz || Mfhi || Mflo || 
							Sll || Srl || Sra || Sllv || Srlv || Srav || Add || Sub || And  || Or || Xor || Nor || Addi ||
							Addiu || Andi || Xori || Slt || Sltu || Slti || Sltiu || Lb || Lbu || Lh || Lhu;
	 
	 assign RFAsel= (Jal | Bgezal) ? 2'b10 ://ra
						 (Addu | Subu | Jalr | Movz | Mfhi | Mflo | Sll | Srl | Sra | Sllv | Srlv | Srav |
						  Add | Sub | And | Or | Xor | Nor | Slt | Sltu) ? 2'b01 ://rd
						 2'b00;//rt
						 
	 assign RFWDsel= (Jal | Jalr | Bgezal) ? 2'b10 ://PC8
						  (Lw | Lb | Lbu | Lh | Lhu) ? 2'b01://Dm
						  2'b00;//AO
						  
	 assign MemWrite= Sw || Sb || Sh;
	 assign Branch= Beq || J || Jal || Jr || Jalr || Bgezal || Bne || Blez || Bgtz || Bgez || Bltz;
	 
	 //0为B类,1为J类
	 assign NPCsel= J || Jal || Jr || Jalr;
	 
	 //0为跳转到立即数
	 assign Branchsel= Jr || Jalr;
						
	 assign EXTOp= Lw || Sw || Beq || Bgezal || Lb || Lbu || Lh || Lhu || Sb || Sh || Addi || Addiu || Slti || Sltiu ||
						Bne || Blez || Bgtz || Bgez || Bltz;
	 
	 assign ALUasel= Sll || Srl || Sra;
	 
	 assign ALUbsel= Ori || Lw || Sw || Lui || Lb || Lbu || Lh || Lhu || Sb || Sh || Addi || Addiu || Andi || Xori || Slti || Sltiu;
	 
	 assign LDsel= Lh ? 3'b100 :
						Lhu? 3'b011 :
						Lb ? 3'b010 :
						Lbu? 3'b001 :
						3'b000;//lw
						
	 assign SDsel= Sh ? 2'b10 :
						Sb ? 2'b01 ://sb
						2'b00;//sw
						
    assign Start= Mult || Multu || Div || Divu || Madd;
	 
	 assign MDOp= Madd ? 3'b110 :
					  Mtlo ? 3'b101 :
					  Mthi ? 3'b100 :
					  Div  ? 3'b011 :
					  Divu ? 3'b010 :
					  Mult ? 3'b001 : 
					  3'b000;//multu
						
	 always @(*) begin
		 case(Op)
			`special: begin
				case(Func)
					`add: ALUOp <= `ALU_ADD;
					`addu: ALUOp <= `ALU_ADD;
					`sub: ALUOp <= `ALU_SUB;
					`subu: ALUOp <= `ALU_SUB;
					`andr: ALUOp <= `ALU_AND;
					`orr: ALUOp <= `ALU_OR;
					`xorr: ALUOp <= `ALU_XOR;
					`norr: ALUOp <= `ALU_NOR;
					`jr: ALUOp <=`ALU_ADD;
					`sll: ALUOp <= `ALU_SLL;
					`srl: ALUOp <= `ALU_SRL;
					`sra: ALUOp <= `ALU_SRA;
					`sllv: ALUOp <= `ALU_SLL;
					`srlv: ALUOp <= `ALU_SRL;
					`srav: ALUOp <= `ALU_SRA;
					`slt: ALUOp <= `ALU_SLT;
					`sltu: ALUOp <= `ALU_SLTU;
					default: ALUOp <=`ALU_ADD;
				endcase
			end
			`addi: ALUOp <= `ALU_ADD;
			`addiu: ALUOp <= `ALU_ADD;
			`andi: ALUOp <= `ALU_AND;
			`xori: ALUOp <= `ALU_XOR;
			`ori: ALUOp <= `ALU_OR;
			`lui: ALUOp <= `ALU_LUI;
			`slti: ALUOp <= `ALU_SLT;
			`sltiu: ALUOp <= `ALU_SLTU;
			default: ALUOp <=`ALU_ADD;
		 endcase
	 end
endmodule
