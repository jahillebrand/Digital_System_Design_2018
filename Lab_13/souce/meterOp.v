
//************************************************************
// this module takes in the digital signal that is given from
// the ADC and compares it to set values to control which LEDs
// on the Nexys 3 board to turn on/off.
// this is all triggered on the positive edge done signal from
// serialCom. (attached in topblock)
//************************************************************
module meterOp(
	input clk,					// trigger to start comparing
	input [11:0] digital,	// digital signal in from ADC
	output reg [7:0] led,		// signal to LED output
	input switch
	);
		
	always @(posedge clk) begin
		if(switch) begin			// when switch is high, the PmodAD1 is in use and uses different voltage levels
			if(digital<12'd2)				// lowest level (no LEDs on)
				led <= 8'b00000000;
			else if(digital<12'd900)	// first level
				led <= 8'b00000001;
			else if(digital<12'd950)
				led <= 8'b00000011;
			else if(digital<12'd1000)
				led <= 8'b00000111;
			else if(digital<12'd1050)
				led <= 8'b00001111;
			else if(digital<12'd1100)
				led <= 8'b00011111;
			else if(digital<12'd1150)
				led <= 8'b00111111;
			else if(digital<12'd1200)
				led <= 8'b01111111;
			else if(digital>12'd1250)	// highest level (all LEDs on)
				led <= 8'b11111111;
		end
		
		else begin							// when switch is low, the PmodMIC is in use
		if(digital<12'd2)					// lowest level (no LEDs on)
				led <= 8'b00000000;
			else if(digital<12'd100)	// first level
				led <= 8'b00000001;
			else if(digital<12'd400)
				led <= 8'b00000011;
			else if(digital<12'd700)
				led <= 8'b00000111;
			else if(digital<12'd1000)
				led <= 8'b00001111;
			else if(digital<12'd1300)
				led <= 8'b00011111;
			else if(digital<12'd1600)
				led <= 8'b00111111;
			else if(digital<12'd1900)
				led <= 8'b01111111;
			else if(digital>12'd1900)	// highest level (all LEDs on)
				led <= 8'b11111111;
		end
	end
endmodule
