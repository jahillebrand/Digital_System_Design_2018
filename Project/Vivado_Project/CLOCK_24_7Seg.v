/*********************************************
 * Setable 24 Hour Clock (Hour, Minute) And  * 
 * Display In Scanning Seven Segment With :  * 
 *    In Normal Condition  :                 * 
 *          HH  :  MM                        *  
 *    Press Display Button :                 *    
 *          MM  :  SS                        *  
 * 7 Seconds Later Back To Normal Condition  *             
 *********************************************/

module CLOCK_24_7Seg(

    input CLK, RESET,DISPLAY_BUTTON, MINUTE_BUTTON, HOUR_BUTTON,
    output [4:1] ENABLE,
    output [7:0] SEGMENT              
    );

	 reg    [7:0]  SEGMENT;
	 reg    [4:1]  ENABLE;
	 reg    [3:0]  DECODE_BCD;
     reg    [7:0]  DISPLAY_COUNT;
	 reg    [3:0]  MINUTE_DEBOUNCE;
	 reg    [3:0]  HOUR_DEBOUNCE;
     reg    [25:1] DIVIDER;
	 reg    [23:0] BCD; 
     reg    FLAG;
  //  wire   [3:0] DELIMIT;
    wire   MINUTE_SET;
    wire   HOUR_SET;
    wire   SCAN_CLK;
    wire   DISPLAY_CLK;  
    wire   COUNT_CLK;  
    wire   MINUTE_CLK; 
    wire   HOUR_CLK;    
	 wire   ADJUST_CLK;     
	 wire   MIN_ENABLE;
	 wire   HOUR_ENABLE;
    wire   HOUR;

/***************************
 * All Time Base Generator *
 ***************************/
  
  always @(posedge CLK or posedge RESET)
    begin
      if (RESET) 
        DIVIDER <= {1'b0,24'h000000};
      else
	       DIVIDER <= DIVIDER + 4'h1;
    end  
    
	assign SCAN_CLK    = DIVIDER[16];
    assign DISPLAY_CLK = DIVIDER[20];
 	assign ADJUST_CLK  = DIVIDER[24];
   assign COUNT_CLK   = DIVIDER[25];

