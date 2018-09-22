`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:16:41 12/28/2017 
// Design Name: 
// Module Name:    exc_reg 
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
module D_exc_reg(
	 input clk,
	 input reset,
	 input [6:2] ExcCodeIn,
	 input EXLIn,
	 input Branch,
	 output reg [6:2] ExcCode_D,
	 output reg EXL_D,
	 output reg BD_D
    );
	 
	 always @(posedge clk) begin
		if(reset) begin
			ExcCode_D <= 5'b0;
			EXL_D <= 1'b0;
			BD_D <= 1'b0;
		end
		else begin
			ExcCode_D<= ExcCodeIn;
			EXL_D <= EXLIn;
			BD_D <= Branch;
		end
	 end
	 
endmodule

module E_exc_reg(
	 input clk,
	 input reset,
	 input [6:2] ExcCodeIn,
	 input EXLIn,
	 input BD_D,
	 output reg [6:2] ExcCode_E,
	 output reg EXL_E,
	 output reg BD_E
    );
	 
	 always @(posedge clk) begin
		if(reset) begin
			ExcCode_E <= 5'b0;
			EXL_E <= 1'b0;
			BD_E <= 1'b0;
		end
		else begin
			ExcCode_E <= ExcCodeIn;
			EXL_E <= EXLIn;
			BD_E <= BD_D;
		end
	 end

endmodule


module M_exc_reg(
	 input clk,
	 input reset,
	 input [6:2] ExcCodeIn,
	 input EXLIn,
	 input BD_E,
	 output reg [6:2] ExcCode_M,
	 output reg EXL_M,
	 output reg BD_M
    );
	 
	 always @(posedge clk) begin
		if(reset) begin
			ExcCode_M <= 5'b0;
			EXL_M <= 1'b0;
			BD_M <= 1'b0;
		end
		else begin
			ExcCode_M<= ExcCodeIn;
			EXL_M <= EXLIn;
			BD_M <= BD_E;
		end
	 end
endmodule
