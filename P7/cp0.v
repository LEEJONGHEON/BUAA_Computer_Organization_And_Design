`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:35:20 12/27/2017 
// Design Name: 
// Module Name:    cp0 
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
module cp0(
    input clk,
    input reset,
    input [4:0] A1,
    input [4:0] A3,
    input [31:0] Din,
    input [31:0] PC,
    input [6:2] ExcCode,
	 input BD,
    input [5:0] HWInt,
    input WE,
    input EXLSet,
    input EXLClr,
    output IntReq,
    output reg [31:0] EPC,
    output [31:0] Dout
    );
	 
	 /*SR:im[7:2]:��Ӧ6���ⲿ�ж�
			ie:ȫ���ж�ʹ�ܣ�1-�����ж�
			exl:�쳣����1-�����쳣�����������жϣ�0-�����ж�
			
		CAUSE:ip[7:2]����Ӧ6���ⲿ�жϣ���¼��ЩӲ�������ж�,1-���ж�
				ExcCode[6:2]���쳣���룬��¼��������ʲô�쳣
				0-Int:�ж�
				4-AdEL:ȡ����ȡָʱ��ַ����
				5-AdES:����ʱ��ַ����
				10-RI:�Ƿ�ָ����
				12-Ov:add,addi,sub���
	 */
	 

	 reg [31:0] PrID;
	 reg [15:10] im,ip;
	 reg [6:2] ExcCodeReg;
	 reg exl,ie,BDReg;
	 
	 initial begin
		im = 6'h3f;
		exl = 1'b0;
		ie = 1'b1;
		BDReg = 1'b0;
		ip = 6'b0;
		ExcCodeReg = 5'b0;
		EPC = 32'b0;
		PrID = 32'b0;
	 end
	 
	 
	 assign IntReq= |(HWInt & im) & !exl & ie;
	 
	 assign Dout= A1==12 ? {16'b0, im, 8'b0, exl, ie} ://SR
					  A1==13 ? {BDReg, 15'b0, ip, 3'b0, ExcCodeReg, 2'b0} ://Cause
					  A1==14 ? EPC :
					  A1==15 ? PrID :
					  32'b0;
	 
	 always @(posedge clk) begin //û�д����쳣
		if(reset) begin
			im <= 6'h3f;
			exl <= 1'b0;
			ie <= 1'b1;
			BDReg <= 1'b0;
			ip <= 5'b0;
			ExcCodeReg <= 5'b0;
			EPC <= 32'b0;
			PrID <= 32'b0;
		end
		else begin
			ip <= HWInt;
			if(IntReq) begin
				EPC <= BD ? PC-4 : PC;
				ip <= HWInt;
				exl <= 1'b1;
				BDReg <= BD;
				ExcCodeReg <= 6'b0;
			end
			else if(EXLSet) begin
				EPC <= BD ? PC-4 : PC;
				exl <= 1'b1;
				BDReg <= BD;
				ExcCodeReg <= ExcCode;
			end
			else if(EXLClr) exl <= 1'b0;
			
			else if(WE) begin
				case(A3)
					12: {im, exl, ie} <= {Din[15:10],Din[1:0]};
					13: {BDReg, ip, ExcCodeReg} <= {Din[31],Din[15:10],Din[6:2]};
					14: EPC <= Din;
					15: PrID <= Din;
				endcase
			end
		end
	 end


endmodule
