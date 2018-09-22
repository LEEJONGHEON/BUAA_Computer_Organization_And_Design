`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:41:02 12/10/2017 
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
	 input [4:0] In1,
	 input [4:0] In2,
	 input Op,
	 output [4:0] Out
    );
	 
	 assign Out=(Op==0)? In1 :In2;
	 
endmodule


module mux2_32(
	 input [31:0] In1,
	 input [31:0] In2,
	 input Op,
	 output [31:0] Out
	 );
	 
	 assign Out=(Op==0)? In1 :In2;
	 
endmodule


module mux3_5(
	 input [4:0] In1,
	 input [4:0] In2,
	 input [4:0] In3,
	 input [1:0] Op,
	 output [4:0] Out
	 );
	 
	 assign Out=(Op==0)? In1 :
					(Op==1)? In2 : In3;
	 
endmodule


module mux3_32(
	 input [31:0] In1,
	 input [31:0] In2,
	 input [31:0] In3,
	 input [1:0] Op,
	 output [31:0] Out
	 );
	 
	 assign Out=(Op==0)? In1 :
					(Op==1)? In2 : In3;

endmodule

module mux4_32(
	 input [31:0] In1,
	 input [31:0] In2,
	 input [31:0] In3,
	 input [31:0] In4,
	 input [1:0] Op,
	 output [31:0] Out
	 );
	 
	 assign Out=(Op==0)? In1 :
					(Op==1)? In2 :
					(Op==2)? In3 : In4;

endmodule

/*
module mux4_5(
	 input [4:0] In1,
	 input [4:0] In2,
	 input [4:0] In3,
	 input [4:0] In4,
	 input [1:0] Op,
	 output [4:0] Out
	 );
	 
	 assign Out=(Op==0)? In1 :
					(Op==1)? In2 :
					(Op==2)? In3 : In4;

endmodule
*/
module mux5_32(
	 input [31:0] In1,
	 input [31:0] In2,
	 input [31:0] In3,
	 input [31:0] In4,
	 input [31:0] In5,
	 input [2:0] Op,
	 output [31:0] Out
	 );
	 
	 assign Out=(Op==0)? In1 :
					(Op==1)? In2 :
					(Op==2)? In3 :
					(Op==3)? In4 : In5;

endmodule
