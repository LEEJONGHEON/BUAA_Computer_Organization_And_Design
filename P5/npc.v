`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:22:13 12/07/2017 
// Design Name: 
// Module Name:    npc 
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
module npc(
    input [31:0] Instr,
    input [31:0] PC4,
    input NPCsel,
	 input cmpout,
    output [31:0] npcout
    );
	 
	 assign npcout = (NPCsel==1)? {{PC4[31:28]},Instr[25:0],2'b00}:
						  (cmpout==1)?	(PC4 + {{14{Instr[15]}},Instr[15:0],2'b00}):
											(PC4+4);//beq比较失败，不进行跳转


endmodule
