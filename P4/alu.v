`timescale 1ns / 1ps
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
// Create Date:    22:16:45 11/25/2017 
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
    input [2:0] ALUOp,
	 input [4:0] Shamt,
    output reg [31:0] C,
    output reg ComResult
    );
	 
	 always @(*) begin
		 case(ALUOp)
			`ALU_ADD: C = A + B;
			`ALU_SUB: C = A - B;
			`ALU_OR: C = A | B;
			`ALU_LUI: C = B << 32'd16;
			`ALU_SLL: C = B << Shamt;
			default: C = 32'b0;
		 endcase
		 
		 case(ALUOp)
			`ALU_BEQ: ComResult = (A==B);
			default: ComResult = 1'b0;
		 endcase
	 end

endmodule
