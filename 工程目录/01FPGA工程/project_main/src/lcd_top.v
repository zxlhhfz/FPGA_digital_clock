module lcd_top
(
	input			Reset_Button,
    input           XTAL_IN,
	input	[5:0]	alarm_hourly_en,
    input   [5:0]   hour_decimal,
    input   [5:0]   minute_decimal,
    input   [5:0]   second_decimal,
    input   [2:0]   mode,
    input   [31:0]  TempHumi,
	input 			flag_am_pm,
    input           alarm1_en, alarm2_en, alarm3_en,
    input   [5:0]   alarm1_second,
    input   [5:0]   alarm2_second,
    input   [5:0]   alarm3_second,

	output			LCD_CLK,
	output			LCD_HYNC,
	output			LCD_SYNC,
	output			LCD_DEN,
	output	[4:0]	LCD_R,
	output	[5:0]	LCD_G,
	output	[4:0]	LCD_B

);


	wire		CLK_SYS;
	wire		CLK_PIX;

    wire        oscout_o;
    reg [2:0]  display_mode;

    Gowin_rPLL chip_pll
    (
        .clkout(CLK_SYS), //output clkout      //200M
        .clkoutd(CLK_PIX), //output clkoutd   //33.33M
        .clkin(XTAL_IN) //input clkin
    );

    always @ (posedge XTAL_IN or negedge Reset_Button) begin
		if(!Reset_Button)
			display_mode <= 3'd0; //默认24进制
		else if(mode == 3'd3) begin
			display_mode <= 3'd1;
        end
		else if(mode == 3'd4) begin
			display_mode <= 3'd0;
        end
	end

	VGAMod	D1
	(
		.CLK		(	CLK_SYS     ),
		.nRST		(	Reset_Button),

		.PixelClk	(	CLK_PIX		),
		.LCD_DE		(	LCD_DEN	 	),
		.LCD_HSYNC	(	LCD_HYNC 	),
    	.LCD_VSYNC	(	LCD_SYNC 	),

		.LCD_B		(	LCD_B		),
		.LCD_G		(	LCD_G		),
		.LCD_R		(	LCD_R		),

        .hour_decimal(hour_decimal),
        .minute_decimal(minute_decimal),
        .second_decimal(second_decimal),
        .display_mode(display_mode),
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

	assign		LCD_CLK		=	CLK_PIX;


endmodule
