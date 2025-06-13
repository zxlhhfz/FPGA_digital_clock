module mode_display(
    input PixelClk,
    input nRST,
    input [15:0] PixelCount,
    input [15:0] LineCount,
    input [2:0] display_mode,
    output reg [4:0] LCD_B,
    output reg [5:0] LCD_G,
    output reg [4:0] LCD_R
);

wire [0:39] xian_char [0:39] = '{
    40'h0000000000, 40'h0000000000, 40'h0000000400, 40'h0060000600, 40'h007FFFFE00, 40'h0070000E00, 40'h0070000E00, 40'h0030000E00,
    40'h0030000E00, 40'h0030000E00, 40'h003FFFFE00, 40'h0030000E00, 40'h0030000E00, 40'h0030000E00, 40'h0030000E00, 40'h0070000E00,
    40'h007FFFFE00, 40'h0070000E00, 40'h0060000800, 40'h0000000000, 40'h0001818000, 40'h000181C0C0, 40'h04018180E0, 40'h03018181E0,
    40'h03818181C0, 40'h01C1818380, 40'h00E1818700, 40'h00E1818600, 40'h0071818C00, 40'h0071819800, 40'h006181B000, 40'h000181C000,
    40'h0001818060, 40'h00018180F0, 40'h1FFFFFFFF8, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000
}; //汉字“显”

wire [0:39] shi1_char [0:39] = '{
    40'h0000000000, 40'h0000000000, 40'h0000000100, 40'h0000000780, 40'h01FFFFFFC0, 40'h0000000000, 40'h0000000000, 40'h0000000000,
    40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000030, 40'h0000000078, 40'h3FFFFFFFFC,
    40'h0000180000, 40'h0000180000, 40'h0000180000, 40'h0000180000, 40'h001C184000, 40'h001E182000, 40'h0038181800, 40'h0038180C00,
    40'h0070180600, 40'h00E0180700, 40'h00C0180380, 40'h01C01801C0, 40'h03801800E0, 40'h03001800F0, 40'h0600180070, 40'h0C00180070,
    40'h1800180020, 40'h200C380000, 40'h0007F80000, 40'h0001F80000, 40'h0000700000, 40'h0000600000, 40'h0000000000, 40'h0000000000
}; //汉字“示”

wire [0:39] mo_char [0:39] = '{
    40'h0000000000, 40'h0080080800, 40'h00E0070E00, 40'h00C0060C00, 40'h00C0060C00, 40'h00C0060C30, 40'h00C3FFFFF8, 40'h00C0060C00,
    40'h00C4060C00, 40'h00CE060C00, 40'h3FFF040800, 40'h00C0200080, 40'h00C03FFFE0, 40'h01C0300180, 40'h01C0300180, 40'h01E0300180,
    40'h01D8300180, 40'h03CC3FFF80, 40'h03CE300180, 40'h06C6300180, 40'h06C6300180, 40'h04C23FFFC0, 40'h0CC030C1C0, 40'h08C020C100,
    40'h18C000C000, 40'h10C001C010, 40'h20C001C038, 40'h40C7FFFFFC, 40'h00C001A000, 40'h00C0019000, 40'h00C0031800, 40'h00C0070C00,
    40'h00C0060600, 40'h00C00C0380, 40'h00C01801F0, 40'h00C07000FC, 40'h00C1C00070, 40'h008E000000, 40'h0000000000, 40'h0000000000
}; //汉字“模”

