module shift_register_left (
    input clk,         // 時鐘信號
    input reset,       // 重置信號
    input shift_in,    // 進來的數據
    output reg [3:0] Q // 4-bit 左移寄存器
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 4'b0000;  // 當重置信號為高時，清空寄存器
        end else begin
            Q <= {Q[2:0], shift_in};  // 左移，新的數據進入最右邊
        end
    end

endmodule
