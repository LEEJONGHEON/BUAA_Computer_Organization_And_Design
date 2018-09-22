`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:48:48 11/06/2017
// Design Name:   string
// Module Name:   E:/Program/ISE/P1/String/string_tb.v
// Project Name:  String
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: string
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module string_tb;

	// Inputs
	reg clk;
	reg clr;
	reg [7:0] in;

	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	string uut (
		.clk(clk), 
		.clr(clr), 
		.in(in), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		clr = 0;
		in = "1";

		#10
		in = "+";
		#10
		in = "2";
		#10
		in = "*";
		#10
		in = "3";
		#30
		clr = 1;
		
		#10
		clr =0;
		in = "1";
		#10
		in = "+";
		#10
		in = "2";
		

	end
	
	always #5 clk=~clk;
      
endmodule

