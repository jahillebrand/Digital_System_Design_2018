`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jacob Hillebrand
// 
// Create Date: 09/21/2018 02:52:30 PM
// Design Name: Simple_logic_circuit_Testbench
// Module Name: simple_logic_circuit_testbench
// Project Name: Simple_Logic_Circuit_Testbench
// Target Devices: 
// Tool Versions: 
// Description: Simulation of Simple_Logic_Circuit
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module simple_logic_circuit_testbench;
    
    //Inputs
    reg A;
    reg B;
    reg C;
    reg D;
    
    //Outputs
    wire y;
    
    //Instantiate the UUT
    simple_logic_circuit uut (
        .y(y),
        .A(A),
        .B(B),
        .C(C),
        .D(D)
    );
    
    //Add stimulus/initialize input
    
    initial begin
    $timeformat(-9,1,"ns",10); //unit, precision, unit, minwidth between characters
    #5 {A,B,C,D} = 4'b0000;
    #10 {A,B,C,D} = 4'b0001;
    #15 {A,B,C,D} = 4'b0010;
    #20 {A,B,C,D} = 4'b0011;
    #25 {A,B,C,D} = 4'b0100;
    #30 {A,B,C,D} = 4'b0101;
    #35 {A,B,C,D} = 4'b0110;
    #40 {A,B,C,D} = 4'b0111;
    #45 {A,B,C,D} = 4'b1000;
    #50 {A,B,C,D} = 4'b1001;
    #55 {A,B,C,D} = 4'b1010;
    #60 {A,B,C,D} = 4'b1011;
    #65 {A,B,C,D} = 4'b1100; 
    #70 {A,B,C,D} = 4'b1101;
    #75 {A,B,C,D} = 4'b1110;
    #80 {A,B,C,D} = 4'b1111;
    end
    
    
    always @(A or B or C or D or y)
    #1 $display("Time=%t, a=%b, b=%b, c=%b, d=%b, y=%b", $time,A,B,C,D,y);
    
    
endmodule
