`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:57:34 11/25/2017 
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
	 input [31:0] Address,
	 input Lb,
    input [31:0] Din,
    output [31:0] Dout
    );
	 
	 integer i;
	 reg [31:0] data[1023:0];
	 wire [31:0] SignExtByte;
	 wire [9:0] Addr;
	 wire [7:0] Byte;
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
	 assign SignExtByte = {{24{Byte[7]}},Byte};
	 assign Dout = (Lb==1)? SignExtByte : data[Addr];
	 
	 always @(posedge clk) begin
		if (reset) begin
			for(i=0;i<=1023;i=i+1) begin 
				data[i]<=32'b0;
			end
		end
		else if(MemWrite) begin
			data[Addr] <= Din;
			$display("@%h: *%h <= %h",PrePC, Address,Din);
		end 
	 end


endmodule
