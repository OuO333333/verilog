module half_adder (
    input A, B,    // 1-bit inputs
    output Sum,    // Sum output
    output Cout    // Carry output
);
    assign Sum = A ^ B;  // Sum is XOR of A and B
    assign Cout = A & B; // Carry is AND of A and B
endmodule
