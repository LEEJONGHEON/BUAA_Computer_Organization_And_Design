`timescale 1ns / 1ps
`define special 6'b000000
`define regimm  6'b000001
`define bgezal  5'b10001
`define movz    6'b001010


//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:12:20 12/07/2017 
// Design Name: 
// Module Name:    E_pipe 
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
module E_pipe(
    input clk,
	 input reset,
    input [31:0] IR_D,
    input [31:0] PC4_D,
    input [31:0] PC8_D,
	 input [4:0] A3_D,
    input [31:0] RF_RD1,
    input [31:0] RF_RD2,
    input [31:0] EXT,
	 input RegWrite_D,
	 input MemWrite_D,
	 input cmpout,
	 input Stall,
    output reg [31:0] IR_E,
    output reg [31:0] PC4_E,
    output reg [31:0] PC8_E,
	 output reg [4:0] A3_E,
    output reg [31:0] RS_E,
    output reg [31:0] RT_E,
    output reg [31:0] EXT_E,
	 output reg RegWrite_E,
	 output reg MemWrite_E	 
    );
	 
	 initial begin
		IR_E <= 32'b0;
		PC4_E <= 32'b0;
		PC8_E <= 32'b0;
		A3_E <= 5'b0;
		RS_E <= 32'b0;
		RT_E <= 32'b0;
		EXT_E <= 32'b0;
		RegWrite_E <= 1'b0;
		MemWrite_E <= 1'b0;
	 end
	 
	 always @(posedge clk) begin
		if (reset) begin
			IR_E <= 32'b0;
			PC4_E <= 32'b0;
			PC8_E <= 32'b0;
			A3_E <= 5'b0;
			RS_E <= 32'b0;
			RT_E <= 32'b0;
			EXT_E <= 32'b0;
			RegWrite_E <= 1'b0;
			MemWrite_E <= 1'b0;
		end
		else if (Stall) begin
			IR_E <= 32'b0;
			PC4_E <= 32'b0;
			PC8_E <= 32'b0;
			A3_E <= 5'b0;
			RS_E <= 32'b0;
			RT_E <= 32'b0;
			EXT_E <= 32'b0;
			RegWrite_E <= 1'b0;
			MemWrite_E <= 1'b0;
		end
		else begin
			IR_E <= IR_D;
			PC4_E <= PC4_D;
			
			if(IR_D[31:26]==`special && IR_D[5:0]==`movz && cmpout==1)begin//movz
				PC8_E <= RF_RD1;
			end
			else PC8_E <= PC8_D;
			
			if((IR_D[31:26]==`special && IR_D[5:0]==`movz) && cmpout==0) begin//movz
				A3_E <= 5'b0;
				RegWrite_E <= 1'b0;
			end
			else begin
				A3_E <= A3_D;
				RegWrite_E <= RegWrite_D;
			end

			RS_E <= RF_RD1;
			RT_E <= RF_RD2;
			EXT_E <= EXT;
			MemWrite_E <= MemWrite_D;
		end
	 end


endmodule
