`timescale 1ns/1ps
`include "HW.v"

module DUT_tb;

reg clk, rst_n, start;
reg [7:0] multipiler, multipicand; 
wire [15:0] product;
wire done;
reg [2:0]product_number;

reg   rst_delay, done_delay;
wire  rst_pulse, done_pulse;
wire [15:0]test_out;
reg [15:0]error_count, test_count, fail_count;
reg [7:0]loop_count;



parameter test_loop = 8'd9;
parameter interval = 8'hff / test_loop;
parameter total_test = (test_loop+1) * (test_loop+1) + 5;


HW_multipiler DUT(
	.clk(clk), 
	.rst_n(rst_n), 
	.start(start), 
	.multipiler(multipiler), 
	.multipicand(multipicand), 
	.product(product), 
	.done(done));


initial begin
	rst_n <= 0;
	clk <= 0;
	multipiler <= 0;
	multipicand <= 0;
	start <= 0;
	product_number <= 0;
	test_count <= 0;
	loop_count <= 0;
	fail_count <= 0;
end

/********** Waveform output **********/

initial begin
   	$dumpfile("../bin/HW.fsdb");
	$dumpvars;
end


assign test_out = multipiler * multipicand ;

always #0.5 begin
	clk <= ~clk;
end

initial #10 begin
	rst_n <= 1;
end



assign rst_pulse = (rst_delay == 0 && rst_n ==1)? 1 : 0;
assign done_pulse = (done_delay == 0 && done ==1)? 1 : 0;

always@(posedge clk)begin
	rst_delay <= rst_n;
	done_delay <= done;
	fail_count <= fail_count + 1;
end


always@(posedge clk or negedge rst_n)begin
	if(rst_n == 0) begin
		start <= 0;
	end
	else begin 		
		if(done_pulse == 1 || rst_pulse == 1)begin
			start<= 1;
		end
		else begin
			start<= 0;
		end
	end	
end


always@(posedge start)begin
	if(start == 1) begin 
		if(test_count==0)begin
			multipiler  <= 8'b11010;
			multipicand <= 8'b01011;
		end
		else if(test_count==1)begin
			multipiler  <= 8'h0;
			multipicand <= 8'hff;
		end
		else if(test_count==2)begin
			multipiler  <= 8'hff;
			multipicand <= 8'h1;
		end
		else if(test_count==3)begin
			multipiler  <= 8'hff;
			multipicand <= 8'h0;
		end
		else if(test_count==4)begin
			multipiler  <= 8'h1;
			multipicand <= 8'hff;
		end
		else if(test_count==5)begin
			multipiler  <= 8'h0;
			multipicand <= 8'h0;
		end
		else if(test_count==6)begin
			multipiler  <= 8'hff;
			multipicand <= 8'hff;
		end
		else begin
			if(loop_count == test_loop)begin
				multipiler  <= 8'hff;
				multipicand <= multipicand - interval;
				loop_count <= 0;
			end
			else begin 
				multipiler <= multipiler - interval;
				loop_count <= loop_count + 1;
			end
			
		end
			
	end	
end

always@(posedge clk or negedge rst_n)begin
	if(rst_n == 0) begin
		error_count <=0;
	end
	else if(done_pulse == 1) begin 
		test_count <= test_count + 1 ;
	
		if (test_out == product)begin
		$display("=================test_number_%0d=====================" ,test_count);
			$display("multipiler   = %0d multipicand = %0d ", multipiler, multipicand);
			$display("correct_prod = %0d ", test_out);
			$display("your_answer  = %0d  ", product);

		end
		else begin	
			error_count = error_count + 1 ;
			$display("=================test_number_%0d_error=====================" ,test_count);
			$display("multipiler   = %0d multipicand = %0d ", multipiler, multipicand);
			$display("correct_prod = %0d ", test_out);
			$display("your_answer  = %0d  ", product);
		end
		
		if (test_count == total_test)begin
			if(error_count == 0)begin
			$display("===============test finish==================");
			$display("Total_error = %0d",error_count);
			$display("===============success!!====================");
			$finish;
			end
			else begin
			$display("===============test finish==================");
			$display("Total_error = %0d",error_count);
			$display("===================fail=====================");
			$finish;
			end
			
		end						
	end	
end

always@(posedge clk)begin
	if(fail_count == 16'hfff0)begin
		$display("===================fail=====================");
		$finish;
	end
end

endmodule
