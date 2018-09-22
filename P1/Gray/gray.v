`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:12:19 11/04/2017 
// Design Name: 
// Module Name:    gray 
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
module gray(
    input Clk,
    input Reset,
    input En,
    output [2:0] Output,
    output reg Overflow
    );
	 
	 reg [2:0] counter;
	 
	 
	 initial begin
		counter = 0;
		Overflow = 0;
	 end
	 
	 assign Output[2:0]={counter[2],counter[2]^counter[1],counter[1]^counter[0]};
	 
	 always @(posedge Clk) begin
		if(Reset) begin
			counter = 0;
			Overflow <= 0;
		end
		else if(En) begin
			if(counter==7) begin
				Overflow <= 1;
			end
			counter <= counter + 1;
		end 
	 end
	 
endmodule