wire [0:39] shi2_char [0:39] = '{
    40'h0000000000, 40'h0000020000, 40'h0000038000, 40'h0000038C00, 40'h0000030700, 40'h0000030380, 40'h0000030380, 40'h0000030180,
    40'h0000030160, 40'h00000300F0, 40'h0FFFFFFFF8, 40'h0000030000, 40'h0000038000, 40'h0000038000, 40'h0000038000, 40'h0000018000,
    40'h0000218000, 40'h0000718000, 40'h0FFFF98000, 40'h000C018000, 40'h000C01C000, 40'h000C00C000, 40'h000C00C000, 40'h000C00C000,
    40'h000C00E000, 40'h000C006000, 40'h000C007008, 40'h000C007008, 40'h000C023808, 40'h000C3C3808, 40'h000FC01C08, 40'h007E000E18,
    40'h0FF0000F18, 40'h1F800007D8, 40'h0E000003F8, 40'h08000000F8, 40'h000000007C, 40'h000000000C, 40'h0000000000, 40'h0000000000
}; //汉字“式”

wire [0:39] jin_char [0:39] = '{
    40'h0000000000, 40'h0000000000, 40'h0000100800, 40'h00001C0E00, 40'h03001C0C00, 40'h01C0180C00, 40'h00E0180C00, 40'h00E0180C00,
    40'h00E0180C00, 40'h0040180C60, 40'h0007FFFFF0, 40'h0000180C00, 40'h0000180C00, 40'h0000180C00, 40'h0000180C00, 40'h00C0180C00,
    40'h3FE0180C00, 40'h00C0180C00, 40'h00C0180C00, 40'h00C0180C30, 40'h00CFFFFFF8, 40'h00C0180C00, 40'h00C0180C00, 40'h00C0180C00,
    40'h00C0180C00, 40'h00C0300C00, 40'h00C0300C00, 40'h00C0600C00, 40'h00C0400C00, 40'h00C0800C00, 40'h01C1000C00, 40'h0336000C00,
    40'h0E18000800, 40'h1C0E000000, 40'h3803FE03FC, 40'h1001FFFFF0, 40'h00001FFFE0, 40'h0000000000, 40'h0000000000, 40'h0000000000
}; //汉字“进”

wire [0:39] zhi_char [0:39] = '{
    40'h0000000000, 40'h0008000040, 40'h000E000070, 40'h000C000070, 40'h020C000060, 40'h038C000060, 40'h030C000060, 40'h070C102060,
    40'h060C383860, 40'h07FFFC3060, 40'h0C0C003060, 40'h080C003060, 40'h080C003060, 40'h100C043060, 40'h000C0E3060, 40'h3FFFFF3060,
    40'h000C003060, 40'h000C003060, 40'h000C003060, 40'h040C1C3060, 40'h07FFFC3060, 40'h060C183060, 40'h060C183060, 40'h060C183060,
    40'h060C183060, 40'h060C183060, 40'h060C183060, 40'h060C183060, 40'h060C182060, 40'h060D180060, 40'h060CF80060, 40'h060C300060,
    40'h040C200060, 40'h000C000060, 40'h000C001FE0, 40'h000C0003E0, 40'h000C0000E0, 40'h0008000080, 40'h0000000000, 40'h0000000000
}; //汉字“制”

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

wire [0:39] four_char [0:39] = '{
    40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000007800, 40'h000000F800,
    40'h000001F800, 40'h000003F800, 40'h00000EF800, 40'h00001CF800, 40'h000038F800, 40'h000060F800, 40'h0001C0F800, 40'h000380F800,
    40'h000700F800, 40'h000C00F800, 40'h003800F800, 40'h007000F800, 40'h00C000F800, 40'h018000F800, 40'h070000F800, 40'h0E0000F800,
    40'h1FFFFFFFF8, 40'h000000F800, 40'h000000F800, 40'h000000F800, 40'h000000F800, 40'h000000F800, 40'h000000F800, 40'h000001F800,
    40'h0000FFFFF0, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000, 40'h0000000000
};

