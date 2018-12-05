`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UW-Stout
// Engineer: Dr. Cheng Liu (with Jacob Hillebrand)
// 
// Create Date: 12/04/2018 04:26:38 PM
// Design Name: 
// Module Name: clock_24_7seg
// Project Name: 24 hr clock for 7-seg display
// Target Devices: 
// Tool Versions: 
// Description: This device is a setable 24 hour clock (Hour, Minute) and
// display in scanning seven segment with:
//      In Normal Condition :
//          HH : MM
//      Press Display Button :
//          MM : SS
// 7 Seconds Later Back To Normal Condition
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock_24_7seg(
    input CLK, RESET, DISPLAY_BUTTON, MINUTE_BUTTON, HOUR_BUTTON,
    output [4:1] ENABLE,
    output [7:0] SEGMENT
    );
    
    //Register declarations
    reg [7:0] SEGMENT;
    reg [4:1] ENABLE;
    reg [3:0] DECODE_BCD;
    reg [7:0] DISPLAY_COUNT;
    reg [3:0] MINUTE_DEBOUNCE;
    reg [3:0] HOUR_DEBOUNCE;
    reg [25:1] DIVIDER;
    reg [23:0] BCD;
    reg FLAG;
    
    //Wire declarations
    wire MINUTE_SET;
    wire HOUR_SET;
    wire SCAN_CLK;
    wire DISPLAY_CLK;
    wire COUNT_CLK;
    wire MINUTE_CLK;
    wire HOUR_CLK;
    wire ADJUST_CLK;
    wire MIN_ENABLE;
    wire HOUR_ENABLE;
    wire HOUR;
    
    /**************************************
    * Base divider for all time generation
    **************************************/
    
    //Time generation divider
    always @(posedge CLK or posedge RESET) begin
        if (RESET)
            DIVIDER <= {1'b0, 24'h000000};
        else
            DIVIDER <= DIVIDER + 4'h1;
    end
    
    //Divider timing assignments
    assign SCAN_CLK = DIVIDER[16];
    assign DISPLAY_CLK = DIVIDER[20];
    assign ADJUST_CLK = DIVIDER[24];
    assign COUNT_CLK = DIVIDER[25];
    
    /**************************************
    * Seconds Timer with carry functions
    **************************************/
    
    //Increment statements
    always @(posedge COUNT_CLK or posedge RESET) begin
        if (RESET)
            BCD[7:0] <= 8'h00;
        else
            begin
                if (BCD[3:0] == 4'h9)
                    begin
                        BCD[3:0] <= 4'h0;
                        BCD[7:4] <= BCD[7:4] + 4'h1;
                    end
                else
                BCD[3:0] <= BCD[3:0] + 4'h1;
                if (BCD[7:0] == 8'h59)
                    BCD[7:0] <= 8'h00;     
            end    
    end
    //Assign the MIN_ENABLE to roll over from 59 sec to 1 min
    assign MIN_ENABLE = (BCD[7:0] == 8'h59)? 1'b1 : 1'b0;
    
    /*********************************************
    * Minute timer with enable and carry functions
    *********************************************/
    
    //Increment Statements
    always @(posedge MINUTE_CLK or posedge RESET) begin
        if (RESET)
            BCD[15:8] <= 8'h00;
        else
            if ((MIN_ENABLE) || (MINUTE_SET))
                begin
                    if (BCD[11:8] == 4'h9)
                        begin
                            BCD[11:8] <= 4'h0;
                            BCD[15:12] <= BCD[15:12] + 4'h1;
                        end
                    else
                        BCD[11:8] <= BCD[11:8] + 4'h1;
                            if (BCD[15:8] == 8'h59)
                                BCD[15:8] <= 8'h00;
                end
    end
    //Assign the HOUR_ENABLE to roll over from 59 min
    assign HOUR_ENABLE = (BCD[15:8] == 8'h59)? 1'b1 : 1'b0;
    //Perform AND operation on HOUR_ENABLE
    // and MIN_ENABLE to roll over the hour
    and (HOUR,HOUR_ENABLE,MIN_ENABLE);
    
    /**************************************
    * Hour timer with enable functions
    **************************************/
    
    //Increment Statements
    always @(posedge HOUR_CLK or posedge RESET) begin
        if (RESET)
            BCD[23:16] <= 8'h00;
        else
            if ((HOUR) || (HOUR_SET))
                begin
                    if (BCD[19:16] == 4'h9)
                        begin
                            BCD[19:16] <= 4'h0;
                            BCD[23:20] <= BCD[23:20] + 4'h1;
                        end
                     else
                        BCD[19:16] <= BCD[19:16] + 4'h1;
                     if (BCD[23:16] == 8'h23)
                        BCD[23:16] <= 8'h00;
                end
    end
    
    /**************************************
    * Enable display location
    **************************************/
    
    //Either reset the diplay to 0 or enable all displays
    always @(posedge SCAN_CLK or posedge RESET) begin
        if (RESET)
            ENABLE <= 4'b1110;
        else
            ENABLE <= {ENABLE[3:1],ENABLE[4]};
    end
    
    /**************************************
    * Data display multiplexer
    **************************************/
    
    //Make BCD -> ENABLE assignments
    //Either enable only the seconds
    //display, or minutes + hours
    always @(ENABLE or BCD or FLAG) begin
        if (FLAG)
            case (ENABLE)
                4'b1110:    DECODE_BCD = BCD[11:8];
                4'b1101:    DECODE_BCD = BCD[15:12];
                4'b1011:    DECODE_BCD = BCD[19:16];
                4'b0111:    DECODE_BCD = BCD[23:20];
                default:    DECODE_BCD = 4'b0111;
            endcase
        else
            case (ENABLE)
                4'b1110:    DECODE_BCD = BCD[3:0];
                4'b1101:    DECODE_BCD = BCD[7:4];
                4'b1011:    DECODE_BCD = BCD[11:8];
                4'b0111:    DECODE_BCD = BCD[15:12];
                default:    DECODE_BCD = 4'b0111;
            endcase
    end
    
    /**************************************
    * BCD to seven segment decoder
    **************************************/
    
    //Seven segment display decoder
    always @(DECODE_BCD) begin
        case (DECODE_BCD)
            4'h0    :   SEGMENT = {1'b1,7'b1000000}; //0
            4'h1    :   SEGMENT = {1'b1,7'b1111001}; //1
            4'h2    :   SEGMENT = {1'b1,7'b0100100}; //2
            4'h3    :   SEGMENT = {1'b1,7'b0110000}; //3
            4'h4    :   SEGMENT = {1'b1,7'b0011001}; //4
            4'h5    :   SEGMENT = {1'b1,7'b0010010}; //5
            4'h6    :   SEGMENT = {1'b1,7'b0000010}; //6
            4'h7    :   SEGMENT = {1'b1,7'b1111000}; //7
            4'h8    :   SEGMENT = {1'b1,7'b0000000}; //8
            4'h9    :   SEGMENT = {1'b1,7'b0010000}; //9
            4'hA    :   SEGMENT = {1'b1,7'b1110110}; //ON
            default :   SEGMENT = {1'b1,7'b1111111}; //OFF
        endcase
    end
    
    /**************************************
    * Minute adjust circuit
    **************************************/
    
    //Debounce the minute button click
    always @(posedge SCAN_CLK or negedge MINUTE_BUTTON) begin
        if (!MINUTE_BUTTON)
            MINUTE_DEBOUNCE <= 4'h0;
        else
            if (MINUTE_DEBOUNCE < 4'hE)
                MINUTE_DEBOUNCE <= MINUTE_DEBOUNCE + 4'h1;
    end
    
    //If the button is truly pressed, assign MINUTE_SET
    assign MINUTE_SET = (MINUTE_DEBOUNCE < 4'hE)? 1'b0 : 1'b1;
    
    //If the MINUTE_SET was triggered, adjust the minutes
    assign MINUTE_CLK = (MINUTE_SET)? ADJUST_CLK : COUNT_CLK;
    
    /**************************************
    * Hour adjust circuit
    **************************************/
    
    //Debounce the hour button click
    always @(posedge SCAN_CLK or negedge HOUR_BUTTON) begin
        if (!HOUR_BUTTON)
            HOUR_DEBOUNCE <= 4'h0;
        else 
            if (HOUR_DEBOUNCE < 4'hE)
                HOUR_DEBOUNCE <= HOUR_DEBOUNCE + 4'h1;
    end
    
    //If the button is truly pressed, assign HOUR_SET
    assign HOUR_SET = (HOUR_DEBOUNCE < 4'hE)? 1'b0 : 1'b1;
    
    //If the HOUR_SET was triggered, adjust the hours
    assign HOUR_CLK = (HOUR_SET)? ADJUST_CLK : COUNT_CLK;
    
    /**************************************
    * Multi_Display circuit
    **************************************/
    
    //Determine whether to show hours or seconds
    always @(posedge DISPLAY_CLK or posedge RESET) begin
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
