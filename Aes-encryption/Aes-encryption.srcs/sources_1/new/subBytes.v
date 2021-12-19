`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2021 03:12:04 PM
// Design Name: 
// Module Name: subBytes
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



module subBytes(
input [127:0]nonSubByted,//Subbyte isleminden onceki sifrelenecek metin.
input clk,basla,//S-box'a gonderilecek basla ve saat sinyalleri.
output reg [127:0]SubByted//Subbyte isleminden sonraki s-box degerleri ile degistirilmis metin.
    );
    wire [127:0] SubByted_next;
    //Gelen metnin S-Box'a gonderilip subByte isleminin uygulandigi yer.
    sBox L0 (.a(nonSubByted[127:120]),  .basla(basla),  .b(SubByted_next[127:120]));
    sBox L1 (.a(nonSubByted[119:112]),  .basla(basla),  .b(SubByted_next[119:112]));
    sBox L2 (.a(nonSubByted[111:104]),  .basla(basla),  .b(SubByted_next[111:104]));
    sBox L3 (.a(nonSubByted[103:96]),   .basla(basla),  .b(SubByted_next[103:96]) ); 
    sBox L4 (.a(nonSubByted[95:88]),    .basla(basla),  .b(SubByted_next[95:88])  );
    sBox L5 (.a(nonSubByted[87:80]),    .basla(basla),  .b(SubByted_next[87:80])  );
    sBox L6 (.a(nonSubByted[79:72]),    .basla(basla),  .b(SubByted_next[79:72])  );
    sBox L7 (.a(nonSubByted[71:64]),    .basla(basla),  .b(SubByted_next[71:64])  );
    sBox L8 (.a(nonSubByted[63:56]),    .basla(basla),  .b(SubByted_next[63:56])  );
    sBox L9 (.a(nonSubByted[55:48]),    .basla(basla),  .b(SubByted_next[55:48])  );
    sBox L10(.a(nonSubByted[47:40]),    .basla(basla),  .b(SubByted_next[47:40])  );
    sBox L11(.a(nonSubByted[39:32]),    .basla(basla),  .b(SubByted_next[39:32])  );
    sBox L12(.a(nonSubByted[31:24]),    .basla(basla),  .b(SubByted_next[31:24])  );
    sBox L13(.a(nonSubByted[23:16]),    .basla(basla),  .b(SubByted_next[23:16])  );
    sBox L14(.a(nonSubByted[15:8]),     .basla(basla),  .b(SubByted_next[15:8])   );
    sBox L16(.a(nonSubByted[7:0]),      .basla(basla),  .b(SubByted_next[7:0])    );

    always@(posedge clk)begin
        SubByted<=SubByted_next;//Clock icinde yapilan s-box'tan gelen degerleri SubByted'a atama islemi.
    end
endmodule
