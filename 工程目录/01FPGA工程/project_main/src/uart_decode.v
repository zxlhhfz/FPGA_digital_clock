module uart_decode(
    input clk,
    input rst_n,
    input [135:0] uart_rx,
    output reg [2:0] mode, //数字钟的模式 0-计时模式 1-输入模式 2-调整模式 3-12进制模式 4-24进制模式 5-闹钟1 6-闹钟2 7-闹钟3
    output reg [1:0] adjust_mode, //在调整模式下，1-调整小时 2-调整分钟 3-调整秒钟
    output reg [1:0] adjust_way, //在调整模式下，1-加模式 2-减模式
    output reg [5:0] adjust_hour, adjust_minute, adjust_second, //在输入模式下，输入的校准参数
    output reg [5:0] alarm1_hour, alarm1_minute, alarm1_second, //闹钟1参数
    output reg [5:0] alarm2_hour, alarm2_minute, alarm2_second, //闹钟2参数
    output reg [5:0] alarm3_hour, alarm3_minute, alarm3_second  //闹钟3参数
);


    always @ (posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            mode <= 3'd0;
            adjust_mode <= 2'd0;
            adjust_way <= 2'd0;
            adjust_hour <= 6'd0;
            adjust_minute <= 6'd0;
            adjust_second <= 6'd0;
            alarm1_hour <= 6'd0;
            alarm1_minute <= 6'd0;
            alarm1_second <= 6'd0;
            alarm2_hour <= 6'd0;
            alarm2_minute <= 6'd0;
            alarm2_second <= 6'd0;
            alarm3_hour <= 6'd0;
            alarm3_minute <= 6'd0;
            alarm3_second <= 6'd0;
        end
        else begin
            mode <= uart_rx[122:120];
            adjust_mode <= uart_rx[113:112];
            adjust_way <= uart_rx[105:104];
            adjust_hour <= uart_rx[101:96];
            adjust_minute <= uart_rx[93:88];
            adjust_second <= uart_rx[85:80];
            alarm1_hour <= uart_rx[77:72];
            alarm1_minute <= uart_rx[69:64];
            alarm1_second <= uart_rx[61:56];
            alarm2_hour <= uart_rx[53:48];
            alarm2_minute <= uart_rx[45:40];
            alarm2_second <= uart_rx[37:32];
            alarm3_hour <= uart_rx[29:24];
            alarm3_minute <= uart_rx[21:16];
            alarm3_second <= uart_rx[13:8];
        end
//        else begin
//            mode <= mode;
//            adjust_mode <= adjust_mode;
//            adjust_way <= adjust_way;
//            adjust_hour <= adjust_hour;
//            adjust_minute <= adjust_minute;
//            adjust_second <=  adjust_second;
//            alarm1_hour <= alarm1_hour;
//            alarm1_minute <= alarm1_minute;
//            alarm1_second <= alarm1_second;
//            alarm2_hour <= alarm2_hour;
//            alarm2_minute <= alarm2_minute;
//            alarm2_second <= alarm2_second;
//            alarm3_hour <= alarm3_hour;
//            alarm3_minute <= alarm3_minute;
//            alarm3_second <= alarm3_second;
//        end
    end

endmodule