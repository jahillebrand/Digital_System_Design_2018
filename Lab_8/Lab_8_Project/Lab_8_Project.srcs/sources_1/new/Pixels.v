`timescale 1ns/1ps

module Pixels(
    input clk, //master clock = 100 MHz
    input clr, //right-most pushbutton for reset
    input up, //up button
    input down, //down button
    input left, //left button
    input right, //right button
    output [2:0] red, //red vga output - 3 bits
    output [1:0] blue, //blue vga output - 2 bits
    output [2:0] green, //green vga output - 3 bits,
    output hsync,
    output vsync
    );

// VGA display clock interconnect
wire dclk;

// generate 7-segment clock & display clock  
clockdiv U1 (
    .clk(clk),
    .clr(clr),
    .dclk(dclk)
    );  

// VGA controller
vga640x480 U3(
    .dclk(dclk),  //25MHz
    .clr(clr),
    .up(up),
    .down(down),
    .left(left),
    .right(right),
    .hsync(hsync),
    .vsync(vsync),
    .red(red),
    .green(green),
    .blue(blue)
    );
    
    
endmodule
    