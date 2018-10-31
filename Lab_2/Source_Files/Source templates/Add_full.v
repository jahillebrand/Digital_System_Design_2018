/////////////////////////////////////////////////////////////////////////////////
// Design Name:
// Module Name:
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
/////////////////////////////////////////////////////////////////////////////////



`timescale 1ns / 1ps

module Add_full(
    output c_out,
    output sum,
    input a,
    input b,
    input c_in
    );

wire w1, w2, w3;

Add_half M1 (w2, w1, a, b);
Add_half M2 (w3, sum, c_in, w1);
or (c_out, w2, w3);

endmodule
