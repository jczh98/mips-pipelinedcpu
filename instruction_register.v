`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:40:51 05/22/2019 
// Design Name: 
// Module Name:    instruction_register 
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
module instruction_register(if_pc4,if_inst,clk,clrn,id_pc4,id_inst,wir
	);
	input wir;
	input [31:0] if_pc4, if_inst;
	input clk, clrn;
	output [31:0] id_pc4,id_inst;
	
	dff32 pc_plus4 (if_pc4,clk,clrn,id_pc4, wir);		//pc+4¼Ä´æÆ÷
	dff32 instruction (if_inst,clk,clrn,id_inst, wir);		//Ö¸Áî¼Ä´æÆ÷
	
endmodule
