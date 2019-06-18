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
	
	input rsrtequ; 		//�ж�ALU�������Ƿ�Ϊ0��if(r=0)rsrtequ=1��
	input [5:0] func,op;		//ָ������Ӧ�������ֶ�
	output wreg,m2reg,wmem,regrt,aluimm,sext,shift,wz;
	output [2:0] aluc;		//ALU������
	output [1:0] pcsource;		//PC��·ѡ����������
	
	reg [2:0] aluc;
	reg [1:0] pcsource;
	
	wire i_add,i_and,i_or,i_xor,i_sll,i_srl;            //�Ĵ��������־
	wire i_addi,i_andi,i_ori,i_xori;		//�����������־
	wire i_lw,i_sw;		//�洢�������־
	wire i_beq,i_bne;		//branch�����־
	wire i_j;		//jump�����־
	
	////////////////////////////////////////////�����־������/////////////////////////////////////////////////////////
	and(i_add,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0],~func[2],~func[1],func[0]);		//add�����־
	and(i_and,~op[5],~op[4],~op[3],~op[2],~op[1],op[0],~func[2],~func[1],func[0]);		//and�����־
	and(i_or,~op[5],~op[4],~op[3],~op[2],~op[1],op[0],~func[2],func[1],~func[0]);		//or�����־
	and(i_xor,~op[5],~op[4],~op[3],~op[2],~op[1],op[0],func[2],~func[1],~func[0]);		//xor�����־
	
	and(i_srl,~op[5],~op[4],~op[3],~op[2],op[1],~op[0],~func[2],func[1],~func[0]);		//srl�����־
	and(i_sll,~op[5],~op[4],~op[3],~op[2],op[1],~op[0],~func[2],func[1],func[0]);		//sll�����־
	
	and(i_addi,~op[5],~op[4],~op[3],op[2],~op[1],op[0]);		//addi�����־
	and(i_andi,~op[5],~op[4],op[3],~op[2],~op[1],op[0]);		//andi�����־
	and(i_ori,~op[5],~op[4],op[3],~op[2],op[1],~op[0]);		//ori�����־
	and(i_xori,~op[5],~op[4],op[3],op[2],~op[1],~op[0]);		//xori�����־
	
	and(i_lw,~op[5],~op[4],op[3],op[2],~op[1],op[0]);		//load�����־
	and(i_sw,~op[5],~op[4],op[3],op[2],op[1],~op[0]);		//store�����־
	
	and(i_beq,~op[5],~op[4],op[3],op[2],op[1],op[0]);		//beq�����־
	and(i_bne,~op[5],op[4],~op[3],~op[2],~op[1],~op[0]);		//bne�����־
	
	and(i_j,~op[5],op[4],~op[3],~op[2],op[1],~op[0]);		//jump�����־
	
	////////////////////////////////////////////�����źŵ�����/////////////////////////////////////////////////////////
	//�������ð��
	wire ID_rs1IsReg=i_add|i_and|i_or|i_xor|i_j|i_addi|i_andi|i_ori|i_xori|i_lw|i_sw|i_beq|i_bne;
	wire ID_rs2IsReg=i_add|i_and|i_or|i_xor|i_srl|i_sll|i_sw|i_beq|i_bne;
	
	assign wreg=(i_add|i_and|i_or|i_xor|i_sll|i_srl|i_addi|i_andi|i_ori|i_xori|i_lw)&wpc&exe_btaken;		//�Ĵ���д�ź�
	assign regrt=i_addi|i_andi|i_ori|i_xori|i_lw;    //regrtΪ1ʱĿ�ļĴ�����rt������Ϊrd
	assign m2reg=i_lw;  //������д�ؼĴ�����Ϊ1ʱ���洢������д��Ĵ���������ALU���д��Ĵ���
	assign shift=i_sll|i_srl;//ALUa��������ѡ��Ϊ1ʱALUa�����ʹ����λλ���ֶ�inst[19:15]
	assign aluimm=i_addi|i_andi|i_ori|i_xori|i_lw|i_sw;//ALUb��������ѡ��Ϊ1ʱALUb�����ʹ��������
	assign sext=i_addi|i_lw|i_sw|i_beq|i_bne;//Ϊ1ʱ������չ����������չ
	assign wmem=i_sw&wpc&exe_btaken;//�洢��д�źţ�Ϊ1ʱд�洢��������д
	assign wz=exe_btaken;//����ð��
	
	//����ð��
	assign exe_adepen=(id_rs1==exe_rd)&(exe_wreg==1)&(ID_rs1IsReg);
	assign mem_adepen=(id_rs1==mem_rd)&(mem_wreg==1)&(ID_rs1IsReg);
	assign exe_bdepen=((id_rs2==exe_rd)&(exe_wreg==1)&(ID_rs2IsReg))|((id_rd==exe_rd)&(exe_wreg==1)&(i_sw));
	assign mem_bdepen=((id_rs2==mem_rd)&(mem_wreg==1)&(ID_rs2IsReg))|((id_rd==mem_rd)&(mem_wreg==1)&(i_sw));
	assign id_adepen[0]=mem_adepen;
	assign id_adepen[1]=mem_adepen|exe_adepen;
	assign id_bdepen[0]=mem_bdepen|aluimm;
	assign id_bdepen[1]=mem_bdepen|exe_bdepen;
	
	assign id_btaken=(pcsource[0]==0)&(pcsource[1]==0);//������ת��btakenΪ1
	
	//�ж��Ƿ���load��أ��������wpcΪ1��ͣһ������
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
