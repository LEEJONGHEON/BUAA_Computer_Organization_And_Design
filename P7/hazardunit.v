`timescale 1ns / 1ps
`define rs  25:21
`define rt  20:16
`define rd	15:11
`define NW  2'b00
`define ALU 2'b01
`define DM  2'b10
`define PC  2'b11
`define cp0     6'b010000
`define mtc0    5'b00100
`define mfc0    5'b00000
`define eret    6'b011000
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:54:06 12/07/2017 
// Design Name: 
// Module Name:    hazardunit 
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
module hazardunit(
	 input [31:0] InstrD,
	 input [31:0] InstrE,
	 input [31:0] InstrM,
	 input [31:0] InstrW,
	 input [4:0] A3_M,
	 input [4:0] A3_E,
	 input [4:0] A3_W,
	 input StartE,
	 input Busy,
	 output Stall,
	 output [2:0] ForwardRSD,
	 output [2:0] ForwardRTD,
	 output [1:0] ForwardRSE,
	 output [1:0] ForwardRTE,
	 output ForwardRTM
    );
	 
	 wire DTuse_rs0,DTuse_rs1,DTuse_rt0,DTuse_rt1,DTuse_rt2;
	 wire Stall_rs0_E1,Stall_rs0_E2,Stall_rs1_E2,Stall_rs0_M1,Stall_rs,Stall_rt0_E1, Stall_rt0_E2,Stall_rt1_E2,Stall_rt0_M1, Stall_rt;
	 wire Stall_md,mdFlagD;//ÐÂÌí¼Ó
	 wire Stall_eret;
	 wire [1:0]res_E,res_M,res_W;
	 wire [4:0]A1_D,A2_D;
	 wire [4:0]A1_E,A2_E;
	 wire [4:0]A2_M;
	 
	 decoder u_decoderD(.Instr(InstrD), .Tuse_rs0(DTuse_rs0), .Tuse_rs1(DTuse_rs1), .Tuse_rt0(DTuse_rt0), .Tuse_rt1(DTuse_rt1),.Tuse_rt2(DTuse_rt2),
							  .A1(A1_D), .A2(A2_D), .mdFlag(mdFlagD));
	 decoder u_decoderE(.Instr(InstrE), .res(res_E), .A1(A1_E), .A2(A2_E));
	 decoder u_decoderM(.Instr(InstrM), .res(res_M), .A2(A2_M));
	 decoder u_decoderW(.Instr(InstrW), .res(res_W));
	 
	 
	 assign Stall_rs0_E1=DTuse_rs0 & (res_E==`ALU) & (A1_D!=5'b0) & (A1_D==A3_E);
	 assign Stall_rs0_E2=DTuse_rs0 & (res_E==`DM)  & (A1_D!=5'b0) & (A1_D==A3_E);
	 assign Stall_rs1_E2=DTuse_rs1 & (res_E==`DM)  & (A1_D!=5'b0) & (A1_D==A3_E);
	 assign Stall_rs0_M1=DTuse_rs0 & (res_M==`DM)  & (A1_D!=5'b0) & (A1_D==A3_M);
	 assign Stall_rs=Stall_rs0_E1 | Stall_rs0_E2 | Stall_rs1_E2 | Stall_rs0_M1;
	 
	 assign Stall_rt0_E1=DTuse_rt0 & (res_E==`ALU) & (A2_D!=5'b0) & (A2_D==A3_E);
	 assign Stall_rt0_E2=DTuse_rt0 & (res_E==`DM)  & (A2_D!=5'b0) & (A2_D==A3_E);
	 assign Stall_rt1_E2=DTuse_rt1 & (res_E==`DM)  & (A2_D!=5'b0) & (A2_D==A3_E);
	 assign Stall_rt0_M1=DTuse_rt0 & (res_M==`DM)  & (A2_D!=5'b0) & (A2_D==A3_M);
	 assign Stall_rt=Stall_rt0_E1 | Stall_rt0_E2 | Stall_rt1_E2 | Stall_rt0_M1;
	 
	 assign Stall_md=(StartE || Busy) && (mdFlagD);
	 
	 assign Stall_eret=(InstrD[31:26]==`cp0 && InstrD[5:0]==`eret)&&
							 ((InstrE[31:26]==`cp0 && InstrE[25:21]==`mtc0)||(InstrM[31:26]==`cp0 && InstrM[25:21]==`mtc0));
	 
	 assign Stall= Stall_rs | Stall_rt | Stall_md |Stall_eret;

	 assign ForwardRSD= ((A1_D!=5'b0) & (A1_D==A3_E) & (res_E==`PC))  ? 3'b100 :
							  ((A1_D!=5'b0) & (A1_D==A3_M) & (res_M==`PC))  ? 3'b011 :
							  ((A1_D!=5'b0) & (A1_D==A3_M) & (res_M==`ALU)) ? 3'b010 :
							  ((A1_D!=5'b0) & (A1_D==A3_W) & (res_W==`PC))  ? 3'b001 :
							  ((A1_D!=5'b0) & (A1_D==A3_W) & (res_W==`DM))  ? 3'b001 :
							  ((A1_D!=5'b0) & (A1_D==A3_W) & (res_W==`ALU)) ? 3'b001 : 3'b000;
	 
	 assign ForwardRTD= ((A2_D!=5'b0) & (A2_D==A3_E) & (res_E==`PC))  ? 3'b100 :
							  ((A2_D!=5'b0) & (A2_D==A3_M) & (res_M==`PC))  ? 3'b011 :
							  ((A2_D!=5'b0) & (A2_D==A3_M) & (res_M==`ALU)) ? 3'b010 :
							  ((A2_D!=5'b0) & (A2_D==A3_W) & (res_W==`PC))  ? 3'b001 :
							  ((A2_D!=5'b0) & (A2_D==A3_W) & (res_W==`DM))  ? 3'b001 :
							  ((A2_D!=5'b0) & (A2_D==A3_W) & (res_W==`ALU)) ? 3'b001 : 3'b000;
	 
	 assign ForwardRSE= ((A1_E!=5'b0) & (A1_E==A3_M) & (res_M==`PC))  ? 2'b11 :
							  ((A1_E!=5'b0) & (A1_E==A3_M) & (res_M==`ALU)) ? 2'b10 :
							  ((A1_E!=5'b0) & (A1_E==A3_W) & (res_W==`PC))  ? 2'b01 :
							  ((A1_E!=5'b0) & (A1_E==A3_W) & (res_W==`DM))  ? 2'b01 :
							  ((A1_E!=5'b0) & (A1_E==A3_W) & (res_W==`ALU)) ? 2'b01 : 2'b00;
							  
	 assign ForwardRTE= ((A2_E!=5'b0) & (A2_E==A3_M) & (res_M==`PC))  ? 2'b11 :
							  ((A2_E!=5'b0) & (A2_E==A3_M) & (res_M==`ALU)) ? 2'b10 :
							  ((A2_E!=5'b0) & (A2_E==A3_W) & (res_W==`PC))  ? 2'b01 :
							  ((A2_E!=5'b0) & (A2_E==A3_W) & (res_W==`DM))  ? 2'b01 :
							  ((A2_E!=5'b0) & (A2_E==A3_W) & (res_W==`ALU)) ? 2'b01 : 2'b00;
							  
    assign ForwardRTM= ((A2_M!=5'b0) & (A2_M==A3_W) & (res_W==`PC))  ? 1'b1 :
							  ((A2_M!=5'b0) & (A2_M==A3_W) & (res_W==`DM))  ? 1'b1 :
							  ((A2_M!=5'b0) & (A2_M==A3_W) & (res_W==`ALU)) ? 1'b1 : 1'b0;
endmodule
