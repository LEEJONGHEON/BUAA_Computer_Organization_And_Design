`timescale 1ns / 1ps
`define ALU_ADDU 4'b0000
`define ALU_SUBU 4'b0001
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
`define ALU_ADD  4'b1100
`define ALU_SUB  4'b1101

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:18:07 12/07/2017 
// Design Name: 
// Module Name:    alu 
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
module alu(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUOp,
    output reg [31:0] C,
	 output Overflow
    );
	 
	 reg flag;
	 
	 assign Overflow= flag!=C[31] && (ALUOp==`ALU_ADD || ALUOp==`ALU_SUB);
	 
	 always @(*) begin
		 case(ALUOp)
			`ALU_ADDU: C = A + B;
			`ALU_SUBU: C = A - B;
			`ALU_AND: C = A & B;
			`ALU_OR: C = A | B;
			`ALU_XOR: C = A ^ B;
			`ALU_NOR: C = ~(A | B);
			`ALU_LUI: C = B << 32'd16;
			`ALU_SLL: C = B << A[4:0];
			`ALU_SRL: C = B >> A[4:0];
			`ALU_SRA: C = $signed(B) >>> A[4:0];
			`ALU_SLT: C = $signed(A)<$signed(B) ? 32'b1 : 32'b0;
			`ALU_SLTU: C = A < B ? 32'b1 : 32'b0;
			`ALU_ADD: {flag,C} = {A[31],A} + {B[31],B};
			`ALU_SUB: {flag,C} = {A[31],A} - {B[31],B};
			default: C = 32'b0;
		 endcase
	 end
	 
endmodule