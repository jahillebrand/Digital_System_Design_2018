`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UW-Stout
// Engineer: Jacob Hillebrand
// 
// Create Date: 11/13/2018 02:38:18 PM
// Design Name: Clock Divider
// Module Name: divider_v
// Project Name: Servo_PWM
// Target Devices: 
// Tool Versions: 
// Description: This is a divder circuit for the Servo_PWM module
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module divider_v(reset_n, clk, clk_out);
input reset_n;
input clk;
output clk_out;

parameter divisor = 5;
parameter divisor2 = 2;


reg [31:0] cnt1;
reg cnt2;
wire EN;
wire compare1, compare2;

always @(posedge clk or negedge reset_n)
begin
    if (reset_n != 0)
        cnt1 <= 0;
    else if (cnt1 == divisor)
        cnt1 <= 1;
    else
        cnt1 <= cnt1 + 1;
end

assign compare1 = (cnt1 == divisor)? 1:0;
assign compare2 = (cnt1 == divisor2)? 1:0;
assign EN = compare1 | compare2;

always @(posedge clk or negedge reset_n)
begin
    if (reset_n != 0)
        cnt2 <= 0;
    else if (EN)
        cnt2 <= ! cnt2;
end
assign clk_out = cnt2;
            
endmodule
