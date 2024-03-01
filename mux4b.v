`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2023 01:43:14 AM
// Design Name: 
// Module Name: mux4b
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


module mux4b(
    input s,
    input [3:0] in1,
    input [3:0] in2,
    output [3:0] out
    );
    assign out[0] = (s & in1[0]) | (~s & in2[0]);
    assign out[1] = (s & in1[1]) | (~s & in2[1]);
    assign out[2] = (s & in1[2]) | (~s & in2[2]);
    assign out[3] = (s & in1[3]) | (~s & in2[3]);
endmodule
