module project_main(
    input clk,
    input rst_n,
    input uart_rxd,
    inout dht11,

	output			LCD_CLK,
	output			LCD_HYNC,
	output			LCD_SYNC,
	output			LCD_DEN,
	output	[4:0]	LCD_R,
	output	[5:0]	LCD_G,
	output	[4:0]	LCD_B,
    output          BUZZER
);

wire [2:0] mode; //数字钟的模式 0-计时模式 1-输入模式 2-调整模式 3-12进制模式 4-24进制模式 5-闹钟1 6-闹钟2 7-闹钟3
wire [1:0] adjust_mode; //在调整模式下，1-调整小时 2-调整分钟 3-调整秒钟
wire [1:0] adjust_way; //在调整模式下，1-加模式 2-减模式
wire [5:0] adjust_hour, adjust_minute, adjust_second; //在输入模式下，输入的校准参数
wire [5:0] alarm1_hour, alarm1_minute, alarm1_second; //闹钟1参数
wire [5:0] alarm2_hour, alarm2_minute, alarm2_second; //闹钟2参数
wire [5:0] alarm3_hour, alarm3_minute, alarm3_second; //闹钟2参数
wire [5:0] hour_decimal; //时钟计数值
wire [5:0] minute_decimal; //分钟计数值
wire [5:0] second_decimal; //秒钟计数值
wire clk_1Hz_en; //以时钟脉冲形式进行分频
wire [31:0] TempHumi; //温湿度传感器采集信号
wire [5:0] alarm_hourly_en; //整点报时的使能信号  
wire flag_am_pm; //12/24进制的状态数
wire alarm1_en, alarm2_en, alarm3_en;

//分频器->1Hz
divider_1s u_divider_1s(
    .clk_27MHz(clk),
    .rst_n(rst_n),
    .clk_1Hz_en(clk_1Hz_en)
);

//串口接收模块
uart_top u_uart_top(
    .clk(clk),
    .rst_n(rst_n),
    .uart_rxd(uart_rxd),
    .mode(mode),
    .adjust_mode(adjust_mode),
    .adjust_way(adjust_way),
    .adjust_hour(adjust_hour),
    .adjust_minute(adjust_minute),
    .adjust_second(adjust_second),
    .alarm1_hour(alarm1_hour),
    .alarm1_minute(alarm1_minute),
    .alarm1_second(alarm1_second),
    .alarm2_hour(alarm2_hour),
    .alarm2_minute(alarm2_minute),
    .alarm2_second(alarm2_second),
    .alarm3_hour(alarm3_hour),
    .alarm3_minute(alarm3_minute),
    .alarm3_second(alarm3_second)    
);

//数字钟模块
digital_clock u_digital_clock(
    .clk(clk),
    .rst_n(rst_n),
    .clk_1Hz_en(clk_1Hz_en),
    .mode(mode),
    .hour_decimal(hour_decimal),
    .minute_decimal(minute_decimal),
    .second_decimal(second_decimal),
    .adjust_hour(adjust_hour),
    .adjust_minute(adjust_minute),
    .adjust_second(adjust_second),
    .adjust_mode(adjust_mode),
    .adjust_way(adjust_way),
    .flag_am_pm(flag_am_pm)
);

//温湿度传感器模块
dht11 u_dht11(
    .clk(clk),
    .rst_n(rst_n),
    .dht11(dht11),
    .TempHumi(TempHumi)
);

//LCD屏幕顶层模块
lcd_top u_lcd_top(
    .Reset_Button(rst_n),
    .XTAL_IN(clk),
    .LCD_CLK(LCD_CLK),
    .LCD_HYNC(LCD_HYNC),
    .LCD_SYNC(LCD_SYNC),
    .LCD_DEN(LCD_DEN),
    .LCD_R(LCD_R),
    .LCD_G(LCD_G),
    .LCD_B(LCD_B),
    .hour_decimal(hour_decimal),
    .minute_decimal(minute_decimal),
    .second_decimal(second_decimal),
    .mode(mode),
    .TempHumi(TempHumi),
    .alarm_hourly_en(alarm_hourly_en),
    .flag_am_pm(flag_am_pm),
    .alarm1_en(alarm1_en),
    .alarm2_en(alarm2_en),
    .alarm3_en(alarm3_en),
    .alarm1_second(alarm1_second),
    .alarm2_second(alarm2_second),
    .alarm3_second(alarm3_second)
);

alarm_hourly u_alarm_hourly(
    .clk(clk),
    .rst_n(rst_n),
    .hour_decimal(hour_decimal),
    .minute_decimal(minute_decimal),
    .second_decimal(second_decimal),
    .alarm_hourly_en(alarm_hourly_en)
);

alarm_settings u_alarm_settings(
    .clk(clk),
    .rst_n(rst_n),
    .hour_decimal(hour_decimal),
    .minute_decimal(minute_decimal),
    .second_decimal(second_decimal),
    .alarm1_hour(alarm1_hour),
    .alarm1_minute(alarm1_minute),
    .alarm1_second(alarm1_second),
    .alarm2_hour(alarm2_hour),
    .alarm2_minute(alarm2_minute),
    .alarm2_second(alarm2_second),
    .alarm3_hour(alarm3_hour),
    .alarm3_minute(alarm3_minute),
    .alarm3_second(alarm3_second),
//    .alarm1_hour(6'd5),
//    .alarm1_minute(6'd0),
//    .alarm1_second(6'd12),
//    .alarm2_hour(6'd5),
//    .alarm2_minute(6'd0),
//    .alarm2_second(6'd33),
//    .alarm3_hour(6'd5),
//    .alarm3_minute(6'd1),
//    .alarm3_second(6'd10),
    .alarm1_en(alarm1_en),
    .alarm2_en(alarm2_en),
    .alarm3_en(alarm3_en)
);

Buzzer u_Buzzer(
    .CLK(clk),
    .nRST(rst_n),
    .BUZZER(BUZZER),
    .shouldTick(1'd0),
    .isTimeUp(1'd0),
    .alarm1_en(alarm1_en),
    .alarm2_en(alarm2_en),
    .alarm3_en(alarm3_en)
);


endmodule