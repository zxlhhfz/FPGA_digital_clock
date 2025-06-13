module Buzzer(
    input CLK,
    input nRST,
    input CP_1Hz,
    output reg BUZZER,
    input shouldTick,
    input isTimeUp,
    input button,
    input alarm1_en, alarm2_en, alarm3_en 
);

// 节拍计数器参数 (假设CP_1Hz是1Hz时钟)
parameter BEAT_COUNT = 24'd20000000; // 每个音符持续0.5秒(根据CP_1Hz调整)

// 音符频率参数 
parameter SILENCE = 18'd0;
//parameter DO  = 18'd91599;  // 261.63 Hz (C4)
//parameter RE  = 18'd81631;  // 293.66 Hz (D4)
//parameter MI  = 18'd72726;  // 329.63 Hz (E4)
//parameter FA  = 18'd68766;  // 349.23 Hz (F4)
//parameter SO  = 18'd61224;  // 392.00 Hz (G4)
//parameter LA  = 18'd54544;  // 440.00 Hz (A4)
//parameter XI  = 18'd48581;  // 493.88 Hz (B4)

parameter DO  = 18'd76335;  // 261.63 Hz (C4)
parameter RE  = 18'd68259;  // 293.66 Hz (D4)
parameter MI  = 18'd60790;  // 329.63 Hz (E4)
parameter FA  = 18'd57306;  // 349.23 Hz (F4)
parameter SO  = 18'd51020;  // 392.00 Hz (G4)
parameter LA  = 18'd45454;  // 440.00 Hz (A4)
parameter XI  = 18'd40567;  // 493.88 Hz (B4)

// 闹钟和滴答声频率
parameter ALARM = 18'd113636; // LA音作为闹铃
parameter TICK  = 18'd191112; // DO音作为滴答声

reg [23:0] beat_cnt = 0;
reg [3:0] note_index = 0;
reg [17:0] freq_cnt = 0;
reg [17:0] freq_data = 0;
wire [16:0] duty_data;

// 节拍计数器
always @(posedge CLK or negedge nRST) begin
    if (!nRST) begin
        beat_cnt <= 0;
        note_index <= 0;
    end else begin
        if (isTimeUp) begin
            beat_cnt <= 0;
            note_index <= 0;
        end else if (shouldTick) begin
            beat_cnt <= 0;
            note_index <= 0;
        end else if (beat_cnt == BEAT_COUNT) begin
            beat_cnt <= 0;
            note_index <= (note_index == 15) ? 0 : note_index + 1;
        end else begin
            beat_cnt <= beat_cnt + 1;
        end
    end
end

// 音符选择逻辑
always @(posedge CLK or negedge nRST) begin
    if (!nRST) begin
        freq_data <= SILENCE;
    end else begin
        if (isTimeUp) begin
            freq_data <= ALARM;
        end else if (shouldTick) begin
            freq_data <= TICK;
        end else if (alarm1_en || alarm2_en || alarm3_en) begin
            case(note_index)
                // 小星星第一段: DO DO SO SO LA LA SO
                4'd0: freq_data <= DO;
                4'd1: freq_data <= DO;
                4'd2: freq_data <= SO;
                4'd3: freq_data <= SO;
                4'd4: freq_data <= LA;
                4'd5: freq_data <= LA;
                4'd6: freq_data <= SO;
                4'd7: freq_data <= SILENCE;
                
                // 小星星第二段: FA FA MI MI RE RE DO
                4'd8:  freq_data <= FA;
                4'd9:  freq_data <= FA;
                4'd10: freq_data <= MI;
                4'd11: freq_data <= MI;
                4'd12: freq_data <= RE;
                4'd13: freq_data <= RE;
                4'd14: freq_data <= DO;
                4'd15: freq_data <= SILENCE;
                
                default: freq_data <= SILENCE;
            endcase
        end else
            freq_data <= SILENCE;
    end
end

// 频率计数器
always @(posedge CLK or negedge nRST) begin
    if(!nRST) begin
        freq_cnt <= 18'd0;
    end else begin
        if(freq_cnt >= freq_data) begin
            freq_cnt <= 18'd0;
        end else begin
            freq_cnt <= freq_cnt + 1;
        end
    end
end

// 占空比设置 (50%)
assign duty_data = freq_data >> 1;

// PWM输出
always @(posedge CLK or negedge nRST) begin
    if(!nRST) begin   
        BUZZER <= 1'b0; 
    end else begin
        if (freq_data == SILENCE) begin
            BUZZER <= 1'b0;
        end else if (freq_cnt == duty_data) begin
            BUZZER <= ~BUZZER;
        end
    end
end

endmodule