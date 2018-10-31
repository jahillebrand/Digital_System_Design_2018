`timescale 1ns / 1ps

module Add_rca_16(
    output c_out,
    output [15:0] sum,
    input [15:0] a,
    input [15:0] b,
    input c_in
    );

wire c_in4, c_in8, c_in12;
Add_rca_4 M1(c_in4,   sum[3:0], a[3:0], b[3:0], c_in);
Add_rca_4 M2(c_in8,   sum[7:4], a[7:4], b[7:4], c_in4);
Add_rca_4 M3(c_in12,  sum[11:8], a[11:8], b[11:8], c_in8);
Add_rca_4 M4(c_out,   sum[15:12], a[15:12], b[15:12], c_in12);
endmodule
