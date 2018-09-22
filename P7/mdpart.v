`timescale 1ns / 1ps
`define special 6'b000000

`define mult    6'b011000
`define multu 	 6'b011001
`define div		 6'b011010
`define divu 	 6'b011011
`define mfhi    6'b010000
`define mflo    6'b010010
`define mthi    6'b010001
`define mtlo    6'b010011
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
	 input IntReq,
	 input [31:0]IR_M,
	 input [2:0] MDOp,
	 output Busy,
	 output reg [31:0] hi,
	 output reg [31:0] lo
    );
	 
	 wire Mult,Multu,Div,Divu,Mthi,Mtlo;
	 wire [5:0]Op,Func;
	 
	 reg [3:0] state;
	 reg [63:0] reserve;
	 
	 initial begin
		hi <=32'b0;
		lo <=32'b0;
		state <= 4'b0;
	 end
	 
	 assign Op=IR_M[31:26];
	 assign Func=IR_M[5:0];
	 
	 assign Mult= Op==`special && Func==`mult;
	 assign Multu= Op==`special && Func==`multu;
	 assign Div= Op==`special && Func==`div;
	 assign Divu= Op==`special && Func==`divu;
	 assign Mthi= Op==`special && Func==`mthi;
	 assign Mtlo= Op==`special && Func==`mtlo;
	 
	 assign Busy= state > 0;
	 
	 always @(posedge clk) begin
		if(reset) begin 
			hi <= 32'b0;
			lo <= 32'b0;
		end
		else if (IntReq && (Mult || Multu || Div || Divu || Mthi || Mtlo)) begin 
			{hi,lo} <= reserve;
			state <= 4'b0;
		end
		else if (Start && !IntReq) begin
			reserve <= {hi,lo};
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
		else if (MDOp==3'b100 && !IntReq) begin
			reserve <= {hi,lo};
			hi <= A;
		end
		else if (MDOp==3'b101 && !IntReq) begin
			reserve <= {hi,lo};			
			lo <= A;
		end
		else if (Busy) state <= state -4'b0001;
	 end


endmodule
