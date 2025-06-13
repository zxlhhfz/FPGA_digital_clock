module divider_1s(
    input clk_27MHz, //板载晶振为27MHz
    input rst_n,
    output reg clk_1Hz_en //以时钟脉冲形式进行分频
);

    reg [31:0] count;

    always @ (posedge clk_27MHz or negedge rst_n) begin
        if(!rst_n) begin
            clk_1Hz_en <= 1'b0;
            count <= 32'b0;
        end
        else if(count == 32'd27000000) begin
            clk_1Hz_en <= 1'b1;
            count <= 32'b0;
        end
        else begin
            clk_1Hz_en <= 1'b0;
            count <= count + 1'b1;
        end
    end
endmodule
