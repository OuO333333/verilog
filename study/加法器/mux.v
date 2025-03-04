module mux2to1 (
    input A, B,       // 1-bit inputs
    input sel,        // Selection input
    output Y          // Output
);
    assign Y = (sel) ? B : A;  // If sel is 1, output B, else output A
endmodule

module mux4to1 (
    input [3:0] A, B, C, D,    // 4-bit inputs
    input [1:0] sel,           // 2-bit selection input
    output [3:0] Y             // 4-bit output
);
    assign Y = (sel == 2'b00) ? A :
               (sel == 2'b01) ? B :
               (sel == 2'b10) ? C : D; // 4-to-1 multiplexer
endmodule
