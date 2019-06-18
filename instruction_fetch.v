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
	 input [31:0] pc, bpc, jpc;		//pc-输入指令地址；bpc-条件跳转指令地址；jpc-无条件跳转指令地址；
	 
	 output [31:0] pc4, npc, inst;		//pc4-pc+4用于输出至ID级计算跳转地址；npc-经过选择的下一条指令地址；inst-根据pc取出的指令

	 add32 pc_plus4(pc,32'h4,pc4);		//32位加法器，用来计算PC+4
	 mux32_4_1 next_pc(pc4,bpc,jpc,32'h0,pcsource,npc);		//根据pcsource信号选择下一条指令的地址
	 Inst_ROM3 inst_mem(pc,inst);		//指令存储器
	 
endmodule
