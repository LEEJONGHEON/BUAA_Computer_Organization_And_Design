`timescale 1ns / 1ps
`define special 6'b000000
`define addu 	 6'b100001
`define subu    6'b100011
`define ori     6'b001101
`define lw      6'b100011
`define sw      6'b101011
`define beq     6'b000100
`define lui     6'b001111
`define nop     6'b000000
`define j       6'b000010
`define jal     6'b000011
`define jr      6'b001000
`define sll     6'b000000
`define jalr    6'b001001
`define lb      6'b100000
`define sb      6'b101000
`define regimm  6'b000001
`define bgezal  5'b10001
`define bltz    5'b00000
`define movz    6'b001010

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:04:33 12/07/2017 
// Design Name: 
// Module Name:    cmp 
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
module cmp(
    input [31:0] Instr,
    input [31:0] Data1,
    input [31:0] Data2,
    output reg cmpout
    );
	 wire [5:0]op;
	 assign op = Instr[31:26];
	 always @(*) begin 
		case(op)
			`beq: cmpout <= Data1==Data2; ///这块之前写的是=，有问题？
			`regimm: begin
				case(Instr[20:16])
					`bgezal: cmpout <= Data1[31]==1'b0;
					`bltz: cmpout <= Data1[31]==1'b1;
					default: cmpout <=0;
				endcase
			end
			`special:begin
				case(Instr[5:0])
					`movz: cmpout <= Data2==32'b0;
					default: cmpout <= 0;
				endcase
			end
			default: cmpout <= 0;
		endcase
	 end	
	 

endmodule
