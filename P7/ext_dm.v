`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:03:44 12/18/2017 
// Design Name: 
// Module Name:    ext_dm 
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
module ext_dm(
    input [1:0] Addrlow,
    input [31:0] Din,
    input [2:0] LDsel,
    output [31:0] Dout
    );
	 
	 wire [7:0] Byte;
	 wire [15:0] Half;
	 
	 assign Byte= (Addrlow==2'b11) ? Din[31:24] :
					  (Addrlow==2'b10) ? Din[23:16] :
					  (Addrlow==2'b01) ? Din[15:8]  :
					  Din[7:0];
	 
	 assign Half= (Addrlow==2'b10) ? Din[31:16] : Din[15:0];
	 
	 assign Dout= (LDsel==3'b100) ? {{16{Half[15]}},Half} :
					  (LDsel==3'b011) ? {16'b0,Half} :
					  (LDsel==3'b010) ? {{24{Byte[7]}},Byte} :
					  (LDsel==3'b001) ? {24'b0,Byte} :
					  Din;


endmodule
