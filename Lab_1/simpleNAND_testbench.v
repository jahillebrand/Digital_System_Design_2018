`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:30:57 09/17/2015
// Design Name:   simpleNAND
// Module Name:   C:/Teaching Materials/CEE-325 Fall 2015/Week 1 Sept 8/simpleNAND/simpleNAND/simpleNAND_testbench.v
// Project Name:  simpleNAND
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: simpleNAND
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module simpleNAND_testbench;

	// Inputs
	reg a;
	reg b;

	// Outputs
	wire y;

	// Instantiate the Unit Under Test (UUT)
	simpleNAND uut (
		.y(y), 
		.a(a), 
		.b(b)
	);

// Add stimulus here
//initilize input
   
	initial begin
$timeformat(-9,1,"ns",10); //unit, precision, unit, minwidth between characters
	   #5 a=1'b1; b=1'b1;
		#10 a=1'b0; b=1'b1; 
		#50 a=1'b1; b=1'b1;
		#80 a=1'b0; b=1'b1;
		#150 a=1'b1; b=1'b1;
		#200 a=1'b1; b=1'b0;
		#250 a=1'b1; b=1'b1;		
	end
      
//monitor the output
//initial
//$display("time=%t, a=%b, b=%b, y=%b", $time,a,b,y);

always @(a or b)
$display("time=%t, a=%b, b=%b, y=%b", $time,a,b,y);
      
endmodule

