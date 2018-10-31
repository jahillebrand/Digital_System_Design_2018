`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UW-Stout
// Engineer: Jacob Hillebrand
// 
// Create Date: 10/25/2018 03:28:48 PM
// Design Name: clockdiv
// Module Name: clockdiv
// Project Name: clockdiv
// Target Devices: 
// Tool Versions: 
// Description: clock divider for vga display maze program
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clockdiv(
    input wire clk,  //master clock: 100 MHz
    input wire clr,  //asynchronous reset
    output wire dclk,  //pixel clock : 25MHz
    output wire segclk //7-segmetn clock: 381Hz
    );
    
//17-bit counter variable
reg [17:0] q;

// CLock divider -- 
// Each bit in q is a clock signal that is 
// only a fraction of the master clock.
always @(posedge clk)
begin
    if (clr == 1)
        q <= 0;
    else
        q <= q + 1'b1;  //mod-2 circuit where q = 50 MHz
end

//50MHz / 2^17 = 381 Hz
assign segclk = q[17];
//50MHz / 2^1 = 25MHz
assign dclk = q[1];

endmodule
