`timescale 1ns/1ps

module EXECUTION(
	clk,
	rst,
	A,
	B,
	DX_RD,
	ALUctr,
	//ID_RW,
	ID_MW,
	ID_MR,
	ID_sw_data,
	
	ALUout,
	XM_RD,
	//EXE_RW,
	EXE_MW,
	EXE_MR,
	EXE_sw_data
);

input clk,rst;
//input [2:0]ALUop;
input [31:0] A,B,ID_sw_data;
input [4:0]DX_RD;
input [2:0] ALUctr,ID_MW,ID_MR;

output reg [31:0]ALUout,EXE_sw_data;
output reg [4:0]XM_RD;
output reg [2:0]EXE_MW,EXE_MR;

//set pipeline register
always @(posedge clk or posedge rst)
begin
  if(rst)
    begin
	  XM_RD	<= 5'd0;
	  //EXE_RW <=ID_RW;
	  EXE_MW <=ID_MW;
	  EXE_MR <=ID_MR;
	  EXE_sw_data <=ID_sw_data;
	end 
  else 
	begin
	  XM_RD <= DX_RD;
	  //EXE_RW <=ID_RW;
	  EXE_MW <=ID_MW;
	  EXE_MR <=ID_MR;
	  EXE_sw_data <=ID_sw_data;
	end
end

// calculating ALUout
always @(posedge clk or posedge rst)
begin
  if(rst)
    begin
	  ALUout	<= 32'd0;
	end 
  else 
	begin
	  case(ALUctr)
	    3'd0: //add //lw //sw
		  begin
	        ALUout <=A+B;
		  end
		3'd1: //sub
		  begin
			ALUout <=A-B;
		    //define sub behavior here
		  end
		3'd2:
		  begin
			ALUout=(A<B)?1:0;
		  end
		3'd3:
		  begin
		  /*
			//$display("\n\n\n and in EXE\n\n\n");
			ALUout[0]=(A[0]&&B[0]);
			ALUout[1]=(A[1]&&B[1]);
			ALUout[2]=(A[2]&&B[2]);
			ALUout[3]=(A[3]&&B[3]);
			ALUout[4]=(A[4]&&B[4]);
			ALUout[5]=(A[5]&&B[5]);
			ALUout[6]=(A[6]&&B[6]);
			ALUout[7]=(A[7]&&B[7]);
			ALUout[8]=(A[8]&&B[8]);
			ALUout[9]=(A[9]&&B[9]);
			ALUout[10]=(A[10]&&B[10]);
			ALUout[11]=(A[11]&&B[11]);
			ALUout[12]=(A[12]&&B[12]);
			ALUout[13]=(A[13]&&B[13]);
			ALUout[14]=(A[14]&&B[14]);
			ALUout[15]=(A[15]&&B[15]);
			ALUout[16]=(A[16]&&B[16]);
			ALUout[17]=(A[17]&&B[17]);
			ALUout[18]=(A[18]&&B[18]);
			ALUout[19]=(A[19]&&B[19]);
			ALUout[20]=(A[20]&&B[20]);
			ALUout[21]=(A[21]&&B[21]);
			ALUout[22]=(A[22]&&B[22]);
			ALUout[23]=(A[23]&&B[23]);
			ALUout[24]=(A[24]&&B[24]);
			ALUout[25]=(A[25]&&B[25]);
			ALUout[26]=(A[26]&&B[26]);
			ALUout[27]=(A[27]&&B[27]);
			ALUout[28]=(A[28]&&B[28]);
			ALUout[29]=(A[29]&&B[29]);
			ALUout[30]=(A[30]&&B[30]);
			ALUout[31]=(A[31]&&B[31]);
			*/
		  end
		3'd4:
		  begin
			//$display("\n\n\n or in EXE\n\n\n");
			//$display("A:%d B:%d",A,B);
			/*
			ALUout[0]=(A[0]||B[0]);
			ALUout[1]=(A[1]||B[1]);
			ALUout[2]=(A[2]||B[2]);
			ALUout[3]=(A[3]||B[3]);
			ALUout[4]=(A[4]||B[4]);
			ALUout[5]=(A[5]||B[5]);
			ALUout[6]=(A[6]||B[6]);
			ALUout[7]=(A[7]||B[7]);
			ALUout[8]=(A[8]||B[8]);
			ALUout[9]=(A[9]||B[9]);
			ALUout[10]=(A[10]||B[10]);
			ALUout[11]=(A[11]||B[11]);
			ALUout[12]=(A[12]||B[12]);
			ALUout[13]=(A[13]||B[13]);
			ALUout[14]=(A[14]||B[14]);
			ALUout[15]=(A[15]||B[15]);
			ALUout[16]=(A[16]||B[16]);
			ALUout[17]=(A[17]||B[17]);
			ALUout[18]=(A[18]||B[18]);
			ALUout[19]=(A[19]||B[19]);
			ALUout[20]=(A[20]||B[20]);
			ALUout[21]=(A[21]||B[21]);
			ALUout[22]=(A[22]||B[22]);
			ALUout[23]=(A[23]||B[23]);
			ALUout[24]=(A[24]||B[24]);
			ALUout[25]=(A[25]||B[25]);
			ALUout[26]=(A[26]||B[26]);
			ALUout[27]=(A[27]||B[27]);
			ALUout[28]=(A[28]||B[28]);
			ALUout[29]=(A[29]||B[29]);
			ALUout[30]=(A[30]||B[30]);
			ALUout[31]=(A[31]||B[31]);
			//$display("ALUout:%d",ALUout);
			*/
		  end
		3'd5:
		  begin
			ALUout=A%B;
		  end
		3'd6:
		  begin
			ALUout=A/B;
		  end
	  endcase
	end
end
endmodule
	
