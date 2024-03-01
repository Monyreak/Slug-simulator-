`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2023 04:02:38 PM
// Design Name: 
// Module Name: countUD16L
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


module countUD16L#(
    parameter [15:0] INIT = 16'd0
)(
    input clock,
    input Up,
    input Dw,
    input LD,
    input [15:0] d,
   
    output [15:0] q,
    output utc,
    output dtc

    );
    
    wire utc0, utc1, utc2, utc3;
    wire dtc0, dtc1, dtc2, dtc3;
    
    countUD4L #(.INIT(INIT[3:0])) count0to3 (.Up(Up), .Dw(Dw), .LD(LD), .clock(clock), .d(d[3:0]), .q(q[3:0]), .utc(utc0), .dtc(dtc0));
    countUD4L #(.INIT(INIT[7:4]))  count4to7 (.Up(Up & utc0), .Dw(Dw & dtc0), .LD(LD), .clock(clock), .d(d[7:4]), .q(q[7:4]), .utc(utc1), .dtc(dtc1));
    countUD4L #(.INIT(INIT[11:8])) count8to11 (.Up(Up & utc0 & utc1), .Dw(Dw & dtc0 & dtc1), .LD(LD), .clock(clock), .d(d[11:8]), .q(q[11:8]), .utc(utc2), .dtc(dtc2));
    countUD4L #(.INIT(INIT[15:12])) count12to15 (.Up(Up & utc0 & utc1 & utc2), .Dw(Dw & dtc0 & dtc1 & dtc2), .LD(LD), .clock(clock), .d(d[15:12]), .q(q[15:12]), .utc(utc3), .dtc(dtc3));
    
    //utc is high if counterbits are all 1
    assign utc = utc3 & utc2 & utc1 & utc0;
    //dtc is high if counterbits are all 0
    assign dtc = dtc3 & dtc2 & dtc1 & dtc0;
endmodule
