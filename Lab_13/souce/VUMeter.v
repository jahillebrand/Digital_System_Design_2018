`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date:    23:08:42 11/19/2016 
// Design Name: A Microphone Triggers LED
// Module Name:    Mic_Demo 
// Project Name: Digital design final
// Target Devices: Basys-3 FPGA board
// Tool versions: 
// Description: This project is designed to be uploaded onto a Basys 3 board
//	with a PmodMic connected to the lower half of JA1 Pmod connector.
// This program will take input from the on-board ADC converter from the PmodMic device
// and will analyze it, and turn on/off the LEDs on the Basys 3 board according to the
// analog signal input from the ADC.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Mic_Demo(
	input wire clk, 			// clock signal from the 100 Mhz clock on board
	input wire reset,			// system reset, mapped to onboard pushbutton
	output wire [7:0] LED,	    // outputs to the 8 on board LEDs
	output sclk,	            // SCLK - divided clock output of 12.5 Mhz			
	output CS,                  // nCS Ccontrols signal sending from the ADC on PmodMic devices				
	input switch,               // 
	input sdata					// sData signal used to recieve data from Pmod device
    );
	
	wire done;					// used to tell meterOp when to turn lights on or off
	wire [11:0] dig;			// used to link the digital output from serialCom to meterOp
	
	clkDiv U0 (.CLK(clk),.RST(reset),.sclk(sclk));
	serialCom U1 (.clk(sclk),.reset(reset),.sdata(sdata),.digital(dig),.CS(CS),.done(done),.switch(switch));
	meterOp U2 (.clk(done),.digital(dig),.led(LED),.switch(switch));
	endmodule





