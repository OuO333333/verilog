module down_counter (
    input clk,         // 時鐘信號
    input reset,       // 重置信號
    input enable,      // 計數使能
    output reg [3:0] count // 4-bit 計數器
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000;  // 當重置信號為高時，將計數器清零
        end else if (enable) begin
            count <= count - 1;  // 計數器遞減
        end
    end

endmodule
