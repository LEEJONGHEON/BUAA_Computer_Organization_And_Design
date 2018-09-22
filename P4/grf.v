`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:14:12 11/25/2017 
// Design Name: 
// Module Name:    grf 
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
module grf(
    input clk,
	 input reset,
	 input [31:0] PrePC,
    input [31:0] busW,
    input WE,
    input [4:0] RA,
    input [4:0] RB,
    input [4:0] RW,
    output [31:0] busA,
    output [31:0] busB
    );
	 
	 reg [31:0] rf[31:0];
	 integer i;
	 
	 initial begin
		for(i=0;i<=31;i=i+1) begin
			rf[i]=0;
		end
	 end
	 
	 assign busA = rf[RA];
	 assign busB = rf[RB];
	 
	 always @(posedge clk) begin
		if (reset) begin
			for(i=0;i<=31;i=i+1) begin
				rf[i]<=0;
			end
		end
		else if (WE && RW!=5'b0) begin
			rf[RW] <= busW;
			$display("@%h: $%d <= %h",PrePC, RW, busW);
		end
	 end

endmodule
