module title_display(
    input PixelClk,
    input nRST,
    input [15:0] PixelCount,
    input [15:0] LineCount,
    output reg [4:0] LCD_B,
    output reg [5:0] LCD_G,
    output reg [4:0] LCD_R
);


wire [0:39] duo_char [0:39] = '{
    40'h0000000000, 40'h0000000000, 40'h0000C00000, 40'h0001C00000, 40'h0003FFFFC0, 40'h0007FFFFE0, 40'h000F0000E0, 40'h001E0001C0,
    40'h003C0003C0, 40'h00F8000380, 40'h01FC000700, 40'h07DE000E00, 40'h0F0F801C00, 40'h0003E03800, 40'h0001F0F000, 40'h00007DE000,
    40'h00003FC000, 40'h00000F0000, 40'h00007E0000, 40'h0003FF0000, 40'h007FC7FFF8, 40'h1FFE0FFFFE, 40'h1FC03C001E, 40'h000078000E,
    40'h0000F0000E, 40'h0003E0001C, 40'h001FF0001C, 40'h00FF7C0038, 40'h03F81E0078, 40'h01800F8070, 40'h000003C0E0, 40'h000001E3C0,
    40'h000000F780, 40'h0000003F00, 40'h0000007E00, 40'h000003F800, 40'h00007FC000, 40'h3FFFFE0000, 40'h3FFFC00000, 40'h0000000000
}; //汉字“多”

wire [0:39] cai_char [0:39] = '{
    40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000380060, 40'h0001F800E0, 40'h003FE001C0, 40'h1FFF0003C0, 40'h1FC01C0380,
    40'h00701C0700, 40'h1C781C0E00, 40'h1E38383C00, 40'h0E3C387800, 40'h071C71F000, 40'h071E73C038, 40'h038EE00078, 40'h0398E00070,
    40'h019C0000E0, 40'h001C0001C0, 40'h001C0003C0, 40'h001C000780, 40'h1FFFFC0F00, 40'h1FFFF83C00, 40'h003E007806, 40'h003F01F00E,
    40'h007F87C00E, 40'h007F8F001C, 40'h00FDC00038, 40'h01FDE00078, 40'h01DCE00070, 40'h039C7000E0, 40'h071C7001C0, 40'h0F1C380380,
    40'h1E1C000F00, 40'h381C001E00, 40'h001C007C00, 40'h001C01F000, 40'h001C07E000, 40'h001C1F0000, 40'h001C1C0000, 40'h0000000000
}; //汉字“彩”

wire [0:39] shu_char [0:39] = '{
    40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h000E003800, 40'h060E1C3800, 40'h070E1C3800, 40'h070E383800, 40'h038E383800,
    40'h038E703800, 40'h01CEF07FFE, 40'h018EE07FFE, 40'h3FFFFE7070, 40'h3FFFFEE070, 40'h001F80E070, 40'h003FC0F070, 40'h007FC1F070,
    40'h01EEE1F070, 40'h03CE73F070, 40'h0F8E7BF070, 40'h1F0E3FB870, 40'h1C0E1C3870, 40'h000E0038E0, 40'h0038003CE0, 40'h0078001CE0,
    40'h3FFFF81CE0, 40'h7FFFFC0FC0, 40'h00E01C0FC0, 40'h01C01C0FC0, 40'h03C01C0780, 40'h0780380780, 40'h0700380FC0, 40'h0FC0700FC0,
    40'h03F0E01CE0, 40'h007DE03CF0, 40'h001FC07870, 40'h000FF0F038, 40'h007FF9E03C, 40'h1FF83FC01E, 40'h3FC007000E, 40'h0000000000
}; //汉字“数”

wire [0:39] zi_char [0:39] = '{
    40'h0000000000, 40'h0000000000, 40'h0000300000, 40'h0000380000, 40'h00003C0000, 40'h00001C0000, 40'h00000C0000, 40'h0FFFFFFFF8,
    40'h1FFFFFFFFC, 40'h1C0000001C, 40'h1C0000001C, 40'h1C0000001C, 40'h1DFFFFFE1C, 40'h1DFFFFFFB8, 40'h1C000007B8, 40'h0000000F00,
    40'h0000003C00, 40'h000001F000, 40'h000007C000, 40'h00001F0000, 40'h00007C0000, 40'h0000700000, 40'h0000780000, 40'h00003C0000,
    40'h00000E0000, 40'h0000070000, 40'h3FFFFFFFFE, 40'h0000038000, 40'h0000038000, 40'h000001C000, 40'h000001C000, 40'h000001C000,
    40'h000001C000, 40'h000001C000, 40'h000001C000, 40'h0000038000, 40'h0030038000, 40'h007F0F0000, 40'h001FFE0000, 40'h0001F80000
}; //汉字“字”

