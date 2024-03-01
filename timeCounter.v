`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2023 05:05:00 PM
// Design Name: 
// Module Name: timeCounter
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


module timeCounter(
    input clk,
    input inc,
    input r,
    output [7:0] tout
    );
    wire [15:0] Qout;
    countUD16L Timecount (.clock(clk) , .Up(inc), .Dw(1'b0) , .LD(r), .d(1'b0), .q(Qout) , .utc() , .dtc());
    assign tout [7:0] = Qout [7:0];
endmodule
