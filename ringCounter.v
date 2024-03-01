`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2023 02:54:03 PM
// Design Name: 
// Module Name: ringCounter
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


module ringCounter(
    input clock,
    input advance,              
    output [3:0] out
    );
    FDRE #(.INIT(1'b1) ) ring1 (.C(clock), .CE(advance), .R(1'b0), .D(out[3]), .Q(out[0]));
    FDRE #(.INIT(1'b0) ) ring2 (.C(clock), .CE(advance), .R(1'b0), .D(out[0]), .Q(out[1]));
    FDRE #(.INIT(1'b0) ) ring3 (.C(clock), .CE(advance), .R(1'b0), .D(out[1]), .Q(out[2]));
    FDRE #(.INIT(1'b0) ) ring4 (.C(clock), .CE(advance), .R(1'b0), .D(out[2]), .Q(out[3]));
endmodule

