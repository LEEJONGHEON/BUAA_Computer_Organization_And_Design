`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:41:50 12/07/2017 
// Design Name: 
// Module Name:    ifu 
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
	 input Branch,
    input [31:0] nextPC,
	 input Stall,
	 input NPCsel,
	 input CMPout,
    output [31:0] Instr,
    output [31:0] ADD4
    );
	 
	 integer i;
	 reg [31:0] PC;
	 reg [31:0] im[1023:0];
	 
	 initial begin
		PC = 32'h00003000;
		for(i=0;i<=1023;i=i+1) begin
			im[i]=32'b0;	
		end
		$readmemh("code.txt",im);
	 end
	 
	 assign Instr = im[PC[11:2]];
	 assign ADD4 = PC+4;
	 
	 always @(posedge clk) begin
		if(reset) begin
			PC <= 32'h00003000;
		end
		else if(Stall) PC <= PC;
		else if(Branch) begin
			if(NPCsel==1'b0 && CMPout==1'b0) begin
				PC <= PC+4;
			end
			else begin 
				PC <= nextPC;
			end
		end
		else PC <= PC+4;
	 end

endmodule