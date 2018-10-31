`timescale 1ns / 1ps

// Segment display controller for the Number Pad display
// Created on 10/09/2018
// Author: Jacob Hillebrand

module SegDisplay(
    input [3:0] DispVal,
    output wire [3:0] anode,
    output reg [6:0] segOut
    );
assign anode = 4'b1110;

//CONVERT KEY CODE INTO ASCII HERE ?????

always @(DispVal)
begin
case (DispVal)

    4'b0001 : segOut = 7'b1111001; //1
    4'b0010 : segOut = 7'b0100100; //2
    4'b0011 : segOut = 7'b0110000; //3
    4'b0100 : segOut = 7'b0011001; //4
    4'b0101 : segOut = 7'b0010010; //5
    4'b0110 : segOut = 7'b0000010; //6
    4'b0111 : segOut = 7'b1111000; //7
    4'b1000 : segOut = 7'b0000000; //8
    4'b1001 : segOut = 7'b0010000; //9
    4'b1010 : segOut = 7'b0001000; //10
    4'b1011 : segOut = 7'b0000000; //11
    4'b1100 : segOut = 7'b1000110; //12
    4'b1101 : segOut = 7'b1000000; //13
    4'b1110 : segOut = 7'b0000110; //14
    4'b1111 : segOut = 7'b0001110; //15
    
    default : segOut = 7'b1000000; //0/Default
endcase
end

endmodule