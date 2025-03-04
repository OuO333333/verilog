module t_flip_flop (
    input clk,     // 時鐘信號
    input reset,   // 重置信號
    input T,       // 輸入控制信號
    output reg Q   // 輸出數據
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 0;  // 當重置信號為高時，Q 設為 0
        end else if (T) begin
            Q <= ~Q; // 當 T 為 1 時，反轉 Q 的值
        end
    end

endmodule
