`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:34:33 05/24/2019 
// Design Name: 
// Module Name:    mux1_2_1 
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
module mux1_2_1(a0,a1,s,y
    );
	 input a0,a1;
	 input s;
	 output y;
	 
	 reg y;
	 always @ (*)
		begin
			case(s)
				1'b0: y=a0;
				1'b1: y=a1;
				default: y=1'bx; 
			endcase
		end
endmodule
