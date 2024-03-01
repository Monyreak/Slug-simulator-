`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2023 03:24:27 PM
// Design Name: 
// Module Name: Syncs
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


module Syncs(
    input clk,
    input [10:0] VIn,
    input [10:0] HIn,
    output VSync,
    output HSync
    );
    
    wire [10:0] Hbound1, Hbound2;
    wire [10:0] Vbound1, Vbound2;
    
    assign Hbound1 = 11'd655;
    assign Hbound2 = 11'd750;
 
    assign Vbound1 = 11'd489;
    assign Vbound2 = 11'd490;
    
    assign VSync = (VIn < Vbound1 ) || (VIn > Vbound2);
    assign HSync = (HIn < Hbound1 ) || (HIn > Hbound2);
    
endmodule
