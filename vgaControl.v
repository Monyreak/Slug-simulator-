`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2023 03:15:07 PM
// Design Name: 
// Module Name: vgaControl
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


module vgaControl(
    input clk,
    input [10:0] row,
    input [10:0] col,
    input BC,
    input BL,
    input BR,
    input BD, 

    input frame1,
    input frame2,
   
    output IncScore, 
    output RScore,
    
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue
    );
    
    wire goSig;
    wire contact;
    wire FlashPlayer;
    wire FlashBorder; 
    wire endSig;
    wire globalSig;
  
    
    wire RowActive;
    wire ColActive;
    wire Active;
    
    assign RowActive = (row < 11'd480);
    assign ColActive = (col < 11'd640);
    assign Active = RowActive & ColActive;
    
    wire top, bot, left, right;
    assign top = (row >= 11'd0 & row <= 11'd7) & (col >= 11'd0 & col <= 11'd639);
    assign left = (col >= 11'd0 & col <= 11'd7) & (row >= 11'd0 & row <= 11'd479);
    assign bot = (row >= 11'd472 & row <= 11'd479) & (col >= 11'd0 &col <=11'd639);
    assign right = (col >= 11'd632 & col <= 11'd639 ) & (row >= 11'd0 & row <= 11'd479);
    
    wire green;
    assign green = (row >= 11'd400 & row <= 11'd407) & (col >= 11'd8 & col <= 11'd631);
    
    wire brown;
    assign brown = (row >= 11'd408 & row <= 11'd471) & (col >= 11'd8 & col <= 11'd631);
    
    wire [10:0] PosX;
    wire [10:0] PosY;
    countUD16L #(.INIT(16'd314)) Hori (.clock(clk), .Up((BR & ~BL & ~ BD & frame1 & ~endSig) & ((PosX + 11'd16) <= 11'd631) &  ((PosY + 11'd12) <= 11'd400) ), .Dw((BL & ~BR & ~ BD & frame1 & ~endSig ) & (PosX >= 11'd8) &  ((PosY + 11'd12) <= 11'd400)), .LD(), .d(16'd314), .q(PosX), .utc() , .dtc());
    countUD16L #(.INIT(16'd383)) Vert (.clock(clk), .Up((BD & frame1 & ~endSig ) & ((PosY + 11'd16) <= 11'd471)), .Dw((~BD & frame1 & ~endSig ) & ((PosY + 11'd16) >= 11'd400)), .LD(), .d(16'd383), .q(PosY), .utc() ,.dtc());
    
    wire [7:0] randnums;
    LSFR srand (.clk(clk), .out(randnums));
    
    wire [10:0] tout;
    wire t1,t2,t3,t4,t5;
    wire tr; 
    
    timeCounter Tmain (.clk(clk), .inc(frame1), .r(tr) , .tout(tout));
    assign t1 = (tout == 10'd60);
    assign t2 = (tout == 10'd120);
    assign t3 = (tout == 10'd180);
    assign t4 = (tout == 10'd240);
    assign t5 = (tout == 10'd300); 

    GameStates Gamer(
     .clk(clk),
     .btnC(BC),
     .t5(t5),
     .contact(contact),
   
     .goSig(goSig),
     .endSig(endSig),
     .globalSig(globalSig),
     .resettmain(tr),
     .FlashPlayer(FlashPlayer),
     .FlashBorder(FlashBorder)
    );  
      
    assign RScore = globalSig;
    
    wire [10:0] Ship1X;
    wire [10:0] Ship1Y;
    
    wire fallsig1;
    wire land1;
    wire contact1;
    wire contactpink1;
    wire ShowShip1;
    wire ShowAlien1;
    wire FlashAlien1;
    wire ResetPosition1;
    wire Loadtar1;
    wire IncSore1;
    
    wire Ship1;
    wire Alien1;
    wire player; 
    
    assign land1 = (Ship1Y + 11'd8 == 11'd399);
    assign contact1 = (player & Ship1 & ShowShip1);
    assign contactpink1 = (player & Alien1 & ShowAlien1);
    
    wire [3:0] savedSrand1;
    Target Ship1Tar (.clk(clk), .D(randnums[3:0]), .CE(Loadtar1), .Q(savedSrand1[3:0]));
    
    wire [10:0] s1tout;
    wire s1t1, s1t3;
    wire s1tr; 
    
    timeCounter TS1 (.clk(clk), .inc(frame1), .r(s1tr) , .tout(s1tout));
    assign s1t1 = (s1tout == 10'd60);
    assign s1t3 = (s1tout == 10'd180);

    shipStates SS1(
    .clk(clk),
    .go(goSig),
    .land(land1),
    .contact(contact1),
    .contactpink(contactpink1),
    .gameover(endSig),

    .t1(s1t1),
    .t3(s1t3),
    
    .Fallsig(fallsig1),  
    .LoadTar(Loadtar1),
    .ResetPosition(ResetPosition1),
    .ResetShipTimer(s1tr),
    
    .ShowShip(ShowShip1),
    .ShowAlien(ShowAlien1),
    .FlashAlien(FlashAlien1),
    .IncSore(IncSore1)
    );
    
    wire [10:0] w1;
    wire [10:0] w2;
    wire [10:0] w3;
    wire [10:0] w4;
    
    assign w1 = 11'd32;
    assign w2 = 11'd64;
    assign w3 = 11'd96;
    assign w4 = 11'd108;
    
    wire [10:0] WidthOut1;
    m4_1 wMux (.sel(savedSrand1[1:0]), .in1(w1) , .in2(w2) , .in3(w3) , .in4(w4) , .Qout(WidthOut1));
    
    assign Ship1X = {savedSrand1[3:0], 5'b00000} + 11'd7;
    
    assign Ship1 = (row >= Ship1Y & row <= (Ship1Y + 11'd10)) & (col >= Ship1X & col <= (Ship1X + WidthOut1));
    
    wire [10:0] a1;
    wire [10:0] a2;
    wire [10:0] a3;
    wire [10:0] a4;
    
    assign a1 = 11'd12;
    assign a2 = 11'd28;
    assign a3 = 11'd44;
    assign a4 = 11'd60;
    wire [10:0] a1out;
    
    m4_1 aMux (.sel(savedSrand1[1:0]), .in1(a1) , .in2(a2) , .in3(a3) , .in4(a4) , .Qout(a1out));

    wire [10:0] Alien1X;
    assign Alien1X = {savedSrand1[3:0], 4'b0000};
  
    assign Alien1 = (row >= (Ship1Y + 11'd2) & row <= (Ship1Y + 11'd8)) & (col >= (Ship1X  + a1out) & col <= (Ship1X + a1out + 10'd7));
    
    countUD16L #(.INIT(11'b11111111111)) VertS1 (
     .clock(clk),
     .Up((fallsig1 & frame1) | (fallsig1 & frame2)), 
     .Dw(1'b0),
     .LD(ResetPosition1 | globalSig), 
     .d(11'b11111111111),
     .q(Ship1Y),
     .utc(),
     .dtc()
     );
     
    wire [10:0] Ship2X;
    wire [10:0] Ship2Y;
    
    wire fallsig2;
    wire land2;
    wire contact2;
    wire contactpink2;
    wire ShowShip2;
    wire ShowAlien2;
    wire FlashAlien2;
    wire ResetPosition2;
    wire Loadtar2;
    wire IncScore2;
    
    wire Ship2;
    wire Alien2; 
    
    assign land2 = (Ship2Y + 11'd8 == 11'd399);
    assign contact2 = (player & Ship2 & ShowShip2);
    assign contactpink2 = (player & Alien2 & ShowAlien2);
    
    wire [3:0] savedSrand2;
    Target Ship2Tar (.clk(clk), .D(randnums[3:0]), .CE(Loadtar2), .Q(savedSrand2[3:0]));
    
    wire [10:0] s2tout;
    wire s2t1, s2t3;
    wire s2tr;
    
    timeCounter TS2 (.clk(clk), .inc(frame1), .r(s2tr) , .tout(s2tout));
    assign s2t1 = (s2tout == 10'd60);
    assign s2t3 = (s2tout == 10'd180);

    shipStates SS2(
    .clk(clk),
    .go(goSig & t1),
    .land(land2),
    .contact(contact2),
    .contactpink(contactpink2),
    .gameover(endSig),

    .t1(s2t1),
    .t3(s2t3),
    
    .Fallsig(fallsig2),  
    .LoadTar(Loadtar2),
    .ResetPosition(ResetPosition2),
    .ResetShipTimer(s2tr),
    
    .ShowShip(ShowShip2),
    .ShowAlien(ShowAlien2),
    .FlashAlien(FlashAlien2),
    .IncSore(IncScore2)
    );
    
    wire [10:0] WidthOut2;
    m4_1 w2Mux (.sel(savedSrand2[1:0]), .in1(w1) , .in2(w2) , .in3(w3) , .in4(w4) , .Qout(WidthOut2));
    
    assign Ship2X = {savedSrand2[3:0], 5'b00000} + 11'd7;

    assign Ship2 = (row >= Ship2Y & row <= (Ship2Y + 11'd10)) & (col >= Ship2X & col <= (Ship2X + WidthOut2));
 
    wire [10:0] a2out;
    m4_1 a2Mux (.sel(savedSrand2[1:0]), .in1(a1) , .in2(a2) , .in3(a3) , .in4(a4) , .Qout(a2out));

    wire [10:0] Alien2X;
    assign Alien2X = {savedSrand2[3:0], 4'b0000};
    assign Alien2 = (row >= (Ship2Y + 11'd2) & row <= (Ship2Y + 11'd8)) & (col >= (Ship2X  + a2out) & col <= (Ship2X + a2out + 10'd7));
    
    countUD16L #(.INIT(11'b11111111111)) VertS2 (
     .clock(clk),
     .Up((fallsig2 & frame1) | (fallsig2 & frame2)), 
     .Dw(1'b0),
     .LD(ResetPosition2 | globalSig ), 
     .d(11'b11111111111),
     .q(Ship2Y),
     .utc(),
     .dtc()
     );
     
    wire [10:0] Ship3X;
    wire [10:0] Ship3Y;
    
    wire fallsig3;
    wire land3;
    wire contact3;
    wire contactpink3;
    wire ShowShip3;
    wire ShowAlien3;
    wire FlashAlien3;
    wire ResetPosition3;
    wire Loadtar3;
    wire IncScore3;
    
    wire Ship3;
    wire Alien3; 
    
    assign land3 = (Ship3Y + 11'd8 == 11'd399);
    assign contact3 = (player & Ship3 & ShowShip3);
    assign contactpink3 = (player & Alien3 & ShowAlien3);
    
    wire [3:0] savedSrand3;
    Target Ship3Tar (.clk(clk), .D(randnums[3:0]), .CE(Loadtar3), .Q(savedSrand3[3:0]));
    
    wire [10:0] s3tout;
    wire s3t1, s3t3;
    wire s3tr;
    
    timeCounter TS3 (.clk(clk), .inc(frame1), .r(s3tr) , .tout(s3tout));
    assign s3t1 = (s3tout == 10'd60);
    assign s3t3 = (s3tout == 10'd180);

    shipStates SS3(
    .clk(clk),
    .go(goSig & t2),
    .land(land3),
    .contact(contact3),
    .contactpink(contactpink3),
    .gameover(endSig),

    .t1(s3t1),
    .t3(s3t3),
    
    .Fallsig(fallsig3),  
    .LoadTar(Loadtar3),
    .ResetPosition(ResetPosition3),
    .ResetShipTimer(s3tr),
    
    .ShowShip(ShowShip3),
    .ShowAlien(ShowAlien3),
    .FlashAlien(FlashAlien3),
    .IncSore(IncScore3)
    );
    
    wire [10:0] WidthOut3;
    m4_1 w3Mux (.sel(savedSrand3[1:0]), .in1(w1) , .in2(w2) , .in3(w3) , .in4(w4) , .Qout(WidthOut3));
    
    assign Ship3X = {savedSrand3[3:0], 5'b00000} + 11'd7;
    assign Ship3 = (row >= Ship3Y & row <= (Ship3Y + 11'd10)) & (col >= Ship3X & col <= (Ship3X + WidthOut3));
 
    wire [10:0] a3out;
    m4_1 a3Mux (.sel(savedSrand3[1:0]), .in1(a1) , .in2(a2) , .in3(a3) , .in4(a4) , .Qout(a3out));

    wire [10:0] Alien3X;
    assign Alien3X = {savedSrand3[3:0], 4'b0000};
    assign Alien3 = (row >= (Ship3Y + 11'd2) & row <= (Ship3Y + 11'd8)) & (col >= (Ship3X  + a3out) & col <= (Ship3X + a3out + 10'd7));
    
    countUD16L #(.INIT(11'b11111111111)) VertS3 (
     .clock(clk),
     .Up((fallsig3 & frame1) | (fallsig3 & frame2)), 
     .Dw(1'b0),
     .LD(ResetPosition3 | globalSig), 
     .d(11'b11111111111),
     .q(Ship3Y),
     .utc(),
     .dtc()
     );
     
    wire [10:0] Ship4X;
    wire [10:0] Ship4Y;
    
    wire fallsig4;
    wire land4;
    wire contact4;
    wire contactpink4;
    wire ShowShip4;
    wire ShowAlien4;
    wire FlashAlien4;
    wire ResetPosition4;
    wire Loadtar4;
    wire IncScore4;
    
    wire Ship4;
    wire Alien4; 
    
    assign land4 = (Ship4Y + 11'd9 == 11'd399);
    assign contact4 = (player & Ship4 & ShowShip4);
    assign contactpink4 = (player & Alien4 & ShowAlien4);
    
    wire [3:0] savedSrand4;
    Target Ship4Tar (.clk(clk), .D(randnums[3:0]), .CE(Loadtar4), .Q(savedSrand4[3:0]));
    
    wire [10:0] s4tout;
    wire s4t1, s4t3;
    wire s4tr;
    
    timeCounter TS4 (.clk(clk), .inc(frame1), .r(s4tr) , .tout(s4tout));
    assign s4t1 = (s4tout == 10'd60);
    assign s4t3 = (s4tout == 10'd180);

    shipStates SS4(
    .clk(clk),
    .go(goSig & t3),
    .land(land4),
    .contact(contact4),
    .contactpink(contactpink4),
    .gameover(endSig),

    .t1(s4t1),
    .t3(s4t3),
    
    .Fallsig(fallsig4),  
    .LoadTar(Loadtar4),
    .ResetPosition(ResetPosition4),
    .ResetShipTimer(s4tr),
    
    .ShowShip(ShowShip4),
    .ShowAlien(ShowAlien4),
    .FlashAlien(FlashAlien4),
    .IncSore(IncScore4)
    );
    
    wire [10:0] WidthOut4;
    m4_1 w4Mux (.sel(savedSrand4[1:0]), .in1(w1) , .in2(w2) , .in3(w3) , .in4(w4) , .Qout(WidthOut4));
    
    assign Ship4X = {savedSrand4[3:0], 5'b00000} + 11'd7;

    assign Ship4 = (row >= Ship4Y & row <= (Ship4Y + 11'd10)) & (col >= Ship4X & col <= (Ship4X + WidthOut4));
 
    wire [10:0] a4out;
    m4_1 a4Mux (.sel(savedSrand4[1:0]), .in1(a1) , .in2(a2) , .in3(a3) , .in4(a4) , .Qout(a4out));

    wire [10:0] Alien4X;
    assign Alien4X = {savedSrand4[3:0], 4'b0000};
    assign Alien4 = (row >= (Ship4Y + 11'd2) & row <= (Ship4Y + 11'd8)) & (col >= (Ship4X  + a4out) & col <= (Ship4X + a4out + 10'd7));
    
    countUD16L #(.INIT(11'b11111111111)) VertS4 (
     .clock(clk),
     .Up((fallsig4 & frame1) | (fallsig4 & frame2)), 
     .Dw(1'b0),
     .LD(ResetPosition4 | globalSig), 
     .d(11'b11111111111),
     .q(Ship4Y),
     .utc(),
     .dtc()
     );
     
    wire [10:0] Ship5X;
    wire [10:0] Ship5Y;
    
    wire fallsig5;
    wire land5;
    wire contact5;
    wire contactpink5;
    wire ShowShip5;
    wire ShowAlien5;
    wire FlashAlien5;
    wire ResetPosition5;
    wire Loadtar5;
    wire IncScore5;
    
    wire Ship5;
    wire Alien5; 
    
    assign land5 = (Ship5Y + 11'd9 == 11'd399);
    assign contact5 = (player & Ship5 & ShowShip5);
    assign contactpink5 = (player & Alien5 & ShowAlien5);
    
    wire [3:0] savedSrand5;
    Target Ship5Tar (.clk(clk), .D(randnums[3:0]), .CE(Loadtar5), .Q(savedSrand5[3:0]));
    
    wire [10:0] s5tout;
    wire s5t1, s5t3;
    wire s5tr;
    
    timeCounter TS5 (.clk(clk), .inc(frame1), .r(s5tr) , .tout(s5tout));
    assign s5t1 = (s5tout == 10'd60);
    assign s5t3 = (s5tout == 10'd180);

    shipStates SS5(
    .clk(clk),
    .go(goSig & t4),
    .land(land5),
    .contact(contact5),
    .contactpink(contactpink5),
    .gameover(endSig),

    .t1(s5t1),
    .t3(s5t3),
    
    .Fallsig(fallsig5),  
    .LoadTar(Loadtar5),
    .ResetPosition(ResetPosition5),
    .ResetShipTimer(s5tr),
    
    .ShowShip(ShowShip5),
    .ShowAlien(ShowAlien5),
    .FlashAlien(FlashAlien5),
    .IncSore(IncScore5)
    );
    
    wire [10:0] WidthOut5;
    m4_1 w5Mux (.sel(savedSrand5[1:0]), .in1(w1) , .in2(w2) , .in3(w3) , .in4(w4) , .Qout(WidthOut5));
    
    assign Ship5X = {savedSrand5[3:0], 5'b00000} + 11'd7;

    assign Ship5 = (row >= Ship5Y & row <= (Ship5Y + 11'd10)) & (col >= Ship5X & col <= (Ship5X + WidthOut5));
 
    wire [10:0] a5out;
    m4_1 a5Mux (.sel(savedSrand5[1:0]), .in1(a1) , .in2(a2) , .in3(a3) , .in4(a4) , .Qout(a5out));

    wire [10:0] Alien5X;
    assign Alien5X = {savedSrand5[3:0], 4'b0000};
    
    assign Alien5 = (row >= (Ship5Y + 11'd2) & row <= (Ship5Y + 11'd8)) & (col >= (Ship5X  + a5out) & col <= (Ship5X + a5out + 10'd7));
    
    countUD16L #(.INIT(11'b11111111111)) VertS5 (
     .clock(clk),
     .Up((fallsig5 & frame1) | (fallsig5 & frame2)), 
     .Dw(1'b0),
     .LD(ResetPosition5 | globalSig), 
     .d(11'b11111111111),
     .q(Ship5Y),
     .utc(),
     .dtc()
     );
     
    wire yellow;
    assign yellow = (row >= PosY & row <= PosY +11'd16) & (col >= PosX & col <= PosX + 11'd16);
    
    assign player = yellow;
 
    wire border; 
    assign border = top | bot | left | right;
    
    wire grass;
    assign grass = green;
    
    wire ground;
    assign ground = brown;
    
    assign contact = contact1 | contact2 | contact3 | contact4 | contact5; 
    assign IncScore = IncSore1 | IncScore2 | IncScore3 | IncScore4 | IncScore5; 
   
    assign vgaRed = {{4{border & (~FlashBorder | (FlashBorder & tout[4])) }} & {4{Active}}} | {{4{ground}} & {4{Active}} & 4'b0110} | {{4{player & (~FlashPlayer | (FlashPlayer & tout[4]))}} & {4{Active}}} 
    | {{4{Alien1 & ShowAlien1 & ~border & (~FlashAlien1 | (FlashAlien1 & tout[4]))}} & {4{Active}}} 
    | {{4{Alien2 & ShowAlien2 & ~border & (~FlashAlien2 | (FlashAlien2 & tout[4]))}} & {4{Active}}} 
    | {{4{Alien3 & ShowAlien3 & ~border & (~FlashAlien3 | (FlashAlien3 & tout[4]))}} & {4{Active}}}
    | {{4{Alien4 & ShowAlien4 & ~border & (~FlashAlien4 | (FlashAlien4 & tout[4]))}} & {4{Active}}}
    | {{4{Alien5 & ShowAlien5 & ~border & (~FlashAlien5 | (FlashAlien5 & tout[4]))}} & {4{Active}}};
    
    assign vgaGreen = {{4{grass}} & {4{Active}}} | {{4{ground}} & {4{Active}} & 4'b0011}
     | {{4{player & (~FlashPlayer | (FlashPlayer & tout[4])) }} & {4{Active}}} ;
    assign vgaBlue = {{4{Ship1 & ShowShip1 & ShowAlien1 & ~border}} & {4{Active}}} | 
     {{4{Ship2 & ShowShip2 & ShowAlien2 & ~border}} & {4{Active}}} |
     {{4{Ship3 & ShowShip3 & ShowAlien3 & ~border}} & {4{Active}}} |
     {{4{Ship4 & ShowShip4 & ShowAlien4 & ~border}} & {4{Active}}} |
     {{4{Ship5 & ShowShip5 & ShowAlien5 & ~border}} & {4{Active}}} |
     {{4{Alien1 & ShowAlien1 & ~border & (~FlashAlien1 | (FlashAlien1 & tout[4]))}} & {4{Active}}} |
     {{4{Alien2 & ShowAlien2 & ~border & (~FlashAlien2 | (FlashAlien2 & tout[4]))}} & {4{Active}}} |
     {{4{Alien3 & ShowAlien3 & ~border & (~FlashAlien3 | (FlashAlien3 & tout[4]))}} & {4{Active}}} | 
     {{4{Alien4 & ShowAlien4 & ~border & (~FlashAlien4 | (FlashAlien4 & tout[4]))}} & {4{Active}}} | 
     {{4{Alien5 & ShowAlien5 & ~border & (~FlashAlien5 | (FlashAlien5 & tout[4]))}} & {4{Active}}};
        
endmodule
