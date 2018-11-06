`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UW-Stout
// Engineer: Jacob Hillebrand
// 
// Create Date: 11/06/2018 03:19:31 PM
// Design Name: pwm_leds
// Module Name: pwm_leds
// Project Name: pwm_leds
// Target Devices: 
// Tool Versions: 
// Description: Controller for DC motor using switches
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pwm_leds(
    input wire clk,
    input wire [7:0] SW,
    //output wire dir,
    output reg pwm
    );
    
parameter sd = 390;

//assign dir = 0;

//Create a counter that counts from 0 to 100,000
reg [16:0] counter = 0;

always @(posedge clk)
begin
    counter = counter + 1'b1;
    
    //switches*sd can vary from 0 to near 100,000
    
    if (counter <= SW*sd) pwm = 1;
    
    else pwm = 0;
    
    if (counter >= 100000) counter = 0;
    
end
    
endmodule
