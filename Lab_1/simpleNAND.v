`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:13:17 09/17/2015 
// Design Name: 
// Module Name:    simpleNAND 
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
module simpleNAND(
    output y,
    input a,
    input b
    );

wire w1;

//instantiate logic gate primitives
and (w1, a,b);
not (y, w1);


endmodule
