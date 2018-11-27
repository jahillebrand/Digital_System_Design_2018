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
    input switch,
    output done,
    output CS,
    output reg [11:0] digital
    );
    
// delcaration of states
localparam [1:0]
    idle      = 2'b00,
    shift_in  = 2'b01,  
    sync_data = 2'b10;
    
reg [3:0] ShiftCounter;

reg nCS;
assign CS = nCS;
reg DONE;
reg START;

reg [1:0] state_reg, state_next;

    
//state register
always @(negedge clk, posedge reset)
    if(reset)
        state_reg <= idle;
    else
        state_reg <= state_next;
        
always @(negedge clk)
    begin
        state_next = state_reg;
        case (state_reg)
            idle:
                begin
                if (START == 1'b1)
                    begin
                    state_next <= shift_in;
                    end
                else
                    begin
                        nCS  <= 1'b1;
                        DONE <= 1'b1;
                    end
                end
            shift_in:
                begin
                if (ShiftCounter == 4'h15)
                    begin
                        state_next <= sync_data;
                    end
                else
                    begin
                        nCS <= 1'b0;
                        DONE <= 1'b0;
                    end
                end
            sync_data:
                begin
                
                end
            default: state_next = idle;
        endcase
    
    end
        
endmodule
