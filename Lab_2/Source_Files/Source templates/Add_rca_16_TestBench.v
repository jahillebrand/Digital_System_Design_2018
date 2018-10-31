`timescale 1ns / 1ps

module Add_rca_16_TestBench;

	// Inputs
	reg [15:0] a;
	reg [15:0] b;
	reg c_in;

	// Outputs
	wire c_out;
	wire [15:0] sum;

	// Instantiate the Unit Under Test (UUT)
	Add_rca_16 uut (
		.c_out(c_out), 
		.sum(sum), 
		.a(a), 
		.b(b), 
		.c_in(c_in)
	);

   initial
	
	//unit, precision, "ns" string, string minwidth
	$timeformat(-9,1,"ns",12);

	initial begin
		
	// Initialize Inputs
	#0 	a = 16'b0000000000000000; b = 16'b0000000000000000; c_in = 1'b0;
	#10 a = 16'b0000000000000111; b = 16'b0000000000000011; c_in = 1'b0;
	#10	a = 16'b0000000000001111; b = 16'b0000000000000011; c_in = 1'b0;
	#10	a = 16'b0000000000011111; b = 16'b0000000000000011; c_in = 1'b1;
	#10	a = 16'b0000000001111111; b = 16'b0000000000000011; c_in = 1'b0;
	
	end
	
	// Add stimulus here
	always @(a or b or c_in or sum or c_out)	
	#1 $display("Time=%t, a=%b, b=%b, c_in=%b, c_out=%b, sum=%b", $time,a,b,c_in,c_out,sum);
	
	
	
      
endmodule

