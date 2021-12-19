`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2021 03:11:23 PM
// Design Name: 
// Module Name: mixCols
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


module mixCols(
    input clk,basla,
    input[127:0] ShiftRowed,
    output reg[127:0] mixColed=128'd0

    );
    
    function [7:0] iki(input [7:0] sayi);//Matris icerisinde iki ile carpilmasi icin kullanilan fonksiyon.
        begin
        iki=(8'd27 & {8{sayi[7]}})^(sayi<<1);
        end
    endfunction
    
    function [7:0] uc(input [7:0] sayi);//Matris icerisinde uc ile carpilmasi icin kullanilan fonksiyon.
        begin
        uc=sayi^iki(sayi);
        end
    endfunction
    
    function [31:0] teksutunkar(input [31:0] sutun);//Tek bir sutun icin carpim elde etmek icin kullanilan fonksiyon.
        reg [7:0] hucre [3:0];
        begin
            hucre[3]=iki(sutun[31:24])^ uc(sutun[23:16])^   sutun[15:8]^        sutun[7:0];
            hucre[2]=sutun[31:24]^      iki(sutun[23:16])^  uc(sutun[15:8])^    sutun[7:0];
            hucre[1]=sutun[31:24]^      sutun[23:16]^       iki(sutun[15:8])^   uc(sutun[7:0]);
            hucre[0]=uc(sutun[31:24])^  sutun[23:16]^       sutun[15:8]^        iki(sutun[7:0]);
            
            teksutunkar={hucre[3],hucre[2],hucre[1],hucre[0]};
            
        end
    endfunction
    always@(posedge clk)begin
        //Satirlarin cikisa esitlenmesi icin kullanilan atama.
        if(basla)begin
            mixColed<={teksutunkar(ShiftRowed[127:96]),
            teksutunkar(ShiftRowed[95:64]),
            teksutunkar(ShiftRowed[63:32]),
            teksutunkar(ShiftRowed[31:0])};
        end
        else if (ShiftRowed==0)
            mixColed<= 128'b0;
        else if (basla==0)
        //10. turda mixColumn isleminin gerceklesmemesi icin kullanilan ?art.   
            mixColed<= ShiftRowed;
    end  
endmodule
