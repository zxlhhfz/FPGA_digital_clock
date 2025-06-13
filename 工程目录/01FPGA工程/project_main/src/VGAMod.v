module VGAMod
(
    input           CLK,
    input           nRST,
    input           PixelClk,
    input   [5:0]   alarm_hourly_en,
    input   [5:0]   hour_decimal,
    input   [5:0]   minute_decimal,
    input   [5:0]   second_decimal,
    input   [2:0]   display_mode,
    input   [31:0]  TempHumi,
    input           flag_am_pm,
    input           alarm1_en, alarm2_en, alarm3_en,
    input   [5:0]   alarm1_second, alarm2_second, alarm3_second,
    output                     LCD_DE,
    output                     LCD_HSYNC,
    output                     LCD_VSYNC,
    output     reg     [4:0]   LCD_B,
    output     reg     [5:0]   LCD_G,
    output     reg     [4:0]   LCD_R
);

    reg  [15:0]  PixelCount;
    reg  [15:0]  LineCount;

    localparam      V_BackPorch = 16'd0;
    localparam      V_Pluse     = 16'd5; 
    localparam      HightPixel  = 16'd480;
    localparam      V_FrontPorch= 16'd45;

    localparam      H_BackPorch = 16'd182;
    localparam      H_Pluse     = 16'd1; 
    localparam      WidthPixel  = 16'd800; 
    localparam      H_FrontPorch= 16'd210;
    
    localparam      PixelForHS  = WidthPixel + H_BackPorch + H_FrontPorch;      
    localparam      LineForVS   = HightPixel + V_BackPorch + V_FrontPorch;

    wire [4:0] LCD_R_clock;
    wire [5:0] LCD_G_clock;
    wire [4:0] LCD_B_clock;

    wire [4:0] LCD_R_mode;
    wire [5:0] LCD_G_mode;
    wire [4:0] LCD_B_mode;

    wire [4:0] LCD_R_temphumi;
    wire [5:0] LCD_G_temphumi;
    wire [4:0] LCD_B_temphumi;    

    wire [4:0] LCD_R_clockimage;
    wire [5:0] LCD_G_clockimage;
    wire [4:0] LCD_B_clockimage; 

    wire [4:0] LCD_R_title;
    wire [5:0] LCD_G_title;
    wire [4:0] LCD_B_title;

    wire [4:0] LCD_R_alarmhourly;
    wire [5:0] LCD_G_alarmhourly;
    wire [4:0] LCD_B_alarmhourly;

    wire [4:0] LCD_R_alarmsettings;
    wire [5:0] LCD_G_alarmsettings;
    wire [4:0] LCD_B_alarmsettings;

    always @(posedge PixelClk or negedge nRST) begin
        if(!nRST) begin
            LineCount <= 16'b0;    
            PixelCount <= 16'b0;
        end
        else if(PixelCount == PixelForHS) begin
            PixelCount <= 16'b0;
            LineCount <= LineCount + 1'b1;
        end
        else if(LineCount == LineForVS) begin
            LineCount <= 16'b0;
            PixelCount <= 16'b0;
        end
        else
            PixelCount <= PixelCount + 1'b1;
    end

    assign LCD_HSYNC = ((PixelCount >= H_Pluse)&&(PixelCount <= (PixelForHS-H_FrontPorch))) ? 1'b0 : 1'b1;
    assign LCD_VSYNC = (((LineCount >= V_Pluse)&&(LineCount <= (LineForVS-0)))) ? 1'b0 : 1'b1;

    assign LCD_DE = ((PixelCount >= H_BackPorch)&&
                   (PixelCount <= PixelForHS-H_FrontPorch) &&
                   (LineCount >= V_BackPorch) &&
                   (LineCount <= LineForVS-V_FrontPorch-1)) ? 1'b1 : 1'b0;
    
    //数字钟显示模块
    digital_clock_display u_digital_clock_display(
        .PixelClk(PixelClk),
        .nRST(nRST),
        .PixelCount(PixelCount),
        .LineCount(LineCount),
        .hour_decimal(hour_decimal),
        .minute_decimal(minute_decimal),
        .second_decimal(second_decimal),
        .LCD_R(LCD_R_clock),
        .LCD_G(LCD_G_clock),
        .LCD_B(LCD_B_clock),
        .flag_am_pm(flag_am_pm)
    );

    //模式显示模块
    mode_display u_mode_display(
        .PixelClk(PixelClk),
        .nRST(nRST),
        .PixelCount(PixelCount),
        .LineCount(LineCount),
        .display_mode(display_mode),
        .LCD_R(LCD_R_mode),
        .LCD_G(LCD_G_mode),
        .LCD_B(LCD_B_mode)
    );

    //温湿度显示模块
    temp_humi_display u_temp_humi_display(
        .PixelClk(PixelClk),
        .nRST(nRST),
        .PixelCount(PixelCount),
        .LineCount(LineCount),
        .TempHumi(TempHumi),
        .LCD_R(LCD_R_temphumi),
        .LCD_G(LCD_G_temphumi),
        .LCD_B(LCD_B_temphumi)
    );
    
    //钟面显示模块
    clock_image_display u_clock_image_display(
        .PixelClk(PixelClk),
        .nRST(nRST),
        .PixelCount(PixelCount),
        .LineCount(LineCount),
        .LCD_R(LCD_R_clockimage),
        .LCD_G(LCD_G_clockimage),
        .LCD_B(LCD_B_clockimage),
        .hour_decimal(hour_decimal),
        .minute_decimal(minute_decimal),
        .second_decimal(second_decimal)        
    );
    

    //标题显示模块
    title_display u_title_display(
        .PixelClk(PixelClk),
        .nRST(nRST),
        .PixelCount(PixelCount),
        .LineCount(LineCount),
        .LCD_R(LCD_R_title),
        .LCD_G(LCD_G_title),
        .LCD_B(LCD_B_title)         
    );
    
    
    //整点报时显示模块
    alarm_hourly_display u_alarm_hourly_display(
        .PixelClk(PixelClk),
        .nRST(nRST),
        .PixelCount(PixelCount),
        .LineCount(LineCount),
        .hour_decimal(hour_decimal),
        .alarm_hourly_en(alarm_hourly_en),
        .LCD_R(LCD_R_alarmhourly),
        .LCD_G(LCD_G_alarmhourly),
        .LCD_B(LCD_B_alarmhourly)
    );

    //闹钟显示模块
    alarm_settings_display(
        .PixelClk(PixelClk),
        .nRST(nRST),
        .PixelCount(PixelCount),
        .LineCount(LineCount),
        .second_decimal(second_decimal),
        .alarm1_en(alarm1_en),
        .alarm2_en(alarm2_en),
        .alarm3_en(alarm3_en),
        .alarm1_second(alarm1_second),
        .alarm2_second(alarm2_second),
        .alarm3_second(alarm3_second),
        .LCD_R(LCD_R_alarmsettings),
        .LCD_G(LCD_G_alarmsettings),
        .LCD_B(LCD_B_alarmsettings)
    );
    

    always @(posedge PixelClk or negedge nRST) begin
        if(!nRST) begin
            LCD_R <= 5'b11111;
            LCD_G <= 6'b111111;
            LCD_B <= 5'b11111;
        end


        else if(PixelCount >= 190 && PixelCount < 640 && LineCount >= 80 && LineCount < 120) begin 
            LCD_R <= LCD_R_clock;
            LCD_G <= LCD_G_clock;
            LCD_B <= LCD_B_clock;
        end
        else if(PixelCount >= 190 && PixelCount < 520 && LineCount >= 130 && LineCount < 170) begin
            LCD_R <= LCD_R_mode;
            LCD_G <= LCD_G_mode;
            LCD_B <= LCD_B_mode;
        end
        else if(PixelCount >= 190 && PixelCount < 400 && LineCount >= 180 && LineCount < 270) begin
            LCD_R <= LCD_R_temphumi;
            LCD_G <= LCD_G_temphumi;
            LCD_B <= LCD_B_temphumi;
        end
        else if(PixelCount >= 600 && PixelCount < 860 && LineCount >= 180 && LineCount < 300) begin
            LCD_R <= LCD_R_clockimage;
            LCD_G <= LCD_G_clockimage;
            LCD_B <= LCD_B_clockimage;        
        end
        else if(PixelCount >= 190 && PixelCount < 400 && LineCount >= 280 && LineCount < 320) begin
            LCD_R <= LCD_R_alarmhourly;
            LCD_G <= LCD_G_alarmhourly;
            LCD_B <= LCD_B_alarmhourly;
        end
        else if(PixelCount >= 320 && PixelCount < 840 && LineCount >= 10 && LineCount < 50) begin
            LCD_R <= LCD_R_title;
            LCD_G <= LCD_G_title;
            LCD_B <= LCD_B_title;
        end
        else if(PixelCount >= 190 && PixelCount < 360 && LineCount >= 330 && LineCount < 370) begin
            LCD_R <= LCD_R_alarmsettings;
            LCD_G <= LCD_G_alarmsettings;
            LCD_B <= LCD_B_alarmsettings;
        end
        else begin
            LCD_R <= 5'b11111;
            LCD_G <= 6'b111111;
            LCD_B <= 5'b11111;
        end
    end

endmodule