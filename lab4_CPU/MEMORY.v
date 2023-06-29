`timescale 1ns/1ps

module MEMORY(
	clk,
	rst,
	ALUout,
	XM_RD,
	//EXE_RW,
	EXE_MW,
	EXE_MR,
	EXE_sw_data,
	input_number,
	
	MW_ALUout,
	MW_RD,
	//MEM_RW
);
input clk, rst;
input [31:0] ALUout,EXE_sw_data;
input [4:0] XM_RD;
input [2:0] EXE_MW,EXE_MR;
input [31:0] input_number;

output reg [31:0] MW_ALUout;
output reg [4:0] MW_RD;
//output reg [2:0] MEM_RW;

//data memory
reg [31:0] DM [0:127];
/*
//always store word to data memory
always @(posedge clk)
  if(XM_MemWrite)
    DM[ALUout[6:0]] <= XM_MD;
*/

//send to Dst REG: "load word from data memory" or  "ALUout"
always @(posedge clk)
begin
  if(rst)
    begin
	  MW_ALUout	<=	32'b0;
	  MW_RD		<=	5'b0;
	  DM[0] <= input_number;
	end
  else if(EXE_MR)begin
	//$display("\n\n\nlwwwwww in MEM\n\n\n");
	MW_ALUout <=DM[ALUout[8:0]];
	MW_RD		<=	XM_RD;
  end
  else if(EXE_MW)begin
	//$display("\n\n\nsw in MEM\n\n\n");
	//$display("ALUout[8:2]: %d",ALUout[8:0]);
	MW_ALUout <=32'b0;
	DM[ALUout[8:0]] <= EXE_sw_data;
	MW_RD <=4'b0;
  end
  else
    begin
	  MW_ALUout	<=	ALUout;
	  MW_RD		<=	XM_RD;
	end
end

endmodule
