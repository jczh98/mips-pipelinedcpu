`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:40:58 05/15/2019 
// Design Name: 
// Module Name:    dff32 
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
module dff32(d,clk,clrn,q,we
	);
	input we;
	input [31:0] d;
	input clk,clrn;
	output [31:0] q;
	reg [31:0] q;
	always @ (negedge clrn or posedge clk)
	if(clrn==0)
	begin
		q<=0;
	end
	else if(we==1)//we写使能等于0不变，为1送npc	
	begin		      
		q<=d;
	end	 
endmodule
