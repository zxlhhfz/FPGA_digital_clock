module alarm_settings_display(
    input PixelClk,
    input nRST,
    input [15:0] PixelCount,
    input [15:0] LineCount,
    input alarm1_en, alarm2_en, alarm3_en,
    input [5:0] alarm1_second,
    input [5:0] alarm2_second,
    input [5:0] alarm3_second,
    input [5:0] second_decimal,
    output reg [4:0] LCD_B,
    output reg [5:0] LCD_G,
    output reg [4:0] LCD_R
);

wire [0:39] zhong_image [0:39] = '{
    40'h0000000000, 40'h0000000000, 40'h3C0000003C, 40'h6600000066, 40'h52000000DA, 40'h5BFFFFFF32, 40'h4BFFFFFFA2, 40'h67FFFFFFEC,
    40'h3C00000070, 40'h1C00000070, 40'h1C00100070, 40'h1C00300070, 40'h1C00100070, 40'h1C00100070, 40'h1C00100070, 40'h1C0010C070,
    40'h1C0011FC70, 40'h1C00178070, 40'h1C003E0070, 40'h1C003C0070, 40'h1C00380070, 40'h1C00380070, 40'h1C00000070, 40'h1C00000070,
    40'h1C00000070, 40'h1C00000070, 40'h1C00000070, 40'h1C00000070, 40'h1C00000070, 40'h1C00000070, 40'h1C00000070, 40'h1E000000F0,
    40'h0F000001E0, 40'h07FFFFFFC0, 40'h01FFFFFF00, 40'h01FFFFFF00, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000
}; //闹钟图形

wire [0:39] nao_char [0:39] = '{
    40'h0000000000, 40'h0040000000, 40'h0060000000, 40'h0030000040, 40'h0038FFFFF0, 40'h00180000E0, 40'h00180000E0, 40'h00186000E0,
    40'h07003000E0, 40'h07003800E0, 40'h06001800E0, 40'h06001810E0, 40'h06000038E0, 40'h063FFFFCE0, 40'h06001800E0, 40'h06001800E0,
    40'h06001800E0, 40'h06001800E0, 40'h06081830E0, 40'h060FFFF8E0, 40'h060C1830E0, 40'h060C1830E0, 40'h060C1830E0, 40'h060C1830E0,
    40'h060C1830E0, 40'h060C1830E0, 40'h060C1830E0, 40'h060C1A30E0, 40'h060C19F0E0, 40'h060C1860E0, 40'h06001840E0, 40'h06001800E0,
    40'h06001800E0, 40'h06001800E0, 40'h0600101FC0, 40'h06000007C0, 40'h0600000180, 40'h0400000100, 40'h0000000000, 40'h0000000000
}; //汉字“闹”

wire [0:39] zhong_char [0:39] = '{
    40'h0000000000, 40'h0080002000, 40'h00E0003800, 40'h01E0003000, 40'h01C0003000, 40'h0180003000, 40'h0181003000, 40'h0383803000,
    40'h03FF803000, 40'h0300003000, 40'h0600103030, 40'h06001FFFF8, 40'h0400183060, 40'h0C06183060, 40'h0FFF183060, 40'h18C0183060,
    40'h10C0183060, 40'h20C0183060, 40'h00C0183060, 40'h00C0183060, 40'h00C1183060, 40'h00C31FFFF0, 40'h3FFF983070, 40'h00C0183060,
    40'h00C0003000, 40'h00C0003000, 40'h00C0003000, 40'h00C0003000, 40'h00C1803000, 40'h00C3003000, 40'h00CC003000, 40'h00D8003000,
    40'h00F0003000, 40'h01E0003000, 40'h00E0003000, 40'h0040003000, 40'h0000003000, 40'h0000002000, 40'h0000000000, 40'h0000000000
}; //汉字“钟”