wire [0:39] zhong_char [0:39] = '{
    40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0300003800, 40'h0700003800, 40'h0700003800, 40'h0700003800, 40'h0600003800,
    40'h0FFF803800, 40'h0FFF003800, 40'h1C003FFFFC, 40'h1C007FFFFC, 40'h380070381C, 40'h780070381C, 40'h700070381C, 40'h000070381C,
    40'h1FFF70381C, 40'h1FFF70381C, 40'h00E070381C, 40'h00E070381C, 40'h00E070381C, 40'h00E070381C, 40'h00E070381C, 40'h00E070381C,
    40'h3FFFF0381C, 40'h3FFFF0381C, 40'h00E070381C, 40'h00E07FFFFC, 40'h00E03FFFF8, 40'h00E0003800, 40'h00E0003800, 40'h00E0003800,
    40'h00E0003800, 40'h00E3003800, 40'h00E7003800, 40'h00EF003800, 40'h00FE003800, 40'h00F8003800, 40'h00F0003800, 40'h0000001800
}; //汉字“钟”

always @(posedge PixelClk or negedge nRST) begin
        if(!nRST) begin
            LCD_R <= 5'd0;
            LCD_G <= 6'd0;
            LCD_B <= 5'd0;
        end
        else begin
            if(PixelCount >= 320 && PixelCount < 360 && LineCount >= 10 && LineCount < 50) begin
                integer x_pos;
                integer y_pos;
                x_pos = PixelCount - 320;
                y_pos = LineCount - 10;

                if(duo_char[y_pos][x_pos] == 1'b1) begin 
                    LCD_R <= 5'b11111;
                    LCD_G <= 6'b000000;
                    LCD_B <= 5'b00000;
                end
                else begin
                    LCD_R <= 5'b11111;
                    LCD_G <= 6'b111111;
                    LCD_B <= 5'b11111;
                end
            end
            else if(PixelCount >= 440 && PixelCount < 480 && LineCount >= 10 && LineCount < 50) begin
                integer x_pos;
                integer y_pos;
                x_pos = PixelCount - 440;
                y_pos = LineCount - 10;

                if(cai_char[y_pos][x_pos] == 1'b1) begin 
                    LCD_R <= 5'b00000;
                    LCD_G <= 6'b111111;
                    LCD_B <= 5'b00000;
                end
                else begin
                    LCD_R <= 5'b11111;
                    LCD_G <= 6'b111111;
                    LCD_B <= 5'b11111;
                end
            end
            if(PixelCount >= 560 && PixelCount < 600 && LineCount >= 10 && LineCount < 50) begin
                integer x_pos;
                integer y_pos;
                x_pos = PixelCount - 560;
                y_pos = LineCount - 10;

                if(shu_char[y_pos][x_pos] == 1'b1) begin 
                    LCD_R <= 5'b00000;
                    LCD_G <= 6'b000000;
                    LCD_B <= 5'b11111;
                end
                else begin
                    LCD_R <= 5'b11111;
                    LCD_G <= 6'b111111;
                    LCD_B <= 5'b11111;
                end
            end
            if(PixelCount >= 680 && PixelCount < 720 && LineCount >= 10 && LineCount < 50) begin
                integer x_pos;
                integer y_pos;
                x_pos = PixelCount - 680;
                y_pos = LineCount - 10;

                if(zi_char[y_pos][x_pos] == 1'b1) begin 
                    LCD_R <= 5'b11111;
                    LCD_G <= 6'b000000;
                    LCD_B <= 5'b11111;
                end
                else begin
                    LCD_R <= 5'b11111;
                    LCD_G <= 6'b111111;
                    LCD_B <= 5'b11111;
                end
            end
            if(PixelCount >= 800 && PixelCount < 840 && LineCount >= 10 && LineCount < 50) begin
                integer x_pos;
                integer y_pos;
                x_pos = PixelCount - 800;
                y_pos = LineCount - 10;

                if(zhong_char[y_pos][x_pos] == 1'b1) begin 
                    LCD_R <= 5'b11111;
                    LCD_G <= 6'b110111;
                    LCD_B <= 5'b00000;
                end
                else begin
                    LCD_R <= 5'b11111;
                    LCD_G <= 6'b111111;
                    LCD_B <= 5'b11111;
                end
            end
        end
end
endmodule