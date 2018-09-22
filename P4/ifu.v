`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:11:41 11/25/2017 
// Design Name: 
// Module Name:    IFU 
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
module ifu(
    input clk,
    input reset,
    input [31:0] Sign_ext,
    input IfBeq,
    input ComResult,
    input [25:0] Address,
    input Jump,
    input [31:0] RegData,
    input JReg,
    output [31:0] Instr,
    output [31:0] PrePC
    );
	 
	 integer i;
	 reg [31:0] im[1023:0];
	 reg [31:0] PC;
	 
	 initial begin
		PC = 32'h00003000;
		for(i=0;i<=1023;i=i+1) begin
			im[i]=32'b0;
		end
		$readmemh("code.txt",im);
	 end
	 
	 assign Instr = im[PC[11:2]];
	 assign PrePC = PC;
	 
	 always @(posedge clk) begin
		if(reset) begin
			PC <= 32'h00003000;
		end
		else if(IfBeq) begin
			if(ComResult) begin
				PC <= PC+4+(Sign_ext << 2);
			end
			else PC <= PC+4;
		end
		else if(Jump)
			PC <= {{PC[31:28]},Address,{2'b00}};//ÓÐÎÊÌâ
		else if(JReg)
			PC <= RegData;
		else PC <= PC+4;
	 end
endmodule
