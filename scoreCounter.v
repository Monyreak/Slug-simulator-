`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2023 05:04:35 PM
// Design Name: 
// Module Name: scoreCounter
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


module scoreCounter(
    input clk,
    input Inc,
    input r,
    output [7:0] Q
    );
    wire [15:0] Qout;
    countUD16L ScoreCount (.clock(clk), .Up(Inc), . Dw(1'b0) , .LD(r) , .d(16'h0000), .q(Qout), .utc(), .dtc());
    assign Q [7:0] = Qout [7:0];
endmodule
