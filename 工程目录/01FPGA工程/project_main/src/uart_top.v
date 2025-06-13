module uart_top(
    input               clk         ,  //系统时钟
    input               rst_n       ,  //系统复位，低有效
    input               uart_rxd    ,  //UART接收端口
    output [2:0] mode, //数字钟的模式 0-计时模式 1-输入模式 2-调整模式 3-12进制模式 4-24进制模式 5-闹钟1 6-闹钟2 7-闹钟3
    output [1:0] adjust_mode, //在调整模式下，1-调整小时 2-调整分钟 3-调整秒钟
    output [1:0] adjust_way, //在调整模式下，1-加模式 2-减模式
    output [5:0] adjust_hour, adjust_minute, adjust_second, //在输入模式下，输入的校准参数
    output [5:0] alarm1_hour, alarm1_minute, alarm1_second, //闹钟1参数
    output [5:0] alarm2_hour, alarm2_minute, alarm2_second, //闹钟2参数
    output [5:0] alarm3_hour, alarm3_minute, alarm3_second  //闹钟3参数
);

wire  [135:0]  uart_rx     ;   
wire           uart_rx_done;

uart_rx u_uart_rx(
    .clk(clk),
    .rst_n(rst_n),
    .uart_rxd(uart_rxd),
    .uart_rx_done(uart_rx_done),
    .uart_rx(uart_rx)
);

uart_decode u_uart_decode(
    .clk(clk),
    .rst_n(rst_n),
    .uart_rx(uart_rx),
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

endmodule