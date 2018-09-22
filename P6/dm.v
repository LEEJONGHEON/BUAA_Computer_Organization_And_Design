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
	 input [1:0]SDsel,	
	 input [31:0] Address,
    input [31:0] Din,
    output [31:0] Dout
    );
	 
	 integer i;
	 reg [7:0] data0[4095:0];
	 reg [7:0] data1[4095:0];
	 reg [7:0] data2[4095:0];
	 reg [7:0] data3[4095:0];
	 
	 wire [11:0] Addr;

	 
	 initial begin
		for(i=0;i<=4095;i=i+1) begin 
				data0[i]=8'b0;
				data1[i]=8'b0;
				data2[i]=8'b0;
				data3[i]=8'b0;
			end
	 end
	 
	 assign Addr = Address[13:2];
	 assign Dout = {data3[Addr],data2[Addr],data1[Addr],data0[Addr]};
	 
	 
	 always @(posedge clk) begin
		if (reset) begin
			for(i=0;i<=4095;i=i+1) begin 
				data0[i]<=8'b0;
				data1[i]<=8'b0;
				data2[i]<=8'b0;
				data3[i]<=8'b0;
			end
		end
		else if(MemWrite) begin
			if (SDsel==2'b10) begin
				case(Address[1:0])
					2'b00:begin
						{data1[Addr],data0[Addr]} <= Din[15:0];
						$display("%d@%h: *%h <= %h",$time,PrePC, {Address[31:2],2'b00},{data3[Addr],data2[Addr],Din[15:0]});
					end
					2'b10:begin
						{data3[Addr],data2[Addr]} <= Din[15:0];
						$display("%d@%h: *%h <= %h",$time,PrePC, {Address[31:2],2'b00},{Din[15:0],data1[Addr],data0[Addr]});
					end
					default {data3[Addr],data2[Addr],data1[Addr],data0[Addr]} <=32'b0;
				endcase
			end
			else if(SDsel==2'b01) begin
				case(Address[1:0])
					2'b00:begin 
						data0[Addr] <= Din[7:0];
						$display("%d@%h: *%h <= %h",$time,PrePC, {Address[31:2],2'b00},{data3[Addr],data2[Addr],data1[Addr],Din[7:0]});
					end
					2'b01:begin 
						data1[Addr] <= Din[7:0];
						$display("%d@%h: *%h <= %h",$time,PrePC, {Address[31:2],2'b00},{data3[Addr],data2[Addr],Din[7:0],data0[Addr]});						
					end
					2'b10:begin
						data2[Addr] <= Din[7:0];
						$display("%d@%h: *%h <= %h",$time,PrePC, {Address[31:2],2'b00},{data3[Addr],Din[7:0],data1[Addr],data0[Addr]});						
					end
					2'b11:begin
						data3[Addr] <= Din[7:0];
						$display("%d@%h: *%h <= %h",$time,PrePC, {Address[31:2],2'b00},{Din[7:0],data2[Addr],data1[Addr],data0[Addr]});						
					end
					default {data3[Addr],data2[Addr],data1[Addr],data0[Addr]} <=32'b0;
				endcase
			end
			else begin
				{data3[Addr],data2[Addr],data1[Addr],data0[Addr]} <= Din;
				$display("%d@%h: *%h <= %h",$time, PrePC, Address,Din);
			end
		end 
	 end


endmodule