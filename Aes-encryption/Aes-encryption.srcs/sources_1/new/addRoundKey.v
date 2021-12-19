`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2021 03:04:22 PM
// Design Name: 
// Module Name: addRoundKey
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


module addRoundKey(
    input [127:0] MixColed, turAnahtari,
    input clk, basla,
    output reg [127:0] Added,
    output reg [127:0] keyAdded

    );
    
    always@* begin
        if(basla)
        keyAdded=MixColed^turAnahtari;
        //Sutun karistirma isleminin ciktisi ile KeySchedule modulunun ciktisi olan tur anahtari XOR islemine tabi tutulur.
    end
    
    always@ (posedge clk) begin
        Added <=keyAdded;
    end

endmodule
