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
    
    //For LCD
    output LCM_RW, LCM_EN, LCM_RS,
    output reg [7:0] LCM_DATA,
    
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
    
    //LCD declarations
    reg [5:0] LCM_COUNT;
    reg LCM_RW;
    reg LCM_RS;
    wire INIT_CLK;
    wire LCM_EN;
    
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
    //for LCD
    assign INIT_CLK = DIVIDER[17]; //LCM clock
    assign LCM_EN = INIT_CLK; //Clock for LCM Enable pin
    
        
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
    
        /******************************
     * Initial And Write LCM Data *
     ******************************/  
    
    //Always block for setting LCD Display
    always @(posedge INIT_CLK or posedge RESET)
    if (RESET)
        begin
            LCM_COUNT = 0;
            LCM_RW <= 1'b0;
        end
    else
        begin
            case (LCM_COUNT)
                0 : 
                    begin
                        LCM_RS <= 1'b0;
                        LCM_DATA <= 8'h38;
                    end
                2 : LCM_DATA <= 8'h01;
                3 : LCM_DATA <= 8'h06;
                4 : LCM_DATA <= 8'h0C;
                5 : LCM_DATA <= 8'h80;
                6 : 
                    begin
                        LCM_RS <= 1'b1;
                        LCM_DATA <= 8'h20; //SPACE
                    end 
                7 : LCM_DATA <= 8'h20; //SPACE
                8 : LCM_DATA <= 8'h32; //2
                9 : LCM_DATA <= 8'h34; //4
                10 : LCM_DATA <= 8'h2D; //-
                11 : LCM_DATA <= 8'h48; //H
                12 : LCM_DATA <= 8'h72; //r
                13 : LCM_DATA <= 8'h2E; //.
                14 : LCM_DATA <= 8'h20; //SPACE
                15 : LCM_DATA <= 8'h43; //C
                16 : LCM_DATA <= 8'h6C; //l
                17 : LCM_DATA <= 8'h6F; //o
                18 : LCM_DATA <= 8'h63; //c
                19 : LCM_DATA <= 8'h6B; //k
                20 : LCM_DATA <= 8'h20; //SPACE
                21 : LCM_DATA <= 8'h20; //SPACE
                22 : 
                    begin
                        LCM_RS <= 1'b0;
                        LCM_DATA <= 8'hC0; // Set Cursor
                    end
                23 :
                    begin
                        LCM_RS <= 1'b1;
                        LCM_DATA <= 8'h20; //SPACE
                    end
                24 : LCM_DATA <= 8'h20; //SPACE
                25 : LCM_DATA <= 8'h20; //SPACE
                26 : LCM_DATA <= 8'h20; //SPACE
                27 : LCM_DATA <= {4'h3, BCD[23:20]};
                28 : LCM_DATA <= {4'h3, BCD[19:16]};
                29 : LCM_DATA <= 8'h3A; //:
                30 : LCM_DATA <= {4'h3, BCD[15:12]};
                31 : LCM_DATA <= {4'h3, BCD[11:8]};
                32 : LCM_DATA <= 8'h3A; //:
                33 : LCM_DATA <= {4'h3, BCD[7:4]};
                34 : LCM_DATA <= {4'h3, BCD[3:0]};
                35 : LCM_DATA <= 8'h20; //SPACE
                36 : LCM_DATA <= 8'h20; //SPACE
                37 : LCM_DATA <= 8'h20; //SPACE
                38 : LCM_DATA <= 8'h20; //SPACE
                default : LCM_DATA <= LCM_DATA;
            endcase
            
            if (LCM_COUNT < 38)
                LCM_COUNT = LCM_COUNT + 1;
            else
                LCM_COUNT = 22;
        end
    
endmodule
