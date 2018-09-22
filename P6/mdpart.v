`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:52:24 12/18/2017 
// Design Name: 
// Module Name:    mdpart 
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
module mdpart(
	 input clk,
	 input reset,
	 input [31:0] A,
	 input [31:0] B,
	 input Start,
	 input [2:0] MDOp,
	 output Busy,
	 output reg [31:0] hi,
	 output reg [31:0] lo
    );
	 
	 reg [3:0] state;
	 
	 initial begin
		hi <=32'b0;
		lo <=32'b0;
		state <= 4'b0;
	 end
	 
	 assign Busy= state > 0;
	 
	 always @(posedge clk) begin
		if(reset) begin 
			hi <= 32'b0;
			lo <= 32'b0;
		end
		else if (Start) begin 
			case(MDOp)
				3'b000:begin
					state <= 4'd5;
					{hi,lo} <= A * B;
				end
				3'b001:begin
					state <= 4'd5;
					{hi,lo} <= $signed(A) * $signed(B);
				end
				3'b010:begin
					state <=4'd10;
					if(B!=32'b0) {hi,lo} <= {A % B,A / B};
				end
				3'b011:begin
					state <=4'd10;
					if(B!=32'b0) {hi,lo} <= {$signed(A)%$signed(B),$signed(A)/$signed(B)};
				end
				3'b110:begin
					state <=4'd5;
					{hi,lo} <= $signed({hi,lo}) + $signed(A) * $signed(B);
				end
				default: {hi,lo} <= 64'b0;
			endcase
		end
		else if (MDOp==3'b100) hi <= A;
		else if (MDOp==3'b101) lo <= A;
		else if (Busy) state <= state -4'b0001;
	 end


endmodule
