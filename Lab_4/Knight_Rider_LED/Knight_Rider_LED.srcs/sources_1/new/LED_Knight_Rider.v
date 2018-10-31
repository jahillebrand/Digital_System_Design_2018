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
    output reg[7:0] LED
    );
    
reg [29:1] DIVIDER;
reg DIRECTION;
wire SHIFT_clk;
wire FAST_clk;
wire SLOW_clk;
wire speed;

//Clock Generator
always @(posedge clk or posedge reset)
    begin
        if(reset)
            DIVIDER <= {28'h0000000,1'b0};
        else
            DIVIDER <= DIVIDER + 1;
    end
    
assign FAST_clk = DIVIDER[20];  //0.02 second
assign SLOW_clk = DIVIDER[21];  //0.04 second
assign speed = DIVIDER[29];  //10.74 second

assign SHIFT_clk = speed ? FAST_clk : SLOW_clk;

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
