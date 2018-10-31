`timescale 1ns / 1ps

module Add_rca_4(
    output c_out,
    output [3:0] sum,
    input [3:0] a,
    input [3:0] b,
    input c_in
    );

wire c_in2, c_in3, c_in4;
Add_full M1 (c_in2, sum[0], a[0], b[0], c_in );
Add_full M2 (c_in3, sum[1], a[1], b[1], c_in2);
Add_full M3 (c_in4, sum[2], a[2], b[3], c_in3);
Add_full M4 (c_out, sum[3], a[3], b[3], c_in4);

endmodule