always @(posedge PixelClk or negedge nRST) begin
        if(!nRST) begin
            LCD_R <= 5'd0;
            LCD_G <= 6'd0;
            LCD_B <= 5'd0;
        end
        else begin
            if(PixelCount >= 190 && PixelCount < 230 && LineCount >= 130 && LineCount < 170) begin
                integer x_pos;
                integer y_pos;
                x_pos = PixelCount - 190;
                y_pos = LineCount - 130;

                if(xian_char[y_pos][x_pos] == 1'b1) begin 
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
            else if(PixelCount >= 230 && PixelCount < 270 && LineCount >= 130 && LineCount < 170) begin
                integer x_pos;
                integer y_pos;
                x_pos = PixelCount - 230;
                y_pos = LineCount - 130;

                if(shi1_char[y_pos][x_pos] == 1'b1) begin 
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
            else if(PixelCount >= 270 && PixelCount < 310 && LineCount >= 130 && LineCount < 170) begin
                integer x_pos;
                integer y_pos;
                x_pos = PixelCount - 270;
                y_pos = LineCount - 130;

                if(mo_char[y_pos][x_pos] == 1'b1) begin 
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
            else if(PixelCount >= 310 && PixelCount < 350 && LineCount >= 130 && LineCount < 170) begin
                integer x_pos;
                integer y_pos;
                x_pos = PixelCount - 310;
                y_pos = LineCount - 130;

                if(shi2_char[y_pos][x_pos] == 1'b1) begin 
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
            else if(PixelCount >= 360 && PixelCount < 400 && LineCount >= 130 && LineCount < 170) begin
                integer x_pos;
                integer y_pos;
                x_pos = PixelCount - 360;
                y_pos = LineCount - 130;

                if(display_mode == 3'd0) begin
                    if(two_char[y_pos][x_pos] == 1'b1) begin 
                        LCD_R <= 5'b00000;
                        LCD_G <= 6'b000000;
                        LCD_B <= 5'b00000;
                    end
                    else begin
                        LCD_R <= 5'b00111;
                        LCD_G <= 6'b111111;
                        LCD_B <= 5'b11111;
                    end
                end
                else if(display_mode == 3'd1) begin
                    if(one_char[y_pos][x_pos] == 1'b1) begin 
                        LCD_R <= 5'b00000;
                        LCD_G <= 6'b000000;
                        LCD_B <= 5'b00000;
                    end
                    else begin
                        LCD_R <= 5'b00111;
                        LCD_G <= 6'b111111;
                        LCD_B <= 5'b11111;
                    end
                end
            end
            else if(PixelCount >= 400 && PixelCount < 440 && LineCount >= 130 && LineCount < 170) begin
                integer x_pos;
                integer y_pos;
                x_pos = PixelCount - 400;
                y_pos = LineCount - 130;

                if(display_mode == 3'd0) begin
                    if(four_char[y_pos][x_pos] == 1'b1) begin 
                        LCD_R <= 5'b00000;
                        LCD_G <= 6'b000000;
                        LCD_B <= 5'b00000;
                    end
                    else begin
                        LCD_R <= 5'b00111;
                        LCD_G <= 6'b111111;
                        LCD_B <= 5'b11111;
                    end
                end
                else if(display_mode == 3'd1) begin
                    if(two_char[y_pos][x_pos] == 1'b1) begin 
                        LCD_R <= 5'b00000;
                        LCD_G <= 6'b000000;
                        LCD_B <= 5'b00000;
                    end
                    else begin
                        LCD_R <= 5'b00111;
                        LCD_G <= 6'b111111;
                        LCD_B <= 5'b11111;
                    end
                end
            end
            else if(PixelCount >= 440 && PixelCount < 480 && LineCount >= 130 && LineCount < 170) begin 
                integer x_pos;
                integer y_pos;
                x_pos = PixelCount - 440;
                y_pos = LineCount - 130;

                if(jin_char[y_pos][x_pos] == 1'b1) begin 
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
            else if(PixelCount >= 480 && PixelCount < 520 && LineCount >= 130 && LineCount < 170) begin 
                integer x_pos;
                integer y_pos;
                x_pos = PixelCount - 480;
                y_pos = LineCount - 130;

                if(zhi_char[y_pos][x_pos] == 1'b1) begin 
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
        end
end

endmodule