`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:13:23 10/29/2012
// Design Name:   pipelinedcpu
// Module Name:   D:/ORG_FPGA2012/PipelinedCpu/pipelinedcpu_tb.v
// Project Name:  PipelinedCpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pipelinedcpu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module PPCPU_tb;
	
	// Inputs
	reg Clock;
	reg Resetn;
	
	// Outputs 
	wire [31:0] PC;
	wire [31:0] IF_Inst;
	wire [31:0] ID_Inst;
	wire [31:0] EXE_Alu;
	wire [31:0] MEM_Alu;
	wire [31:0] WB_Alu;
	
	// Instantiate the Unit Under Test (UUT)
	PPCPU uut (
	.Clock(Clock),  
	.Resetn(Resetn), 
	.PC(PC), 
	.IF_Inst(IF_Inst),
	.ID_Inst(ID_Inst),
	.EXE_Alu(EXE_Alu),
	.MEM_Alu(MEM_Alu),
	.WB_Alu(WB_Alu)
	);
	
	initial begin
		$dumpfile("ppcpu.vcd");
		$dumpvars(1,Clock, Resetn, PC, IF_Inst, ID_Inst, EXE_Alu, MEM_Alu,WB_Alu);
		// Initialize Inputs
		Clock = 1;
		Resetn = 0;
		
		// Wait 100 ns for global reset to finish
		#100
		Resetn=1;
		// Add stimulus here
		#1500
		$finish();
		
	end
	always #50 Clock=~Clock;
	
endmodule

