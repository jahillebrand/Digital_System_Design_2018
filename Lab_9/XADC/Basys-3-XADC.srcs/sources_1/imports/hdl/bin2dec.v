`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// 
// 
// Create Date: 03/23/2017
// 
// 
// Target Devices: Basys 3
// Tool Versions: Vivado 2018.2
// Description: converts an input in the range (0x0000-0xFFFF) to 
// a hex string in the range (16'h0000-16'h1000)
// assert start & din, some amount of time later, 
// done is asserted with valid dout
// Dependencies: none
// 
// 
//
/////////////////////////////////////////////////////////////////

module bin2dec (
    input clk,
    input start,
    input [15:0] din,
    output done,
    output reg [15:0] dout
);
    //{0x0000-0xFFFF}->{"0000"-"1000"} 
    localparam  S_IDLE=0,
                S_DONE=1,
                S_DIVIDE=2,
                S_NEXT_DIGIT=3,
                S_CONVERT=4;
    reg [2:0] state=S_IDLE;
    reg [31:0] data;
    reg [31:0] div;
    reg [3:0] mod;
    reg [1:0] byte_count;
    
    assign done = (state == S_IDLE || state == S_DONE) ? 1 : 0;

    
    always@(posedge clk)
        case (state)
        S_IDLE: begin
            if (start == 1) begin
                state <= S_DIVIDE;
                
                //multiplication, division and modulus operators are binary
                //operators, meaning that the data will be
                //returned as binary number. Examples as below
                
                 // data <= din;
               // data <= ( din * 1000) / 65536;
                // data <= ({4'b0, din} * 1000) >> 16;
                // data <= ( din * 1000) >> 16;
               
                //data <= din;
               data <= ({16'b0, din} * 1000) >> 16;
               
                byte_count <= 0;
            end
        end
        S_DONE: begin
            if (start == 0)
                state <= S_IDLE;
        end
        S_DIVIDE: begin
            div <= data / 10; //get a digit value
            mod <= data % 10; //get a decimal value
            state <= S_CONVERT;
        end
        S_NEXT_DIGIT: begin
            if (byte_count == 3) //calcuate for 3 decimal places
                state <= S_DONE;
            else
                state <= S_DIVIDE;
            data <= div;
            byte_count <= byte_count + 1;
        end
        S_CONVERT: begin
            dout[11:0] <= dout[15:4];
            dout[15:12] <= mod[3:0];
            state <= S_NEXT_DIGIT;
        end
        default: begin
            state <= S_IDLE;
        end
        endcase
    
endmodule