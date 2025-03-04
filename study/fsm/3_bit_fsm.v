module state_machine (
    input clk,             // Clock signal
    input reset,           // Reset signal (synchronous or asynchronous)
    input x,               // Input signal
    output reg [2:0] state // 3-bit state output
);

    // 3-bit state machine states
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;

    // Synchronous reset state machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;  // Reset to state S0
        end else begin
            case (state)
                S0: state <= (x) ? S2 : S1;  // Transition from S0
                S1: state <= (x) ? S4 : S3;  // Transition from S1
                S2: state <= (x) ? S3 : S0;  // Transition from S2
                S3: state <= (x) ? S0 : S4;  // Transition from S3
                S4: state <= (x) ? S2 : S1;  // Transition from S4
                default: state <= S0;         // Default state S0
            endcase
        end
    end
endmodule
