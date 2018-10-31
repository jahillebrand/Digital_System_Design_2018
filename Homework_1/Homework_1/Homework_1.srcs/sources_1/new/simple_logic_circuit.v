`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jacob Hillebrand 
// 
// Create Date: 09/21/2018 02:33:49 PM
// Design Name: Simple_Logic_Circuit
// Module Name: simple_logic_circuit
// Project Name: Simple_Logic_Circuit
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


module simple_logic_circuit(
    output y,
    input A,
    input B,
    input C,
    input D
    );
    
//instantiate logic gates
assign y = (~(A|D) && (B&&C&&~D));

endmodule
