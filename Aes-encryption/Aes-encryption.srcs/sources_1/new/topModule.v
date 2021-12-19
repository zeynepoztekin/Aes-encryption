`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2021 03:12:15 PM
// Design Name: 
// Module Name: topModule
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


module topModule (
input [127:0] blok, anahtar,
input clk,rst,g_gecerli,
output reg hazir=1,c_gecerli=0,
output reg [127:0] sifre

    );
    
    reg [5:0] sayac=1;
    reg [3:0] basla=4'b1111;
    reg [127:0] firstText, anahtar_temp=0,biranahtar;
    wire [127:0] SubByted,ShifRowed, MixColed, AddedWire, yeni_anahtar,keyAdded;
    
    always@(blok)begin//Sifrelenecek metnin her degistigi durumda calisacak blok.
        if(hazir && g_gecerli)
            firstText=anahtar^blok;
            c_gecerli=0;
        end
    
    always@(anahtar)begin//Giris anahtari ilk verildiginde calisacak blok.
        if(hazir && g_gecerli)
            anahtar_temp=anahtar;//Sonrasinda basa tekrardan verilecek olan anahtar_temp degerine ilk degeri olan Master Key atanir.
            c_gecerli=0;
        end
        
    always@(yeni_anahtar)begin//Her yeni anahtar uretildiginde calisacak blok.
        #40;//Anahtarin senkron bir sekilde olusmasi icin uygulanan gecikme.
        biranahtar=yeni_anahtar;
    end
    
    always@(posedge clk)begin
        if(!rst)begin//Islemlerin takibi icin kullanilan her turda bir artan sayac.
            if(sayac>0)begin
            sayac=sayac+1;
            hazir=0;
            end
        if(sayac==6'h2a)begin//10. tura giris yapildigini belirten sart. 
            basla=4'b1011;//Giris yapildiginda mixCols modulunun durdurulmasi icin basla degeri degistirilir.
        end
        if(sayac==6'h2b)begin//Kodun sona geldigini kontrol eden sart. Butun islemler tamamlandiginda calisir ve kod sifirlanir.
            sifre<=AddedWire;
            hazir<=1;
            c_gecerli<=1;
            sayac<=0;
            basla<=0;
            firstText<=0;
            anahtar_temp<=0;
        end
        
        if(sayac==0 && hazir && anahtar_temp > 0)begin//Kodun ilk kullanimindan sonra bir kez daha sifreleme islemi yapilmak
        //istendiginde gerekli ayarlamalarin yapilmasini saglayan kontrol.
        sayac<=1;
        basla<=4'b1111;
        sifre<=0;//Yeni deger alindiginda bir onceki sifreleme sonucunu 0'a esitleyen satir.
        end
        if(yeni_anahtar>0 && sayac%4==2 && sayac>2)
        anahtar_temp<=yeni_anahtar;
        
        if(sayac%4==3 && sayac>3)//Subbyte modulunun girdisinin yalnizca ilk turun sonunda degismesini saglayacak sart.
        firstText<=AddedWire;
        
        end
        else begin//Reset sinyali 1 oldugunda yapilacak islemler.
            hazir<=1;
            sifre<=0;
            firstText<=0;
            sayac<=0;        
        end
    end
    //Boru hatti yontemi ile birbirlerinin cikislarina baglanan ve asil sifreleme isleminin gerceklesmesini saglayan kisim.
    subBytes mod1(firstText, clk, basla[0], SubByted);
    shiftRows mod2(SubByted, clk, basla[1], ShifRowed);
    mixCols mod3(clk, basla[2], ShifRowed, MixColed);
    addRoundKey mod5(MixColed,biranahtar, clk, basla[3], keyAdded,AddedWire); 
    keySchedule mod4(anahtar_temp,sayac,yeni_anahtar);
    
endmodule
