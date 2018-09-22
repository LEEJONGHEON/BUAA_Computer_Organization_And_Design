`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:30:18 12/27/2017 
// Design Name: 
// Module Name:    bridge 
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
module bridge(
    input clk,
    input reset,
    input [31:0] Addr,
    input WE,
    input [31:0] Din,
    output [31:0] Dout,
    output [7:2] HWInt
    );
	 
	 wire sel0,sel1,IRQ0,IRQ1;
	 wire [31:0] Dout0,Dout1;
	 
	 assign sel0= Addr[15:8]==8'h7f && Addr[4]==1'b0;
	 assign sel1= Addr[15:8]==8'h7f && Addr[4]==1'b1;
	
	 timer u_timer0(.clk(clk),
						 .reset(reset),
						 .Addr(Addr[3:2]),
						 .WE(WE&&sel0),
						 .Din(Din),
						 .Dout(Dout0),
						 .IRQ(IRQ0)
						 );
						 
	 timer u_timer1(.clk(clk),
						 .reset(reset),
						 .Addr(Addr[3:2]),
						 .WE(WE&&sel1),
						 .Din(Din),
						 .Dout(Dout1),
						 .IRQ(IRQ1)
						 );
	 
	 assign Dout= sel0 ? Dout0 :
					  sel1 ? Dout1 :
					  32'b0;
	
	 assign HWInt= {4'b0, IRQ1, IRQ0};
	 
	 
endmodule
