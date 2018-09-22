`timescale 1ns / 1ps
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
	 input [4:0] Shamt,
    output reg [31:0] C
    );
	 
	 always @(*) begin
		 case(ALUOp)
			`ALU_ADD: C = A + B;
			`ALU_SUB: C = A - B;
			`ALU_OR: C = A | B;
			`ALU_LUI: C = B << 32'd16;
			`ALU_SLL: C = B << Shamt;
			`ALU_SIGNCOM: C = $signed(A)<$signed(B) ? 32'b1 : 32'b0;
			default: C = 32'b0;
		 endcase
	 end

endmodule