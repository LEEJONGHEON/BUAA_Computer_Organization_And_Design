`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:03:34 12/07/2017 
// Design Name: 
// Module Name:    dm 
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
module dm(
    input clk,
    input reset,
	 input [31:0] PrePC,
    input MemWrite,
	 input [1:0]LDsel,
	 input [1:0]SDsel,
	 input [31:0] Address,
    input [31:0] Din,
    output [31:0] Dout
    );
	 
	 integer i;
	 reg [31:0] data[1023:0];
	 wire [9:0] Addr;
	 wire [7:0] Byte;
	 wire [31:0] SignEXTByte;
	 initial begin
		for(i=0;i<=1023;i=i+1) begin 
				data[i]=32'b0;
			end
	 end
	 
	 assign Addr = Address[11:2];
	 
	 assign Byte = (Address[1:0]==2'b00)? data[Addr][7:0]:
						(Address[1:0]==2'b01)? data[Addr][15:8]:
						(Address[1:0]==2'b10)? data[Addr][23:16]:
						data[Addr][31:24];	 
	 assign SignEXTByte = {{24{Byte[7]}},Byte};
	 assign Dout = (LDsel==2'b01)? SignEXTByte : //lb
						data[Addr];//lw
	 
	 
	 always @(posedge clk) begin
		if (reset) begin
			for(i=0;i<=1023;i=i+1) begin 
				data[i]<=32'b0;
			end
		end
		else if(MemWrite) begin
			if(SDsel==2'b01) begin
				case(Address[1:0])
					2'b00: data[Addr] <= {data[Addr][31:8],Din[7:0]};
					2'b01: data[Addr] <= {data[Addr][31:16],Din[7:0],data[Addr][7:0]};
					2'b10: data[Addr] <= {data[Addr][31:24],Din[7:0],data[Addr][15:0]};
					2'b11: data[Addr] <= {Din[7:0],data[Addr][23:0]};
					default data[Addr] <=32'b0;
				endcase
				$display("%d@%h: *%h <= %h",$time,PrePC, Address,Din[7:0]);
			end
			else begin
				data[Addr] <= Din;
				$display("%d@%h: *%h <= %h",$time, PrePC, Address,Din);
			end
		end 
	 end


endmodule