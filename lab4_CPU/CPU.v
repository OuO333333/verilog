`timescale 1ns/1ps

`include "INSTRUCTION_FETCH.v"
`include "INSTRUCTION_DECODE.v"
`include "EXECUTION.v"
`include "MEMORY.v"

module CPU(
	input clk, 
	input rst,
    input sw0,
    input sw1,
    input sw2,
    input sw3,
    input sw4,
    input sw5,
    input sw6,
    input sw7,
    input sw8,
	input sw9,
    input sw10,
    input sw11,
	input sw12,

    output a,
    output b,
    output c,
    output d,
    output e,
    output f,
    output g,
    output d0,
    output d1,
    output d2,
    output d3,
    output d4,
    output d5,
    output d6,
    output d7 
);

wire [31:0] input_number;
reg [31:0] first_number,second_number;
reg [17:0] counter;
reg [2:0] state;
reg [6:0] seg_number,seg_data;
reg [7:0] scan;
reg [7:0] counter2;
reg clk2;

/*============================== Wire  ==============================*/
// INSTRUCTION_FETCH wires
wire [31:0] FD_PC, FD_IR,branch_PC_wire;
wire [2:0] branch_wire;
// INSTRUCTION_DECODE wires
wire [31:0] A, B;
wire [4:0] DX_RD;
wire [2:0] ALUctr;
// EXECUTION wires
wire [31:0] XM_ALUout;
wire [4:0] XM_RD;
// DATA_MEMORY wires
wire [31:0] MW_ALUout;
wire [4:0]	MW_RD;
//RW,MW,MR wires
wire [2:0] MD_RW;
wire [2:0] DX_RW,DX_MW,DX_MR;
wire [2:0] XM_RW,XM_MW,XM_MR;
//store word wire
wire [31:0] DX_sw_data,XM_sw_data;

assign input_number = {sw12,sw11,sw10,sw9,sw8,sw7,sw6,sw5,sw4,sw3,sw2,sw1,sw0};

/*============================== INSTRUCTION_FETCH  ==============================*/

INSTRUCTION_FETCH IF(
	.clk(clk2),
	.rst(rst),
	.branch(branch_wire),
	.branch_PC(branch_PC_wire),
	//.MEM_RW(MF_RW),

	.PC(FD_PC),
	.IR(FD_IR)
);

/*============================== INSTRUCTION_DECODE ==============================*/

INSTRUCTION_DECODE ID(
	.clk(clk2),
	.rst(rst),
	.PC(FD_PC),
	.IR(FD_IR),
	.MW_RD(MW_RD),
	.MW_ALUout(MW_ALUout),
	//.MEM_RW(MD_RW),

	.A(A),
	.B(B),
	.RD(DX_RD),
	.ALUctr(ALUctr),
	.branch_or_not(branch_wire),
	.ID_branch_PC(branch_PC_wire),
	//.ID_RW(DX_RW),
	.ID_MW(DX_MW),
	.ID_MR(DX_MR),
	.ID_sw_data(DX_sw_data)
);

/*==============================     EXECUTION  	==============================*/

EXECUTION EXE(
	.clk(clk2),
	.rst(rst),
	.A(A),
	.B(B),
	.DX_RD(DX_RD),
	.ALUctr(ALUctr),
	//.ID_RW(DX_RW),
	.ID_MW(DX_MW),
	.ID_MR(DX_MR),
	.ID_sw_data(DX_sw_data),
	//.ALUop(),


	.ALUout(XM_ALUout),
	.XM_RD(XM_RD),
	//.EXE_RW(XM_RW),
	.EXE_MW(XM_MW),
	.EXE_MR(XM_MR),
	.EXE_sw_data(XM_sw_data)
);

/*==============================     DATA_MEMORY	==============================*/

MEMORY MEM(
	.clk(clk2),
	.rst(rst),
	.ALUout(XM_ALUout),
	.XM_RD(XM_RD),
	//.EXE_RW(XM_RW),
	.EXE_MW(XM_MW),
	.EXE_MR(XM_MR),
	.EXE_sw_data(XM_sw_data),
	.input_number(input_number),

	.MW_ALUout(MW_ALUout),
	.MW_RD(MW_RD)
	//.MEM_RW(MD_RW)
);

always @(posedge clk) begin
    counter2 <= (counter2 <= 100)? (counter2 + 1): 0;
    clk2     <= (counter2 == 100)? ~clk2: clk2;
end

//wtite down your code here
always@(posedge clk) begin
	second_number <= MEM.DM[2];
	first_number <= MEM.DM[1];
end

//8é¡?(d0~d7)7-segment(a~g)é¡¯ç¤º dp?‚º?³ä¸‹è?’ç??.
assign {d7,d6,d5,d4,d3,d2,d1,d0} = scan;
always@(posedge clk) begin
  counter <=(counter<=100000) ? (counter +1) : 0;
  state <= (counter==100000) ? (state + 1) : state;
   case(state)
	0:begin
	  seg_number <= first_number/1000;//6?‹switch?¼æ?å¤šç‚º63,63/10=6,é¡¯ç¤º?œ¨å·¦é??
	  scan <= 8'b0111_1111;
	end
	1:begin
	  seg_number <= (first_number%1000)/100;//63%10=3,é¡¯ç¤º?œ¨?³???
	  scan <= 8'b1011_1111;
	end
	2:begin
	  seg_number <= (first_number%100)/10;
	  scan <= 8'b1101_1111;
	end
	3:begin
	  seg_number <= first_number%10;
	  scan <= 8'b1110_1111;
	end
	4:begin
	  seg_number <= second_number/1000;//63*63=3969,3969/1000=3
	  scan <= 8'b1111_0111;
	end
	5:begin
	  seg_number <= (second_number%1000)/100;//3969%1000=969,969/1000=9
	  scan <= 8'b1111_1011;
	end
	6:begin
	  seg_number <= (second_number%100)/10;
	  scan <= 8'b1111_1101;
	end
	7:begin
	  seg_number <= second_number%10;
	  scan <= 8'b1111_1110;
	end
	default: state <= state;
  endcase 
end  

//7-segment è¼¸å‡º?•¸å­—è§£ç¢?
assign {g,f,e,d,c,b,a} = seg_data;
always@(posedge clk) begin  
  case(seg_number)
	16'd0:seg_data <= 7'b100_0000;
	16'd1:seg_data <= 7'b111_1001;
	16'd2:seg_data <= 7'b010_0100;
	16'd3:seg_data <= 7'b011_0000;
	16'd4:seg_data <= 7'b001_1001;
	16'd5:seg_data <= 7'b001_0010;
	16'd6:seg_data <= 7'b000_0010;
	16'd7:seg_data <= 7'b101_1000;
	16'd8:seg_data <= 7'b000_0000;
	16'd9:seg_data <= 7'b001_0000;
	default: seg_number <= seg_number;
  endcase
end 

endmodule
