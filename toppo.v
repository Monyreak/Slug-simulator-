`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2023 11:07:51 AM
// Design Name: 
// Module Name: toppo
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


module toppo(   
    input clkin,
    input btnC,
    input btnL,
    input btnR,
    input btnD,
    input btnU,
    input [15:0] sw,
    
    output [15:0] led,
    output [3:0] an,
    output [6:0] seg,
    output dp,
    
    output [3:0] vgaRed,
    output [3:0] vgaBlue,
    output [3:0] vgaGreen,
    output Hsync,
    output Vsync
    );
    
    wire SynBtnC;
    wire SynBtnU;
    wire SynBtnD;
    wire SynBtnL;
    wire SynBtnR;
    
    wire clk, digsel;
    labVGA_clks not_so_slow (.clkin(clkin), .greset(SynBtnU), .clk(clk), .digsel(digsel));
    
    FDRE #(.INIT(1'b0)) BtnUFF  (.C(clk), .CE(1'b1), .R(1'b0), .D(btnU), .Q(SynBtnU));
    FDRE #(.INIT(1'b0)) BtnCFF (.C(clk), .CE(1'b1), .R(1'b0), .D(btnC), .Q(SynBtnC));
    FDRE #(.INIT(1'b0)) BtnLFF  (.C(clk), .CE(1'b1), .R(1'b0), .D(btnL), .Q(SynBtnL));
    FDRE #(.INIT(1'b0)) BtnRF  (.C(clk), .CE(1'b1), .R(1'b0), .D(btnR), .Q(SynBtnR));
    FDRE #(.INIT(1'b0)) BtnDFF  (.C(clk), .CE(1'b1), .R(1'b0), .D(btnD), .Q(SynBtnD));

    wire [15:0] VMain; 
    wire [15:0] HMain;
    
    PixelAddress PAdd (.clk(clk), .Hpix(HMain), .Vpix(VMain)); 
    
    wire frame1;
    assign frame1 = (HMain == 11'd788) & (VMain == 11'd523);
    wire frame2;
    assign frame2 = (HMain == 11'd789) & (VMain == 11'd523);
                                                      
    wire [3:0] vgaRedIn;
    wire [3:0] vgaGreenIn;
    wire [3:0] vgaBlueIn;
    
    wire InScoreSig;
    wire RScoreSig;
    
    vgaControl vga(
    .clk(clk), 
    .row(VMain), .col(HMain), 
    .BL(SynBtnL), 
    .BR(SynBtnR), 
    .BD(SynBtnD),
    .BC(SynBtnC),
    
    .frame1(frame1),
    .frame2(frame2),
    
    .IncScore(InScoreSig),
    .RScore(RScoreSig),
    .vgaRed(vgaRedIn), 
    .vgaGreen(vgaGreenIn), 
    .vgaBlue(vgaBlueIn)
    );

    wire [3:0] vgaRedOut;
    wire [3:0] vgaGreenOut;
    wire [3:0] vgaBlueOut;
    
    FDRE RedFF[3:0] (.C({4{clk}}), .CE({4{1'b1}}), .R({4{1'b0}}), .D(vgaRedIn[3:0]), .Q(vgaRedOut[3:0]));
    FDRE GreenFF[3:0] (.C({4{clk}}), .CE({4{1'b1}}), .R({4{1'b0}}), .D(vgaGreenIn[3:0]), .Q(vgaGreenOut[3:0]));
    FDRE BlueFF[3:0] (.C({4{clk}}), .CE({4{1'b1}}), .R({4{1'b0}}), .D(vgaBlueIn[3:0]), .Q(vgaBlueOut[3:0]));
    
    wire HSyncIn;
    wire VSyncIn;
    Syncs Syncer(.clk(clk), .HIn(HMain) , .VIn(VMain), .HSync(HSyncIn), .VSync(VSyncIn));
    
    wire HSyncOut, VSyncOut;
    
    FDRE #(.INIT(1'b1)) HsyncFF  (.C(clk), .CE(1'b1), .R(1'b0), .D(HSyncIn), .Q(HSyncOut));
    FDRE #(.INIT(1'b1)) VsyncFF (.C(clk), .CE(1'b1), .R(1'b0), .D(VSyncIn), .Q(VSyncOut));
    
    wire IncScore; 
    wire [7:0] ScoreOut;
    scoreCounter ScoreCount (.clk(clk) , .Inc(InScoreSig) , .r(RScoreSig) , .Q(ScoreOut));
    
    wire [15:0] InputSel;
    assign InputSel[7:0] = ScoreOut;
    
    wire [3:0] ringOut;
    ringCounter RC( .advance(digsel) , .clock(clk), .out(ringOut));
    
    wire [3:0] OutSel;
    Selector sel( .N(InputSel), .sel(ringOut), .H(OutSel));
    wire [6:0] myseg;
    hex7seg myhex(.n(OutSel), .s(myseg));
     
    assign seg = myseg;
    
    assign an[0] = ~(ringOut[0]);
    assign an[1] = ~(ringOut[1]);
    assign an[2] = 1'b1;
    assign an[3] = 1'b1;

    assign dp = 1'b1; 
    assign vgaRed = vgaRedOut;
    assign vgaBlue = vgaBlueOut;
    assign vgaGreen = vgaGreenOut;
    
    assign Hsync = HSyncOut;
    assign Vsync = VSyncOut;
  
endmodule   
