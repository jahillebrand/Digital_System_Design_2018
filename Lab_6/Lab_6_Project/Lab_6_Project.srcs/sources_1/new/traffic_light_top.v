`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jacob Hillebrand
// 
// Create Date: 10/02/2018 03:01:33 PM
// Design Name: traffic_light_top
// Module Name: traffic_light_top
// Project Name: traffic_light_top
// Target Devices: 
// Tool Versions: 
// Description: TThis design is the master design file for the traffic light 
//controller
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Top module of a traffic signal controller for an
//intersection of main highway and country road

module traffic_light_top(
    input wire clk,
    input wire btn1,
    input wire btn2,
    output wire [5:0] led
    );
    
wire clk3;
wire clr;

//btn1 is pressed to simulate the presecence of pedestrians
//btn2 is pressed to clear the system

assign X = btn1;
assign clr = btn2;

clkdiv U1 (.clk(clk),.clr(clr),.clk3(clk3));/////////////////////////////////////////

Traffic_controller U2 (.X(X), .clk(clk3), .clr(clr), .lights(led));

endmodule
