`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:58:49 12/07/2017 
// Design Name: 
// Module Name:    M_pipe 
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
module M_pipe(
    input clk,
	 input reset,
    input [31:0] IR_E,
    input [31:0] PC4_E,
    input [31:0] PC8_E,
	 input [4:0] A3_E,
    input [31:0] AO,
    input [31:0] RT_E,
	 input RegWrite_E,
	 input MemWrite_E,
    output reg [31:0] IR_M,
    output reg [31:0] PC4_M,
    output reg [31:0] PC8_M,
	 output reg [4:0] A3_M,
    output reg [31:0] AO_M,
    output reg [31:0] RT_M,
	 output reg RegWrite_M,
	 output reg MemWrite_M	 
    );
	 
	 initial begin
		IR_M <= 32'b0;
		PC4_M <= 32'b0;
		PC8_M <= 32'b0;
		A3_M <= 5'b0;
		AO_M <= 32'b0;
		RT_M <= 32'b0;
		RegWrite_M <= 1'b0;
		MemWrite_M <= 1'b0;
	 end
	 
	 always @(posedge clk) begin
		 if(reset) begin
			IR_M <= 32'b0;
			PC4_M <= 32'b0;
			PC8_M <= 32'b0;
			A3_M <= 5'b0;
			AO_M <= 32'b0;
			RT_M <= 32'b0;
			RegWrite_M <= 1'b0;
			MemWrite_M <= 1'b0;
		 end
		 else begin
			IR_M <= IR_E;
			PC4_M <= PC4_E;
			PC8_M <= PC8_E;
			A3_M <= A3_E;
			AO_M <= AO;
			RT_M <= RT_E;
			RegWrite_M <= RegWrite_E;
			MemWrite_M <= MemWrite_E;
		 end
	 end
	 
endmodule
