module uart_rx(
    input                 clk         ,  //系统时钟
    input                 rst_n       ,  //系统复位，低有效
    input                 uart_rxd    ,  //UART接收端口
    output  reg           uart_rx_done,  //UART接收完成信号
    output       [135:0]  uart_rx        //UART接收到的数据
);
  
parameter CLK_FREQ = 27000000;               //系统时钟频率
parameter UART_BPS = 9600  ;               //串口波特率
localparam BAUD_CNT_MAX = CLK_FREQ/UART_BPS; //为得到指定波特率，对系统时钟计数BPS_CNT次

//reg define
reg          uart_rxd_d0;
reg          uart_rxd_d1;
reg          uart_rxd_d2;
reg          rx_flag    ;  //接收过程标志信号
reg  [3:0]   rx_cnt     ;  //接收数据计数器
reg  [15:0]  baud_cnt   ;  //波特率计数器
reg  [7:0]   rx_data_t  ;  //接收数据寄存器
reg  [4:0]   data_group; // 接收的数据组计数器
reg  [7:0]   uart_rx_data [16:0];

assign uart_rx = {uart_rx_data[0], uart_rx_data[1], uart_rx_data[2], uart_rx_data[3], uart_rx_data[4], 
                  uart_rx_data[5], uart_rx_data[6], uart_rx_data[7], uart_rx_data[8], uart_rx_data[9], 
                  uart_rx_data[10], uart_rx_data[11], uart_rx_data[12], uart_rx_data[13], uart_rx_data[14],
                  uart_rx_data[15], uart_rx_data[16]};

//assign uart_rx = {uart_rx_data[16], uart_rx_data[15], uart_rx_data[14], uart_rx_data[13], uart_rx_data[12], 
//                  uart_rx_data[11], uart_rx_data[10], uart_rx_data[9], uart_rx_data[8], uart_rx_data[7], 
//                  uart_rx_data[6], uart_rx_data[5], uart_rx_data[4], uart_rx_data[3], uart_rx_data[2],
//                  uart_rx_data[1], uart_rx_data[0]};
//wire define
wire        start_en;

//捕获接收端口下降沿(起始位)，得到一个时钟周期的脉冲信号
assign start_en = uart_rxd_d2 & (~uart_rxd_d1) & (~rx_flag);

//针对异步信号的同步处理
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        uart_rxd_d0 <= 1'b0;
        uart_rxd_d1 <= 1'b0;
        uart_rxd_d2 <= 1'b0;
    end
    else begin
        uart_rxd_d0 <= uart_rxd;
        uart_rxd_d1 <= uart_rxd_d0;
        uart_rxd_d2 <= uart_rxd_d1;
    end
end

//给接收标志赋值
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        rx_flag <= 1'b0;
    else if(start_en)    //检测到起始位
        rx_flag <= 1'b1; //接收过程中，标志信号rx_flag拉高
    //在停止位一半的时候，即接收过程结束，标志信号rx_flag拉低
    else if((rx_cnt == 4'd9) && (baud_cnt == BAUD_CNT_MAX/2 - 1'b1))
        rx_flag <= 1'b0;
    else
        rx_flag <= rx_flag;
end        

//波特率的计数器赋值
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        baud_cnt <= 16'd0;
    else if(rx_flag) begin     //处于接收过程时，波特率计数器（baud_cnt）进行循环计数
        if(baud_cnt < BAUD_CNT_MAX - 1'b1)
            baud_cnt <= baud_cnt + 16'b1;
        else 
            baud_cnt <= 16'd0; //计数达到一个波特率周期后清零
    end    
    else
        baud_cnt <= 16'd0;     //接收过程结束时计数器清零
end

//对接收数据计数器（rx_cnt）进行赋值
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        rx_cnt <= 4'd0;
    else if(rx_flag) begin                  //处于接收过程时rx_cnt才进行计数
        if(baud_cnt == BAUD_CNT_MAX - 1'b1) //当波特率计数器计数到一个波特率周期时
            rx_cnt <= rx_cnt + 1'b1;        //接收数据计数器加1
        else
            rx_cnt <= rx_cnt;
    end
    else
        rx_cnt <= 4'd0;                     //接收过程结束时计数器清零
end        

//根据rx_cnt来寄存rxd端口的数据
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        rx_data_t <= 8'b0;
    else if(rx_flag) begin                           //系统处于接收过程时
        if(baud_cnt == BAUD_CNT_MAX/2 - 1'b1) begin  //判断baud_cnt是否计数到数据位的中间
           case(rx_cnt)
               4'd1 : rx_data_t[0] <= uart_rxd_d2;   //寄存数据的最低位
               4'd2 : rx_data_t[1] <= uart_rxd_d2;
               4'd3 : rx_data_t[2] <= uart_rxd_d2;
               4'd4 : rx_data_t[3] <= uart_rxd_d2;
               4'd5 : rx_data_t[4] <= uart_rxd_d2;
               4'd6 : rx_data_t[5] <= uart_rxd_d2;
               4'd7 : rx_data_t[6] <= uart_rxd_d2;
               4'd8 : rx_data_t[7] <= uart_rxd_d2;   //寄存数据的高低位
               default : ;
            endcase  
        end
        else
            rx_data_t <= rx_data_t;
    end
    else
        rx_data_t <= 8'b0;
end        

//给接收完成信号和接收到的数据赋值
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        uart_rx_done <= 1'b0;
        data_group <= 5'd0; // 初始化数据组计数器
        uart_rx_data[0] <= 8'b0; // 初始化数据寄存器
        uart_rx_data[1] <= 8'b0;
        uart_rx_data[2] <= 8'b0;
        uart_rx_data[3] <= 8'b0;
        uart_rx_data[4] <= 8'b0;
        uart_rx_data[5] <= 8'b0;
        uart_rx_data[6] <= 8'b0;
        uart_rx_data[7] <= 8'b0;
        uart_rx_data[8] <= 8'b0;
        uart_rx_data[9] <= 8'b0;
        uart_rx_data[10] <= 8'b0;
        uart_rx_data[11] <= 8'b0;
        uart_rx_data[12] <= 8'b0;
        uart_rx_data[13] <= 8'b0;
        uart_rx_data[14] <= 8'b0;
        uart_rx_data[15] <= 8'b0;
        uart_rx_data[16] <= 8'b0;    
    end
    //当接收数据计数器计数到停止位，且baud_cnt计数到停止位的中间时
    else if(rx_cnt == 4'd9 && baud_cnt == BAUD_CNT_MAX/2 - 1'b1) begin
        if (data_group < 5'd17) begin // 确保接收到的数据组不超过4组
            uart_rx_data[data_group] <= rx_data_t; //将接收到的数据存储到对应组
            data_group <= data_group + 1'b1; // 增加数据组计数
        end
        uart_rx_done <= 1'b1; //拉高接收完成信号
    end
    else if (uart_rx_done) begin
        uart_rx_done <= 1'b0; // uart_rx_done拉高时重新准备接收
        if (data_group >= 5'd17) begin
            data_group <= 4'd0; // 如果达到最大组数，重置计数器
        end
    end    
    else begin
        uart_rx_done <= 1'b0;
        uart_rx_data[data_group] <= uart_rx_data[data_group]; // 保持当前数据
    end
end

endmodule