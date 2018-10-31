`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UW-Stout
// Engineer: Jacob Hillebrand
// 
// Create Date: 10/09/2018 03:12:20 PM
// Design Name: Decoder_OSU
// Module Name: Decoder_OSU
// Project Name: Decoder_OSU
// Target Devices: 
// Tool Versions: 
// Description: Decoder to display button input from keypad on seven
//segment display
// 
// Dependencies: 
// 
// Revision: Initial (0.01)
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Decoder_OSU(
    input clk,
    input reset,
    input [3:0] Row,
    output reg [3:0] Col,
    output reg [3:0] DecodeOut
    );
//Create registry for clock divider (debounce)
reg [19:0] divider;

//Initiate Clock Divider to debounce switch input
always @(posedge clk or posedge reset)
    begin
        if(reset)
            divider <= 20'b00000000000000000000;
        else
            divider <= divider + 1;
    end

always @(posedge clk)
begin

//1st Column
// 1ms delay for switch debounces
//20'b00011000011010100000 in binary, decimal equivalent: 100000
    if (divider == 20'b00011000011010100000)
    //Scanning Column 1
        Col <= 4'b0111;
//20'b00011000011010101000 in binary //decimal eq: 100008
    else if (divider == 20'b00011000011010101000)
        begin
        //Scanning keys on Row 1
            if (Row == 4'b0111)
                DecodeOut <= 4'b0001; //1
        //Scanning Keys on Row 2
            else if (Row == 4'b1011)
                DecodeOut <= 4'b0100; //4
        //Scanning Keys on Row 3
            else if (Row == 4'b1101)
                DecodeOut <= 4'b0111; //7
        //Scanning Keys on Row 4
            else if (Row == 4'b1110)
                DecodeOut <= 4'b0000; //0
         end
         
//2nd Column
//2ms Delay for switch debounce
//20'b00110000110101000000 in binary, decimal equivalent: 200000
    else if (divider == 20'b00110000110101000000)
    //Scanning Column 2
        Col <= 4'b1011;
        //20'b00110000110101001000 in binary/ 200008 in decimal
        else if (divider == 20'b00110000110101001000)
            begin
                //Scanning keys on Row 1
                    if (Row == 4'b0111)
                        DecodeOut <= 4'b0010; //2
                //Scanning keys on Row 2
                    else if (Row == 4'b1011)
                        DecodeOut <= 4'b0101; //5
                //Scanning keys on Row 3
                    else if (Row == 4'b1101)
                        DecodeOut <= 4'b1000; //8
                //Scanning keys on Row 4
                    else if (Row == 4'b1110)
                        DecodeOut <= 4'b1111; //F/15
            end
            
//3rd Column
//4ms Delay for switch debounce
//20'b01100001101010000000 in binary, decimal equivalent: 400000
    else if (divider == 20'b01100001101010000000)
    //Scanning Column 3
        Col <= 4'b1101;
        //20'b01100001101010001000 in binary/ 400008 in decimal
        else if (divider == 20'b01100001101010001000)
            begin
                //Scanning keys on Row 1
                    if (Row == 4'b0111)
                        DecodeOut <= 4'b0011; //3
                //Scanning keys on Row 2
                    else if (Row == 4'b1011)
                        DecodeOut <= 4'b0110; //6
                //Scanning keys on Row 3
                    else if (Row == 4'b1101)
                        DecodeOut <= 4'b1001; //9
                //Scanning keys on Row 4
                    else if (Row == 4'b1110)
                        DecodeOut <= 4'b1110; //E/14
            end     
            
            
//4th Column
//8ms Delay for switch debounce
//20'b11000011010100000000 in binary, decimal equivalent: 800000
    else if (divider == 20'b11000011010100000000)
    //Scanning Column 4
        Col <= 4'b1110;
        //20'b11000011010100001000 in binary/ 800008 in decimal
        else if (divider == 20'b11000011010100001000)
            begin
                //Scanning keys on Row 1
                    if (Row == 4'b0111)
                        DecodeOut <= 4'b1010; //A/10
                //Scanning keys on Row 2
                    else if (Row == 4'b1011)
                        DecodeOut <= 4'b1011; //B/11
                //Scanning keys on Row 3
                    else if (Row == 4'b1101)
                        DecodeOut <= 4'b1100; //C/12
                //Scanning keys on Row 4
                    else if (Row == 4'b1110)
                        DecodeOut <= 4'b1101; //D/13
            end 
    end                 
endmodule
