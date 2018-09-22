`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:52:02 12/28/2017 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );
	 
	 wire [31:0] PrAddr,PrRD,PrWD;
	 wire [7:2] HWInt;
	 wire PrWE;
	 
	 //PrRD-从bridge中读到的数据
	 //PrWD-输到bridge中的数据

	 bridge u_bridge(.clk(clk),
						  .reset(reset),
						  .Addr(PrAddr),
						  .WE(PrWE),
						  .Din(PrWD),
						  .Dout(PrRD),
						  .HWInt(HWInt)
						  );

	 cpu u_cpu(.clk(clk),
				  .reset(reset),
				  .PrAddr(PrAddr),
				  .PrWE(PrWE),
				  .PrWD(PrWD),
				  .PrRD(PrRD),
				  .HWInt(HWInt)
				  );
	 
	 


endmodule
