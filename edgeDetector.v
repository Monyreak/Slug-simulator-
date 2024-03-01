`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2023 11:59:25 AM
// Design Name: 
// Module Name: edgeDetector
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


module edgeDetector(
    input btn,
    input clock,
    output sig
    );
    wire w0,w1;
    FDRE #(.INIT(1'b0) ) edge1 (.CE(1'b1), .C(clock), .R(), .D(btn), .Q(w0));
    FDRE #(.INIT(1'b0) ) edge2 (.CE(1'b1), .C(clock), .R(), .D(w0), .Q(w1));
    
    assign sig = (btn & ~w0 & ~w1);
    
endmodule
