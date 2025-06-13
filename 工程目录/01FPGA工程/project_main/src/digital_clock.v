module digital_clock(
    input clk,
    input rst_n,
    input clk_1Hz_en,
    input [2:0] mode,
    input [5:0] adjust_hour, 
    input [5:0] adjust_minute, 
    input [5:0] adjust_second,
    input [1:0] adjust_mode,
    input [1:0] adjust_way,
    output reg [5:0] hour_decimal,
    output reg [5:0] minute_decimal,
    output reg [5:0] second_decimal,
    output reg flag_am_pm
);

reg display_mode;
reg count;

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        display_mode <= 1'd0;
    end
    else if(mode == 3'd3) begin
        display_mode <= 1'd1;
    end
    else if(mode == 3'd4) begin
        display_mode <= 1'd0;
    end
    else begin
        display_mode <= display_mode;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        flag_am_pm <= 1'd0;
    end
    else if(display_mode == 1'd1) begin //12进制
        if(count == 1'd0)
            flag_am_pm <= 1'd0;
        else if(count == 1'd1)
            flag_am_pm <= 1'd1;
    end
    else if(display_mode == 1'd0) begin //24进制
        if(hour_decimal <= 6'd11)
            flag_am_pm <= 1'd0;
        else
            flag_am_pm <= 1'd1;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        hour_decimal <= 6'd4;
        minute_decimal <= 6'd59;
        second_decimal <= 6'd46;
        count <= 1'd0;
    end
    else if(mode == 3'd1) begin
        hour_decimal <= adjust_hour;
        minute_decimal <= adjust_minute;
        second_decimal <= adjust_second;
    end
    else if(mode == 3'd2 && clk_1Hz_en == 1'b1) begin
        if(adjust_mode == 2'd0) begin
            hour_decimal <= hour_decimal;
            minute_decimal <= minute_decimal;
            second_decimal <= second_decimal;
        end
        if(adjust_mode == 2'd1) begin
            if(adjust_way == 2'd1) begin
                if(display_mode == 1'd1) begin
                    if(hour_decimal == 6'd11)
                        hour_decimal <= 6'd0;
                    else
                        hour_decimal <= hour_decimal + 1'd1;
                end
                else if(display_mode == 1'd0) begin
                    if(hour_decimal == 6'd23)
                        hour_decimal <= 6'd0;
                    else
                        hour_decimal <= hour_decimal + 1'd1;
                end
            end
            else if(adjust_way == 2'd2) begin
                if(hour_decimal == 6'd0)
                    hour_decimal <= 6'd23;
                else
                    hour_decimal <= hour_decimal - 1'd1;
            end               
        end
        else if(adjust_mode == 2'd2) begin
            if(adjust_way == 2'd1) begin
                if(minute_decimal == 6'd59)
                    minute_decimal <= 6'd0;
                else
                    minute_decimal <= minute_decimal + 1'd1;
            end
            else if(adjust_way == 2'd2) begin
                if(minute_decimal == 6'd0)
                    minute_decimal <= 6'd59;
                else
                    minute_decimal <= minute_decimal - 1'd1;
            end               
        end
        else if(adjust_mode == 2'd3) begin
            if(adjust_way == 2'd1) begin
                if(second_decimal == 6'd59)
                    second_decimal <= 6'd0;
                else
                    second_decimal <= second_decimal + 1'd1;
            end
            else if(adjust_way == 2'd2) begin
                if(second_decimal == 6'd0)
                    second_decimal <= 6'd59;
                else
                    second_decimal <= second_decimal - 1'd1;
            end               
        end
    end
    else if(clk_1Hz_en == 1) begin
        if(display_mode <= 1'd0) begin
            if(hour_decimal == 6'd23 && minute_decimal == 6'd59 && second_decimal == 6'd59) begin
                hour_decimal <= 6'd0;
                minute_decimal <= 6'd0;
                second_decimal <= 6'd0;
            end
            else if(minute_decimal == 6'd59 && second_decimal == 6'd59) begin
                hour_decimal <= hour_decimal + 1'd1;
                minute_decimal <= 6'd0;
                second_decimal <= 6'd0;        
            end
            else if(second_decimal == 6'd59) begin
                minute_decimal <= minute_decimal + 1'd1;
                second_decimal <= 6'd0;        
            end
            else begin
                second_decimal <= second_decimal + 1'd1;
            end
        end
        else if(display_mode <= 1'd1) begin
            hour_decimal <= hour_decimal % 12;
            if(hour_decimal == 6'd11 && minute_decimal == 6'd59 && second_decimal == 6'd59) begin
                count <= count + 1'd1;
                hour_decimal <= 6'd0;
                minute_decimal <= 6'd0;
                second_decimal <= 6'd0;
            end
            else if(minute_decimal == 6'd59 && second_decimal == 6'd59) begin
                hour_decimal <= hour_decimal + 1'd1;
                minute_decimal <= 6'd0;
                second_decimal <= 6'd0;        
            end
            else if(second_decimal == 6'd59) begin
                minute_decimal <= minute_decimal + 1'd1;
                second_decimal <= 6'd0;        
            end
            else begin
                second_decimal <= second_decimal + 1'd1;
            end
        end
    end

end

endmodule