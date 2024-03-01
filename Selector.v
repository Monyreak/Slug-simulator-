`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2023 02:54:22 PM
// Design Name: 
// Module Name: Selector
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


module Selector(    
    input [3:0] sel,
    input [15:0] N,
    output [3:0] H
    );
    
    wire [3:0] A;
    wire [3:0] B;
    wire [3:0] C;
    wire [3:0] D;
    
    mux4b Mux1 ( .s(sel[0]), .in1(N[3:0]), .in2(0), .out(A));
    mux4b Mux2 ( .s(sel[1]), .in1(N[7:4]), .in2(A), .out(B));
    mux4b Mux3 ( .s(sel[2]), .in1(N[11:8]), .in2(B), .out(C));
    mux4b Mux4 ( .s(sel[3]), .in1(N[15:12]), .in2(C), .out(D));
    assign H = D; 
endmodule
