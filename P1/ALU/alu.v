`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:16:57 11/03/2017 
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
    output [31:0] C
    );
	 
	 reg [31:0]c;
	 
	 assign C=c;
	
	 always @* begin
		case(ALUOp)
		0:
			c <= A+B;
		1:
			c <= A-B;
		2:
			c <= A&B;
		3:
			c <= A|B;
		4:
			c <= A>>B;
		5:
			c <= $signed(A)>>>B;
		endcase
	 end

endmodule