wire [0:39] one_char [0:39] = '{
    40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000060000, 40'h00000E0000,
    40'h0000FE0000, 40'h007FFE0000, 40'h00003E0000, 40'h00003E0000, 40'h00003E0000, 40'h00003E0000, 40'h00003E0000, 40'h00003E0000,
    40'h00003E0000, 40'h00003E0000, 40'h00003E0000, 40'h00003E0000, 40'h00003E0000, 40'h00003E0000, 40'h00003E0000, 40'h00003E0000,
    40'h00003E0000, 40'h00003E0000, 40'h00003E0000, 40'h00003E0000, 40'h00003E0000, 40'h00003E0000, 40'h00003E0000, 40'h00007F0000,
    40'h007FFFFF00, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000
};  

wire [0:39] two_char [0:39] = '{
    40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h00007F0000, 40'h001F87F800,
    40'h0078003E00, 40'h01E0001F80, 40'h03C0000FC0, 40'h07C00007C0, 40'h07E00007C0, 40'h07F00007C0, 40'h03F00007C0, 40'h0000000FC0,
    40'h0000000F80, 40'h0000001F00, 40'h0000003C00, 40'h000000F800, 40'h000001E000, 40'h0000078000, 40'h00001E0000, 40'h0000780000,
    40'h0001E00000, 40'h0007800000, 40'h001E000000, 40'h0038000060, 40'h00E00000C0, 40'h03C00001C0, 40'h07000007C0, 40'h0FFFFFFFC0,
    40'h0FFFFFFF80, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000
}; 

wire [0:39] three_char [0:39] = '{
    40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000FC0000, 40'h001F0FE000,
    40'h00F000F800, 40'h01E0003E00, 40'h03E0001F00, 40'h03F0001F80, 40'h03F0001F80, 40'h01E0001F80, 40'h0000001F00, 40'h0000001F00,
    40'h0000007C00, 40'h000001F000, 40'h00007F8000, 40'h0001FFC000, 40'h000000F800, 40'h0000001F00, 40'h0000000F80, 40'h00000007C0,
    40'h00000007E0, 40'h00000007E0, 40'h01C00007E0, 40'h07F00007E0, 40'h07F00007C0, 40'h07E0000F80, 40'h03E0001F00, 40'h01F0007C00,
    40'h003F07F000, 40'h0001FE0000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000
};

