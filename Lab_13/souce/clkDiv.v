
//************************************************************
// This module divides the onboard 100 Mhz clock to 12.5 Mhz
// for use with the Pmod devices.
//************************************************************
	module clkDiv(
		input CLK,		// input clock
		input RST,		// reset signal
		output sclk	 // 12.5 Mhz divided clock
		);
		reg [3:0] div;											//used to count how many clocks cycles have passed

		always @(posedge CLK or posedge RST)
		begin
			if(RST)
				div <= 1'b0;
			else
				div <= div + 1'b1;
		end
			 
		assign sclk = div[3];	// assigning clk12 output to synced to the third bit in register div
		
	endmodule
