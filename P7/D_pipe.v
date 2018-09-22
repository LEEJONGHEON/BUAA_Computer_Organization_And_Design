`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:25:16 12/07/2017 
// Design Name: 
// Module Name:    D_pipe 
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
module D_pipe(
    input clk,
	 input reset,
    input [31:0] Instr,
    input [31:0] ADD4,
	 input Stall,
	 input EXLClrD,
    output reg [31:0] IR_D,
    output reg [31:0] PC4_D,
    output reg [31:0] PC8_D
    );
	 
	 initial begin
		IR_D <= 32'b0;
		PC4_D <= 32'b0;
		PC8_D <= 32'b0;
	 end
	 
	 always @(posedge clk) begin
		if(reset) begin
			IR_D <= 32'b0;
			PC4_D <= 32'b0;
			PC8_D <= 32'b0;
		 end
		else if(Stall) begin
			IR_D <= IR_D;
			PC4_D <= PC4_D;
			PC8_D <= PC8_D;
		end
		else if(EXLClrD) begin
			IR_D <= 32'b0;
			PC4_D <= 32'b0;
			PC8_D <= 32'b0;
		end
		else begin 
			IR_D <= Instr;
			PC4_D <= ADD4;
			PC8_D <= ADD4+4;
		end
	 end

endmodule
