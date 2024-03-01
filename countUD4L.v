`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2023 03:03:35 PM
// Design Name: 
// Module Name: countUD4L
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


module countUD4L #(
    parameter [3:0] INIT = 4'b0000
)(
    input clock,
    input Up,
    input Dw,
    input LD,
    input [3:0] d,
    
    output [3:0] q,
    output utc,
    output dtc
    
    );
    
    //utc is high if counterbits are all 1
    assign utc = q[3] & q[2] & q[1] & q[0];
    //dtc is high if counterbits are all 0
    assign dtc = ~q[3] & ~q[2] & ~q[1] & ~q[0];
    
    wire ce;
    wire up0, up1, up2, up3;
    wire down1, down2, down3;
    
    assign ce = (Up ^ Dw) | LD;
    //up count
    assign up0 = (q[0] ^ ce);
    assign up1 = q[1] ^ (ce & q[0]);
    assign up2 = q[2] ^ (ce & q[1] & q[0]);
    assign up3 = q[3] ^ (ce & q[2] & q[1] & q[0]);
    
    //down count
    assign down1 = q[1] ^ (ce & ~q[0]);
    assign down2 = q[2] ^ (ce & ~q[1] & ~q[0]);
    assign down3 = q[3] ^ (ce & ~q[2] & ~q[1] & ~q[0]);
    
    wire [3:0] out;
    
    assign out[3] = ((((up3 & Up & ~Dw) | (down3 & ~Up & Dw)) & ~LD) | (LD & d[3]));
    assign out[2] = ((((up2 & Up & ~Dw) | (down2 & ~Up & Dw)) & ~LD) | (LD & d[2]));
    assign out[1] = ((((up1 & Up & ~Dw) | (down1 & ~Up & Dw)) & ~LD) | (LD & d[1]));
    assign out[0] = ((((up0 & Up & ~Dw) | (up0 & ~Up & Dw)) & ~LD) | (LD & d[0]));

    FDRE #(.INIT(INIT[3]) ) flip3 (.C(clock), .R(1'b0), .CE(ce), .D(out[3]), .Q(q[3]));
    FDRE #(.INIT(INIT[2]) ) flip2 (.C(clock), .R(1'b0), .CE(ce), .D(out[2]), .Q(q[2]));
    FDRE #(.INIT(INIT[1]) ) flip1 (.C(clock), .R(1'b0), .CE(ce), .D(out[1]), .Q(q[1]));
    FDRE #(.INIT(INIT[0]) ) flip0 (.C(clock), .R(1'b0), .CE(ce), .D(out[0]), .Q(q[0]));
endmodule

