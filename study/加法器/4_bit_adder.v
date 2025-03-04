module four_bit_adder (
    input [3:0] A,  // 4-bit input A
    input [3:0] B,  // 4-bit input B
    input Cin,      // Carry-in
    output [3:0] Sum,  // 4-bit sum output
    output Cout     // Carry-out
);
    wire [3:0] carry;  // Internal carry bits
    
    // Full adders for each bit
    full_adder FA0 (.A(A[0]), .B(B[0]), .Cin(Cin), .Sum(Sum[0]), .Cout(carry[0]));
    full_adder FA1 (.A(A[1]), .B(B[1]), .Cin(carry[0]), .Sum(Sum[1]), .Cout(carry[1]));
    full_adder FA2 (.A(A[2]), .B(B[2]), .Cin(carry[1]), .Sum(Sum[2]), .Cout(carry[2]));
    full_adder FA3 (.A(A[3]), .B(B[3]), .Cin(carry[2]), .Sum(Sum[3]), .Cout(cout));

endmodule

// Full Adder Module
module full_adder (
    input A, B, Cin,    // 1-bit inputs
    output Sum, Cout     // 1-bit sum and carry-out
);
    assign Sum = A ^ B ^ Cin;   // Sum is XOR of A, B, and Cin
    assign Cout = (A & B) | (Cin & (A ^ B)); // Carry-out calculation
endmodule
