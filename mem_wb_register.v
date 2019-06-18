`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:42:12 05/22/2019 
// Design Name: 
// Module Name:    exe_wb_register 
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
module mem_wb_register(mem_wreg,mem_m2reg,mem_mo,mem_alu,mem_rn,clk,clrn,
	wb_wreg,wb_m2reg,wb_mo,wb_alu,wb_rn
	);
	input [31:0] mem_alu,mem_mo;
	input [4:0] mem_rn;
	input mem_wreg,mem_m2reg;
	input clk,clrn;
	output [31:0] wb_alu,wb_mo;
	output [4:0] wb_rn;
	output wb_wreg,wb_m2reg;
	
	reg [31:0] wb_alu,wb_mo;
	reg [4:0] wb_rn;
	reg wb_wreg,wb_m2reg;
	
	always @(negedge clrn or posedge clk)
	if(clrn==0)
	begin
		wb_wreg<=0;    wb_m2reg<=0;    wb_mo<=0;
		wb_alu<=0;     wb_rn<=0;      
		
	end
	else
	begin
		wb_wreg<=mem_wreg;    wb_m2reg<=mem_m2reg;    wb_mo<=mem_mo;
		wb_alu<=mem_alu;     wb_rn<=mem_rn;      
	end
	
endmodule