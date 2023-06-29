`timescale 1ns/1ps

module INSTRUCTION_DECODE(
	clk,
	rst,
	IR,
	PC,
	MW_RD,
	MW_ALUout,
	//MEM_RW,
	
	A,
	B,
	RD,
	ALUctr,
	branch_or_not,
	ID_branch_PC,
	//ID_RW,
	ID_MW,
	ID_MR,
	ID_sw_data
);

input clk,rst;
input [31:0]IR, PC, MW_ALUout;
input [4:0] MW_RD;
//input [2:0] MEM_RW;


output reg [31:0] A, B,ID_branch_PC,ID_sw_data;
output reg [4:0] RD;
output reg [2:0] ALUctr,branch_or_not,ID_MW,ID_MR;

reg [31:0]temp_A;
//register file
reg [31:0] REG [0:31];

//Write back
always @(posedge clk)//add new Dst REG source here
	if(rst)
	   begin
	       REG[0] <=32'b0;
           REG[1] <=32'd1;
           REG[2] <=32'd2;
       end
	else if(MW_RD)
	  REG[MW_RD] <= MW_ALUout;
	else
	  REG[MW_RD] <= REG[MW_RD];//keep REG[0] always equal zero

//set A, and other register content(j/beq flag and address)	
always @(posedge clk or posedge rst)
begin
	if(rst) 
	  begin
	    A 	<=32'b0;
	    ///REG[0] <=32'b0;
		///REG[1] <=32'd1;
		///REG[2] <=32'd2;
	  end 
	else 
	  begin
	    A 	<=REG[IR[25:21]];
	  end
end

//set control signal, choose Dst REG, and set B	
always @(posedge clk or posedge rst)
begin
	if(rst) 
	  begin
		B 		<=32'b0;
		RD 		<=5'b0;
		ALUctr 	<=3'b0;
		branch_or_not <=3'b0;
		ID_branch_PC <=32'd0;
		//ID_RW <=3'd0;
		ID_MR <=3'd0;
		ID_MW <=3'b0;
		ID_sw_data <=32'b0;
	  end 
	else 
	  begin
	    case(IR[31:26])
		  6'd0://R-Type
		    begin
			  case(IR[5:0])//funct & setting ALUctr
			    6'd32://add
				  begin
					branch_or_not <=3'b0;
					//ID_RW <=3'd0;
					ID_MR <=3'd0;
					ID_MW <=3'b0;
		            B	<=REG[IR[20:16]];
		            RD	<=IR[15:11];
					ALUctr <=3'd0;//self define ALUctr value
				  end
				6'd33://mod
				  begin
					branch_or_not <=3'b0;
					//ID_RW <=3'd0;
					ID_MR <=3'd0;
					ID_MW <=3'b0;
		            B	<=REG[IR[20:16]];
		            RD	<=IR[15:11];
					ALUctr <=3'd5;//self define ALUctr value
				  end
				6'd34://sub
				  begin
					branch_or_not <=3'b0;
					//ID_RW <=3'd0;
					ID_MR <=3'd0;
					ID_MW <=3'b0;
					B	<=REG[IR[20:16]];
					RD	<=IR[15:11];
					//define sub behavior here
					ALUctr <=3'd1;//self define ALUctr value
				  end
				6'd35://div
				  begin
					branch_or_not <=3'b0;
					//ID_RW <=3'd0;
					ID_MR <=3'd0;
					ID_MW <=3'b0;
		            B	<=REG[IR[20:16]];
		            RD	<=IR[15:11];
					ALUctr <=3'd6;//self define ALUctr value
				  end
				6'd42://slt
				  begin
					//ID_RW <=3'd0;
					ID_MR <=3'd0;
					ID_MW <=3'b0;
					branch_or_not <=3'b0;
					B	<=REG[IR[20:16]];
					RD	<=IR[15:11];
					ALUctr <=3'd2;
					//define slt behavior here
				  end
				6'd36://and
				  begin
					//ID_RW <=3'd0;
					ID_MR <=3'd0;
					ID_MW <=3'b0;
					branch_or_not <=3'b0;
					B	<=REG[IR[20:16]];
					RD	<=IR[15:11];
					ALUctr <=3'd3;
					//define and behavior here
				  end
				6'd37://or
				  begin
					//ID_RW <=3'd0;
					ID_MR <=3'd0;
					ID_MW <=3'b0;
					branch_or_not <=3'b0;
					B	<=REG[IR[20:16]];
					RD	<=IR[15:11];
					ALUctr <=3'd4;
					//define or behavior here
				  end
					
			  endcase
			end	      
		  6'd35://lw
			begin
				branch_or_not <=3'b0;
				//$display("\n\n\nlwwwwww in ID\n\n\n");
				B = {{16{1'b0}},IR[15:0]};
				//$display("B: ",B);
				RD	=IR[20:16];
				//$display("RD: ",RD);
				//ID_RW <=3'd1;
				ID_MR <=3'd1;
				ID_MW <=3'b0;
				ALUctr <=3'd0;
			  //define lw behavior here
			end
	      6'd43://sw
			begin
				//$display("\n\n\nsw in ID\n\n\n");
				branch_or_not <=3'b0;
				B = {{16{1'b0}},IR[15:0]};
				RD	<=IR[20:16];
				//ID_RW <=3'd0;
				ID_MR <=3'd0;
				ID_MW <=3'b1;
				ALUctr <=3'd0;
				ID_sw_data =REG[IR[20:16]];
				//$display("IR[20:16]: %d",IR[20:16]);
				//$display("IR[15:0]: %d",IR[15:0]);
				//$display("sw_data: %d",ID_sw_data);
			  //define sw behavior here
			end
	      6'd4://beq
			begin
				//ID_RW <=3'd0;
				ID_MR <=3'd0;
				ID_MW <=3'b0;
				//$display("A: %d B: %d",REG[IR[25:21]],REG[IR[20:16]]);
				temp_A	=REG[IR[25:21]];
				B	=REG[IR[20:16]];
				//$display("r1: %d r2: %d offset: %d\n",IR[25:21],IR[20:16],IR[15:0]);
				//$display("A: %d B: %d",A,B);
				branch_or_not <=3'b0;
				if(temp_A==B)begin
					branch_or_not <=3'd1;
					ID_branch_PC = {{14{IR[15]}},IR[15:0],{2{1'b0}}};
					ID_branch_PC = ID_branch_PC+PC;
				end
				else
					ID_branch_PC <=PC+4;
			  //define beq behavior here
			end
	      6'd2://j
			begin
				//ID_RW <=3'd0;
				ID_MR <=3'd0;
				ID_MW <=3'b0;
				branch_or_not <=3'd1;
				ID_branch_PC <={PC[31:28],IR[25:0],{2{1'b0}}};
				//$display("ID_branch_PC: ",ID_branch_PC);
			  //define j behavior here
			end
		endcase
	  end
end
endmodule
