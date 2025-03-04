module decoder2to4 (
    input [1:0] A,    // 2-bit input
    output [3:0] Y    // 4-bit output
);
    assign Y = (A == 2'b00) ? 4'b0001 :
               (A == 2'b01) ? 4'b0010 :
               (A == 2'b10) ? 4'b0100 :
               (A == 2'b11) ? 4'b1000 : 4'b0000; // 2-to-4 decoder
endmodule

module decoder3to8 (
    input [2:0] A,    // 3-bit input
    output [7:0] Y    // 8-bit output
);
    assign Y = (A == 3'b000) ? 8'b00000001 :
               (A == 3'b001) ? 8'b00000010 :
               (A == 3'b010) ? 8'b00000100 :
               (A == 3'b011) ? 8'b00001000 :
               (A == 3'b100) ? 8'b00010000 :
               (A == 3'b101) ? 8'b00100000 :
               (A == 3'b110) ? 8'b01000000 :
               (A == 3'b111) ? 8'b10000000 : 8'b00000000; // 3-to-8 decoder
endmodule
