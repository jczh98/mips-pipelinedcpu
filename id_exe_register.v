`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:01:40 05/22/2019 
// Design Name: 
// Module Name:    id_exe_register 
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
module id_exe_register(clk,clrn,
	id_wreg,id_m2reg,id_wmem,id_aluc,id_aluimm,id_a,id_b,id_imm,id_rn,id_shift,id_wz,
	exe_wreg,exe_m2reg,exe_wmem,exe_aluc,exe_aluimm,exe_a,exe_b,exe_imm,exe_rn,exe_shift,exe_wz,
	id_adepen, id_bdepen, exe_adepen, exe_bdepen,
	id_btaken, exe_btaken
	);
	input [1:0] id_adepen, id_bdepen;
	output [1:0] exe_adepen, exe_bdepen;
	
	input id_btaken;
	output exe_btaken;
	
	input [31:0] id_a,id_b,id_imm;
	input [4:0] id_rn;
	input [2:0] id_aluc;
	input id_wreg,id_m2reg,id_wmem,id_aluimm,id_shift,id_wz;
	input clk,clrn;
	
	output [31:0] exe_a,exe_b,exe_imm;
	output [4:0] exe_rn;
	output [2:0] exe_aluc;
	output exe_wreg,exe_m2reg,exe_wmem,exe_aluimm,exe_shift,exe_wz;
	reg [31:0] exe_a,exe_b,exe_imm;
	reg [4:0] exe_rn;
	reg [2:0] exe_aluc;
	reg exe_wreg,exe_m2reg,exe_wmem,exe_aluimm,exe_shift,exe_wz;
	reg [1:0] exe_adepen, exe_bdepen;
	reg exe_btaken;
	always @(negedge clrn or posedge clk)
	if(clrn==0)
	begin
		exe_wreg<=0;    exe_m2reg<=0;
		exe_wmem<=0;    exe_aluc<=0;
		exe_aluimm<=0;  exe_a<=0;
		exe_b<=0;       exe_imm<=0;
		exe_rn<=0;      exe_shift<=0;
		exe_wz<=0;
		exe_adepen<=0;
		exe_bdepen<=0;
		exe_btaken<=0;
	end
	else
	begin
		exe_wreg<=id_wreg;    exe_m2reg<=id_m2reg;
		exe_wmem<=id_wmem;    exe_aluc<=id_aluc;
		exe_aluimm<=id_aluimm;  exe_a<=id_a;
		exe_b<=id_b;       exe_imm<=id_imm;
		exe_rn<=id_rn;      exe_shift<=id_shift;
		exe_wz<=id_wz;
		exe_adepen<=id_adepen;
		exe_bdepen<=id_bdepen;
		exe_btaken<=id_btaken;
	end
	
endmodule
