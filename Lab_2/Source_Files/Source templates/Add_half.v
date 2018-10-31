`timescale 1ns / 1ps

module Add_half(
    output c_out,
    output sum,
    input a,
    input b
    );

xor (sum,a,b);
and (c_out,a,b);
endmodule
