`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2023 05:01:10 AM
// Design Name: 
// Module Name: Target
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


module Target(
    input clk,
    input [3:0] D,
    input CE,
    output [3:0] Q
    );
    FDRE FF0 (.C(clk), .CE(CE) , .D(D[0]), .Q(Q[0]));
    FDRE FF1 (.C(clk), .CE(CE) , .D(D[1]), .Q(Q[1]));
    FDRE FF2 (.C(clk), .CE(CE) , .D(D[2]), .Q(Q[2]));
    FDRE FF3 (.C(clk), .CE(CE) , .D(D[3]), .Q(Q[3]));
endmodule
    
