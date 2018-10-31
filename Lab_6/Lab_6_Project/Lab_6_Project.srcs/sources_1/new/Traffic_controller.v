`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jacob Hillebrand
// 
// Create Date: 10/02/2018 03:19:38 PM
// Design Name: Traffic Controller State Machine
// Module Name: Traffic_controller
// Project Name: Traffic Controller State Machine
// Target Devices: 
// Tool Versions: 
// Description: This design provides a finite state machine traffic light controller
//for the top level traffic light design
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//use define directive to define text macros in Verilog
//define is similar to the #define construct in C

//signal from the inductive loop to detect the presence of car on country road
// output signal logic '1' when a car is detected, otherwise logic '0'


`define RED 2'd0;       //2'b00
`define YELLOW 2'd1     //2'b01
`define GREEN 2'd2      //2'b10

//delays for traffic lights
`define Y2RDELAY 3
`define R2GDELAY 2

module Traffic_controller(
    input wire X,
    input wire clk,
    input wire clr,
    output reg [5:0] lights
    );
    
//State Declaration         HWY         CNTRY
parameter S0 = 3'd0,        //Green     RED
          S1 = 3'd1,        //YELLOW    RED
          S2 = 3'd2,        //RED       RED
          S3 = 3'd3,        //RED       GREEN
          S4 = 3'd4;        //RED       YELLOW
          
// Internal state variables
reg [2:0] state;
reg [2:0] next_state;

//state changes only at positive edge of clock

always @(posedge clk)
    if (clr)
        state <= S0; //controller starts in S0 state
    else
        state <= next_state;    //State change
        
//State machine using case statements
always @(state or X or clr)
begin
    if (clr)
        next_state = S0;
     else
        case (state)
        
            S0  :   if (X)
                        next_state = S1;
                    else
                        next_state = S0;
            S1  :   begin   //delay some positive edges of clock
                    repeat(`Y2RDELAY)//@(posedge clock)
                    next_state = S2;
                    end
                    
            S2  :   begin //delay some positive edges of clock
                    repeat(`R2GDELAY)//@(posedge clock)
                    next_state = S3;
                    end
                    
            S3  :   if (X)
                    next_state = S3;
                    else
                    next_state = S4;
            S4  :   begin //delay some positive edges of clock
                    repeat(`Y2RDELAY)//@(posedge clock)
                    next_state = S0;
                    end
            default :   next_state = S0;
          endcase
end

    always @(*)
        begin 
            case (state)
                S0: lights = 6'b100001;
                S1: lights = 6'b100010;
                S2: lights = 6'b100100;
                S3: lights = 6'b001100;
                S4: lights = 6'b010100;
          //S5: lights = 6'b100100;
                default lights = 6'b100001;
                endcase
                end
endmodule
