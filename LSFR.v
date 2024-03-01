`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2023 04:59:54 AM
// Design Name: 
// Module Name: LSFR
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


module LSFR(
    input clk,
    output [7:0] out
    );
    wire [7:0] rnd;
    wire d_in;
    
    assign d_in = rnd[0] ^ rnd[5] ^ rnd[6] ^ rnd[7];
    
    FDRE #(.INIT(1'b1) ) rng1 (.C(clk), .CE(1'b1), .R(1'b0), .D(d_in), .Q(rnd[0]));
    FDRE #(.INIT(1'b0) ) rng2 (.C(clk), .CE(1'b1), .R(1'b0), .D(rnd[0]), .Q(rnd[1]));
    FDRE #(.INIT(1'b0) ) rng3 (.C(clk), .CE(1'b1), .R(1'b0), .D(rnd[1]), .Q(rnd[2]));
    FDRE #(.INIT(1'b0) ) rng4 (.C(clk), .CE(1'b1), .R(1'b0), .D(rnd[2]), .Q(rnd[3]));
    FDRE #(.INIT(1'b0) ) rng5 (.C(clk), .CE(1'b1), .R(1'b0), .D(rnd[3]), .Q(rnd[4]));
    FDRE #(.INIT(1'b0) ) rng6 (.C(clk), .CE(1'b1), .R(1'b0), .D(rnd[4]), .Q(rnd[5]));
    FDRE #(.INIT(1'b0) ) rng7 (.C(clk), .CE(1'b1), .R(1'b0), .D(rnd[5]), .Q(rnd[6]));
    FDRE #(.INIT(1'b0) ) rng8 (.C(clk), .CE(1'b1), .R(1'b0), .D(rnd[6]), .Q(rnd[7]));
    assign out[7:0] = {rnd[7:0]};

endmodule
