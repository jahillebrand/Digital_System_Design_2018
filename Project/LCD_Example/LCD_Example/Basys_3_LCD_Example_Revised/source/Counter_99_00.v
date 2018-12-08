/*******************************************
 * This is a Liquid Crystal Display (LCD) Example *
 *           for Basys-3 FPGA               *
 *******************************************/ 

/************************************************
 * 99-00 Down Counter And Display In LCM (LCD) With : *
 *   1. Normal Count : Display Count Value      *
 *   2. Count To 00  : Display Time Over!!      *  
 *             									*
 ************************************************/ 
 
module Counter_99_00 (
input CLK,
input RESET,
output LCM_RW,
output LCM_EN, 
output LCM_RS, 
output reg [7:0] LCM_DATA 
);

	reg    [7:0]  TIME_BCD;
    reg	   [25:1] DIVIDER;
	reg    [5:0]  LCM_COUNT;
	reg    TIME_OVER;
    reg    LCM_RW;
    reg    LCM_RS;
	wire	  INIT_CLK;
    wire   COUNT_CLK;
    wire   LCM_EN;
	
    /***********************
    * Time Base Generator *
    * Basys-3 Board with a 100MHz Clock
    * f=1/100MHz = 1*10^-8 and to generate following clock
    * 1*10^-8 * DIVIDER[16]=0.65ms
    * 1*10^-8 * DIVIDER[17]=1.31ms
    * 1*10^-8 * DIVIDER[26]=0.67sec
    * 1*10^-8 * DIVIDER[27]=1.34sec
    ***********************/
 
  always @(posedge CLK or posedge RESET)
   if (RESET) 
    DIVIDER <= {24'h000000,1'b0};
   else
	   DIVIDER <= DIVIDER + 1;
 
   assign INIT_CLK  = DIVIDER[17];  //LCM clock
   assign COUNT_CLK = DIVIDER[25];	 //count down timer clock rate
   assign LCM_EN    = INIT_CLK; // Clock for LCM Enable pin
  
/******************************
 * Initial And Write LCM Data *
 ******************************/

    always @(posedge INIT_CLK or posedge RESET)
    if (RESET)
    begin
        LCM_COUNT = 0;
        LCM_RW   <= 1'b0;
    end
	  else
     begin
	    case (LCM_COUNT)
	  0 :
		begin
	    LCM_RS   <= 1'b0;
	    LCM_DATA <= 8'h38;   
	 end
      2 : LCM_DATA <= 8'h01;   
	  3 : LCM_DATA <= 8'h06;   
  	  4 : LCM_DATA <= 8'h0C;   
      5 : LCM_DATA <= 8'h80;   
  	  6 :
	begin
	      LCM_RS   <= 1'b1;
	      LCM_DATA <= 8'h4C;  // L
	end
  	  7 : LCM_DATA <= 8'h43;  // C
	  8 : LCM_DATA <= 8'h44;  // D
  	  9 : LCM_DATA <= 8'h20;  //   
	  10: LCM_DATA <= 8'h44;  // D
  	  11: LCM_DATA <= 8'h49;  // I
	  12: LCM_DATA <= 8'h53;  // S
  	  13: LCM_DATA <= 8'h50;  // P
	  14: LCM_DATA <= 8'h4C;  // L
      15: LCM_DATA <= 8'h41;  // A
	  16: LCM_DATA <= 8'h59;  // Y
	  17: LCM_DATA <= 8'h20;  // SPACE 
	  18: LCM_DATA <= 8'h54;  // T
      19: LCM_DATA <= 8'h45;  // E
	  20: LCM_DATA <= 8'h53;  // S
      21: LCM_DATA <= 8'h54;  // T
      22:
	begin
          LCM_RS   <= 1'b0;
          LCM_DATA <= 8'hC0;  // Set Cursor
	end
      23:
    begin
         LCM_RS   <= 1'b1;
         if (TIME_OVER)
		  LCM_DATA <= 8'h20;  //	SPACE
		else
		  LCM_DATA <= 8'h43;  //	C   
	  	end
	  24: 
		if (TIME_OVER)
		    LCM_DATA <= 8'h20;	 //	SPACE 
		else
			LCM_DATA <= 8'h6F;	 //	o  
	  25: 
		if (TIME_OVER)
			LCM_DATA <= 8'h20;	 //	SPACE
		else
	        LCM_DATA <= 8'h75;  // u
	  26: 
		    if (TIME_OVER)
		    LCM_DATA <= 8'h54;	 //	T
			else
	        LCM_DATA <= 8'h6E;  // n	  
	  27:
		if (TIME_OVER)
			LCM_DATA <= 8'h69;	 //	i
		else
	        LCM_DATA <= 8'h74;  // t
							 
	 28:
			if (TIME_OVER)
			LCM_DATA <= 8'h6D;	 //	m
			else
   	        LCM_DATA <= 8'h44;  //	D
	 29: 
			if (TIME_OVER)
			LCM_DATA <= 8'h65;	 //	e
			else
	        LCM_DATA <= 8'h6F;  // o	 
	  30: 	
			if (TIME_OVER)
			LCM_DATA <= 8'h20;	 //	SPACE 
			else
            LCM_DATA <= 8'h77;  // w
	  31: 	
			if (TIME_OVER)
			LCM_DATA <= 8'h4F;	 //	O
			else 
            LCM_DATA <= 8'h6E;  // n
      32: 
		  	if (TIME_OVER)
			LCM_DATA <= 8'h76;	 //	v
			else
            LCM_DATA <= 8'h20;  // space
	  33: 
			if (TIME_OVER)
			LCM_DATA <= 8'h65;	 //	e
			else
	         LCM_DATA <= 8'h20;  // SPACE 
	  34: 
			if (TIME_OVER)
			LCM_DATA <= 8'h72;	 //	r
	  		else		
            LCM_DATA <= 8'h3A;  //  :
	  35: 
			if (TIME_OVER)
			LCM_DATA <= 8'h21;	 //	!
		 	else
            LCM_DATA <= 8'h20;  // SPACE 
      36:
			if (TIME_OVER)
			LCM_DATA <= 8'h21;	 //	!
			else
            LCM_DATA <= 8'h20;  // SPACE	
	  37:
			if (TIME_OVER)
			LCM_DATA <= 8'h20;	 //	SPACE
			else
            LCM_DATA <= {4'h3,TIME_BCD[7:4]};  
	  38:
			if (TIME_OVER)
			LCM_DATA <= 8'h20;	 //	SPACE
			else
            LCM_DATA <= {4'h3,TIME_BCD[3:0]};  
	     
	     default   : 
			LCM_DATA <= LCM_DATA;	
	    endcase 
     
     
      if (LCM_COUNT < 38)
        LCM_COUNT = LCM_COUNT + 1;
	  else
	   LCM_COUNT = 22;
	  end 

/*******************************
 * Down_Counter Range 99 To 00 *
 *******************************/

  always @(posedge COUNT_CLK or posedge RESET)
   if (RESET)
	begin
        TIME_BCD  <= 8'h99;
		TIME_OVER <= 1'b0;
	end
   else
	begin
        TIME_BCD[3:0]    <= TIME_BCD[3:0] - 1;
	    if (TIME_BCD[3:0]==	4'h0)
		begin
  	    TIME_BCD[3:0]<= 4'h9;
		TIME_BCD[7:4]<= TIME_BCD[7:4] - 1;
		end
          
		if (TIME_BCD ==	8'h00)
		TIME_OVER  <= 1'b1;
	   end

endmodule 