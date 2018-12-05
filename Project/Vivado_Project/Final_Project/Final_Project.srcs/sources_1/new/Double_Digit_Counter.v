`timescale 1ns / 1ps
//TODO: Make minute increment and hour increment buttons actually work
//////////////////////////////////////////////////////////////////////////////////
// Company: UW-Stout
// Engineer: Jacob Hillebrand
//
// Create Date: 09/25/2018 01:44:55 PM
// Design Name: 24-hr Clock
// Module Name: Double_Digit_Counter
// Project Name: DSD_FINAL_PROJECT
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module Double_Digit_Counter(
    input clk,
    input reset,
    input HB_INC,
    input MB_INC,
    input EN_HM,
    input EN_SEC,
    output reg [4:1] ENABLE,
    output reg [7:0] SEGMENT
    );

    reg [25:1] DIVIDER;
    reg [23:0] BCD;
    reg [3:0] DECODE_BCD;
    integer STATE = 1;

    wire SCAN_clk;
    wire HB_INC_clk;
    wire MB_INC_clk;
    wire clk_wire;
    
    //Controls the value of reg 'divider'; if 'reset' is pressed
    //divider is set to zero, and otherwise is incremental on the
    //clock tick.
    always @(negedge clk or posedge reset)
        begin
            if(reset)
                DIVIDER <= 24'h000000;
            else
                DIVIDER <= DIVIDER + 1;
        end
   assign SCAN_clk = DIVIDER[25];
   //Assign clk to wire to avoid routing issue?????


   // finite state machine for the debouncing circuit//??????????????????????????????
   db_fsm U1 (.clk(clk), .reset(reset), .sw(HB_INC), .db(HB_INC_clk));
   db_fsm U2 (.clk(clk), .reset(reset), .sw(MB_INC), .db(MB_INC_clk));


   //Controls the value of bcd for every possible change method
   always @(posedge HB_INC_clk or posedge reset or posedge MB_INC_clk or posedge SCAN_clk)
    begin
        //For when the reset button is pressed
        if(reset) begin
            BCD <= 24'h000000;
            STATE <= 0;
            end
            
        //For when the "Hour increment" button is pressed
        else if (HB_INC_clk) begin
            if (BCD[19:16] == 4'h4)
                if (BCD[23:20] == 4'h2)
                    BCD <= 24'h000000;
                else
                    begin
                        BCD[23:20] = BCD[23:20] + 1;
                        BCD[19:0] = 20'h00000;
                    end
            else
                begin
                    BCD[19:16] = BCD[19:16] +1;
                end   
        end
        
        //For when the "Minute increment" button is pressed
        else if (MB_INC_clk) begin
            if (BCD[11:8] == 4'h9)
                if (BCD[15:12] ==4'h5)
                    if (BCD[19:16] == 4'h4)
                        if (BCD[23:20] == 4'h2)
                            BCD <= 24'h000000;
                        else
                            begin
                                BCD[23:20] = BCD[23:20] + 1;
                                BCD[19:0] = 20'h00000;
                            end
                    else
                        begin
                            BCD[19:16] = BCD[19:16] +1;
                            BCD[15:0] = 16'h0000;
                        end   
                else
                    begin
                        BCD[15:12] = BCD[15:12] + 1;
                        BCD[11:0] = 12'h000;
                    end
            else
                begin
                    BCD[11:8] <= BCD[11:8] + 1;
                end
        end
        
        //For when the clock signals the seconds to increment
        else if (SCAN_clk)
            begin
                    if(BCD[3:0] == 4'h9)
                        begin
                        if (BCD[7:4] == 4'h5)
                            if (BCD[11:8] == 4'h9)
                                if (BCD[15:12] ==4'h5)
                                    if (BCD[19:16] == 4'h4)
                                        if (BCD[23:20] == 4'h2)
                                            BCD <= 24'h000000;
                                        else
                                            begin
                                                BCD[23:20] = BCD[23:20] + 1;
                                                BCD[19:0] = 20'h00000;
                                            end
                                    else
                                        begin
                                            BCD[19:16] = BCD[19:16] +1;
                                            BCD[15:0] = 16'h0000;
                                        end   
                                else
                                    begin
                                        BCD[15:12] = BCD[15:12] + 1;
                                        BCD[11:0] = 12'h000;
                                    end
                            else
                                begin
                                    BCD[11:8] <= BCD[11:8] + 1;
                                    BCD[7:0] <= 8'h00;
                                end
                        else
                            begin
                                BCD[7:4] = BCD[7:4] + 1;
                                BCD[3:0] = 4'h0;
                            end
                    end
                else
                    begin
                    BCD[3:0] <= BCD[3:0] + 1;
                    end
              end
      end
      
      // Controller for the hour/min vs seconds on the display
          always @(posedge clk)
              begin
                  if (EN_HM)
                      STATE <= 0;
                  else if (EN_SEC)
                      STATE <= 1;
              end


    // Enable the LED Display
    // Based on the STATE variable, the proper displays will be enabled
    always @(posedge clk)
        begin
            if (STATE == 0)
                ENABLE <= {4'b11,ENABLE[3:1],ENABLE[4]};
            else if (STATE == 1)
                ENABLE <= {4'b11,ENABLE[1],ENABLE[2]};
        end


    //Data display multiplexer
    // If the display is set to hours/minutes (ie. STATE == 0) the 
    // display will choose to display the proper times
    always @(ENABLE or BCD)
        begin
            case (ENABLE)
                4'b1110 : if (STATE == 1'b0)
                              DECODE_BCD <= BCD[11:8];
                          else 
                              DECODE_BCD <= BCD[3:0];
                4'b1101 : if(STATE == 1'b0)
                              DECODE_BCD <= BCD[15:12];
                          else
                              DECODE_BCD <= BCD[7:4];
                4'b1011 : DECODE_BCD <= BCD[19:16];
                4'b0111 : DECODE_BCD <= BCD[23:20];
                default : DECODE_BCD <= BCD[23:20];
            endcase
        end


    // BCD to Seven Segment Decoder
    always @(DECODE_BCD)
        begin
            case (DECODE_BCD)
                4'h0    :  SEGMENT = {1'b1, 7'b1000000}; //0
                4'h1    :  SEGMENT = {1'b1, 7'b1111001}; //1
                4'h2    :  SEGMENT = {1'b1, 7'b0100100}; //2
                4'h3    :  SEGMENT = {1'b1, 7'b0110000}; //3
                4'h4    :  SEGMENT = {1'b1, 7'b0011001}; //4
                4'h5    :  SEGMENT = {1'b1, 7'b0010010}; //5
                4'h6    :  SEGMENT = {1'b1, 7'b0000010}; //6
                4'h7    :  SEGMENT = {1'b1, 7'b1111000}; //7
                4'h8    :  SEGMENT = {1'b1, 7'b0000000}; //8
                4'h9    :  SEGMENT = {1'b1, 7'b0010000}; //9
                default :  SEGMENT = {1'b1, 7'b1111111};
            endcase
        end
        
endmodule

