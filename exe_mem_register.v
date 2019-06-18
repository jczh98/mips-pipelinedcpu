`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:46:17 05/22/2019 
// Design Name: 
// Module Name:    exe_mem_register 
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
module exe_mem_register(clk,clrn,
								exe_wreg,exe_m2reg,exe_wmem,exe_alu,exe_b,exe_rn,exe_z,
								mem_wreg,mem_m2reg,mem_wmem,mem_alu,mem_b,mem_rn,mem_z
							   );
	 input [31:0] exe_alu,exe_b;		//exe_b-在store指令的情况下需要将rt写入存储器
	 input [4:0] exe_rn;
	 input exe_wreg,exe_m2reg,exe_wmem,exe_z;
	 input clk,clrn;
	 output [31:0] mem_alu,mem_b;
	 output [4:0] mem_rn;
	 output mem_wreg,mem_m2reg,mem_wmem,mem_z;
	 reg [31:0] mem_alu,mem_b;
	 reg [4:0] mem_rn;
	 reg mem_wreg,mem_m2reg,mem_wmem,mem_z;
	 always @(negedge clrn or posedge clk)
	     if(clrn==0)
		      begin
				    mem_wreg<=0;    mem_m2reg<=0;
					 mem_wmem<=0;    mem_alu<=0;
				    mem_b<=0;       mem_rn<=0;
					 mem_z<=0;
			   end
			else
			    begin
				     mem_wreg<=exe_wreg;    mem_m2reg<=exe_m2reg;
					  mem_wmem<=exe_wmem;    mem_alu<=exe_alu;
				     mem_b<=exe_b;       mem_rn<=exe_rn;   
					  mem_z<=exe_z;
				 end
endmodule
