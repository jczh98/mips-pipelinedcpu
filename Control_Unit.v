`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:46:15 05/15/2019 
// Design Name: 
// Module Name:    Control_Unit 
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
module Control_Unit(rsrtequ,func,
	op,wreg,m2reg,wmem,aluc,regrt,aluimm,
	sext,pcsource,shift,wz,
	exe_rd, mem_rd, exe_wreg, mem_wreg, id_adepen, id_bdepen, id_rs1, id_rs2, id_rd, exe_m2reg, wpc,
	id_btaken, exe_btaken
	);
	input exe_btaken;
	output id_btaken;
	
	input [4:0] exe_rd, mem_rd, id_rs1, id_rs2, id_rd;
	input exe_wreg, mem_wreg, exe_m2reg;
	
	output [1:0] id_adepen, id_bdepen;
	output wpc;
	
	input rsrtequ; 		//判断ALU输出结果是否为0：if(r=0)rsrtequ=1；
	input [5:0] func,op;		//指令中相应控制码字段
	output wreg,m2reg,wmem,regrt,aluimm,sext,shift,wz;
	output [2:0] aluc;		//ALU控制码
	output [1:0] pcsource;		//PC多路选择器控制码
	
	reg [2:0] aluc;
	reg [1:0] pcsource;
	
	wire i_add,i_and,i_or,i_xor,i_sll,i_srl;            //寄存器运算标志
	wire i_addi,i_andi,i_ori,i_xori;		//立即数运算标志
	wire i_lw,i_sw;		//存储器运算标志
	wire i_beq,i_bne;		//branch运算标志
	wire i_j;		//jump运算标志
	
	////////////////////////////////////////////运算标志的生成/////////////////////////////////////////////////////////
	and(i_add,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0],~func[2],~func[1],func[0]);		//add运算标志
	and(i_and,~op[5],~op[4],~op[3],~op[2],~op[1],op[0],~func[2],~func[1],func[0]);		//and运算标志
	and(i_or,~op[5],~op[4],~op[3],~op[2],~op[1],op[0],~func[2],func[1],~func[0]);		//or运算标志
	and(i_xor,~op[5],~op[4],~op[3],~op[2],~op[1],op[0],func[2],~func[1],~func[0]);		//xor运算标志
	
	and(i_srl,~op[5],~op[4],~op[3],~op[2],op[1],~op[0],~func[2],func[1],~func[0]);		//srl运算标志
	and(i_sll,~op[5],~op[4],~op[3],~op[2],op[1],~op[0],~func[2],func[1],func[0]);		//sll运算标志
	
	and(i_addi,~op[5],~op[4],~op[3],op[2],~op[1],op[0]);		//addi运算标志
	and(i_andi,~op[5],~op[4],op[3],~op[2],~op[1],op[0]);		//andi运算标志
	and(i_ori,~op[5],~op[4],op[3],~op[2],op[1],~op[0]);		//ori运算标志
	and(i_xori,~op[5],~op[4],op[3],op[2],~op[1],~op[0]);		//xori运算标志
	
	and(i_lw,~op[5],~op[4],op[3],op[2],~op[1],op[0]);		//load运算标志
	and(i_sw,~op[5],~op[4],op[3],op[2],op[1],~op[0]);		//store运算标志
	
	and(i_beq,~op[5],~op[4],op[3],op[2],op[1],op[0]);		//beq运算标志
	and(i_bne,~op[5],op[4],~op[3],~op[2],~op[1],~op[0]);		//bne运算标志
	
	and(i_j,~op[5],op[4],~op[3],~op[2],op[1],~op[0]);		//jump运算标志
	
	////////////////////////////////////////////控制信号的生成/////////////////////////////////////////////////////////
	//解决数据冒险
	wire ID_rs1IsReg=i_add|i_and|i_or|i_xor|i_j|i_addi|i_andi|i_ori|i_xori|i_lw|i_sw|i_beq|i_bne;
	wire ID_rs2IsReg=i_add|i_and|i_or|i_xor|i_srl|i_sll|i_sw|i_beq|i_bne;
	
	assign wreg=(i_add|i_and|i_or|i_xor|i_sll|i_srl|i_addi|i_andi|i_ori|i_xori|i_lw)&wpc&exe_btaken;		//寄存器写信号
	assign regrt=i_addi|i_andi|i_ori|i_xori|i_lw;    //regrt为1时目的寄存器是rt，否则为rd
	assign m2reg=i_lw;  //运算结果写回寄存器：为1时将存储器数据写入寄存器，否则将ALU结果写入寄存器
	assign shift=i_sll|i_srl;//ALUa数据输入选择：为1时ALUa输入端使用移位位数字段inst[19:15]
	assign aluimm=i_addi|i_andi|i_ori|i_xori|i_lw|i_sw;//ALUb数据输入选择：为1时ALUb输入端使用立即数
	assign sext=i_addi|i_lw|i_sw|i_beq|i_bne;//为1时符号拓展，否则零拓展
	assign wmem=i_sw&wpc&exe_btaken;//存储器写信号：为1时写存储器，否则不写
	assign wz=exe_btaken;//控制冒险
	
	//数据冒险
	assign exe_adepen=(id_rs1==exe_rd)&(exe_wreg==1)&(ID_rs1IsReg);
	assign mem_adepen=(id_rs1==mem_rd)&(mem_wreg==1)&(ID_rs1IsReg);
	assign exe_bdepen=((id_rs2==exe_rd)&(exe_wreg==1)&(ID_rs2IsReg))|((id_rd==exe_rd)&(exe_wreg==1)&(i_sw));
	assign mem_bdepen=((id_rs2==mem_rd)&(mem_wreg==1)&(ID_rs2IsReg))|((id_rd==mem_rd)&(mem_wreg==1)&(i_sw));
	assign id_adepen[0]=mem_adepen;
	assign id_adepen[1]=mem_adepen|exe_adepen;
	assign id_bdepen[0]=mem_bdepen|aluimm;
	assign id_bdepen[1]=mem_bdepen|exe_bdepen;
	
	assign id_btaken=(pcsource[0]==0)&(pcsource[1]==0);//不发生转移btaken为1
	
	//判断是否发生load相关，如果是则wpc为1暂停一个周期
	assign wpc=~(((id_rs1==exe_rd)&exe_m2reg&ID_rs1IsReg)|((id_rs2==exe_rd)&exe_m2reg&ID_rs2IsReg)|
	((id_rd==exe_rd)&exe_wreg&i_sw)|((id_rd==mem_rd)&mem_wreg&i_sw)|((i_bne|i_beq)&mem_wreg));
	always @(*)
	case (op)
		6'b000000: begin aluc<=3'b000; pcsource<=2'b00; end		//+; pc=pc+4
		6'b000001: 
		case (func[2:0])
			3'b001: begin aluc<=3'b001; pcsource<=2'b00; end		//and; pc=pc+4
			3'b010: begin aluc<=3'b010; pcsource<=2'b00; end		//or; pc=pc+4
			3'b100: begin aluc<=3'b011; pcsource<=2'b00; end		//xor; pc=pc+4
		endcase
		6'b000010: 
		case (func[2:0])
			3'b010: begin aluc<=3'b100; pcsource<=2'b00; end		//srl; pc=pc+4
			3'b011: begin aluc<=3'b101; pcsource<=2'b00; end		//sll; pc=pc+4
		endcase				
		6'b000101: begin aluc<=3'b000; pcsource<=2'b00; end		//addi; pc=pc+4
		6'b001001: begin aluc<=3'b001; pcsource<=2'b00; end		//andi; pc=pc+4
		6'b001010: begin aluc<=3'b010; pcsource<=2'b00; end		//ori; pc=pc+4
		6'b001100: begin aluc<=3'b011; pcsource<=2'b00; end		//xori; pc=pc+4
		
		6'b001101: begin aluc<=3'b000; pcsource<=2'b00; end		//load; pc=pc+4
		6'b001110: begin aluc<=3'b000; pcsource<=2'b00; end		//store; pc=pc+4
		6'b001111: begin aluc<=3'b110; if(rsrtequ) pcsource<=2'b01; else pcsource<=2'b00; end		//beq; pc=bpc
		6'b010000: begin aluc<=3'b110; if(!rsrtequ) pcsource<=2'b01; else pcsource<=2'b00; end		//beq; pc=bpc
		6'b010010: pcsource<=2'b10;		//beq; pc=jpc
	endcase
	
endmodule
