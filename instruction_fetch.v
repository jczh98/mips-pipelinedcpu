`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:34:26 05/14/2019 
// Design Name: 
// Module Name:    IF_STAGE 
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
module instruction_fetch(pcsource,pc,bpc,jpc,pc4,npc,inst
    );
	 input [1:0] pcsource;
	 input [31:0] pc, bpc, jpc;		//pc-����ָ���ַ��bpc-������תָ���ַ��jpc-��������תָ���ַ��
	 
	 output [31:0] pc4, npc, inst;		//pc4-pc+4���������ID��������ת��ַ��npc-����ѡ�����һ��ָ���ַ��inst-����pcȡ����ָ��

	 add32 pc_plus4(pc,32'h4,pc4);		//32λ�ӷ�������������PC+4
	 mux32_4_1 next_pc(pc4,bpc,jpc,32'h0,pcsource,npc);		//����pcsource�ź�ѡ����һ��ָ��ĵ�ַ
	 Inst_ROM3 inst_mem(pc,inst);		//ָ��洢��
	 
endmodule
