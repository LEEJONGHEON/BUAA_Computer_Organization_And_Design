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
	 input EXLClr,
	 input [31:0] EPC,
	 input IntReq,
	 output PCExc,
    output [31:0] Instr,
    output [31:0] ADD4
    );
	 
	 integer i;
	 reg [31:0] PC;
	 wire [31:0] PC_now;
	 reg [31:0] im[4095:0];
	 
	 initial begin
		PC = 32'h00003000;
		for(i=0;i<=4095;i=i+1) begin
			im[i]=32'b0;	
		end
		$readmemh("code.txt",im);
		$readmemh("code_handler.txt",im,1120,2047);//???1120
	 end
	 
	 assign PC_now=PC-32'h3000;
	 assign Instr = im[PC_now[13:2]];
	 assign ADD4 = PC+4;
	 assign PCExc = !(PC>=32'h3000 && PC < 32'h4fff && PC[0]==1'b0 && PC[1]==1'b0);	 
	 
	 always @(posedge clk) begin
		if(reset) begin
			PC <= 32'h00003000;
		end
		else if(IntReq) PC <= 32'h4180;
		else if(EXLClr) PC <= EPC;
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