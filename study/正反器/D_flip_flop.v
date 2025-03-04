module d_flip_flop (
    input clk,     // 時鐘信號
    input reset,   // 重置信號
    input D,       // 輸入數據
    output reg Q   // 輸出數據
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 0;  // 當重置信號為高時，Q 設為 0
        end else begin
            Q <= D;  // 否則，Q 設為 D 的值
        end
    end

endmodule
