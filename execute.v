`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:19:13 05/15/2019 
// Design Name: 
// Module Name:    EXE_STAGE 
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
module execute(exe_aluc,exe_aluimm,exe_a,exe_b,exe_imm,exe_shift,exe_alu,z,
						mem_alu,wb_mo,exe_adepen, exe_bdepen,
						exe_wz
    );
	 input exe_wz;

	 input [1:0] exe_adepen, exe_bdepen;
	 input [31:0] wb_mo, mem_alu;

	 input [31:0] exe_a,exe_b,exe_imm;		//ea-由寄存器读出的操作数a；eb-由寄存器读出的操作数a；eimm-经过扩展的立即数；
	 input [2:0] exe_aluc;		//ALU控制码
	 input exe_aluimm,exe_shift;		//ALU输入操作数的多路选择器
	 output [31:0] exe_alu;		//alu操作输出
	 output z;

	 wire ze;
	 assign z = ze&exe_wz;

	 wire [31:0] alua,alub,sa;

	 assign sa={27'b0,exe_imm[9:5]};//移位位数的生成

	 mux32_4_1 alu_ina (exe_a,sa,mem_alu,wb_mo,exe_adepen,alua);//选择ALU a端的数据来源
	 mux32_4_1 alu_inb (exe_b,exe_imm,mem_alu,wb_mo,exe_bdepen,alub);//选择ALU b端的数据来源
 	 alu al_unit (alua,alub,exe_aluc,exe_alu,ze);//ALU
	 
endmodule
