`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:26:21 12/07/2017 
// Design Name: 
// Module Name:    W_pipe 
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
module W_pipe(
    input clk,
	 input reset,
    input [31:0] IR_M,
    input [31:0] PC4_M,
    input [31:0] PC8_M,
	 input [4:0] A3_M,
    input [31:0] AO_M,
    input [31:0] DM,
	 input RegWrite_M,
    output reg [31:0] IR_W,
    output reg [31:0] PC4_W,
    output reg [31:0] PC8_W,
	 output reg [4:0] A3_W,
    output reg [31:0] AO_W,
    output reg [31:0] DM_W,
	 output reg RegWrite_W
    );
	 
	 initial begin
		IR_W <= 32'b0;
		PC4_W <= 32'b0;
		PC8_W <= 32'b0;
		A3_W <= 5'b0;
		AO_W <= 32'b0;
		DM_W <= 32'b0;
		RegWrite_W <= 1'b0;
	 end

	 always @(posedge clk) begin
		if (reset) begin
			IR_W <= 32'b0;
			PC4_W <= 32'b0;
			PC8_W <= 32'b0;
			A3_W <= 5'b0;
			AO_W <= 32'b0;
			DM_W <= 32'b0;
			RegWrite_W <= 1'b0;
		end
		else begin 
			IR_W <= IR_M;
			PC4_W <= PC4_M;
			PC8_W <= PC8_M;
			A3_W <= A3_M;
			AO_W <= AO_M;
			DM_W <= DM;
			RegWrite_W <= RegWrite_M;
		end
	 end

endmodule
