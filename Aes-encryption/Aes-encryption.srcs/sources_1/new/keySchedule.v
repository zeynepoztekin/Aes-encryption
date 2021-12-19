`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2021 03:11:07 PM
// Design Name: 
// Module Name: keySchedule
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


module keySchedule(
    input [127:0] master_key,//Top modulden gelen tur anahtari (ilk basta disaridan verilen anahtara atanmistir.)
    input [5:0] r,//Anahtar uretiminin diger islemlerin sonunda gerceklesmesini kontrol edecek sayac.
    output reg [127:0] round_key//Her turda cikti olarak verilir.
 
    );
    reg basla=1'b1;//S-Box'a gonderilecek basla sinyali.
    reg [31:0] line1, line2, line3, line4, newline4;//Girdi olarak alinan anahtarin sutunlari.
    reg [127:0] kaydirilmis_durum;
      
    always@ (*) begin
        line1 = master_key[127:96];
        line2 = master_key[95:64];
        line3 = master_key[63:32];
        line4 = master_key[31:0];
        
        newline4 = {line4[23:0], line4[31:24]};//Son sutunun kaydirilmis hali.   
    end
        
    always@ (*) begin
        kaydirilmis_durum <= {line1, line2, line3, newline4};
    end
           
    
    reg [31:0] row1, row2, row3, sword;
    reg [127:0] durum;
    wire [31:0] new_sword;
        
    always@* begin
        //Anahtarin kaydirilmis halinin sutunlari.
        row1 = kaydirilmis_durum[127:96];
        row2 = kaydirilmis_durum[95:64];
        row3 = kaydirilmis_durum[63:32];
        sword = kaydirilmis_durum[31:0];  
    end 
    
    //Son sutunun sboxa gonderilmesi.
    sBox L0 (sword[31:24], basla, new_sword[31:24]);
    sBox L1 (sword[23:16], basla, new_sword[23:16]);
    sBox L2 (sword[15:8], basla, new_sword[15:8]);
    sBox L3 (sword[7:0], basla, new_sword[7:0]);
    
    always@ (*) begin
        durum <= {row1, row2, row3, new_sword};
    end
    
    reg [31:0] rcon;
    reg [3:0]sayac_next;
    
    
    always@ (*) begin
            sayac_next = (r-2)/4+1;
            case(sayac_next)
                //Yeni anahtar uretilirken kullanilan vetktorler.
                4'h1: rcon=32'h01000000;
                4'h2: rcon=32'h02000000;
                4'h3: rcon=32'h04000000;
                4'h4: rcon=32'h08000000;
                4'h5: rcon=32'h10000000;
                4'h6: rcon=32'h20000000;
                4'h7: rcon=32'h40000000;
                4'h8: rcon=32'h80000000;
                4'h9: rcon=32'h1b000000;
                4'ha: rcon=32'h36000000;
                default: rcon=32'h00000000;
            endcase
    end     
    reg [31:0] queue1, queue2, queue3, queue4;
    reg [31:0] newqueue1, newqueue2, newqueue3, newqueue4;
    
    always@ (*) begin
        //S-Box'a sokulmus durumun sutunlari.
        queue1 = durum[127:96];
        queue2 = durum[95:64];
        queue3 = durum[63:32];
        queue4 = durum[31:0];  
        newqueue1 = queue1 ^ queue4 ^ rcon;
        newqueue2 = queue2 ^ newqueue1;
        newqueue3 = queue3 ^ newqueue2;
        newqueue4 = line4 ^ newqueue3; 
    end
  
    always@ (*) begin
        round_key <= {newqueue1, newqueue2, newqueue3, newqueue4};//Tur anahtari.
    end

endmodule

