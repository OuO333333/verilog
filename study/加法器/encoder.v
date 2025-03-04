module encoder4to2 (
    input [3:0] A,    // 4-bit input
    output [1:0] Y    // 2-bit output
);
    assign Y = (A[3]) ? 2'b11 :
               (A[2]) ? 2'b10 :
               (A[1]) ? 2'b01 : 2'b00;  // 4-to-2 encoder
endmodule

module encoder8to3 (
    input [7:0] A,    // 8-bit input
    output [2:0] Y    // 3-bit output
);
    assign Y = (A[7]) ? 3'b111 :
               (A[6]) ? 3'b110 :
               (A[5]) ? 3'b101 :
               (A[4]) ? 3'b100 :
               (A[3]) ? 3'b011 :
               (A[2]) ? 3'b010 :
               (A[1]) ? 3'b001 : 3'b000;  // 8-to-3 encoder
endmodule
