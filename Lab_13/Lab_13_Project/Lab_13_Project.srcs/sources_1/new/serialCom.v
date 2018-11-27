`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UW-Stout
// Engineer: Jacob Hillebrand
// 
// Create Date: 11/15/2018 03:17:57 PM
// Design Name: seialCom
// Module Name: serialCom
// Project Name: Mic_Demo
// Target Devices: Basys 3 FPGA
// Tool Versions: 
// Description: Provides the state machine for the design of the Mic_Demo
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module serialCom(
    input clk,
    input reset,
    input sdata,
    output reg [11:0] digital,
    output reg CS,
    output reg done,
    input switch
    );
    
    
// delcaration of states
parameter idle = 2'b01,
            shift_in = 2'b10,
            sync_data = 2'b11;

// declare other necessary regs
reg start;
reg [15:4] temp;
reg [2:0] state;
reg [4:0] count;
   
//state register
always @(posedge clk or posedge reset)
begin
    if(reset)
        begin
            state <= idle;
            start <= 1'b0;
            count <= 4'b0000;
            CS <= 1'b1;
            temp <= 12'b000000000000;
            digital <= 12'b000000000000;
            done <= 1'b1;
        end
    else
    begin
        case (state)
            idle:
                if(start == 1'b1 && count < 16)
                    state <= shift_in;
                else
                    begin
                        done <= 1'b1;
                        start <= 1'b1;
                        count <= 4'b0001;
                        CS <= 1'b1;
                        temp <= 12'b000000000000;
                        digital <= 12'b000000000000;
                        state <= idle; //Maybe don't leave this at idle?
                    end
            shift_in:
                if (start == 1'b1 && count == 16)
                    state = sync_data;
                else
                    begin
                        CS <= 1'b0;
                        done <= 1'b0;
                        if (count > 3)
                            begin
                                if(switch)
                                    begin
                                        temp[19-count] <= sdata;
                                    end
                            end
                            count <= count +1'b1;
                            state <= shift_in;
                    end
            sync_data:
                if (start == 1'b0)
                    state <= idle;
                else 
                    begin
                        digital [11:0] <= temp [15:4];
                        CS <= 1'b1;
                        done <= 1'b0;
                        start <= 1'b0;
                        state = sync_data;
                    end
            default: state = idle;
        endcase
    
    end
end
        
endmodule
