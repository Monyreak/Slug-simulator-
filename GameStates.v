`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2023 03:20:32 PM
// Design Name: 
// Module Name: GameStates
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


module GameStates(
    input clk,
    input btnC,
    input t5,
    input contact,
    
    output goSig,
    output endSig,
    output globalSig,
    output resettmain,
    output FlashPlayer,
    output FlashBorder
    );
    
    wire IDLE, SPAWN, GAME, END;
    wire NEXT_IDLE, NEXT_SPAWN, NEXT_GAME, NEXT_END;
    wire [3:0] PS;
    wire [3:0] NS;
    
    FDRE #(.INIT(1'b1)) PS0FF (.C(clk), .CE(1'b1) , .D(NS[0]), .Q(PS[0]));
    FDRE PS12FF[3:1] (.C({3{clk}}), .CE({3{1'b1}}) , .D(NS[3:1]), .Q(PS[3:1]));
    
    assign IDLE = PS[0];
    assign SPAWN =  PS[1];
    assign GAME =  PS[2];
    assign END = PS[3];
    
    assign NS[0] = NEXT_IDLE;
    assign NS[1] = NEXT_SPAWN;
    assign NS[2] = NEXT_GAME;
    assign NS[3] = NEXT_END;
    
    assign NEXT_IDLE = IDLE & ~btnC;
    assign NEXT_SPAWN = (IDLE & btnC) | (SPAWN & ~ t5  & ~ contact) | (END & btnC);
    assign NEXT_GAME = (SPAWN & t5  & ~ contact) | (GAME & ~contact);
    assign NEXT_END = (SPAWN & contact) | (GAME & contact) | (END & ~btnC);
    
    assign goSig = SPAWN;
    assign endSig = END;
    assign FlashPlayer =  END;
    assign FlashBorder =  END; 
    assign resettmain = (IDLE & btnC) | (END & btnC);
    assign globalSig = (END & btnC);
   
endmodule
