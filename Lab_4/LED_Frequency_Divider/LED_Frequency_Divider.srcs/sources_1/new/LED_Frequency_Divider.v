`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jacob Hillebrand
// 
// Create Date: 09/20/2018 02:44:15 PM
// Design Name: Frequency_Generator
// Module Name: LED_Frequency_Divider
// Project Name: Frequency_Generator
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Frequency Generator:
//On-board oscillator: 100 MHz
//T=1/f=1/(100MHz)=1*10^-8;
//Divider[22]=T*2^23=0.084 second
//Divider[23]=T*2^24=0.168 second
//Divider[24]=T*2^25=0.336 second
//Divider[25]=T*2^26=0.671 second
//Divider[26]=T*2^27=1.342 seconds
//Divider[27]=T*2^28=2.68 seconds
//Divider[28]=T*2^29=5.37 seconds
//Divider[29]=T*2^30=10.73 seconds
//////////////////////////////////////////////////////////////////////////////////


module LED_Frequency_Divider(
    input clk,
    input reset,
    output [7:0] LED
    );
    
reg [30:1] DIVIDER;

//  Frequency Generator

always @(posedge clk or posedge reset)
    begin //pushbutton inputs are normally low on
          //NEXYS boards, and driven high when pressed.
     if (reset) //us a push button on NEXYS-3 as a reset button
        DIVIDER <= {28'h0000000,2'b00}; //use concatenation
                //technique to express a 30-bit divider
     else
        DIVIDER <= DIVIDER + 1'b1;
     end
     
assign  LED[0] = DIVIDER[23], //T = 0.084 second
        LED[1] = DIVIDER[24], //T = 0.186 second
        LED[2] = DIVIDER[25], //T = 0.336 second
        LED[3] = DIVIDER[26], //T = 0.671 second
        LED[4] = DIVIDER[27], //T = 1.342 second
        LED[5] = DIVIDER[28], //T = 2.68 second
        LED[6] = DIVIDER[29], //T = 5.37 second
        LED[7] = DIVIDER[30]; //T = 10.73 second
endmodule
