module full_adder (
    input A, B, Cin,   // 1-bit inputs
    output Sum, Cout    // 1-bit sum and carry-out
);
    assign Sum = A ^ B ^ Cin;  // Sum is XOR of A, B, and Cin
    assign Cout = (A & B) | (Cin & (A ^ B)); // Carry-out calculation
endmodule
