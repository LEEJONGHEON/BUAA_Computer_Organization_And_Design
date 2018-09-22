`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:48:38 11/26/2017 
// Design Name: 
// Module Name:    mux 
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
module mux2_5(
	 input [4:0] A,
	 input [4:0] B,
	 input Op,
	 output [4:0] C
    );
	 
	 assign C=(Op==0)? A :B;
	 
endmodule

module mux2_32(
	 input [31:0] A,
	 input [31:0] B,
	 input Op,
	 output [31:0] C
	 );
	 
	 assign C=(Op==0)? A :B;
	 
endmodule
