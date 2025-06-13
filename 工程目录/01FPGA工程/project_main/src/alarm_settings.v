module alarm_settings(
    input clk,
    input rst_n,
    input [5:0] hour_decimal,
    input [5:0] minute_decimal,
    input [5:0] second_decimal,
    input [5:0] alarm1_hour, alarm1_minute, alarm1_second, //闹钟1参数
    input [5:0] alarm2_hour, alarm2_minute, alarm2_second, //闹钟2参数
    input [5:0] alarm3_hour, alarm3_minute, alarm3_second, //闹钟3参数
    output reg alarm1_en, alarm2_en, alarm3_en    
);


always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        alarm1_en <= 1'd0;
    end
    else begin
        if(alarm1_hour == 0 && alarm1_minute == 0 && alarm1_second == 0) begin
            alarm1_en <= 1'd0;  
        end
        else if(alarm1_hour == hour_decimal && alarm1_minute == minute_decimal && alarm1_second >= second_decimal - 4'd10 && alarm1_second <= second_decimal) begin
            alarm1_en <= 1'd1;
        end
        else begin
            alarm1_en <= 1'd0;
        end
    end

end

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        alarm2_en <= 1'd0;
    end
    else begin
        if(alarm2_hour == 0 && alarm2_minute == 0 && alarm2_second == 0) begin
            alarm2_en <= 1'd0;    
        end
        else if(alarm2_hour == hour_decimal && alarm2_minute == minute_decimal && alarm2_second >= second_decimal - 4'd10 && alarm2_second <= second_decimal) begin
            alarm2_en <= 1'd1;
        end
        else begin
            alarm2_en <= 1'd0;
        end
    end
end

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        alarm3_en <= 1'd0;
    end
    else begin
        if(alarm3_hour == 0 && alarm3_minute == 0 && alarm3_second == 0) begin
            alarm3_en <= 1'd0;    
        end
        else if(alarm3_hour == hour_decimal && alarm3_minute == minute_decimal && alarm3_second >= second_decimal - 4'd10 && alarm3_second <= second_decimal) begin
            alarm3_en <= 1'd1;
        end
        else begin
            alarm3_en <= 1'd0;
        end
    end
end

endmodule