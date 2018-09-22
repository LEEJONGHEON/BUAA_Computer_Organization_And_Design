`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:17:36 11/25/2017 
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
    output reg [31:0] Out
    );
	 always @(*)begin
		 case(SignOp)
			0: Out <= {{16{1'b0}},In};
			1: Out <= {{16{In[15]}},In};
			default: Out <= 32'b0;
		 endcase
	 end
endmodule
