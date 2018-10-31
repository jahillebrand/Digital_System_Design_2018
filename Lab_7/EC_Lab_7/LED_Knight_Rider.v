`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jacob Hillebrand
// 
// Create Date: 09/20/2018 03:34:36 PM
// Design Name: Knight_Rider_LED
// Module Name: LED_Knight_Rider
// Project Name: Knight_Rider_LED
// Target Devices: 
// Tool Versions: 
// Description: This design is an 8-bit Knight Rider LED control with a Clock 
//Frequency divider circuit
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LED_Knight_Rider(
    input clk,
    input reset,
    input [3:0] DispLED,
    output reg[7:0] LED
    );
    
reg [29:0] DIVIDER;
reg DIRECTION;
wire SHIFT_clk;
reg speed;

//Clock Generator
always @(posedge clk or posedge reset)
    begin
        if(reset)
            DIVIDER <= {28'h0000000,1'b00};
        else
            DIVIDER <= DIVIDER + 1;
    end
    
//Keypad input to LED speed displays
//Calls in decoder to knightRider module
always @(DispLED)
begin
case (DispLED)
    4'b0001 : speed = DIVIDER[28]; // 5.12 sec when key "1" is pressed
    4'b0010 : speed = DIVIDER[27]; // "2" key
    4'b0011 : speed = DIVIDER[26]; // 3
    4'b0100 : speed = DIVIDER[25]; // 4
    4'b0101 : speed = DIVIDER[24]; // 5
    4'b0110 : speed = DIVIDER[23]; // 6
    4'b0111 : speed = DIVIDER[22]; // 7
    4'b1000 : speed = DIVIDER[21]; // 8
    4'b1001 : speed = DIVIDER[20]; // 9
    4'b1010 : speed = DIVIDER[19]; // A
    4'b1011 : speed = DIVIDER[18]; // B
    default : speed = DIVIDER[29];
  
endcase
end


// How fast the LEDs rotate
assign SHIFT_clk = speed;

//8-bit knight rider light control
always @(posedge SHIFT_clk or posedge reset)
begin
    if(reset)
        begin
            DIRECTION <= 1'b0;
            LED <= 8'b11000000;  //"1100_0000b"
        end
    else
        begin
            if(LED == 8'b00000110) //"0000_0110b"
                DIRECTION <= 1'b1;
            else if (LED == 8'b01100000) //"0110_0000b"
                DIRECTION <= 1'b0;
            if (DIRECTION)
                LED <= LED<<1;
            else
                LED <= LED>>1;
                
        end
         end      
            
        
endmodule
