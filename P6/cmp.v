`timescale 1ns / 1ps
`define beq     6'b000100
`define bne     6'b000101
`define blez    6'b000110
`define bgtz    6'b000111

`define regimm  6'b000001
`define bgezal  5'b10001
`define bltz    5'b00000
`define bgez	 5'b00001

`define special 6'b000000
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
			`beq: cmpout <= Data1==Data2; 
			`bne: cmpout <= Data1!=Data2;
			`blez: cmpout <= (Data1[31]==1'b1 || Data1==32'b0);
			`bgtz: cmpout <= (Data1[31]==1'b0 &&  Data1!=32'b0);
			`regimm: begin
				case(Instr[20:16])
					`bgezal: cmpout <= Data1[31]==1'b0;
					`bgez: cmpout <= Data1[31]==1'b0;
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
