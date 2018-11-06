`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UW-Stout
// Engineer: Jacob Hillebrand
// 
// Create Date: 11/06/2018 03:29:57 PM
// Design Name: pwm_dc_motor
// Module Name: pwm_dc_motor
// Project Name: pwm_dc_motor
// Target Devices: 
// Tool Versions: 
// Description: Its a module for controlling the pwm_dc_motor
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pwm_dc_motor(
    input wire clk,
    input wire [7:0] SW,
    output wire dir,
    output reg pwm
    );
    
parameter sd = 390;

assign dir = 0;

// use a 17-bit counter to generate a period of
//100,000 counts in a loop
reg [16:0] counter = 0;

always @(posedge clk)
    begin 
        counter = counter + 1'b1;
        //sitches*sd can vary from 0 to near 50,000 counts
        if (counter <= SW*sd) pwm = 1;
            else pwm = 0;
        if (counter >= 100000) counter = 0;
    end
endmodule