/***************************
 * Second Timer With Carry *
 ***************************/

  always @(posedge COUNT_CLK or posedge RESET)
    begin
      if (RESET)
	       BCD[7:0] <= 8'h00;
      else
		 begin
	     if (BCD[3:0] ==	4'h9)
			begin
			 BCD[3:0] <= 4'h0;
			 BCD[7:4] <= BCD[7:4] + 4'h1;
         end
          else
            BCD[3:0] <= BCD[3:0] + 4'h1; 
            
				if (BCD[7:0] ==	8'h59)
					 BCD[7:0]  <= 8'h00;
				end
       end   
	 assign MIN_ENABLE = (BCD[7:0] == 8'h59)? 1'b1 : 1'b0;
   
/**************************************
 * Minute Timer With Enable And Carry *
 **************************************/

  always @(posedge MINUTE_CLK or posedge RESET)
    begin
      if (RESET)
	       BCD[15:8] <= 8'h00;
      else
        if ((MIN_ENABLE) || (MINUTE_SET)) 
			begin
	        if (BCD[11:8]==	4'h9)
				begin
				 BCD[11:8] <= 4'h0;
				 BCD[15:12]<= BCD[15:12] + 4'h1;
              end
            else
              BCD[11:8]  <= BCD[11:8] + 4'h1;
              
					if (BCD[15:8]==	8'h59)
					 BCD[15:8]  <= 8'h00;
					end
				end

		assign HOUR_ENABLE = (BCD[15:8] == 8'h59)? 1'b1 : 1'b0;
		and (HOUR,HOUR_ENABLE,MIN_ENABLE);

/**************************
 * Hour Timer With Enable *
 **************************/

  always @(posedge HOUR_CLK or posedge RESET)
    begin
      if (RESET)
	       BCD[23:16] <= 8'h00;
      else
 			 if ((HOUR) || (HOUR_SET)) 
				begin
	       	 if (BCD[19:16] ==	4'h9)
					begin
					 BCD[19:16] <= 4'h0;
					 BCD[23:20] <= BCD[23:20] + 4'h1;
				   end
            else
              BCD[19:16]   <= BCD[19:16] + 4'h1;
              
       			if (BCD[23:16] ==	8'h23)
					 BCD[23:16]   <= 8'h00;
					end
      end
     
/***************************
 * Enable Display Location *
 ***************************/

  always @(posedge SCAN_CLK or posedge RESET)
    begin
		if (RESET)
		 ENABLE <= 4'b1110;
		else
		 ENABLE <= {ENABLE[3:1],ENABLE[4]};
	 end

/****************************
 * Data Display Multiplexer	*
 ****************************/	

	always @(ENABLE or BCD or FLAG)
    begin
     if (FLAG)
       case (ENABLE)
		  4'b1110: DECODE_BCD = BCD[11:8];
		  4'b1101: DECODE_BCD = BCD[15:12];
		  4'b1011: DECODE_BCD = BCD[19:16];
        4'b0111: DECODE_BCD = BCD[23:20];
		  default: DECODE_BCD = 4'b0111;
		 endcase		
	
     else
		 case (ENABLE)
		  4'b1110: DECODE_BCD = BCD[3:0];
		  4'b1101: DECODE_BCD = BCD[7:4];
		  4'b1011: DECODE_BCD = BCD[11:8];
        4'b0111: DECODE_BCD = BCD[15:12];
	     default: DECODE_BCD = 4'b0111;
		 endcase			 
    end

/********************************
 * BCD To Seven Segment Decoder	*
 ********************************/

		always @(DECODE_BCD)
	   begin
		 case (DECODE_BCD)
		  4'h0    : SEGMENT = {1'b1,7'b1000000};	// 0
		  4'h1    : SEGMENT = {1'b1,7'b1111001};	//	1
		  4'h2    : SEGMENT = {1'b1,7'b0100100};	//	2
		  4'h3    : SEGMENT = {1'b1,7'b0110000};	//	3
		  4'h4    : SEGMENT = {1'b1,7'b0011001};	//	4
		  4'h5    : SEGMENT = {1'b1,7'b0010010};	//	5
		  4'h6    : SEGMENT = {1'b1,7'b0000010};	//	6
		  4'h7    : SEGMENT = {1'b1,7'b1111000};	//	7
		  4'h8    : SEGMENT = {1'b1,7'b0000000};	//	8
		  4'h9    : SEGMENT = {1'b1,7'b0010000};	//	9
        4'hA    : SEGMENT = {1'b1,7'b1110110};	//	ON
		  default : SEGMENT = {1'b1,7'b1111111}; // OFF
		  endcase
    end
 
 /*************************
 * Minute Adjust Circuit *
 *************************/

  always @(posedge SCAN_CLK or negedge MINUTE_BUTTON)
    begin
      if (!MINUTE_BUTTON)
         MINUTE_DEBOUNCE <= 4'h0;
      else
        if (MINUTE_DEBOUNCE < 4'hE)
           MINUTE_DEBOUNCE <= MINUTE_DEBOUNCE + 4'h1;
    end

    
  assign MINUTE_SET = (MINUTE_DEBOUNCE < 4'hE)? 1'b0 : 1'b1;

  
  assign MINUTE_CLK = (MINUTE_SET)? ADJUST_CLK : COUNT_CLK; 

/***********************
 * Hour Adjust Circuit *
 ***********************/

  always @(posedge SCAN_CLK or negedge HOUR_BUTTON)
    begin
      if (!HOUR_BUTTON)
         HOUR_DEBOUNCE <= 4'h0;
      else
         if (HOUR_DEBOUNCE < 4'hE)
            HOUR_DEBOUNCE <= HOUR_DEBOUNCE + 4'h1;
    end       
  assign HOUR_SET = (HOUR_DEBOUNCE < 4'hE)? 1'b0 : 1'b1;
   
  assign HOUR_CLK = (HOUR_SET)? ADJUST_CLK : COUNT_CLK; 

/*************************
 * Multi_Display Circuit *
 *************************/
 
  always @(posedge DISPLAY_CLK or posedge RESET) 
    begin
      if (RESET)
        begin  
          FLAG <= 1'b1;
          DISPLAY_COUNT <= 8'h00;
        end  
      else
        begin
          if (DISPLAY_BUTTON)
            begin
              DISPLAY_COUNT <= 8'hFF;
              FLAG <= 1'b0;
            end  
            
          if (DISPLAY_COUNT > 8'h00)
            DISPLAY_COUNT <= DISPLAY_COUNT - 4'h1;
          else 
            FLAG <= 1'b1;   
        end
    end

endmodule 