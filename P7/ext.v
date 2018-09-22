`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:55:15 12/07/2017 
// Design Name: 
// Module Name:    ext 
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
module ext(
	 input [15:0] In,
    input SignOp,
    output [31:0] Out
    );
	 
	 assign Out = (SignOp==1'b0) ? {{16{1'b0}},In}:{{16{In[15]}},In};
	 

endmodule
