`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module vga640x480(
	input wire dclk,			//pixel clock: 25MHz
	input clr,			//asynchronous reset
	input up,
	input down,
	input left,
	input right,
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	//Nexys4 DDR uses 12 bits per pixel but this project uses 8 bits per pixel for each RGB color.
	output reg [2:0] red,	//red vga output
	output reg [2:0] green, //green vga output
	output reg [1:0] blue	//blue vga output
	);

// video structure constants 
//Signal timings for a 640-pixel by 480 row display using a 25 MHz pixel clock and 60 Hz vertical refresh
//see the signal timings on page 17 on the Nexys4 DDR FPGA Board Reference Manual

parameter hpixels = 10'd800;// horizontal Sync pulse (Ts) 
parameter vlines = 10'd521; // vertical sync lines (Ts)
parameter hpulse = 7'd96; 	// hsync pulse width Tpw
parameter vpulse = 2'd2; 	// vsync lines Tpw
parameter hbp = 8'd144; 	// end of horizontal back porch
parameter hfp = 10'd784; 	// beginning of horizontal front porch
parameter vbp = 5'd31; 		// end of vertical back porch
parameter vfp = 10'd511; 	// beginning of vertical front porch
reg[9:0] ball_x_min = 10'd320; // beginning of ball x min
reg[9:0] ball_x_max = 10'd330; // beginning of ball x max
reg[9:0] ball_y_min = 10'd210; // beginning of ball y min
reg[9:0] ball_y_max = 10'd220; // beginning of ball y max

//This project code uses 640-pixel by 480-row
// active horizontal video is therefore: 784 - 144 = 640 (T_disp, Horizontal video)
// active vertical video is therefore: 511 - 31 = 480 (T_disp, Vertical video

// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;
reg frame_rate;
reg stop;

always @(*)
begin
 //here defines vc (vertical line counter) and hc (horizontal pixel counter)
 //start a new frame when the counters vc & hc reach the vertical and horizontal back porch on the screen
	if(vc == vbp && hc == hbp)
		frame_rate <= 1'b1;
	else
		frame_rate <= 1'b0;
end

//start a new picture frame and display the movement of the ball, includes collision and movement via the 4 buttons
always @(posedge frame_rate)
begin
			if (clr)
			begin
			    //This defines ball's start position on the screen
				
				ball_x_min <= 10'd280;
                ball_x_max <= 10'd290;
				ball_y_min <= 10'd210;
				ball_y_max <= 10'd220;
			end
			
			//here define the stop line for the ball. If ball hits this line on the screen
            //the end line displays aqua (cyan) color (mix of green and blue)
			else if(ball_x_max <= 10'd700 && ball_x_min >= 10'd670 && ball_y_min >= 10'd300 && ball_y_max <= 10'd330)
				stop <= 1'b1;
			else
				stop <= 1'b0;
			
			//move the ball up the screen	
			if (up)
			begin
				ball_y_min <= ball_y_min - 1'b1;
				ball_y_max <= ball_y_max - 1'b1;
			end
			
			//move the ball down the screen
			else if (down)
			begin
				ball_y_min <= ball_y_min + 1'b1;
				ball_y_max <= ball_y_max + 1'b1;
			end
			
			//move the ball to left of the screen
			if(left)
			begin
				ball_x_min <= ball_x_min - 1'b1;
				ball_x_max <= ball_x_max - 1'b1;
			end
			
			//move the ball to right of the screen
			else if (right)
			begin
				ball_x_min <= ball_x_min + 1'b1;
				ball_x_max <= ball_x_max + 1'b1;
			end
			
			//the ball position is defined. If the ball hits the place where the wall is defined,
			//the ball is reset to the starting position.
			if(ball_y_min == 10'd200 && ball_x_min >= (10'd350) && ball_x_max <= 10'd400)
			begin
				ball_x_min <= 10'd320;
				ball_x_max <= 10'd330;
				ball_y_min <= 10'd210;
				ball_y_max <= 10'd220;

			end
        //move the ball to the starting position if it hits the walls
		else if(ball_y_max == 10'd230 && ball_x_min >= (10'd350) && ball_x_max <= 10'd430)
			begin
				ball_x_min <= 10'd320;
				ball_x_max <= 10'd330;
				ball_y_min <= 10'd210;
				ball_y_max <= 10'd220;

			end
        //move the ball to the starting position if it hits the walls
		else if(ball_x_min == 10'd400 && ball_y_max <= 10'd200 && ball_y_min >= 10'd100)
			begin
				ball_x_min <= 10'd320;
				ball_x_max <= 10'd330;
				ball_y_min <= 10'd210;
				ball_y_max <= 10'd220;

			end
        //move the ball to the starting position if it hits the walls
		else if(ball_x_max == 10'd430 && ball_y_min <= 10'd230 && ball_y_max >= 10'd130)
			begin
				ball_x_min <= 10'd320;
				ball_x_max <= 10'd330;
				ball_y_min <= 10'd210;
				ball_y_max <= 10'd220;

			end
        //move the ball to the starting position if it hits the walls
		else if(ball_y_min == 10'd100 && ball_x_min >= 10'd400 && ball_x_max <= 10'd600)
			begin
				ball_x_min <= 10'd320;
				ball_x_max <= 10'd330;
				ball_y_min <= 10'd210;
				ball_y_max <= 10'd220;
			end
        //move the ball to the starting position if it hits the walls
		else if(ball_y_max == 10'd130 && ball_x_min >= 10'd430 && ball_x_max <= 10'd570)
			begin
				ball_x_min <= 10'd320;
				ball_x_max <= 10'd330;
				ball_y_min <= 10'd210;
				ball_y_max <= 10'd220;

			end
        //move the ball to the starting position if it hits the walls
		else if(ball_x_max == 10'd600 && ball_y_max >= 10'd100 && ball_y_min <= 10'd300)
			begin
				ball_x_min <= 10'd320;
				ball_x_max <= 10'd330;
				ball_y_min <= 10'd210;
				ball_y_max <= 10'd220;

			end
        //move the ball to the starting position if it hits the walls
		else if(ball_x_min == 10'd570 && ball_y_max >= 10'd130 && ball_y_min <= 10'd330)
			begin
				ball_x_min <= 10'd320;
				ball_x_max <= 10'd330;
				ball_y_min <= 10'd210;
				ball_y_max <= 10'd220;

			end
        //move the ball to the starting position if it hits the walls
		else if(ball_y_max == 10'd300 && ball_x_min >= 10'd600 && ball_x_max <= 10'd700)
			begin
				ball_x_min <= 10'd320;
				ball_x_max <= 10'd330;
				ball_y_min <= 10'd210;
				ball_y_max <= 10'd220;
			end

        //move the ball to the starting position if it hits the walls
		else if(ball_y_min == 10'd330 && ball_x_min >= 10'd570 && ball_x_max <= 10'd700)
			begin
				ball_x_min <= 10'd320;
				ball_x_max <= 10'd330;
				ball_y_min <= 10'd210;
				ball_y_max <= 10'd220;

			end
        //move the ball to the starting position if it hits the walls
		else if(ball_x_max == 10'd700 && ball_y_max >= 10'd300 && ball_y_min <= 10'd330)
			begin
				ball_x_min <= 10'd320;
				ball_x_max <= 10'd330;
				ball_y_min <= 10'd210;
				ball_y_max <= 10'd220;

			end
end
	
// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
// ------------------------
// Sequential "always block", which is a block that is
// only triggered on signal transitions or "edges".
// posedge = rising edge  &  negedge = falling edge
// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
always @(posedge dclk)
begin
		// keep counting until the end of the line
		if (hc < hpixels - 1'b1)
			hc <= hc + 1'b1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 1'b0;
			if (vc < vlines - 1'b1)
				vc <= vc + 1'b1;
			else
				vc <= 1'b0;
		end
		
	//end
end

// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type
assign hsync = (hc < hpulse) ? 1'b0:1'b1;
assign vsync = (vc < vpulse) ? 1'b0:1'b1;

// display 100% saturation colorbars
// ------------------------
// Combinational "always block", which is a block that is
// triggered when anything in the "sensitivity list" changes.
// The asterisk implies that everything that is capable of triggering the block
// is automatically included in the sensitivty list.  In this case, it would be
// equivalent to the following: always @(hc, vc)
// Assignment statements can only be used on type "reg" and should be of the "blocking" type: =


//This is not all but this is the general idea behind how the reset button “clr” works, how the 
//buttons operate the green square, and that when the square hits the red lines, it sends it back to
//the beginning.  

//Now here is the code that creates the maze on the screen.


always @(hc or vc)
begin
	// first check if we're within vertical active video range
	if (vc >= vbp && vc < vfp)
	begin
		// now display different colors every 80 pixels
		// while we're within the active horizontal range
		// -----------------
		// display white bar
		//IF IT DOESN'T WORK PUT BACK HERE "took out porch"
		
		//8-bit string can make up to 256 (0-255) combinations of colors
		//Now, If we assign 1 Byte (8 bits)
        
        //each pixel is represented by one 8-bit byte
        //The maximum number of colors that can be displayed at any one time is 256
        // 8 bits directly describe red, green, and blue values, typically with 3 bits for red, 
        //3 bits for green and 2 bits for blue
        //Bit    7  6  5  4  3  2  1  0
        //Data   R  R  R  G  G  G  B  B

		if(vc == 10'd200 && hc >= (10'd350) && hc <= 10'd400)
			begin
				red = 3'b111;  //111
				green = 3'b000;
				blue = 2'b00;
			end

		else if(vc == 10'd230 && hc >= (10'd350) && hc <= 10'd430)
			begin
				red = 3'b111;  //111
				green = 3'b000;
				blue = 2'b00;
			end

		else if(hc == 10'd400 && vc <= 10'd200 && vc >= 10'd100)
			begin
				red = 3'b111; //111
				green = 3'b000;
				blue = 2'b00;
			end

		else if(hc == 10'd430 && vc <= 10'd230 && vc >= 10'd130)
			begin
				red = 3'b111; //111
				green = 3'b000;
				blue = 2'b00;
			end

		else if(vc == 10'd100 && hc >= 10'd400 && hc <= 10'd600)
			begin
				red = 3'b111; //111
				green = 3'b000;
				blue = 2'b00;
			end

		else if(vc == 10'd130 && hc >= 10'd430 && hc <= 10'd570)
			begin
				red = 3'b111; //111
				green = 3'b000;
				blue = 2'b00;
			end

		else if(hc == 10'd600 && vc >= 10'd100 && vc <= 10'd300)
			begin
				red = 3'b111; //111
				green = 3'b000;
				blue = 2'b00;
			end

		else if(hc == 10'd570 && vc >= 10'd130 && vc <= 10'd330)
			begin
				red = 3'b111; //111
				green = 3'b000;
				blue = 2'b00;
			end

		else if(vc == 10'd300 && hc >= 10'd600 && hc <= 10'd700)
			begin
				red = 3'b111;//111
				green = 3'b000;
				blue = 2'b00;
			end

		else if(vc == 10'd330 && hc >= 10'd570 && hc <= 10'd700)
			begin
				red = 3'b111;//111
				green = 3'b000;
				blue = 2'b00;
			end

		else if(hc == 10'd700 && vc >= 10'd300 && vc <= 10'd330)
			begin
				red = 3'b111;//111
				green = 3'b000;
				blue = 2'b00;
			end
			
		//here define the stop line for the ball. If ball hits this line on the screen
		//the end line displays aqua (cyan) color (mix of green and blue)
		else if ((hc <= 10'd700 && hc >= 10'd670 && vc >= 10'd300 && vc <= 10'd330) && (stop == 1'b1))
		begin
				red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
		end
		
		//here define the stop line for the ball. If ball hits this line on the screen
        //the end line displays aqua color (mix of green and blue)
		else if(hc == 10'd670 && vc >= 10'd300 && vc <= 10'd330)
			begin
				red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
			end
		else if(hc >= ball_x_min && hc <= ball_x_max && vc >= ball_y_min && vc <= ball_y_max)
		begin
			red = 0;
			green = 3'b111;
			blue = 0;
		end
		// we're outside active horizontal range so display black
		else
		begin
			red = 0;
			green = 0;
			blue = 0;
		end
	end
	// we're outside active vertical range so display black
	else
	begin
		red = 0;
		green = 0;
		blue = 0;
	end
end


endmodule
