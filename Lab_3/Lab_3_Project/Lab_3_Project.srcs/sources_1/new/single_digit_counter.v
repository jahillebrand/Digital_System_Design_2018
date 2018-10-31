`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jacob Hillebrand
// 
// Create Date: 09/18/2018 03:17:36 PM
// Design Name: Single_Digit_Counter
// Module Name: single_digit_counter
// Project Name: Single_Digit_Counter
// Target Devices: Artix-7
// Tool Versions: 
// Description: Provides a simple counter
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//Set up module with necessary inputs and outputs
module single_digit_counter(
    input clk,
    input reset,
    output wire pointer,
    output wire [4:1] ENABLE,
    output reg [6:0] SEGMENT
    );
    
    reg [25:1] DIVIDER;
    reg [3:0] BCD;
    wire count_clk;
    
    //Time Generator
    always @(posedge clk or posedge reset)
     begin
        if(reset)
         DIVIDER <= 24'h000000;
          else
          DIVIDER <= DIVIDER +4'h1;
     end
    assign count_clk = DIVIDER[25];
    
    //UP counter from 0 to 9
    always @(posedge count_clk or posedge reset)
     begin
        if(reset)
         BCD <= 4'h0;
         else
          begin
            if(BCD == 4'h9)
             BCD <= 4'h0;
             else
              BCD <= BCD + 4'h1;
            end
          end
    
    
    //BCD to Seven Segment Decoder
    always @(BCD)
    begin
     case(BCD)
       4'h0     : SEGMENT = 7'b1000000; //0
       4'h1     : SEGMENT = 7'b1111001; //1
       4'h2     : SEGMENT = 7'b0100100; //2
       4'h3     : SEGMENT = 7'b0110000; //3
       4'h4     : SEGMENT = 7'b0011001; //4
       4'h5     : SEGMENT = 7'b0010010; //5
       4'h6     : SEGMENT = 7'b0000010; //6
       4'h7     : SEGMENT = 7'b1111000; //7
       4'h8     : SEGMENT = 7'b0000000; //8
       4'h9     : SEGMENT = 7'b0010000; //9
       default  : SEGMENT = 7'b0000000;
     endcase
   end
   
   assign ENABLE = 4'b1011;
   assign pointer = count_clk;
endmodule
