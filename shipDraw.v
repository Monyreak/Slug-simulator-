`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2023 06:20:26 PM
// Design Name: 
// Module Name: shipDraw
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments
// 
//////////////////////////////////////////////////////////////////////////////////


module shipDraw(
    input clk,
    input [10:0] row,
    input [10:0] col,
    input goSig,
   
    input r,
    input frame1,
    input frame2,
    
    output ship,
    output alien
    );
    
    wire [7:0] randnums;
    LSFR srand (.clk(clk), .out(randnums));
    
    wire Loadtar;
    wire [3:0] savedSrand;
    
    Target HoldRand (.clk(clk), .D(randnums[3:0]), .CE(Loadtar), .Q(savedSrand));
    
    wire [7:0] tout;
    wire t1,t3;
    wire tr; 
    timeCounter TC (.clk(clk), .inc(frame1), .r(tr) , .tout(tout));
    assign t1 = (tout == 8'd60);
    assign t3 = (tout == 8'd180);
    
    wire [10:0] PosX;
    wire [10:0] PosY;
    
    wire fallsig;
    wire ground;
    wire ShipOut;
    wire AlienOut;  
    assign ground = PosY + 11'd10 == 11'd400;
    
     shipStates SS(
    .clk(clk), 
    .go(goSig), 
    .t1(t1), 
    .t3(t3), 

    .ground(ground),
    .fallsig(fallsig),
    .ShipGone(ShipOut), 
    .AlienGone(AlienOut));
    
    wire [10:0] w1;
    wire [10:0] w2;
    wire [10:0] w3;
    wire [10:0] w4;
    
    assign w1 = 11'd32;
    assign w2 = 11'd64;
    assign w3 = 11'd96;
    assign w4 = 11'd108;
    
    wire [10:0] WidthOut;
    m4_1 wMux (.sel(savedSrand[1:0]), .in1(w1) , .in2(w2) , .in3(w3) , .in4(w4) , .Qout(WidthOut));
    
    assign PosX = {savedSrand[3:0], 5'b00000};
    wire blue;
    assign blue = (row >= PosY & row <= PosY + 11'd10) & (col >= PosX & col <= PosX + WidthOut);

    wire [10:0] Ax;
    assign Ax = {savedSrand[3:0], 4'b0000};
  
    wire pink;
    assign pink = (row >= PosY - 11'd2 & row <= PosY + 11'd6) & (col >= Ax - 11'd4 & col <= Ax + 11'd4);
    
    countUD16L #(.INIT(16'd0)) VerFall (.clock(clk), .Up((fallsig & frame1) & ((PosY + 11'd10) <= 11'd399) |  
    (fallsig & frame2) & ((PosY + 11'd10) <= 11'd399)), 
    .Dw(1'b0),
    .LD(r), 
    .d(16'd0),
    .q(PosY),
    .utc(),
    .dtc());
   
    assign ship = blue &  ShowShip;
    assign alien = pink & ShowAlien;
 
endmodule
