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
`define bgezal  5'b10001
`define bltz    5'b00000
`define bgez	 5'b00001

//J型
`define j       6'b000010
`define jal     6'b000011

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
	 output [4:0]A2,
	 output mdFlag//新添加,还未添加功能
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
	 
	 assign Tuse_rs0= Beq || Jr || Jalr || Bgezal || Movz || Bltz || Bne || Blez || Bgtz || Bgez || Bltz;
	 assign Tuse_rs1= Addu || Subu || Ori || Lw || Sw || Slt || Sltu || Sb || Sh || Mult || Multu || Div || Divu || Mthi || Mtlo ||
							Sllv || Srlv || Srav || Add || Sub || And || Or || Xor || Nor || Addi || Addiu || Andi || Xori || Slti || Sltiu||
							Lb || Lbu || Lh || Lhu || Madd;
	 
	 assign Tuse_rt0= Beq || Movz || Bne;
	 assign Tuse_rt1= Addu || Subu || Slt || Sltu || Mult || Multu || Div || Divu || Sll || Srl || Sra || Sllv || Srlv || Srav ||
							Add || Sub || And || Or || Xor || Nor || Madd;
	 assign Tuse_rt2= Sw || Sb || Sh;
	 
	 assign mdFlag= Mult || Multu || Div || Divu || Mthi || Mtlo || Mfhi || Mflo || Madd;
	 
	 assign A1=Instr[`rs];
	 assign A2=Instr[`rt];
	
	 always @(*) begin
		 case(Op)
			`special: begin
				case(Func)
					`add: res <= `ALU;
					`addu: res <= `ALU;
					`sub: res <= `ALU;
					`subu: res <= `ALU;
					`andr: res <= `ALU;
					`orr: res <= `ALU;
					`xorr: res <= `ALU;
					`norr: res <= `ALU;
					`sll: res <= `ALU;
					`srl: res <= `ALU;
					`sra: res <= `ALU;
					`sllv: res <= `ALU;
					`srlv: res <= `ALU;
					`srav: res <= `ALU;
					`jalr: res <= `PC;
					`movz: res <= `PC;
					`slt: res <= `ALU;
					`sltu: res <= `ALU;
					`mfhi: res <= `ALU;
					`mflo: res <= `ALU;
					default: res <= `NW;
				endcase
			end
			`regimm: begin
				case(Instr[`rt])
					`bgezal: res <= `PC;
					default: res <= `NW;
				endcase
			end
			`addi: res <= `ALU;
			`addiu: res <= `ALU;
			`andi: res <= `ALU;
			`xori: res <= `ALU;
			`ori: res <= `ALU;
			`lw: res <= `DM;
			`jal: res <= `PC;
			`lui: res <= `ALU;
			`lb: res <= `DM;
			`lbu: res <= `DM;
			`lh: res <= `DM;
			`lhu: res <= `DM;
			`slti: res <= `ALU;
			`sltiu: res <= `ALU;
			default: res <= `NW;
		 endcase
	 end

endmodule
