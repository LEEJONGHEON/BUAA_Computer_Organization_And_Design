`timescale 1ns / 1ps
`define IM  	 3
`define MODE  	 2:1
`define ENABLE  0
`define IDLE    2'b00
`define LOAD    2'b01
`define CNTING  2'b10
`define INT     2'b11
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:25:10 12/27/2017 
// Design Name: 
// Module Name:    timer 
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
module timer(
    input clk,
    input reset,
    input [3:2] Addr,
    input WE,
    input [31:0] Din,
    output [31:0] Dout,
    output IRQ
    );
	 
	 reg [31:0] ctrl,preset,count;
	 reg [1:0] state;
	 reg irqflag;
	 
	 initial begin
		ctrl <= 32'b0;
		preset <= 32'b0;
		count <= 32'b0;
		state <= 2'b0;
	 end
	 
	 assign Dout= Addr==2'b00 ? ctrl :
					  Addr==2'b01 ? preset :
					  Addr==2'b10 ? count :
					  32'b0;
				
	 assign IRQ= irqflag && ctrl[`IM];
	 
	 always @(posedge clk) begin
		if (reset) begin
			ctrl <= 32'b0;
			preset <= 32'b0;
			count <= 32'b0;
			state <= 2'b0;
		end
		else if (WE) begin
			case (Addr)//这块存在问题
				2'b00: begin 
					ctrl[3:0] <= Din[3:0];
					irqflag <= 1'b0;
				end
				2'b01: begin
					preset <= Din;
					count <= Din;
				end
				default: ctrl <= ctrl;
			endcase
		end
		//store类指令优先级较高
		else begin
			case (state)
				`IDLE: begin
					if (ctrl[`ENABLE]) state <= `LOAD;
				end
				`LOAD: begin
					count <= preset;
					irqflag <= 1'b0;
					state <= `CNTING;
				end
				`CNTING: begin
					if(ctrl[`ENABLE]) begin
						count <= count-1;
						if (count==32'b1) state <= `INT;
					end
				end
				`INT: begin//只有在从计数转到中断的时候才会产生中断置位
					irqflag <= 1'b1;
					if(ctrl[`MODE]==2'b00) begin 
							state <= `IDLE;
							ctrl[`ENABLE] <= 1'b0;
						end
					else if(ctrl[`MODE]==2'b01) state <= `LOAD;//转到哪里？
				end	
				default: state <= `IDLE;
			endcase
		end
	 end

endmodule
