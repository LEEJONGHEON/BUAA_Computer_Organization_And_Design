`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:11:14 11/06/2017 
// Design Name: 
// Module Name:    string 
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
module string(
    input clk,
    input clr,
    input [7:0] in,
    output reg out
    );
	 
	 integer state;
	 
	 initial begin 
		out = 0;
		state = 0;
	 end
	 
	 always @(posedge clk or posedge clr) begin
		if (clr) begin
			state <= 0;
			out <= 0;
		end
		else begin
			case (state)
			0:
				begin
					if(in>="0" && in<="9") begin 
						out <= 1;
						state <= 1;
					end
					else begin
						out <=0;
						state <= 4;
					end
				end
			1:
				begin
					if(in=="+" || in=="*") begin
						out <= 0;
						state <= 2;
					end
					else begin
						state <= 4;
						out <= 0;
					end
				end
			2:
				begin
					if(in>="0" && in<="9") begin 
						out <= 1;
						state <= 3;
					end
					else begin
						state <= 4;
						out <= 0;
					end
				end
			3:
				begin
					if(in=="+" || in=="*") begin 
						state <= 2;
						out <= 0;
					end
					else begin 
						state <= 4;
						out <= 0;
					end
				end
			default: 
				begin
					state <= 4;
					out <=0;
				end
			endcase
		end
	 
	 end
	 
endmodule
