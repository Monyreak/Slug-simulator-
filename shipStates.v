`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2023 01:04:16 PM
// Design Name: 
// Module Name: shipStates
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

module shipStates(
    input clk,
    input go,
    input land,
    input contact,
    input contactpink,
    input gameover,
    input t1,
    input t3,
    
    output Fallsig,
    output LoadTar,
    output ResetPosition,
    output ShowShip,
    output ShowAlien,
    output FlashAlien,
    output ResetShipTimer,
    output IncSore
    
    );
    
    wire IDLE, FALL, ENDGAMEBOTH, GROUND, PILOT, CONTACTFLASH, ENDPILOT;
    wire NEXT_IDLE, NEXT_FALL, NEXT_ENDGAMEBOTH, NEXT_GROUND, NEXT_PILOT, NEXT_CONTACTFLASH, NEXT_ENDPILOT;
    
    wire [6:0] PS;
    wire [6:0] NS;
    
    FDRE #(.INIT(1'b1)) PS0FF (.C(clk), .CE(1'b1) , .D(NS[0]), .Q(PS[0]));
    FDRE PS12FF[6:1] (.C({6{clk}}), .CE({6{1'b1}}) , .D(NS[6:1]), .Q(PS[6:1]));
    
    assign IDLE = PS[0];
    assign FALL =  PS[1];
    assign ENDGAMEBOTH =  PS[2];
    assign GROUND = PS[3];
    assign PILOT = PS[4];
    assign CONTACTFLASH = PS[5];
    assign ENDPILOT = PS[6];
   
    assign NS[0] = NEXT_IDLE;
    assign NS[1] = NEXT_FALL;
    assign NS[2] = NEXT_ENDGAMEBOTH;
    assign NS[3] = NEXT_GROUND;
    assign NS[4] = NEXT_PILOT;
    assign NS[5] = NEXT_CONTACTFLASH;
    assign NS[6] = NEXT_ENDPILOT;
    
    assign NEXT_IDLE = (IDLE & ~go) | (FALL & contact & ~gameover) | (GROUND & ~t1 & contact & ~gameover) | (CONTACTFLASH & gameover);
    assign NEXT_FALL = (IDLE & go) | (FALL & ~land & ~gameover & ~ contact) | (ENDGAMEBOTH & go) | (PILOT & t3 & ~gameover) | (ENDPILOT & go) | (CONTACTFLASH & t1 & ~gameover);
    assign NEXT_ENDGAMEBOTH = (FALL & gameover & ~contact) | (ENDGAMEBOTH & ~ go) | (GROUND & gameover & ~ contact);
    assign NEXT_GROUND = (FALL & land & ~ contact & ~ gameover) | (GROUND & ~t1 & ~contact & ~ gameover);
    assign NEXT_PILOT = (GROUND & t1 & ~ gameover & ~contact) | (PILOT & ~t3 & ~contactpink & ~gameover);
    assign NEXT_CONTACTFLASH = (PILOT & ~gameover & contactpink & ~t3) | CONTACTFLASH & ~t1 & ~gameover;
    assign NEXT_ENDPILOT = PILOT & gameover | ENDPILOT & ~go;
    
    assign ShowShip = FALL | GROUND | ENDGAMEBOTH;
    assign Fallsig = FALL;
    assign ShowAlien = ~IDLE;
    
    assign FlashAlien = CONTACTFLASH;
    assign ResetShipTimer = (FALL & land & ~ contact & ~ gameover) | (GROUND & t1 & ~ gameover & ~contact) |(PILOT & ~gameover & contactpink & ~t3) ;
    
    assign LoadTar = (IDLE & go) | (ENDGAMEBOTH & go) | (PILOT & t3 & ~gameover) | (ENDPILOT & go) | (CONTACTFLASH & t1 & ~gameover);
    assign ResetPosition = (IDLE & go) | (ENDGAMEBOTH & go) | (PILOT & t3 & ~gameover) | (ENDPILOT & go) | (CONTACTFLASH & t1 & ~gameover); 
    assign IncSore = (PILOT & ~gameover & contactpink & ~t3);
endmodule
