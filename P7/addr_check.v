`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:26:24 12/28/2017 
// Design Name: 
// Module Name:    addr_check 
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
module addr_check(
	 input MemWrite,
	 input [1:0]SDsel,
	 input [2:0]LDsel,
	 input [31:0] Addr,
	 output reg [4:0] DAExcCode,
	 output reg DataAddrExc
    );
	 
	 always @(*) begin
		if(MemWrite) begin
			DAExcCode <= 5'd5;
		   if (!((Addr >=32'b0 && Addr <= 32'h2fff)|| ( Addr >= 32'h7f00 && Addr <= 32'h7f0b) || (Addr >= 32'h7f00 && Addr <= 32'h7f0b))) DataAddrExc <= 1'b1;//存在问题
			else if (SDsel==2'b10) begin//sh
				if(!(Addr >=32'b0 && Addr <= 32'h2fff)) DataAddrExc <= 1'b1;//访问timer
				else DataAddrExc <= !Addr[0]==1'b0;
			end
			else if (SDsel==2'b11 && !(Addr >=32'b0 && Addr <= 32'h2fff)) DataAddrExc <= 1'b1;//sb访问timer
			else if (SDsel==2'b00) begin//sw
				if(Addr==32'h7f08 || Addr==32'h7f18) DataAddrExc <= 1'b1;//访问count
				else DataAddrExc <= !(Addr[0]==1'b0 && Addr[1]==1'b0);
			end
			else DataAddrExc <= 1'b0;
		end
		else if(LDsel!=3'b111) begin
			DAExcCode <= 5'd4;
		   if (!((Addr >=32'b0 && Addr <= 32'h2fff)|| ( Addr >= 32'h7f00 && Addr <= 32'h7f0b) || (Addr >= 32'h7f00 && Addr <= 32'h7f0b))) DataAddrExc <= 1'b1;
			else if(LDsel==3'b100 || LDsel==3'b011) begin//lh,lhu
				if(!(Addr >=32'b0 && Addr <= 32'h2fff)) DataAddrExc <= 1'b1;//访问timer
				else DataAddrExc <= !Addr[0]==1'b0;
			end
			else if((LDsel==3'b010 || LDsel==3'b001)&& !(Addr >=32'b0 && Addr <= 32'h2fff)) DataAddrExc <= 1'b1;//lbu,lb访问timer
			else if(LDsel==3'b000) DataAddrExc <= !(Addr[0]==1'b0 && Addr[1]==1'b0);//lw
		   else DataAddrExc <= 1'b0;
		end
		else DataAddrExc <= 1'b0;
	 end


endmodule
