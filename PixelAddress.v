`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2023 02:59:27 PM
// Design Name: 
// Module Name: PixelAddress
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


module PixelAddress(
    input clk,
    output [15:0] Hpix,
    output [15:0] Vpix
    ); 
    
    wire [15:0] HorizonOut;
    wire [15:0] VerticalOut; 
    
    wire [15:0] Hreset;
    wire [15:0] Vreset;
    
    assign Hreset = 16'd799;
    assign Vreset = 16'd524;
    
    countUD16L Hori (.clock(clk), .Up(1'b1), .Dw(1'b0), .LD(Hreset == HorizonOut), .d(16'h0000), .q(HorizonOut) , .utc() , .dtc());
    countUD16L Vert (.clock(clk), .Up(Hreset == HorizonOut), .Dw(1'b0), .LD(Vreset == VerticalOut & Hreset == HorizonOut), .d(16'h0000), .q(VerticalOut), .utc() ,.dtc());
    
    assign Hpix = HorizonOut;
    assign Vpix = VerticalOut;
    
endmodule
