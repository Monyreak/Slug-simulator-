`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2023 01:46:04 PM
// Design Name: 
// Module Name: m4_1
// Project Name: 
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


module m4_1(
    input [1:0] sel,
    input [10:0] in1,
    input [10:0] in2,
    input [10:0] in3,
    input [10:0] in4,
    
    output [10:0] Qout
    );
    
    assign Qout = (in1 & ~{11{sel[1]}} & ~ {11{sel[0]}}) |
    (in1 & ~{11{sel[1]}} & {11{sel[0]}}) |
    (in2 & {11{sel[1]}} & ~ {11{sel[0]}}) | 
    (in3 & {11{sel[1]}} &  {11{sel[0]}});
    
endmodule
