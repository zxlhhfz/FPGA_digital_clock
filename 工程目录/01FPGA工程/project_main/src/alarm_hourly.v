module alarm_hourly(
    input clk,
    input rst_n,
    input [5:0] hour_decimal,
    input [5:0] minute_decimal,
    input [5:0] second_decimal,
    output reg [5:0] alarm_hourly_en //整点报时的使能信号   
);

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n)
        alarm_hourly_en <= 6'd0;
    else if(minute_decimal == 6'd0 && second_decimal <= 6'd0 + hour_decimal * 2) 
        alarm_hourly_en <= second_decimal + 1'd1; 
    else
        alarm_hourly_en <= 6'd0;

end

endmodule