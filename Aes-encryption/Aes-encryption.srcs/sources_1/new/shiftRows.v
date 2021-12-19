`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2021 03:11:50 PM
// Design Name: 
// Module Name: shiftRows
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


module shiftRows(
    input [127:0] SubByted,//SubByte modulunun ciktisi.
    input clk,basla,
    output reg [127:0] ShiftRowed=0//Karistirma modulune verilecek olan cikis.
    );
    
    reg [31 : 0] col1=0, col2=0, col3=0, col4=0, newcol1=0, newcol2=0, newcol3=0, newcol4=0;
    
    always@* begin
        if(basla)begin
            //Sifrelenecek metin 4 sutuna bolunmustur. Metnin ilk 32 biti durum matrisinin ilk sutununa estir.
            col1 = SubByted[127:96];
            col2 = SubByted[95:64];
            col3 = SubByted[63:32];
            col4 = SubByted[31:0];
            //Sutunlarin ilk 8 biti sabit tutularak aslinda durum matrisinin ilk satiri sabit tutulmustur.
            //Sutunlardaki 8 bitlik parcalarin yerlerini degistirerek satir kaydirma islemi gerceklestirilir. 
            newcol1 = {col1[31:24], col2[23:16], col3[15:8], col4[7:0]};
            newcol2 = {col2[31:24], col3[23:16], col4[15:8], col1[7:0]};
            newcol3 = {col3[31:24], col4[23:16], col1[15:8], col2[7:0]};
            newcol4 = {col4[31:24], col1[23:16], col2[15:8], col3[7:0]};
        end
    end
  


    always@ (posedge clk) begin
        if(basla)
            ShiftRowed <={newcol1, newcol2, newcol3, newcol4};
        else
            ShiftRowed <= 128'b0;//Basla sinyalinin 1 olmadigi durumda cikisa '0' atamasi yapilir.
    end

endmodule