always @(posedge PixelClk or negedge nRST) begin
        if(!nRST) begin
            LCD_R <= 5'd0;
            LCD_G <= 6'd0;
            LCD_B <= 5'd0;
        end
        else begin
            if(PixelCount >= 190 && PixelCount < 230 && LineCount >= 330 && LineCount < 370) begin
                integer x_pos;
                integer y_pos;
                x_pos = PixelCount - 190;
                y_pos = LineCount - 330;

                if(nao_char[y_pos][x_pos] == 1'b1) begin 
                    LCD_R <= 5'b00000;
                    LCD_G <= 6'b000000;
                    LCD_B <= 5'b00000;
                end
                else begin
                    LCD_R <= 5'b11111;
                    LCD_G <= 6'b111111;
                    LCD_B <= 5'b11111;
                end
            end
            else if(PixelCount >= 230 && PixelCount < 270 && LineCount >= 330 && LineCount < 370) begin
                integer x_pos;
                integer y_pos;
                x_pos = PixelCount - 230;
                y_pos = LineCount - 330;

                if(zhong_char[y_pos][x_pos] == 1'b1) begin 
                    LCD_R <= 5'b00000;
                    LCD_G <= 6'b000000;
                    LCD_B <= 5'b00000;
                end
                else begin
                    LCD_R <= 5'b11111;
                    LCD_G <= 6'b111111;
                    LCD_B <= 5'b11111;
                end
            end
            else if(PixelCount >= 280 && PixelCount < 320 && LineCount >= 330 && LineCount < 370) begin
                integer x_pos;
                integer y_pos;
                x_pos = PixelCount - 280;
                y_pos = LineCount - 330;

                if(alarm1_en) begin
                    if(alarm1_second % 2 == 0) begin
                        if(second_decimal % 2 == 0) begin
                            if(zhong_image[y_pos][x_pos] == 1'b1) begin 
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
                        else begin
                            LCD_R <= 5'b11111;
                            LCD_G <= 6'b111111;
                            LCD_B <= 5'b11111;
                        end
                    end
                    else if(alarm1_second % 2 == 1) begin
                        if(second_decimal % 2 == 1) begin
                            if(zhong_image[y_pos][x_pos] == 1'b1) begin 
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
                        else begin
                            LCD_R <= 5'b11111;
                            LCD_G <= 6'b111111;
                            LCD_B <= 5'b11111;
                        end 
                    end
                end

                else if(alarm2_en) begin
                    if(alarm2_second % 2 == 0) begin
                        if(second_decimal % 2 == 0) begin
                            if(zhong_image[y_pos][x_pos] == 1'b1) begin 
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
                        else begin
                            LCD_R <= 5'b11111;
                            LCD_G <= 6'b111111;
                            LCD_B <= 5'b11111;
                        end
                    end
                    else if(alarm2_second % 2 == 1) begin
                        if(second_decimal % 2 == 1) begin
                            if(zhong_image[y_pos][x_pos] == 1'b1) begin 
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
                        else begin
                            LCD_R <= 5'b11111;
                            LCD_G <= 6'b111111;
                            LCD_B <= 5'b11111;
                        end 
                    end
                end

                else if(alarm3_en) begin
                    if(alarm3_second % 2 == 0) begin
                        if(second_decimal % 2 == 0) begin
                            if(zhong_image[y_pos][x_pos] == 1'b1) begin 
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
                        else begin
                            LCD_R <= 5'b11111;
                            LCD_G <= 6'b111111;
                            LCD_B <= 5'b11111;
                        end
                    end
                    else if(alarm3_second % 2 == 1) begin
                        if(second_decimal % 2 == 1) begin
                            if(zhong_image[y_pos][x_pos] == 1'b1) begin 
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
                        else begin
                            LCD_R <= 5'b11111;
                            LCD_G <= 6'b111111;
                            LCD_B <= 5'b11111;
                        end 
                    end
                end
            end
            else if(PixelCount >= 320 && PixelCount < 360 && LineCount >= 330 && LineCount < 370) begin
                integer x_pos;
                integer y_pos;
                x_pos = PixelCount - 320;
                y_pos = LineCount - 330;

                if(alarm1_en) begin
                    if(alarm1_second % 2 == 0) begin
                        if(second_decimal % 2 == 0) begin
                            if(one_char[y_pos][x_pos] == 1'b1) begin 
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
                        else begin
                            LCD_R <= 5'b11111;
                            LCD_G <= 6'b111111;
                            LCD_B <= 5'b11111;
                        end
                    end
                    else if(alarm1_second % 2 == 1) begin
                        if(second_decimal % 2 == 1) begin
                            if(one_char[y_pos][x_pos] == 1'b1) begin 
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
                        else begin
                            LCD_R <= 5'b11111;
                            LCD_G <= 6'b111111;
                            LCD_B <= 5'b11111;
                        end 
                    end
                end

                else if(alarm2_en) begin
                    if(alarm2_second % 2 == 0) begin
                        if(second_decimal % 2 == 0) begin
                            if(two_char[y_pos][x_pos] == 1'b1) begin 
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
                        else begin
                            LCD_R <= 5'b11111;
                            LCD_G <= 6'b111111;
                            LCD_B <= 5'b11111;
                        end
                    end
                    else if(alarm2_second % 2 == 1) begin
                        if(second_decimal % 2 == 1) begin
                            if(two_char[y_pos][x_pos] == 1'b1) begin 
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
                        else begin
                            LCD_R <= 5'b11111;
                            LCD_G <= 6'b111111;
                            LCD_B <= 5'b11111;
                        end 
                    end
                end

                else if(alarm3_en) begin
                    if(alarm3_second % 2 == 0) begin
                        if(second_decimal % 2 == 0) begin
                            if(three_char[y_pos][x_pos] == 1'b1) begin 
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
                        else begin
                            LCD_R <= 5'b11111;
                            LCD_G <= 6'b111111;
                            LCD_B <= 5'b11111;
                        end
                    end
                    else if(alarm3_second % 2 == 1) begin
                        if(second_decimal % 2 == 1) begin
                            if(three_char[y_pos][x_pos] == 1'b1) begin 
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
                        else begin
                            LCD_R <= 5'b11111;
                            LCD_G <= 6'b111111;
                            LCD_B <= 5'b11111;
                        end 
                    end
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

